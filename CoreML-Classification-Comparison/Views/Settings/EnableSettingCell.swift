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

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueSwitch: UISwitch!

    private var viewModel: FilterSettingsViewModel!

    private var valueProperty: MutableProperty<Bool>!

    func configure(viewModel: FilterSettingsViewModel, indexPath: IndexPath) {
        self.viewModel = viewModel
        valueProperty = indexPath.row == 1
            ? viewModel.settings.shouldUseModelImageSize
            : viewModel.settings.shouldUseGrayscale

        titleLabel.text = indexPath.row == 1
            ? "Preprocess image to model size"
            : "Preprocess image to grayscale"

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
