//
//  PermissionProtocol.swift
//  CoreML-Classification-Comparison
//
//  Created by Matthias Wagner on 23.06.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import AVFoundation
import ReactiveSwift
import Photos
import UIKit
import Result

protocol PermissionProtocol {
    func havePermissionFor(_ sourceType: UIImagePickerControllerSourceType) -> SignalProducer<Bool, NoError>
    func requestAccessFor(_ sourceType: UIImagePickerControllerSourceType) -> SignalProducer<Bool, NoError>
}

extension PermissionProtocol {

    func havePermissionFor(_ sourceType: UIImagePickerControllerSourceType) -> SignalProducer<Bool, NoError> {

        if sourceType == .camera {
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                return getCompletedProducerWith(false)}

            switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
            case .notDetermined:
                return requestAccessFor(.camera)
            case .restricted, .denied:
                return getCompletedProducerWith(false)
            case .authorized:
                return getCompletedProducerWith(true)
            }
        }

        if sourceType == .photoLibrary {
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return getCompletedProducerWith(false) }

            switch PHPhotoLibrary.authorizationStatus() {
            case .notDetermined:
                return requestAccessFor(.photoLibrary)
            case .restricted, .denied:
                return getCompletedProducerWith(false)
            case .authorized:
                return getCompletedProducerWith(true)
            }
        }

        return getCompletedProducerWith(false)
    }

    func requestAccessFor(_ sourceType: UIImagePickerControllerSourceType) -> SignalProducer<Bool, NoError> {

        if sourceType == .camera {
            return SignalProducer { sink, _ in
                AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
                    sink.send(value: response)
                    sink.sendCompleted()
                }
            }
        }

        if sourceType == .photoLibrary {
            return SignalProducer { sink, _ in
                PHPhotoLibrary.requestAuthorization { status in
                    switch status {
                    case .notDetermined, .restricted, .denied:
                        sink.send(value: false)
                    case .authorized:
                        sink.send(value: true)
                    }

                    sink.sendCompleted()
                }
            }
        }

        return getCompletedProducerWith(false)
    }

    private func getCompletedProducerWith(_ value: Bool) -> SignalProducer<Bool, NoError> {
        return SignalProducer { sink, _ in
            sink.send(value: value)
            sink.sendCompleted()
        }
    }
}
