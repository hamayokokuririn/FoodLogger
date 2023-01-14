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
    let content = ContentsService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            do {
                foodList = try await content.fetchShouldCheckFoodList()
                tableView.reloadData()
            } catch {
                fatalError()
            }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShouldCheckFoodCell")
        let food = foodList[indexPath.row]
        cell?.textLabel?.text = food.name
        return cell!
    }
}
