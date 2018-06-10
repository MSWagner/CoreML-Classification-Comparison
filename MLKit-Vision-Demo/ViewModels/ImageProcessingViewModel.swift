//
//  ImageProcessingViewModel.swift
//  MLKit-Vision-Demo
//
//  Created by Matthias Wagner on 11.06.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import Foundation
import ReactiveSwift

class ImageProcessingViewModel {

    private var _photo: MutableProperty<Photo>
    lazy var photo: Property<Photo> = {
        return Property(self._photo)
    }()

    private var _settings: MutableProperty<ProcessingSettings>
    lazy var settings: Property<ProcessingSettings> = {
        return Property(self._settings)
    }()

    init(photo: Photo) {
        self._photo = MutableProperty<Photo>(photo)

        let defaultSettings = ProcessingSettings(isVisionTextEnabled: true)
        self._settings = MutableProperty<ProcessingSettings>(defaultSettings)
    }
}
