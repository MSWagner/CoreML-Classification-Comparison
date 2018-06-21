//
//  ImageCollectionCell.swift
//  MLKit-Vision-Demo
//
//  Created by Matthias Wagner on 10.06.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import UIKit
import AlamofireImage

class ImageCollectionCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!

    var photo: Photo!

    func configure(photo: Photo) {
        self.photo = photo

        imageView.af_cancelImageRequest()
        imageView.image = nil

        if let image = photo.image {
            imageView.image =  UIImage(data: image)
        } else {
            let url = photo.url
            imageView.af_setImage(withURL: url) { response in
                self.photo.image = response.data
            }
        }
    }
}
