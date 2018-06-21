//
//  ImageTableViewCell.swift
//  MLKit-Vision-Demo
//
//  Created by Matthias Wagner on 11.06.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import UIKit
import MBDataSource
import AlamofireImage

class ImageTableViewCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet private weak var photoView: UIImageView!

    // MARK: - Properties

    var viewModel: ImageViewModel!

    // MARK: - Configure

    func configure(viewModel: ImageViewModel) {
        self.viewModel = viewModel

        photoView.af_cancelImageRequest()
        photoView.image = nil

        let imageData = viewModel.imageData

        if let imageData = imageData {
            photoView.image =  UIImage(data: imageData)
        } else if let url = viewModel.url {
            photoView.af_setImage(withURL: url)
        }
    }

}

extension ImageTableViewCell {
    static var descriptor: CellDescriptor<ImageViewModel, ImageTableViewCell> {
        return CellDescriptor("ImageCell")
            .configure { (data, cell, _) in
                cell.configure(viewModel: data)
        }
    }
}
