//
//  MLViewModel.swift
//  CoreML-Classification-Comparison
//
//  Created by Matthias Wagner on 24.06.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import Foundation
import ReactiveSwift

protocol MLViewModel {
    var isProcessing: MutableProperty<Bool> { get }
    var isSaving: MutableProperty<Bool> { get }
    var areFilteredResults: Property<Bool> { get }
    var modelName: String { get }
    var canSave: Bool { get }
    var modelType: MLModelType { get }

    func startImageProcessing()
    func saveResults()
}
