//
//  LogListCollectionViewController.swift
//  FoodLogger
//
//  Created by 齋藤健悟 on 2023/01/19.
//

import Foundation
import UIKit

final class LogListCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let dateFormatter = DateFormatter().customDateAndTime
    let dateString = "2023年1月1日 12:10"
    private lazy var models: [Meal] = {
        [Meal(date: dateFormatter.date(from: dateString)!,
              foods: [InputedFood(name: "りんご")])!,
         Meal(date: dateFormatter.date(from: dateString)!,
              foods: [InputedFood(name: "レモン")])!
        ]
    }()
    
    var showData = [Meal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        
        let section = gridSection(collectionViewBounds: collectionView.frame)
        let layout = UICollectionViewCompositionalLayout(section: section)
        collectionView.collectionViewLayout = layout
        
        showData = models.reversed()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Task {
            let list = await UIApplication.shared.contentsService.inputDataStore.getMealList()
            self.showData = (self.models + list).reversed()
            collectionView.reloadData()
        }
    }
    
    private func gridSection(collectionViewBounds: CGRect) -> NSCollectionLayoutSection {
        let itemCount = 1 // 横に並べる数
        // １つのitemを生成
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(100))
        )
        let group = NSCollectionLayoutGroup
            .horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(100)),
                repeatingSubitem: item, count: itemCount)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = CGFloat(24)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24)
        return section
    }
    
    @IBAction func backToLogList(segue: UIStoryboardSegue) {
        // 戻ってきた時はコレクションビューを更新する
        self.collectionView.reloadData()
    }
    
}

extension LogListCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InputedFoodCollectionCell", for: indexPath) as? LogListCollectionCell else {
            return UICollectionViewCell()
        }
        
        let index = indexPath.row
        let model = showData[index]
        cell.setup(first: model.foods.first!.name,
                   date: DateFormatter().customDateAndTime.string(from: model.date))
        
        return cell
    }
    
    
}
