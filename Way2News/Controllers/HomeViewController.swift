//
//  HomeViewController.swift
//  Way2news
//
//  Created by Smscountry on 13/03/21.
//

import UIKit
import CoreLocation
import MapKit

class HomeViewController: UIViewController {
    
    // Outlet Connections
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    
    // Variable definitions
    var locationManager = CLLocationManager()
    let manager = CoreDataModel()
    var searcharray = [Locations]()
    var locationArray = [Locations]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let tapgesture = UITapGestureRecognizer(target: self, action: #selector(gettouchLocation)) as? UITapGestureRecognizer   {
            mapView.addGestureRecognizer(tapgesture)
        }
        searchTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        searchTableView.isHidden = true
        //UpdateAnnotations
        self.updateAnnotations()
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        mapView.delegate = self
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (CLLocationManager.locationServicesEnabled()) {
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        }
    }
    
    
    //MARK:- Methods
    @objc func gettouchLocation( _ sender: UITapGestureRecognizer) {
        
        let location = sender.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        self.getlocationInformation(coordinates: coordinate)
        
    }
    
    func getlocationInformation(coordinates: CLLocationCoordinate2D)  {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Location name
            if let locationName = placeMark.name as? String {
                print(locationName)
                // Add annotation here
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinates
                annotation.title = String(locationName)
                // annotation.subtitle = city
                self.mapView.addAnnotation(annotation)
                CoreDataModel.sharedInstance.savelocationsData(location_name: locationName, location_lat: Double(location.coordinate.latitude), location_long: Double(location.coordinate.longitude))
            }
        })
    }
    
    func updateAnnotations()  {
        self.locationArray = CoreDataModel.sharedInstance.fetchingLocationData()
        print("locations count", locationArray.count)
        if (locationArray.count > 0) {
            for record in locationArray {
                let latitude = CLLocationDegrees(record.latitude)
                let longitude = CLLocationDegrees(record.longitude)
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = record.location_name
                // annotation.subtitle = city
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
}



//MARK:- CLLocationManagerDelegate
extension HomeViewController: CLLocationManagerDelegate {
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        switch manager.authorizationStatus {
        case .authorizedAlways , .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        case .notDetermined , .denied , .restricted:
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Getting current location
        let location = locations.last!
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        var region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        region.center = mapView.userLocation.coordinate
        mapView.setRegion(region, animated: true)
        //DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.locationManager.stopUpdatingLocation()
       // }
        
    }
}
//MARK:- MKMapViewDelegate
extension HomeViewController: MKMapViewDelegate {
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let selected_annotation = view.annotation as? MKAnnotation else {return}
        let mainstoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let cityViewcontroller = mainstoryBoard.instantiateViewController(identifier: "CityViewController") as! CityViewController
        cityViewcontroller.latitude = selected_annotation.coordinate.latitude
        cityViewcontroller.longitude = selected_annotation.coordinate.longitude
        cityViewcontroller.cityName = (selected_annotation.title ?? "City")! 
        self.navigationController?.pushViewController(cityViewcontroller, animated: true)
    }
}

//MARK:- UITableViewDataSource, UITableViewDelegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searcharray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? UITableViewCell {
            cell.textLabel?.text = searcharray[indexPath.row].location_name
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchTableView.isHidden = true
    }
    
    
}

//MARK:- UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.locationArray = CoreDataModel.sharedInstance.fetchingLocationData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchTableView.isHidden = false
        self.view.bringSubviewToFront(self.searchTableView)
        self.searchBar.resignFirstResponder()
        self.view.endEditing(true)
        if (searchBar.text != "") {
            searchTableView.isHidden = false
            self.view.bringSubviewToFront(self.searchTableView)
            let array = self.locationArray.filter { (($0 as! Locations).location_name! as String).range(of: self.searchBar.text!, options: [.caseInsensitive]) != nil }
            self.searcharray = array
            DispatchQueue.main.async {
                self.searchTableView.reloadData()
            }
        } else {
            searchTableView.isHidden = true
            
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchTableView.isHidden = true
        self.searchBar.resignFirstResponder()
        self.view.endEditing(true)
    }
}
