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
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let result = viewModel?.onShouldPerformSegue() ?? false
        if result == false {
            let alert = UIAlertController()
            alert.title = "入力された食品がありません"
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
        return result
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 保存処理
        Task {
            await viewModel?.onPrepare()
        }
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InputFoodCell", for: indexPath) as? InputFoodCell,
              let viewModel else {
            return UITableViewCell()
        }
        let index = indexPath.row
        let cellData = viewModel.cellShowDataList[index]
        
        cell.setup(name: cellData.name,
                   date: cellData.dateString,
                   shouldCheckFood: cellData.shouldCheck)
        
        cell.didSwitchChanged = { changed in
            self.viewModel?.updateShouldCheck(name: viewModel.cellShowDataList[index].name, checked: changed)
        }
        return cell
    }
    
    

}
