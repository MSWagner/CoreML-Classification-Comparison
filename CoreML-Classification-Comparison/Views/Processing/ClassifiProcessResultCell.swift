//
//  ClassifiProcessResultCell.swift
//  MLKit-Vision-Demo
//
//  Created by Matthias Wagner on 15.06.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import UIKit
import MBDataSource
import Vision

class ClassifiProcessResultCell: UITableViewCell {

    @IBOutlet weak var identifierLabel: UILabel!
    @IBOutlet weak var confidenceLabel: UILabel!
    
    func configure(classification: VNClassificationObservation) {
        identifierLabel.text = classification.identifier
        confidenceLabel.text = Formatters.percentFormatter.string(from: NSNumber(value: classification.confidence))

        confidenceLabel.textColor = classification.confidence > 0.5 ? .darkGray : .red
    }

}

extension ClassifiProcessResultCell {
    static var descriptor: CellDescriptor<VNClassificationObservation, ClassifiProcessResultCell> {
        return CellDescriptor("MLClassifiResultCell")
            .configure { (classification, cell, _) in
                cell.configure(classification: classification)
        }
    }
}
