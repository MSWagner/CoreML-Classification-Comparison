//
//  ClassifiProcessResultCell.swift
//  MLKit-Vision-Demo
//
//  Created by Matthias Wagner on 15.06.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import UIKit
import MBDataSource

class ClassifiProcessResultCell: UITableViewCell {

    @IBOutlet weak var identifierLabel: UILabel!
    @IBOutlet weak var confidenceLabel: UILabel!
    
    func configure(imageClass: ImageClass) {
        identifierLabel.text = imageClass.identifier
        confidenceLabel.text = Formatters.percentFormatter.string(from: NSNumber(value: imageClass.confidence))

        confidenceLabel.textColor = imageClass.confidence > 0.5 ? .darkGray : .red
    }

}

extension ClassifiProcessResultCell {
    static var descriptor: CellDescriptor<ImageClass, ClassifiProcessResultCell> {
        return CellDescriptor("MLClassifiResultCell")
            .configure { (imageClass, cell, _) in
                cell.configure(imageClass: imageClass)
        }
    }
}
