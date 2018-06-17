//
//  CoreMLSectionHeaderCell.swift
//  MLKit-Vision-Demo
//
//  Created by Matthias Wagner on 14.06.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import UIKit
import MBDataSource
import ReactiveSwift

class CoreMLSectionHeaderCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet weak var saveButtonWidthConstraint: NSLayoutConstraint!

    @IBOutlet weak var modelNameLabel: UILabel!
    @IBOutlet weak var startProcessingButton: DesignableButton!
    @IBOutlet weak var saveButton: DesignableButton!

    // MARK: - Properties

    private var viewModel: CoreMLViewModel!

    var disposableBag = CompositeDisposable()

    // MARK: - Configure

    func configure(viewModel: CoreMLViewModel) {
        self.viewModel = viewModel
        modelNameLabel.text = viewModel.modelName
        disposableBag.dispose()
        disposableBag = CompositeDisposable()

        disposableBag += viewModel.isProcessing.producer
            .startWithValues { [weak self] isProcessing in
                self?.startProcessingButton.isLoading = isProcessing

            }

        disposableBag += viewModel.areFilteredResults.producer
            .startWithValues { [weak self] areFilteredResults in
                self?.saveButtonWidthConstraint.constant = areFilteredResults ? 100 : 0
            }
    }

    // MARK: - IBActions

    @IBAction func onStartButton(_ sender: Any) {
        viewModel.startImageProcessing()
    }

    @IBAction func onSaveButton(_ sender: Any) {
    }
}

// MARK: - DataSource Extension

extension CoreMLSectionHeaderCell {
    static var descriptor: CellDescriptor<CoreMLViewModel, CoreMLSectionHeaderCell> {
        return CellDescriptor("MLSectionCell")
            .configure { (data, cell, _) in
                cell.configure(viewModel: data)
        }
    }
}
