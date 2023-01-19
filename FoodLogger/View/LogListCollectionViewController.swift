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
    
    private let models = [Meal(date: Date(),
                               foods: [InputedFood(name: "apple")]),
                          Meal(date: Date(),
                               foods: [InputedFood(name: "banana")]),
                          Meal(date: Date(),
                               foods: [InputedFood(name: "orange")]),
                          Meal(date: Date(),
                               foods: [InputedFood(name: "melon")]),
                          Meal(date: Date(),
                               foods: [InputedFood(name: "apple")]),
                          Meal(date: Date(),
                               foods: [InputedFood(name: "lemon")])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        
        let section = gridSection(collectionViewBounds: collectionView.frame)
        let layout = UICollectionViewCompositionalLayout(section: section)
        collectionView.collectionViewLayout = layout
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
    }
    
}

extension LogListCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InputedFoodCollectionCell", for: indexPath) as? LogListCollectionCell else {
            return UICollectionViewCell()
        }
        let index = indexPath.row
        let model = models[index]
        cell.setup(first: model.foods.first!.name,
                   date: DateFormatter().custom.string(from: model.date))
        
        return cell
    }
    
    
}
