//
//  TodayForecastModel.swift
//  Way2News
//
//  Created by Smscountry on 13/03/21.
//

import Foundation
import UIKit

class TodayForecastModel {
    
    var temprature: mainModel?
    var wind: windModel?
    var clouds: Clouds?
    var weather: Weather?
    var dat_text = String()
    
    init(forecastDict: Dictionary<String, Any>) {
        if let dt_txt = forecastDict["dt_txt"] as? String {
            self.dat_text = dt_txt
        }
        if let main = forecastDict["main"] as? [String: Any] {
            self.temprature = mainModel(mainDictionary: main)
        }
        if let wind = forecastDict["wind"] as? [String: Any] {
            self.wind = windModel(windDictinary: wind)
        }
        if let clouds = forecastDict["clouds"] as? [String: Any] {
            self.clouds = Clouds(cloudsDict: clouds)
        }
        if let weather = forecastDict["weather"] as? [[String: Any]] {
            self.weather = Weather(weatherDict: weather[0])
        }
    }
}

class mainModel {
    var temparature = Double()
    var humidity = Int()
    init(mainDictionary: Dictionary<String, Any>) {
        if let temp = mainDictionary["temp"] as? Double {
            self.temparature = temp
        }
        if let humdity = mainDictionary["humidity"] as? Int {
            self.humidity = humdity
        }
    }
}

class windModel {
    var speed = Double()
    init(windDictinary: Dictionary<String, Any>) {
        if let speeed = windDictinary["speed"] as? Double {
            self.speed = speeed
        }
    }
}
class Clouds {
    var clouds = Int()
    
    init(cloudsDict: Dictionary<String, Any>) {
        if let all = cloudsDict["all"] as? Int {
            self.clouds = all
        }
    }
}
class Weather {
    var description = String()
    
    init(weatherDict: Dictionary<String, Any>) {
        if let descr = weatherDict["description"] as? String {
            self.description = descr
        }
    }
}
