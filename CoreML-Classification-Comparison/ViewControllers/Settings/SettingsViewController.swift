//
//  SettingsViewController.swift
//  MLKit-Vision-Demo
//
//  Created by Matthias Wagner on 15.06.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import UIKit
import ReactiveSwift
import MBDataSource

class SettingsViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties

    var viewModel: FilterSettingsViewModel!

    lazy var dataSource: DataSource = {
        return DataSource(
            cellDescriptors: [
                PrecisionCell.descriptor
                    .configure { [weak self] (viewModel, cell, _) in
                        cell.configure(viewModel: viewModel)
                    }
                    .height { 80 },
                EnableSettingCell.descriptor
                    .configure { [weak self] (viewModel, cell, indexPath) in
                        cell.configure(viewModel: viewModel, indexPath: indexPath)
                    }
                    .height { 60 }
            ],
            sectionDescriptors: [
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
        bindDataSource()
    }

    // MARK: - Datasource

    private func bindDataSource() {

        viewModel.settings.shouldUseModelImageSize.producer
            .startWithValues { [weak self] isImageResizingOn in
                guard let `self` = self else { return }

                var rows: [Row] = [
                    Row(self.viewModel, identifier: "PrecisionCell"),
                    Row(self.viewModel.withType(.modelImageSize), identifier: "EnableSettingCell"),
                    Row(self.viewModel.withType(.grayScale), identifier: "EnableSettingCell")
                ]

                if isImageResizingOn {
                    rows.append(Row(self.viewModel.withType(.showScaledImage), identifier: "EnableSettingCell"))
                }

                self.dataSource.sections = [Section(rows: rows).with(identifier: "Footer")]
                self.dataSource.reloadData(self.tableView, animated: false)
            }
    }
}
