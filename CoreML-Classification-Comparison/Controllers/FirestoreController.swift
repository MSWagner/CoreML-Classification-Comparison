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

    private(set) var classificationDict = [String: [ClassificationResult]]()

    private var _firestoreResultObjects = MutableProperty<[FirestoreResultObject]>([])
    lazy var firestoreResultObjects: Property<[FirestoreResultObject]> = {
        return Property(self._firestoreResultObjects)
    }()

    static let shared = FirestoreController()

    private init() {

        db.settings.isPersistenceEnabled = true

        tagsRef.addSnapshotListener { [weak self] querySnapshot, error in
            print("Update")

            if error != nil { return }

            guard let documents = querySnapshot?.documents else {
                self?._firestoreResultObjects.value = []
                return
            }

            let firestoreResultObjects = documents
                .map { document -> FirestoreResultObject in
                    let idComponents = document.documentID.components(separatedBy: "&")
                    let identifier = idComponents.first!
                    let type = MLModelType(rawValue: idComponents[1])

                    let dataDict = document.data()

                    var classificationEntries = [String: [ImageClass]]()

                    let imagePrecisionResults = (dataDict["images"] as! [String : Double])
                        .map { entry -> ImagePrecisionResult in

                            let classificationEntry = ImageClass(identifier: identifier, confidence: entry.value)
                            if var classes = classificationEntries[entry.key] {
                                classes.append(classificationEntry)
                                classificationEntries[entry.key] = classes
                            } else {
                                classificationEntries[entry.key] = [classificationEntry]
                            }

                            return ImagePrecisionResult(url: entry.key, precision: entry.value)
                        }

                    classificationEntries.forEach { url, imageClasses in
                        let classResult = ClassificationResult(processingType: type!, classifications: imageClasses)

                        if var oldClassResult = self?.classificationDict[url] {
                            oldClassResult.append(classResult)
                            self?.classificationDict[url] = oldClassResult
                        } else {
                            self?.classificationDict[url] = [classResult]
                        }
                    }

                    let result = FirestoreResultObject(identifier: identifier,
                                                       type: type!,
                                                       imageResults: imagePrecisionResults)

                    return result
                }

            self?._firestoreResultObjects.value = firestoreResultObjects
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
