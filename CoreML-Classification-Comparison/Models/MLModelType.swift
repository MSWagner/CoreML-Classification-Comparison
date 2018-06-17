//
//  MLModelType.swift
//  MLKit-Vision-Demo
//
//  Created by Matthias Wagner on 14.06.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import Foundation
import CoreML

enum MLModelType {
    case mobileNet
    case vgg16
    case squeezeNet
    case resnet50
    case inceptionv3
    case googleLeNetPlaces

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

    var name: String {
        switch self {
        case .mobileNet: return "MobileNet"
        case .vgg16: return "VGG16"
        case .squeezeNet: return "SqueezeNet"
        case .resnet50: return "Resnet50"
        case .inceptionv3: return "Inceptionv3"
        case .googleLeNetPlaces: return "GoogLeNetPlaces"
        }
    }
}
