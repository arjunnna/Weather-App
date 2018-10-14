//
//  AppConstants.swift
//  Weather
//
//  Created by Mallikarjuna Chilakala on 10/14/18.
//

import UIKit
import CoreLocation

// MARK: - Internal constants

internal let Token = "564799b60389a0358bade7d74899c4e6"
internal let emptyString = ""

// MARK: - AppError constants
struct AppError {
    enum Code: Int {
        case urlError                 = -6000
        case networkRequestFailed     = -6001
        case jsonSerializationFailed  = -6002
        case jsonParsingFailed        = -6003
        case unableToFindLocation  = -6004
    }
    
    let errorCode: Code
}


// MARK: - WeatherAPI constants
enum WeatherFetchType: Int {
    
    case userLocation = 0
    case userCity = 1
}

struct WeatherAPI {
    
    private static let iconURL = "https://openweathermap.org/img/w/"
    private static let API = "https://api.openweathermap.org/data/2.5/weather?"
    private static let API1 = "https://api.openweathermap.org/data/2.5/"

    private static let AppID = "&appid=" + Token
    
    static func with(City city:String) -> String {
        return WeatherAPI.API + "q=\(city)" + WeatherAPI.AppID
    }
    
    static func forecastUrl(City city:String) -> String {
        return WeatherAPI.API1 + "forecast?" + "q=\(city)" + WeatherAPI.AppID
    }
    
    static func forecastUrl(City city:String, country:String) -> String {
        return WeatherAPI.API1 + "forecast?" + "q=\(city),\(country)" + WeatherAPI.AppID
    }
    
    static func forecastUrlWith(lattitude lat:String, and long:String) -> String {
        return WeatherAPI.API1 + "forecast?" + "lat=\(lat)&lon=\(long)"  + WeatherAPI.AppID
    }
    
    
    static func forecastUrlWith( location loc:CLLocation) -> String {
        let lat = String(loc.coordinate.latitude)
        let long = String(loc.coordinate.longitude)
        return  WeatherAPI.forecastUrlWith(lattitude: lat, and: long)
        
    }
   
    
}

















