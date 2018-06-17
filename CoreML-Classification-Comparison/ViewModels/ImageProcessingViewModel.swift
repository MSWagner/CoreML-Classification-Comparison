//
//  ImageProcessingViewModel.swift
//  MLKit-Vision-Demo
//
//  Created by Matthias Wagner on 11.06.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import Foundation
import ReactiveSwift
import Vision
import CoreML

class ImageProcessingViewModel {

    // MARK: - Properties

    private var _coreMLViewModels = MutableProperty<[CoreMLViewModel]>([])
    lazy var coreMLViewModels: Property<[CoreMLViewModel]> = {
        return Property(self._coreMLViewModels)
    }()

    private var _photo: MutableProperty<Photo>
    lazy var photo: Property<Photo> = {
        return Property(self._photo)
    }()

    private var _classifications = MutableProperty<[ClassificationResult]>([])
    var filteredClassifications = MutableProperty<[ClassificationResult]>([])

    private var settings: FilterSettings

    // MARK: - Init

    init(photo: Photo) {
        self._photo = MutableProperty<Photo>(photo)
        settings = FilterSettings()

        let coreMLViewModels = [
            CoreMLViewModel(imageProcessingViewModel: self, type: .mobileNet),
            CoreMLViewModel(imageProcessingViewModel: self, type: .vgg16),
            CoreMLViewModel(imageProcessingViewModel: self, type: .resnet50),
            CoreMLViewModel(imageProcessingViewModel: self, type: .inceptionv3),
            CoreMLViewModel(imageProcessingViewModel: self, type: .squeezeNet),
            CoreMLViewModel(imageProcessingViewModel: self, type: .googleLeNetPlaces)
        ]

        _coreMLViewModels.value = coreMLViewModels

        SignalProducer
            .combineLatest(settings.precision.producer, _classifications.producer)
            .startWithValues { [weak self] precision, classifications in
                guard let `self` = self else { return }

                let newFilteredClassifications = classifications
                    .map { oldResult -> ClassificationResult in

                        let filteredClassifications = oldResult.classifications
                            .filter { Double($0.confidence) > precision }

                        return ClassificationResult(processingType: oldResult.processingType,
                                                    classifications: filteredClassifications)
                    }

                self.filteredClassifications.value = newFilteredClassifications
            }
    }

    // MARK: - Functions

    func getFilterSettingsViewModel() -> FilterSettingsViewModel {
        return FilterSettingsViewModel(settings: settings)
    }

    func addClassificationResult(_ result: ClassificationResult) {
        var newClassifications = _classifications.value
            .filter { $0.processingType != result.processingType }
        newClassifications.append(result)

        _classifications.value = newClassifications
    }
}
