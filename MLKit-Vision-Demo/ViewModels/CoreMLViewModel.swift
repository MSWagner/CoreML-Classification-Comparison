//
//  CoreMLViewModel.swift
//  MLKit-Vision-Demo
//
//  Created by Matthias Wagner on 14.06.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import Foundation
import CoreML
import Vision
import ReactiveSwift

class CoreMLViewModel {

    // MARK: - Private Properties

    private var imageProcessingViewModel: ImageProcessingViewModel
    private(set) var modelType: MLModelType

    private var classificationRequest: VNCoreMLRequest!

    // MARK: - Init

    init(imageProcessingViewModel: ImageProcessingViewModel, type: MLModelType) {
        self.imageProcessingViewModel = imageProcessingViewModel
        self.modelType = type
    }

    // MARK: - Properties

    var modelName: String {
        return modelType.name
    }

    var isProcessing = MutableProperty<Bool>(false)

    lazy var areFilteredResults: Property<Bool> = {
        let initial = imageProcessingViewModel.filteredClassifications.value
            .filter { $0.processingType == modelType }
            .isEmpty

        let producer = imageProcessingViewModel.filteredClassifications.producer
            .map { !$0.filter { $0.processingType == self.modelType }.isEmpty }

        return Property(initial: !initial, then: producer)
    }()

    // MARK: - Functions

    func startImageProcessing() {
        guard let imageData = imageProcessingViewModel.photo.value.image else { return }

        isProcessing.value = true
        DispatchQueue.global(qos: .userInitiated).async {

            let handler = VNImageRequestHandler(data: imageData, orientation: .up)
            self.classificationRequest = self.createMLRequestFor(self.modelType)

            do {
                try handler.perform([self.classificationRequest])
            } catch {
                print("Failed to perform classification.\n\(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.isProcessing.value = false
                }
            }
        }
    }

    private func createMLRequestFor(_ mlModelType: MLModelType) -> VNCoreMLRequest {
        let model = try! VNCoreMLModel(for: mlModelType.model)

        let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
            self?.processClassifications(for: request, error: error, type: mlModelType)
        })

        request.imageCropAndScaleOption = .centerCrop
        return request
    }

    private func processClassifications(for request: VNRequest, error: Error?, type: MLModelType) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                print("Unable to classify image.\n\(error!.localizedDescription)")
                return
            }
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let classifications = results as! [VNClassificationObservation]

            for classification in classifications {
                print("Identifier: \(classification.identifier): \(classification.confidence)")
            }
            self.isProcessing.value = false

            let classificationResult = ClassificationResult(processingType: self.modelType,
                                                            classifications: classifications)
            self.imageProcessingViewModel.addClassificationResult(classificationResult)
        }
    }
}
