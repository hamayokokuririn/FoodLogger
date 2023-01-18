//
//  ShouldCheckFoodTableViewController.swift
//  VisionTest
//
//  Created by 齋藤健悟 on 2023/01/14.
//

import Foundation
import UIKit

final class ShouldCheckFoodTableViewController: UITableViewController {
    
    var foodList: [ShouldCheckFood] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Task {
            foodList = await UIApplication.shared.contentsService.fetchShouldCheckFoodList()
            tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "５、６か月以降"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return foodList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShouldCheckFoodCell", for: indexPath) as? ShouldCheckFoodCell else { return UITableViewCell() }
        let food = foodList[indexPath.row]
        let otherNames: String? = food.otherNames.isEmpty ? nil : food.otherNames.joined(separator: "/")
        cell.setup(name: food.name, otherNames: otherNames)
        cell.didChangeCheck(checked: food.checked)        
        
        return cell
    }
}
