//
//  FilterSettingsViewModel.swift
//  MLKit-Vision-Demo
//
//  Created by Matthias Wagner on 15.06.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import Foundation
import ReactiveSwift

class FilterSettingsViewModel {

    private(set) var settings: FilterSettings

    init(settings: FilterSettings?) {
        self.settings = settings ?? FilterSettings()
    }

    lazy var precision: Property<Float> = {
        return Property<Double>(settings.precision).map { Float($0 * 100) }
    }()

    func setPrecision(_ precision: Double) {
        settings.precision.value = precision
    }
}
