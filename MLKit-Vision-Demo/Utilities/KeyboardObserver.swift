//
//  KeyboardObserver.swift
//  MLKit-Vision-Demo
//
//  Created by Matthias Wagner on 14.06.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import Foundation
import ReactiveSwift
import UIKit
import Result

struct KeyboardNotification {
    let keyboardEndFrame: CGRect
    let animationDuration: Double
    let animationOptions: UIViewAnimationOptions
}

class KeyboardObserver {
    static let shared = KeyboardObserver()

    let keyboardWillShowSignal: Signal<KeyboardNotification?, NoError>!
    let keyboardWillHideSignal: Signal<KeyboardNotification?, NoError>!

    private init() {
        let mapClosure: ((Notification) -> KeyboardNotification?) = { notification in
            guard let userInfo = notification.userInfo else { return nil}
            guard let kbFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return nil }
            guard let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else { return nil }
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue ?? 0 << 16))
            return KeyboardNotification(keyboardEndFrame: kbFrame, animationDuration: duration, animationOptions: options)
        }

        keyboardWillShowSignal = NotificationCenter.default.reactive.notifications(forName: Notification.Name.UIKeyboardWillShow).map(mapClosure)
        keyboardWillHideSignal = NotificationCenter.default.reactive.notifications(forName: Notification.Name.UIKeyboardWillHide).map(mapClosure)
    }

}
