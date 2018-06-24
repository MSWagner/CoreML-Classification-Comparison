//
//  UIImagePickerControllerSourceType+DKImagePicker .swift
//  CoreML-Classification-Comparison
//
//  Created by Matthias Wagner on 24.06.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import Foundation
import DKImagePickerController

extension UIImagePickerControllerSourceType {

    var dkSourceType: DKImagePickerControllerSourceType {
        switch self {
        case .photoLibrary:
            return .photo
        case .camera:
            return .camera
        case .savedPhotosAlbum:
            return .photo
        }
    }
}

