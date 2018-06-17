//
//  ClassificationResult.swift
//  MLKit-Vision-Demo
//
//  Created by Matthias Wagner on 15.06.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import Foundation
import Vision

struct ClassificationResult {
    let processingType: MLModelType
    let classifications: [VNClassificationObservation]
}
