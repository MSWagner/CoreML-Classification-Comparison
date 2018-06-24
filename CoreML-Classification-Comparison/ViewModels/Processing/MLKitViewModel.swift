//
//  MLKitViewModel.swift
//  CoreML-Classification-Comparison
//
//  Created by Matthias Wagner on 24.06.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import Foundation
import ReactiveSwift
import PKHUD
import Firebase

class MLKitViewModel: MLViewModel {

    // MARK: - Private Properties

    private var imageProcessingViewModel: ImageProcessingViewModel
    private(set) var modelType: MLModelType

    private var mlKitVision = Vision.vision()
    private lazy var labelDetector: VisionLabelDetector = {
        let options = VisionLabelDetectorOptions(confidenceThreshold: 0)
        return mlKitVision.labelDetector(options: options)
    }()

    private(set) var isProcessing = MutableProperty<Bool>(false)
    private(set) var isSaving = MutableProperty<Bool>(false)

    // MARK: - Init

    init(imageProcessingViewModel: ImageProcessingViewModel, type: MLModelType) {
        self.imageProcessingViewModel = imageProcessingViewModel
        self.modelType = type
    }

    // MARK: - Properties

    var modelName: String {
        return modelType.rawValue
    }

    var canSave: Bool {
        return imageProcessingViewModel.photo.value.url != nil
    }

    lazy var areFilteredResults: Property<Bool> = {
        let initial = imageProcessingViewModel.filteredClassifications.value
            .filter { $0.processingType == modelType }
            .isEmpty

        let producer = imageProcessingViewModel.filteredClassifications.producer
            .map { !$0.filter { $0.processingType == self.modelType }.isEmpty }

        return Property(initial: !initial, then: producer)
    }()

    // MARK: - Processing Functions

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

    func startImageProcessing() {
        guard let imageData = imageProcessingViewModel.photo.value.image, let image = UIImage(data: imageData) else { return }

        isProcessing.value = true

        DispatchQueue.global(qos: .userInitiated).async {
            let visionImage = VisionImage(image: image)
            let metadata = VisionImageMetadata()
            metadata.orientation = .rightTop

            self.labelDetector.detect(in: visionImage) { [weak self] features, error in
                DispatchQueue.main.async {
                    defer { self?.isProcessing.value = false }

                    guard let `self` = self else { return }

                    if let error = error {
                        HUD.flash(.labeledError(title: Strings.Classification.preProcessingFailedTitle, subtitle: error.localizedDescription), delay: 2)
                    } else {

                        guard let features = features, !features.isEmpty else { return }

                        let imageClasses = features
                            .map { ImageClass(identifier: $0.label.lowercased(),
                                              confidence: Double($0.confidence))
                        }

                        let classificationResult = ClassificationResult(processingType: self.modelType,
                                                                        classifications: imageClasses)

                        self.imageProcessingViewModel.addClassificationResult(classificationResult)
                    }
                }
            }
        }
    }
}
