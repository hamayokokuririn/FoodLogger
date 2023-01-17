//
//  InputFoodTableViewController.swift
//  VisionTest
//
//  Created by 齋藤健悟 on 2023/01/13.
//

import UIKit

class InputFoodTableViewController: UITableViewController {

    var wordList = [String]()
    var viewModel: InputFoodTableViewModel? = nil  {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 保存処理
        // 食事情報
        // check listの更新
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
        guard let cellData = viewModel?.cellShowDataList[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.setup(name: cellData.name,
                   date: cellData.dateString,
                   shouldCheckFood: cellData.shouldCheck)
        return cell
    }
    
    

}
