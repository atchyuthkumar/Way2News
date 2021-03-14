//
//  FivedaysForecatTVCell.swift
//  Way2News
//
//  Created by Smscountry on 14/03/21.
//

import UIKit

class FivedaysForecatTVCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var fivedaysCollectionView: UICollectionView!
    var arrofData = [TodayForecastModel]()
    
    override class func awakeFromNib() {
        
    }
    
    func configureCollectionView(tableviewData: [TodayForecastModel])  {
        self.arrofData = tableviewData
        self.fivedaysCollectionView.dataSource = self
        self.fivedaysCollectionView.delegate = self
    }
    
}

//MARK:- UICollectionViewDataSource, UICollectionViewDelegate
extension FivedaysForecatTVCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrofData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FivedaysCollectionViewCell", for: indexPath) as? FivedaysCollectionViewCell {
            collectionViewCell.timeLabel.text = self.arrofData[indexPath.row].dat_text.components(separatedBy: " ")[1]
            collectionViewCell.temparaturenLabel.text = "\(self.arrofData[indexPath.row].temprature?.temparature ?? 0.0)"
            collectionViewCell.humidityLabel.text = "\(self.arrofData[indexPath.row].temprature?.humidity ?? 0)"
            collectionViewCell.cloudsLabel.text = "\(self.arrofData[indexPath.row].clouds?.clouds ?? 0)"
            collectionViewCell.windLabel.text = "\(self.arrofData[indexPath.row].wind?.speed ?? 0.0)"
            
            return collectionViewCell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 0
        let padding: CGFloat = 20
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        
        
        return CGSize(width: 300, height: 100)
    }
    
    
}
