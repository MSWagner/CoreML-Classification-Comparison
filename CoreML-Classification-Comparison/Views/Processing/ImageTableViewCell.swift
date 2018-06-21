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

    var viewModel: ImageProcessingViewModel!

    // MARK: - Configure

    func configure(viewModel: ImageProcessingViewModel) {
        self.viewModel = viewModel

        photoView.af_cancelImageRequest()
        photoView.image = nil

        let photo = viewModel.photo.value

        if let image = photo.image {
            photoView.image =  UIImage(data: image)
        } else {
            let url = photo.url
            photoView.af_setImage(withURL: url) 
        }
    }

}

extension ImageTableViewCell {
    static var descriptor: CellDescriptor<ImageProcessingViewModel, ImageTableViewCell> {
        return CellDescriptor("ImageCell")
            .configure { (data, cell, _) in
                cell.configure(viewModel: data)
        }
    }
}
