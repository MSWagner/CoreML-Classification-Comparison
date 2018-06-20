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
import PKHUD

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
        return modelType.rawValue
    }

    var isProcessing = MutableProperty<Bool>(false)
    var isSaving = MutableProperty<Bool>(false)

    lazy var areFilteredResults: Property<Bool> = {
        let initial = imageProcessingViewModel.filteredClassifications.value
            .filter { $0.processingType == modelType }
            .isEmpty

        let producer = imageProcessingViewModel.filteredClassifications.producer
            .map { !$0.filter { $0.processingType == self.modelType }.isEmpty }

        return Property(initial: !initial, then: producer)
    }()

    // MARK: - Accesible Functions

    func startImageProcessing() {
        guard let imageData = imageProcessingViewModel.photo.value.image else { return }

        isProcessing.value = true
        DispatchQueue.global(qos: .userInitiated).async {

            guard let handler = self.getImageRequestHandlerWith(imageData) else {
                DispatchQueue.main.async {
                    self.isProcessing.value = false
                    HUD.flash(.labeledError(title: "Error", subtitle: "Image Preprocessing failed"), delay: 1.2)
                }
                return
            }

            self.classificationRequest = self.createMLRequestFor(self.modelType)

            do {
                try handler.perform([self.classificationRequest])
            } catch {
                print("Failed to perform classification.\n\(error.localizedDescription)")
                DispatchQueue.main.async {
                    HUD.flash(.labeledError(title: "Error", subtitle: error.localizedDescription), delay: 1.2)
                    self.isProcessing.value = false
                }
            }
        }
    }

    func saveResults() {
        if let producer = imageProcessingViewModel.saveResultsFor(modelType) {
            isSaving.value = true

            producer.startWithResult { [weak self] result in
                switch result {
                case .success(_): break
                case .failure(let error):
                    HUD.flash(.label(error.errorDescription))
                }

                self?.isSaving.value = false
            }
        }
    }
}

// MARK: - Model Processing

extension CoreMLViewModel {
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

            let imageClasses = classifications
                .map { ImageClass(identifier: $0.identifier,
                                  confidence: Double($0.confidence))
            }

            let classificationResult = ClassificationResult(processingType: self.modelType,
                                                            classifications: imageClasses)
            self.imageProcessingViewModel.addClassificationResult(classificationResult)
        }
    }
}

// MARK: - Image Preprocessing

extension CoreMLViewModel {

    private func getImageRequestHandlerWith(_ data: Data) -> VNImageRequestHandler? {
        let settings = imageProcessingViewModel.settings
        let shouldUseGrayscale = settings.shouldUseGrayscale.value
        let shouldUseModelImageSize = settings.shouldUseModelImageSize.value

        if !shouldUseGrayscale && !shouldUseModelImageSize {

            return VNImageRequestHandler(data: data, orientation: .up)
        } else if shouldUseModelImageSize && !shouldUseGrayscale {

            guard let pixelBuffer = UIImage(data: data)?
                .pixelBuffer(width: modelType.imageWidth,
                             height: modelType.imageHeight) else { return nil }

            return VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up)
        } else if shouldUseModelImageSize && shouldUseGrayscale {

            guard let pixelBuffer = UIImage(data: data)?
                .pixelBufferGray(width: modelType.imageWidth,
                                 height: modelType.imageHeight) else { return nil }

            return VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up)
        } else if !shouldUseModelImageSize && shouldUseGrayscale {

            guard let image = UIImage(data: data) else { return nil }

            guard let pixelBuffer = image
                .pixelBufferGray(width: Int(image.size.width),
                                 height: Int(image.size.height)) else { return nil }

            return VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up)
        }

        return nil
    }
}
