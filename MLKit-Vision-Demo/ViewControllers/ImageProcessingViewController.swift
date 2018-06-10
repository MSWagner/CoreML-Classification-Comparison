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

class ImageProcessingViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var tableView: UITableView!

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
                    .height { self.imageCellHeight },
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

        if let imageData = viewModel.photo.value.image, let image = UIImage(data: imageData) {
            imageCellHeight = image.size.height < 1000 ? image.size.height : 1000
        }

        bindDataSource()
    }

    // MARK: - Setup

    private func bindDataSource() {
        viewModel.photo.producer.startWithValues { [weak self] photo in
            guard let `self` = self else { return }

            let imageSection = Section(rows: [Row(self.viewModel, identifier: "ImageCell")]).with(identifier: "Footer")

            self.dataSource.sections = [imageSection]
            self.dataSource.reloadData(self.tableView, animated: true)
        }
    }
}
