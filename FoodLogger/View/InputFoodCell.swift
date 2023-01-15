//
//  InputFoodCell.swift
//  FoodLogger
//
//  Created by 齋藤健悟 on 2023/01/15.
//

import Foundation
import UIKit

final class InputFoodCell: UITableViewCell {
    @IBOutlet private weak var foodName: UILabel!
    @IBOutlet private weak var lastDate: UILabel!
    
    func setup(name: String, date: String) {
        foodName.text = name
        lastDate.text = date
    }
    
}
