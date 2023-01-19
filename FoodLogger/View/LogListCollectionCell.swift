//
//  LogListCollectionCell.swift
//  FoodLogger
//
//  Created by 齋藤健悟 on 2023/01/19.
//

import Foundation
import UIKit

final class LogListCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var firstFood: UILabel!
    @IBOutlet weak var secondFood: UILabel!
    @IBOutlet weak var thirdFood: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    func setup(first: String, date: String) {
        firstFood.text = first
        dateLabel.text = date
    }
}
