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

    private var _coreMLViewModels = MutableProperty<[CoreMLViewModel]>([])
    lazy var coreMLViewModels: Property<[CoreMLViewModel]> = {
        return Property(self._coreMLViewModels)
    }()

    private var _photo: MutableProperty<Photo>
    lazy var photo: Property<Photo> = {
        return Property(self._photo)
    }()

    init(photo: Photo) {
        self._photo = MutableProperty<Photo>(photo)

        let coreMLViewModels = [
            CoreMLViewModel(imageProcessingViewModel: self, type: .mobileNet),
            CoreMLViewModel(imageProcessingViewModel: self, type: .vgg16),
            CoreMLViewModel(imageProcessingViewModel: self, type: .resnet50),
            CoreMLViewModel(imageProcessingViewModel: self, type: .inceptionv3),
            CoreMLViewModel(imageProcessingViewModel: self, type: .squeezeNet),
            CoreMLViewModel(imageProcessingViewModel: self, type: .googleLeNetPlaces)
        ]

        _coreMLViewModels.value = coreMLViewModels
    }


}
