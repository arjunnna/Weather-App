//
//  WeatherResponseModel.swift
//  Weather
//
//  Created by Mallikarjuna Chilakala on 10/14/18.
//

import Foundation
import CoreLocation

//MARK: WeatherResponse
struct WeatherResponse: Codable {
    let cod: String
    let message: Double
    let cnt: Int
    let list: [List]
    let city: City
    
}

struct City: Codable {
    let id: Int?
    let name: String
    let coord: Coord?
    let country: String
    let population: Int?
}

struct Coord: Codable {
    let lat, lon: Double
}

struct List: Codable {
    let dt: Int
    let weatherData: WeatherData
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let rain: Rain?
    let sys: Sys
    let dtTxt: String
    
    enum CodingKeys: String, CodingKey {
        case  dt, weather, clouds, wind, rain, sys
        case dtTxt = "dt_txt"
        case weatherData = "main"
    }
}

struct Clouds: Codable {
    let all: Int
}

struct WeatherData: Codable {
    let temp, tempMin, tempMax, pressure: Double
    let seaLevel, grndLevel: Double
    let humidity: Int
    let tempKf: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

struct Rain: Codable {
    let the3H: Double?
    
    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

struct Sys: Codable {
    let pod: String
}



struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}



struct Wind: Codable {
    let speed, deg: Double
}


//MARK: VIEWMODELS
struct CityViewModel {
    let city , country: String
    var description: String {
        return city + " , " + country
    }
    init(with city: City) {
        self.city = city.name
        self.country = city.country
    }
}

struct WeatherViewModel {
    
    
    let timeString: String
    let weatherIcon: String
    let temp: String
    let des:String
    
    init(with list: List) {
        temp = Temperature(openWeatherMapDegrees: Double(list.weatherData.temp)).degrees
        timeString = ResponseDateTime(date: Double(list.dt)).shortDate + " " + ResponseDateTime(date: Double(list.dt)).shortTime
        weatherIcon = WeatherIcon(condition: list.weather[0].id, iconString: list.weather[0].icon).iconText
        des = list.weather[0].main
    }
}




struct Temperature {
    let degrees: String
    
    init(country: String = "IN", openWeatherMapDegrees: Double) {
        if country == "US" {
            degrees = String(TemperatureConverter.kelvinToFahrenheit(openWeatherMapDegrees)) + "\u{f045}"
        } else {
            degrees = String(TemperatureConverter.kelvinToCelsius(openWeatherMapDegrees)) + "\u{f03c}"
        }
    }
}

//MARK: TemperatureConverter

struct TemperatureConverter {
    
    // Convert from K to C (Double)
    static func kelvinToCelsius(_ degrees: Double) -> Double {
        return round(degrees - 273.15)
    }
    
    // Convert from K to F (Integer)
    static func kelvinToFahrenheit(_ degrees: Double) -> Double {
        return round(degrees * 9 / 5 - 459.67)
    }
    
    // Convert from F to C (Integer)
    static func fahrenheitToCelsius(fahrenheit:Int) ->Int {
        let celsius = (fahrenheit - 32) * 5 / 9
        return celsius as Int
    }
    
    // Convert from C to F (Integer)
    static func celsiusToFahrenheit(celsius:Int) ->Int {
        let fahrenheit = (celsius * 9/5) + 32
        return fahrenheit as Int
    }

}



struct ResponseDateTime {
    let rawDate: Double
    let timeZone: TimeZone
    
    init(date: Double, timeZone: TimeZone = TimeZone.current) {
        self.timeZone = timeZone
        self.rawDate = date
    }
    
    var shortTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = "h:mm a"
        let date = Date(timeIntervalSince1970: rawDate)
        return dateFormatter.string(from: date)
    }
    var shortDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = "dd MMM,yyyy"
        let date = Date(timeIntervalSince1970: rawDate)
        return dateFormatter.string(from: date)
    }
}




