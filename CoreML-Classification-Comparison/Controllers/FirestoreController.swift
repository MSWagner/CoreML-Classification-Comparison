//
//  FirestoreController.swift
//  CoreML-Classification-Comparison
//
//  Created by Matthias Wagner on 17.06.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import Foundation
import FirebaseFirestore
import ReactiveSwift

class FirestoreController {

    private let db = Firestore.firestore()
    private lazy var tagsRef: CollectionReference = {
        return db.collection("tags")
    }()

    private var _classificationResults = MutableProperty<[FirestoreResultObject]>([])
    lazy var classificationResults: Property<[FirestoreResultObject]> = {
        return Property(self._classificationResults)
    }()

    static let shared = FirestoreController()

    private init() {

        tagsRef.addSnapshotListener { [weak self] (querySnapshot, error) in
            print("Update")

            if error != nil { return }

            guard let documents = querySnapshot?.documents else {
                self?._classificationResults.value = []
                return
            }

            let classificationResults = documents
                .map { document -> FirestoreResultObject in
                    let idComponents = document.documentID.components(separatedBy: "&")
                    let identifier = idComponents.first!
                    let type = MLModelType(rawValue: idComponents[1])

                    let dataDict = document.data()

                    let imagePrecisionResults = (dataDict["images"] as! [String : Double])
                        .map { ImagePrecisionResult(url: $0.key, precision: $0.value) }

                    let result = FirestoreResultObject(identifier: identifier,
                                                       type: type!,
                                                       imageResults: imagePrecisionResults)

                    return result
                }

            self?._classificationResults.value = classificationResults
        }
    }

    func saveEntriesFor(_ url: String, withResult result: ClassificationResult) -> SignalProducer<[Void], APIError> {

        let producers = result.classifications
            .compactMap { imageClass -> SignalProducer<Void, APIError>? in
                let id = "\(imageClass.identifier)&\(result.processingType.rawValue)"
                let data = [
                    "images": [url: imageClass.confidence]
                ]

                return self.setData(id: id, data: data)
        }

        return SignalProducer.combineLatest(producers)
    }

    private func setData(id: String, data: [String: Any]) -> SignalProducer<Void, APIError> {
        return SignalProducer<Void, APIError> { sink, _ in
            self.tagsRef
                .document(id)
                .setData(data, merge: true, completion: { error in
                    if error != nil {
                        sink.send(error: .setFireStoreData)
                    }
                    sink.send(value: ())
                    sink.sendCompleted()
                })

        }
    }
}
