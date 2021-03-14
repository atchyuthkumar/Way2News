//
//  Webservices.swift
//  Way2News
//
//  Created by Smscountry on 13/03/21.
//

import Foundation
import UIKit

enum ServerResponseStatus {
    case success // API success response
    case nill // API response success but get empty data
    case error // error case
    
    init() {
        self = .success
    }
}

class Webservices {
    
    static let sharedInstance: Webservices = {
        let instance = Webservices()
        return instance
    }()
    
    var responseStatus = ServerResponseStatus()
    
    
    // GET API Calling
    func getAPI(API_String: String, target: UIViewController, completionHandler: @escaping(_ response: Any) -> Void)  {
        let myUrl = NSURL(string: API_String);
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "GET"
        var responseData = [String: Any]()
        let dataTask = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            do {
                if (data == nil ) {
                    self.responseStatus = ServerResponseStatus.nill
                    completionHandler(responseData)
                } else {
                    if let jsonData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any] {
                        self.responseStatus = ServerResponseStatus.success
                        print("jsondata", jsonData)
                        responseData = jsonData
                        completionHandler(responseData)
                    }
                }
            } catch let error {
                self.responseStatus = ServerResponseStatus.error
                completionHandler(responseData)
                #if DEBUG
                print("failure status, reson is \(error.localizedDescription)")
                #endif
            }
        }
        
        dataTask.resume()
    }
}
