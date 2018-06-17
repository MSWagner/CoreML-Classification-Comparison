//
//  FirestoreResultObject.swift
//  CoreML-Classification-Comparison
//
//  Created by Matthias Wagner on 17.06.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import Foundation

struct FirestoreResultObject {
    let identifier: String
    let type: MLModelType
    let imageResults: [ImagePrecisionResult]
}

struct ImagePrecisionResult {
    let url: String
    let precision: Double
}
