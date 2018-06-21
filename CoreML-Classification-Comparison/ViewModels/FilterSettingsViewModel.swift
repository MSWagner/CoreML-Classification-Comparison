//
//  FilterSettingsViewModel.swift
//  MLKit-Vision-Demo
//
//  Created by Matthias Wagner on 15.06.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import Foundation
import ReactiveSwift

enum EnableSettingType {
    case modelImageSize
    case grayScale
    case showScaledImage
}

class FilterSettingsViewModel {

    private(set) var settings: FilterSettings

    private(set) var settingType: EnableSettingType?

    init(settings: FilterSettings?) {
        self.settings = settings ?? FilterSettings()

        self.settings.shouldShowResizedImage <~ self.settings.shouldUseModelImageSize
            .producer
            .map {
                return !$0 ? $0 : self.settings.shouldShowResizedImage.value
            }
    }

    convenience init(settings: FilterSettings, type: EnableSettingType) {
        self.init(settings: settings)
        self.settingType = type
    }

    lazy var precision: Property<Float> = {
        return Property<Double>(settings.precision).map { Float($0 * 100) }
    }()

    func setPrecision(_ precision: Double) {
        settings.precision.value = precision
    }

    func withType(_ type: EnableSettingType) -> FilterSettingsViewModel {
        settingType = type
        return self.copy() as! FilterSettingsViewModel
    }
}

extension FilterSettingsViewModel: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = FilterSettingsViewModel(settings: settings, type: settingType!)
        return copy
    }
}
