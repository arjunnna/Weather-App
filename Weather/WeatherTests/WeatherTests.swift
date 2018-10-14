//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by Mallikarjuna Chilakala on 10/14/18.
//

import XCTest
import CoreLocation
@testable import Weather
import Foundation

class WeatherTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testWeatherResponseModelData() {
       
        let jsonData  = """
        {"coord":{"lon":139,"lat":35},
         "sys":{"country":"JP","sunrise":1369769524,"sunset":1369821049},
         "weather":[{"id":804,"main":"clouds","description":"overcast clouds","icon":"04n"}],
         "main":{"temp":289.5,"humidity":89,"pressure":1013,"temp_min":287.04,"temp_max":292.04},
         "wind":{"speed":7.31,"deg":187.002},
         "rain":{"3h":0},
         "clouds":{"all":92},
         "dt":1369824698,
         "id":1851632,
         "name":"Shuzenji",
         "cod":200}
        """.data(using: .utf8)
        do {
           let response = try JSONDecoder().decode(WeatherResponseModel.self, from: jsonData!)
            let json = try JSONSerialization.jsonObject(with: jsonData!, options: []) as? [String:Any]
           XCTAssertEqual("JP", response.country)
            let weatherViewModel = WeatherResponseViewModel(with: response)
           XCTAssertEqual(response.country, weatherViewModel.country)
           XCTAssertEqual(response.responseCode, 200)
           XCTAssertEqual(weatherViewModel.city, "Shuzenji")
            
            let jsonModel = WeatherResponseModel(with: json!)
            XCTAssertEqual(jsonModel.country, weatherViewModel.country)
            
            let weatherICon = WeatherIcon(condition: 804, iconString: "04n")
            XCTAssertEqual(weatherViewModel.location, weatherICon.iconText)

            


        } catch {
            XCTAssertThrowsError(error)
        }

    }
    
    func testWeatherAPI() {
        let cityAPI = WeatherAPI.with(City: "london")
        XCTAssertEqual("https://api.openweathermap.org/data/2.5/weather?q=london&appid=564799b60389a0358bade7d74899c4e6", cityAPI)

       let location = CLLocation(latitude: 13.71234, longitude: 14.21234)
       let locationAPI = WeatherAPI.with(location: location)
        XCTAssertEqual("https://api.openweathermap.org/data/2.5/weather?lat=13.71234&lon=14.21234&appid=564799b60389a0358bade7d74899c4e6", locationAPI)
        let cityCountryAPI = WeatherAPI.with(city: "London", country: "UK")
        XCTAssertEqual("https://api.openweathermap.org/data/2.5/weather?q=London,UK&appid=564799b60389a0358bade7d74899c4e6", cityCountryAPI)
        }

    func testTemperatureConvertions() {
        XCTAssertEqual(TemperatureConverter.kelvinToCelsius(200), -73)
        XCTAssertEqual(TemperatureConverter.kelvinToFahrenheit(200), -100)
        XCTAssertEqual(TemperatureConverter.celsiusToFahrenheit(celsius: 200), 392)
        XCTAssertEqual(TemperatureConverter.fahrenheitToCelsius(fahrenheit: 392), 200)

    }
    
    func testCity() {
        let cityJson = ["city":"xyz","country":"abc"]
        let cityJsonModel = City(with: cityJson)
        XCTAssertNotNil(cityJsonModel)
        let cityJsonViewModel = CityViewModel(with: cityJsonModel)
        XCTAssertEqual(cityJsonModel.country, cityJsonViewModel.country)
        XCTAssertEqual(cityJsonModel.city, cityJsonViewModel.city)
        XCTAssertEqual("xyz , abc", cityJsonViewModel.description)
        
        do {
            let jsondata = """
                { "city":"xyz","country":"abc"}
            """.data(using: .utf8)
            let cityModel = try JSONDecoder().decode(City.self, from: jsondata!)
            XCTAssertNotNil(cityModel)
            let cityViewModel = CityViewModel(with: cityModel)
            XCTAssertEqual(cityJsonModel.country, cityViewModel.country)
            XCTAssertEqual(cityJsonModel.city, cityViewModel.city)
            XCTAssertEqual("xyz , abc", cityViewModel.description)
        } catch {
            XCTAssertThrowsError(error)

        }
    }

    
}
