//
//  PrecisionCell.swift
//  MLKit-Vision-Demo
//
//  Created by Matthias Wagner on 15.06.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import UIKit
import MBDataSource
import ReactiveSwift

class PrecisionCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet weak var precisionSlider: UISlider!

    // MARK: - Properties

    private var viewModel: FilterSettingsViewModel!

    // MARK: - Configure

    func configure(viewModel: FilterSettingsViewModel) {
        self.viewModel = viewModel

        viewModel.settings.precision <~ precisionSlider.reactive.values.producer.map { Double($0) / 100 }
        precisionSlider.reactive.value <~ viewModel.precision.producer
    }
}

// MARK: - DataSource Extension

extension PrecisionCell {
    static var descriptor: CellDescriptor<FilterSettingsViewModel, PrecisionCell> {
        return CellDescriptor("PrecisionCell")
            .configure { (viewModel, cell, _) in
                cell.configure(viewModel: viewModel)
        }
    }
}
