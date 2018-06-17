//
//  ImageProcessingSectionView.swift
//  MLKit-Vision-Demo
//
//  Created by Matthias Wagner on 14.06.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import UIKit

class ImageProcessingSectionView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var hideButton: UIButton!

    var onHideButton: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ImageProcessingSectionView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    @IBAction func onHideButton(_ sender: Any) {
        onHideButton?()
    }
}
