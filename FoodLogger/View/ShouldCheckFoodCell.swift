//
//  ShouldCheckFoodCell.swift
//  FoodLogger
//
//  Created by 齋藤健悟 on 2023/01/18.
//

import Foundation
import UIKit

final class ShouldCheckFoodCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var otherNamesLabel: UILabel!
    @IBOutlet weak var checkmarkImage: UIImageView!
    
    func setup(name: String, otherNames: String?) {
        nameLabel.text = name
        if let otherNames {
            otherNamesLabel.isHidden = false
            otherNamesLabel.text = otherNames
        } else {
            otherNamesLabel.isHidden = true
        }
    }
    
    func didChangeCheck(checked: Bool) {
        if checked {
            checkmarkImage.image = UIImage(systemName: "checkmark.circle.fill")
        } else {
            checkmarkImage.image = UIImage(systemName: "checkmark.circle")
        }
    }
}
