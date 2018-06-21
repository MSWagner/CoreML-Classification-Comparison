//
//  ImageViewModel.swift
//  CoreML-Classification-Comparison
//
//  Created by Matthias Wagner on 21.06.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import Foundation
import ReactiveSwift

class ImageViewModel {
    private(set) var url: URL?
    private(set) var imageData: Data?

    init(imageData: Data? = nil, url: URL? = nil) {
        self.imageData = imageData
        self.url = url
    }
}
