//
//  MLModelType.swift
//  MLKit-Vision-Demo
//
//  Created by Matthias Wagner on 14.06.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import Foundation
import CoreML

enum MLModelType: String {
    case mobileNet = "MobileNet"
    case vgg16 = "VGG16"
    case squeezeNet = "SqueezeNet"
    case resnet50 = "Resnet50"
    case inceptionv3 = "Inceptionv3"
    case googleLeNetPlaces = "GoogLeNetPlaces"

    var model: MLModel {
        switch self {
        case .mobileNet: return MobileNet().model
        case .vgg16: return VGG16().model
        case .squeezeNet: return SqueezeNet().model
        case .resnet50: return Resnet50().model
        case .inceptionv3: return Inceptionv3().model
        case .googleLeNetPlaces: return GoogLeNetPlaces().model
        }
    }
}
