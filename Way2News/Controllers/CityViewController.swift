//
//  CityViewController.swift
//  Way2News
//
//  Created by Smscountry on 13/03/21.
//

import UIKit
import CoreLocation

class CityViewController: UIViewController {
    
    // Outlet Connections
    @IBOutlet weak var forecastCollectionView: UICollectionView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imagview: UIImageView!
    @IBOutlet weak var tableview: UITableView!
    
    // Variable definitions
    var latitude = CLLocationDegrees()
    var longitude = CLLocationDegrees()
    var cityName = String()
    var arrofData = [TodayForecastModel]()
    var fivedaysarrofData = [[TodayForecastModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityNameLabel.text = cityName
        self.tableview.isHidden = true
        self.getAPIresponse()
    }
    
    //MARK:- Button Actions
    
    @IBAction func showFivedaysReports(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        if (sender.isSelected) {
            imagview.image = UIImage(named: "up-arrow")
            self.tableview.isHidden = false
            if self.fivedaysarrofData.count > 0 {
                
            } else {
                self.getAPIFivedaysresponse()
            }
        } else {
            imagview.image = UIImage(named: "down-arrow")
            self.tableview.isHidden = true
        }
    }
    
    @IBAction func settingsButtonClick(_ sender: UIButton) {
        
        let mainstoryBoard = UIStoryboard(name: "Main", bundle: nil)
        if #available(iOS 13.0, *) {
            let settingsViewcontroller = mainstoryBoard.instantiateViewController(identifier: "SettingsViewController") as! SettingsViewController
            self.navigationController?.pushViewController(settingsViewcontroller, animated: true)
        } else {
            let settingsViewcontroller = mainstoryBoard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
            self.navigationController?.pushViewController(settingsViewcontroller, animated: true)
        }
        
        
    }
    
    //MARK:- Methods
    
    func getAPIresponse()  {
        let endpoint_Str = "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(APIKey)"
        Webservices.sharedInstance.getAPI(API_String: endpoint_Str, target: self) { [weak self] (data) in
            switch Webservices.sharedInstance.responseStatus {
            case.success:
                if let response_data = data as? [String: Any] {
                    self?.arrofData.append(TodayForecastModel(forecastDict: response_data))
                    
                    DispatchQueue.main.async {
                        if let description = self?.arrofData[0].weather?.description as? String {
                            self?.descriptionLabel.text = description
                        }
                        self?.forecastCollectionView.reloadData()
                    }
                }
            case.error:
                // Display internet connection alert
                print("error")
            case.nill:
                // Display internet connection alert
                print("error")
            default:
                break
            }
        }
    }
    
    func getAPIFivedaysresponse()  {
        
        let endpoint_url = "http://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(APIKey)&units=metric"
        Webservices.sharedInstance.getAPI(API_String: endpoint_url, target: self) { [weak self] (data) in
            switch Webservices.sharedInstance.responseStatus {
            case.success:
                if let response_data = data as? [String: Any] {
                    if let list = response_data["list"] as? [[String: Any]] {
                        var finalArray = [TodayForecastModel]()
                        for record in list {
                            finalArray.append(TodayForecastModel(forecastDict: record))
                        }
                        self?.datasegregation(data: finalArray)
                    }
                }
            case.error:
                // Display internet connection alert
                print("error")
            case.nill:
                // Display internet connection alert
                print("error")
            default:
                break
            }
        }
    }
    
    func datasegregation(data: [TodayForecastModel])  {
        var finalArray = [TodayForecastModel]()
        var lastArray = [[TodayForecastModel]]()
        var previousDate_str = ""
        if (data.count > 0) {
            for object in data {
                let datesperated_str = (object.dat_text).components(separatedBy: " ")
                if previousDate_str == "" || datesperated_str[0] == previousDate_str {
                    previousDate_str = datesperated_str[0]
                    finalArray.append(object)
                } else {
                    lastArray.append(finalArray)
                    finalArray.removeAll()
                    finalArray.append(object)
                    previousDate_str = datesperated_str[0]
                }
            }
            self.fivedaysarrofData = lastArray
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
        }
    }
    
    deinit {
        print("cleared")
    }
}

//MARK:- UICollectionViewDataSource, UICollectionViewDelegate
extension CityViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrofData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "forecastCell", for: indexPath) as? ForecastCollectionViewCell {
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
        
        
        return CGSize(width: forecastCollectionView.frame.size.width, height: 100)
    }
}

//MARK:- UITableViewDataSource, UITableViewDelegate
extension CityViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fivedaysarrofData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FivedaysForecatTVCell") as? FivedaysForecatTVCell {
            cell.dateLabel.text = self.fivedaysarrofData[indexPath.row][0].dat_text.components(separatedBy: " ")[0]
            cell.configureCollectionView(tableviewData: self.fivedaysarrofData[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    
}
