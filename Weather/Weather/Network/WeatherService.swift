//
//  RequestManager.swift
//  Weather
//
//  Created by Mallikarjuna Chilakala on 10/14/18.
//

import Foundation
import UIKit

enum Result <T>{
    case Success(T)
    case Error(reason: String)
}

/// Manager for handling all REST API calls
final class WeatherService {
    
    static let Global = WeatherService ()
    
    private let reachability = Reachability()
    
    private var isConnectedToInternet: Bool {
        return Reachability.isConnectedToNetwork()
    }
    //1 creating the session
    private let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        configuration.timeoutIntervalForRequest = 60.00
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    

    typealias WeatherResponseCompletionHandler = (Result<WeatherResponse>) -> ()

    //Data call with request
    
    func fetchWeather(withURL url:URL, completionHandler completion: @escaping WeatherResponseCompletionHandler) {
        print("Service URL: \(url)")
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil, let httpResponse = response as? HTTPURLResponse  else {
                completion(.Error(reason:"Network is not avialable"))
                return
            }
            if httpResponse.statusCode == 200, let responsedata = data {
                do {
                    let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: responsedata)
                    DispatchQueue.main.async {
                        print("data count :\(weatherResponse.list.count)")
                        completion(.Success(weatherResponse))
                    }
                } catch (let error){
                    print(error)
                    completion(.Error(reason: "Response is not valid"))
                }
                
            } else {
                completion(.Error(reason: "Response is not valid"))
                print("\(String(describing: error))")
            }
        }
        task.resume()
    }

    
   
}
