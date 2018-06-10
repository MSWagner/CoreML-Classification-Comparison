//
//  Photo.swift
//  MLKit-Vision-Demo
//
//  Created by Matthias Wagner on 10.06.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import Foundation
import UIKit

struct Photo {
    let url: URL
    var image: Data?

    init?(urlString: String) {
        if let url = URL(string: urlString) {
            self.url = url
        } else {
            return nil
        }

        image = nil
    }
}
