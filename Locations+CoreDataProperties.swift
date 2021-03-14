//
//  Locations+CoreDataProperties.swift
//  Way2News
//
//  Created by Smscountry on 13/03/21.
//
//

import Foundation
import CoreData


extension Locations {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Locations> {
        return NSFetchRequest<Locations>(entityName: "Locations")
    }

    @NSManaged public var location_name: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double

}

extension Locations : Identifiable {

}
