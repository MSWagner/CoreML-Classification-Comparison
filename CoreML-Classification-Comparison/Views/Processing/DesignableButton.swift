//
//  DesignableButton.swift
//  Example
//
//  Created by Gunter Hager on 03.06.16.
//  Copyright © 2016 all about apps. All rights reserved.
//
import UIKit

@IBDesignable

class DesignableButton: SimpleButton {

    /// Background color for normal state.
    @IBInspectable var backgroundColorNormal: UIColor?
    @IBInspectable var backgroundColorDisabled: UIColor?
    @IBInspectable var backgroundColorHighlight: UIColor?
    @IBInspectable var backgroundColorLoading: UIColor?
    @IBInspectable var backgroundColorSelected: UIColor?
    @IBInspectable var titleColorNormal: UIColor?
    @IBInspectable var titleColorSelected: UIColor?
    @IBInspectable var titleColorDisabled: UIColor?
    @IBInspectable var titleColorHighlighted: UIColor?
    @IBInspectable var titleColorLoading: UIColor?

    @IBInspectable var titleLoading: String?

    @IBInspectable var shadow: Bool = false
    @IBInspectable var shadowColor: UIColor?
    @IBInspectable var shadowOffset: CGSize = CGSize.zero
    @IBInspectable var shadowRadius: CGFloat = 0
    @IBInspectable var shadowOpacity: Float = 0

    override func configureButtonStyles() {
        super.configureButtonStyles()

        if let titleLoading = titleLoading {
            setTitle(titleLoading, for: SimpleButtonControlState.loading)
        } else {
            setTitle("", for: SimpleButtonControlState.loading)
        }
        if let backgroundColorLoading = backgroundColorLoading {
            setBackgroundColor(backgroundColorLoading, for: SimpleButtonControlState.loading)
        }
        if let backgroundColorNormal = backgroundColorNormal {
            setBackgroundColor(backgroundColorNormal, for: .normal)
        }
        if let backgroundColorDisabled = backgroundColorDisabled {
            setBackgroundColor(backgroundColorDisabled, for: .disabled)
        }
        if let backgroundColorHighlight = backgroundColorHighlight {
            setBackgroundColor(backgroundColorHighlight, for: .highlighted)
        }
        if let backgroundSelected = backgroundColorSelected {
            setBackgroundColor(backgroundSelected, for: .selected)
        }
        if let titleColorLoading = titleColorLoading {
            setTitleColor(titleColorLoading, for: SimpleButtonControlState.loading)
        }
        if let titleColorNormal = titleColorNormal {
            setTitleColor(titleColorNormal, for: .normal)
        }
        if let titleColorHighlighted = titleColorHighlighted {
            setTitleColor(titleColorHighlighted, for: .highlighted)
        }

        if let titleColorDisabled = titleColorDisabled {
            setTitleColor(titleColorDisabled, for: .disabled)
        }

        if let titleColorSelected = titleColorSelected {
            setTitleColor(titleColorSelected, for: .selected)
        }



        if shadow {
            if let shadowColor = shadowColor {
                setShadowColor(shadowColor)
            }
            setShadowOffset(shadowOffset)
            setShadowRadius(shadowRadius)
            setShadowOpacity(shadowOpacity)
        }
    }
}
