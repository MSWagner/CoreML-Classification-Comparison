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

class CoreMLViewModel {

    private var imageProcessingViewModel: ImageProcessingViewModel
    private var modelType: MLModelType

    private var classificationRequest: VNCoreMLRequest!

    init(imageProcessingViewModel: ImageProcessingViewModel, type: MLModelType) {
        self.imageProcessingViewModel = imageProcessingViewModel
        self.modelType = type
    }

    var modelName: String {
        return modelType.name
    }

    func startImageProcessing() {
        guard let imageData = imageProcessingViewModel.photo.value.image else { return }

        DispatchQueue.global(qos: .userInitiated).async {

            let handler = VNImageRequestHandler(data: imageData, orientation: .up)
            self.classificationRequest = self.createMLRequestFor(self.modelType)

            do {
                try handler.perform([self.classificationRequest])
            } catch {
                /*
                 This handler catches general image processing errors. The `classificationRequest`'s
                 completion handler `processClassifications(_:error:)` catches errors specific
                 to processing that request.
                 */
                print("Failed to perform classification.\n\(error.localizedDescription)")
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

    func processClassifications(for request: VNRequest, error: Error?, type: MLModelType) {
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
        }
    }
}
