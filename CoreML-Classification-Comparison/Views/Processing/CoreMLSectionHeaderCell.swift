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

    @IBOutlet private weak var saveButtonWidthConstraint: NSLayoutConstraint!

    @IBOutlet private weak var modelNameLabel: UILabel!
    @IBOutlet private weak var startProcessingButton: DesignableButton!
    @IBOutlet private weak var saveButton: DesignableButton!

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

        disposableBag += viewModel.isSaving.producer
            .startWithValues { isSaving in
                self.saveButton.isLoading = isSaving
            }

        disposableBag += viewModel.areFilteredResults.producer
            .startWithValues { [weak self] areFilteredResults in
                let startButtonTitle = areFilteredResults ? Strings.ProcessingViewController.startButtonTitle : Strings.ProcessingViewController.reStartButtonTitle
                self?.startProcessingButton.setTitle(startButtonTitle, for: .normal)
                self?.saveButtonWidthConstraint.constant = areFilteredResults ? 100 : 0
            }
    }

    // MARK: - IBActions

    @IBAction func onStartButton(_ sender: Any) {
        viewModel.startImageProcessing()
    }

    @IBAction func onSaveButton(_ sender: Any) {
        viewModel.saveResults()
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
