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

    private var viewModel: MLViewModel!

    var disposableBag = CompositeDisposable()

    // MARK: - Configure

    func configure(viewModel: MLViewModel) {
        self.viewModel = viewModel
        modelNameLabel.text = viewModel.modelName
        disposableBag.dispose()
        disposableBag = CompositeDisposable()

        disposableBag += viewModel.isSaving.producer
            .startWithValues { isSaving in
                self.saveButton.isLoading = isSaving
            }

        disposableBag += SignalProducer.combineLatest(viewModel.areFilteredResults.producer,
                                                      viewModel.isProcessing.producer)
            .startWithValues { [weak self] areFilteredResults, isProcessing in
                guard let `self` = self else { return }

                self.startProcessingButton.isLoading = isProcessing

                if !isProcessing {
                    let startButtonTitle = areFilteredResults ? Strings.ProcessingViewController.reStartButtonTitle : Strings.ProcessingViewController.startButtonTitle

                    self.startProcessingButton.setTitle(startButtonTitle, for: .normal)
                    self.saveButtonWidthConstraint.constant = areFilteredResults && self.viewModel.canSave ? 100 : 0
                }
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
    static var descriptor: CellDescriptor<MLViewModel, CoreMLSectionHeaderCell> {
        return CellDescriptor("MLSectionCell")
            .configure { (data, cell, _) in
                cell.configure(viewModel: data)
        }
    }
}
