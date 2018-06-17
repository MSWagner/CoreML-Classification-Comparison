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

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties

    var viewModel: FilterSettingsViewModel!

    lazy var dataSource: DataSource = {
        return DataSource(
            cellDescriptors: [
                PrecisionCell.descriptor
                    .configure { [weak self] (viewModel, cell, _) in
                        cell.configure(viewModel: viewModel)
                    }
                    .height { 80 }
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
        setupDataSource()
    }

    // MARK: - Datasource

    private func setupDataSource() {
        let precisionSection = Section(rows: [Row(viewModel, identifier: "PrecisionCell")]).with(identifier: "Footer")

        dataSource.sections = [precisionSection]
        dataSource.reloadData(tableView, animated: true)
    }
}
