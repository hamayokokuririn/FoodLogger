//
//  InputFoodTableViewController.swift
//  VisionTest
//
//  Created by 齋藤健悟 on 2023/01/13.
//

import UIKit

class InputFoodTableViewController: UITableViewController {

    var wordList = [String]()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dataStore = InputedFoodDataStore()
        Task {
            let list = wordList.map {
                InputedFood(name: $0, registeredDate: Date())
            }
            await dataStore.insert(foodList: list)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return wordList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InputFoodCell", for: indexPath) as? InputFoodCell else {
            return UITableViewCell()
        }
        let word = wordList[indexPath.row]
        cell.setup(name: word, date: "2020年1月31日")
        return cell
    }

}
