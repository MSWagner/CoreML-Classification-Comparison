//
//  CoreMLSectionHeaderCell.swift
//  MLKit-Vision-Demo
//
//  Created by Matthias Wagner on 14.06.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import UIKit
import MBDataSource

class CoreMLSectionHeaderCell: UITableViewCell {

    @IBOutlet weak var modelNameLabel: UILabel!

    private var viewModel: CoreMLViewModel!

    // MARK: - Configure

    func configure(viewModel: CoreMLViewModel) {
        self.viewModel = viewModel
        modelNameLabel.text = viewModel.modelName
    }

    @IBAction func onStartButton(_ sender: Any) {
        viewModel.startImageProcessing()
    }
}

extension CoreMLSectionHeaderCell {
    static var descriptor: CellDescriptor<CoreMLViewModel, CoreMLSectionHeaderCell> {
        return CellDescriptor("MLSectionCell")
            .configure { (data, cell, _) in
                cell.configure(viewModel: data)
        }
    }
}
