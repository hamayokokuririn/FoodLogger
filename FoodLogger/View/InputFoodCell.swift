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
    @IBOutlet weak var switchStackView: UIStackView!
    
    var didSwitchChanged: ((Bool) -> Void)?
    
    func setup(name: String, date: String, shouldCheckFood: Bool) {
        foodName.text = name
        lastDate.text = date
        switchStackView.isHidden = !shouldCheckFood
    }
    
}
