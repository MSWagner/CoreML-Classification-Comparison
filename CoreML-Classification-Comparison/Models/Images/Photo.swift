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
    let searchQuery: String
    var image: Data?

    init?(urlString: String, searchQuery: String) {
        if let url = URL(string: urlString) {
            self.url = url
        } else {
            return nil
        }

        self.searchQuery = searchQuery
        image = nil
    }
}
