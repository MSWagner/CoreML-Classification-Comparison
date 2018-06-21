//
//  UIImage+Data?.swift
//  CoreML-Classification-Comparison
//
//  Created by Matthias Wagner on 22.06.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import UIKit

extension UIImage {
    var jpeg: Data? {
        return UIImageJPEGRepresentation(self, 1)   // QUALITY min = 0 / max = 1
    }
    var png: Data? {
        return UIImagePNGRepresentation(self)
    }
}
