//
//  EnableSettingCell.swift
//  CoreML-Classification-Comparison
//
//  Created by Matthias Wagner on 20.06.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import UIKit
import MBDataSource
import ReactiveSwift
import ReactiveCocoa

class EnableSettingCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var valueSwitch: UISwitch!

    private var viewModel: FilterSettingsViewModel!

    private var valueProperty: MutableProperty<Bool>!

    func configure(viewModel: FilterSettingsViewModel, indexPath: IndexPath) {
        self.viewModel = viewModel

        switch viewModel.settingType! {
        case .modelImageSize:
            valueProperty = viewModel.settings.shouldUseModelImageSize
            titleLabel.text = "Preprocess image to model size"
        case .grayScale:
            valueProperty = viewModel.settings.shouldUseGrayscale
            titleLabel.text = "Preprocess image to grayscale"
        case .showScaledImage:
            valueProperty = viewModel.settings.shouldShowResizedImage
            titleLabel.text = "Show the scaled image"
        }

        valueSwitch.reactive.isOn <~ valueProperty.producer
        valueProperty <~ valueSwitch.reactive.isOnValues
    }
}

// MARK: - DataSource Extension

extension EnableSettingCell {
    static var descriptor: CellDescriptor<FilterSettingsViewModel, EnableSettingCell> {
        return CellDescriptor("EnableSettingCell")
            .configure { (viewModel, cell, indexPath) in
                cell.configure(viewModel: viewModel, indexPath: indexPath)
        }
    }
}
