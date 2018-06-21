//
//  FilterSettings.swift
//  MLKit-Vision-Demo
//
//  Created by Matthias Wagner on 15.06.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import Foundation
import ReactiveSwift

struct FilterSettings {
    var query: MutableProperty<String?>
    var precision: MutableProperty<Double>

    var shouldUseModelImageSize = MutableProperty<Bool>(false)
    var shouldUseGrayscale = MutableProperty<Bool>(false)
    var shouldShowResizedImage = MutableProperty<Bool>(false)

    init(query: String? = nil, precision: Double = 0.2) {
        self.query = MutableProperty<String?>(query)
        self.precision = MutableProperty<Double>(precision)
    }
}
