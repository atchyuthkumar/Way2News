//
//  CoreDataManger.swift
//  Way2News
//
//  Created by Smscountry on 13/03/21.
//

import Foundation
import CoreData
import UIKit


class CoreDataModel {
    static let sharedInstance: CoreDataModel = {
        let instance = CoreDataModel()
        return instance
    }()
   
    let mainContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
     
    func savelocationsData(location_name: String, location_lat: Double, location_long: Double)  {
        
        let entity = NSEntityDescription.entity(forEntityName: "Locations", in: mainContext)
        let newLocation = NSManagedObject(entity: entity!, insertInto: mainContext)
        newLocation.setValue(location_name, forKey: "location_name")
        newLocation.setValue(location_lat, forKey: "latitude")
        newLocation.setValue(location_long, forKey: "longitude")
        
        do {
            try mainContext.save()
            print("data saved")
        } catch let error {
            print("saving data failed due to \(error.localizedDescription)")
        }
        
    }
    
    func fetchingLocationData() -> [Locations]  {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Locations")
        request.returnsObjectsAsFaults = false
        var finalUserdetails = [Locations]()
        do {
            let result = try mainContext.fetch(request)
            for data in result as! [Locations] {
                print(data.location_name)
                finalUserdetails.append(data)
            }
            return finalUserdetails
        } catch {
            print("Failed")
            return finalUserdetails
        }
    }
    
    
}
