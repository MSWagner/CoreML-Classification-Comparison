//
//  ImageProcessingViewController.swift
//  MLKit-Vision-Demo
//
//  Created by Matthias Wagner on 11.06.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import UIKit
import MBDataSource
import ReactiveSwift
import Vision
import CoreML

class ImageProcessingViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties

    var viewModel: ImageProcessingViewModel!

    var imageCellHeight: CGFloat = 200

    lazy var dataSource: DataSource = {
        return DataSource(
            cellDescriptors: [
                ImageTableViewCell.descriptor
                    .configure { [weak self] (viewModel, cell, _) in
                        cell.configure(viewModel: viewModel)
                    }
                    .height { 200 },
                CoreMLSectionHeaderCell.descriptor
                    .configure { [weak self] (viewModel, cell, _) in
                        cell.configure(viewModel: viewModel)
                    }
                    .height { 50 },
                ClassifiProcessResultCell.descriptor
                    .configure { [weak self] (classification, cell, _) in
                        cell.configure(imageClass: classification)
                    }
                    .estimatedHeight { 40 }
            ],
            sectionDescriptors: [
                SectionDescriptor<Void>("ImageCellFooter")
                    .footer {
                        .view(self.createFooterForImageCell())
                    }
                    .footerHeight {
                        .value(40)
                    },
                SectionDescriptor<Void>("Footer")
                    .footerHeight {
                        .value(1)
                    }
            ]
        )
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if let imageData = viewModel.photo.value.image, let image = UIImage(data: imageData) {
            imageCellHeight = image.size.height < 1000 ? image.size.height : 1000
        }

        if let  query = viewModel.photo.value.searchQuery {
            navigationItem.title = query
        }

        bindDataSource()
    }

    // MARK: - Setup

    private func bindDataSource() {
        SignalProducer.combineLatest(viewModel.photo.producer,
                                     viewModel.coreMLViewModels.producer,
                                     viewModel.filteredClassifications.producer,
                                     viewModel.shouldShowResizedImage.producer)
            .startWithValues { [weak self] photo, coreMlViewModels, classificationResults, shouldShowResizedImage in
                guard let `self` = self else { return }

                let imageSection = Section(rows: [Row(self.viewModel.getImageViewModel(), identifier: "ImageCell")])
                    .with(identifier: "ImageCellFooter")

                let rows = coreMlViewModels
                    .map { coreMLViewModel -> [Row] in
                        var typeRows = [
                            Row(coreMLViewModel, identifier: "MLSectionCell")
                        ]

                        let classifications = classificationResults.lazy
                            .filter { $0.processingType == coreMLViewModel.modelType }
                            .map { $0.classifications
                                .map {
                                    Row($0, identifier: "MLClassifiResultCell")
                                }
                            }
                            .flatMap { $0 }

                        if shouldShowResizedImage && !classifications.isEmpty  {
                            typeRows.append(
                                Row(self.viewModel.getImageViewModel(coreMLViewModel: coreMLViewModel),identifier: "ImageCell")
                            )
                        }

                        typeRows += classifications
                        return typeRows
                    }
                    .flatMap { $0 }

                let coreMLSections = Section(rows: rows).with(identifier: "Footer")

                self.dataSource.sections = [imageSection, coreMLSections]
                self.dataSource.reloadData(self.tableView, animated: false)
        }
    }

    func createFooterForImageCell() -> UIView {
        let label = UILabel()
        label.backgroundColor = Colors.Main.red
        label.textAlignment = .center
        label.text = "Press Start to classify the image"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 12.0)
        return label
    }

    // MARK: - IBActions

    @IBAction func onSettings(_ sender: Any) {
        let settingsVC: SettingsViewController = UIStoryboard(.settings).instantiateViewController()
        settingsVC.viewModel = viewModel.getFilterSettingsViewModel()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
}
