//
//  WeatherDataVC.swift
//  Weather
//
//  Created by Mallikarjuna Chilakala on 10/14/18.
//

import UIKit
import CoreLocation


class WeatherDataVC: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var selectedCity: CityViewModel?
    
    @IBOutlet weak var collectionView:UICollectionView!
    var data:[String.SubSequence : [List]]?
    var list = [List]()
    var weatherData : [String.SubSequence : [List]] = [:]

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib.init(nibName: "WeatherTableCell", bundle: nil), forCellReuseIdentifier: "WeatherTableCell")
   
//        if let selectedCity = selectedCity {
//            fetchWeather(selectedCity)
//        } else {
//            startUserLocationService()
//        }
        localupdate()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// This Method is used to show and hide the Activity Indicator
    ///
    /// - Parameter show: Bool value to show and hide Activity Indicator
    func showActivityIndicator(show: Bool) {
        if show {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }

    /// This method is used to fetch the data from 
    private func localupdate() {
       self.showActivityIndicator(show: true)
         if let url = Bundle.main.url(forResource: "forecast", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                let datalist = weatherResponse.list
                list = weatherResponse.list
                self.title = weatherResponse.city.name + " , " +  weatherResponse.city.country
                //GroupBy
                let predicate = {(element : List) in
                    return element.dtTxt.prefix(10)
                }
                self.weatherData = Dictionary(grouping: datalist, by: predicate)
                DispatchQueue.main.async {
                    self.showActivityIndicator(show: false)
                    self.tableView.reloadData()
                }
            } catch {
                
            }
        }
    }
    
    private func startUserLocationService(){
        let location = LocationService.sharedInstance
        location.delegate = self
        location.startUpdatingLocation()
    }
    
    private func fetchWeather(_ selectedCity:CityViewModel){
        self.showActivityIndicator(show: true)
        let apiString = WeatherAPI.forecastUrl(City: selectedCity.city)
        WeatherService.Global.fetchWeather(withURL: URL(string: apiString.urlEncoded!)!) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let weatherResponse):
                    let datalist = weatherResponse.list
                    self.list = datalist
                     self.title = weatherResponse.city.name + " , " +  weatherResponse.city.country
                    //GroupBy
                    let predicate = {(element : List) in
                        return element.dtTxt.prefix(10)
                    }

                    self.weatherData = Dictionary(grouping: datalist, by: predicate)
                    print("data .count \(String(describing: self.data?.count))")
                    DispatchQueue.main.async {
                        self.showActivityIndicator(show: false)
                        self.tableView.reloadData()
                    }
                default:
                    break
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
//MARK: LocationServiceDelegate

extension WeatherDataVC: LocationServiceDelegate {

    func locationDidUpdate(_ service: LocationService, location: CLLocation) {
        print(location.coordinate.latitude,location.coordinate.longitude)
        
        let apiString = WeatherAPI.forecastUrlWith(location : location)
        self.showActivityIndicator(show: true)
        WeatherService.Global.fetchWeather(withURL: URL(string: apiString.urlEncoded!)!) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let weatherResponse):
                    let datalist = weatherResponse.list
                    self.list = datalist
                    self.title = weatherResponse.city.name + " , " +  weatherResponse.city.country
                    //GroupBy
                    let predicate = {(element : List) in
                        return element.dtTxt.prefix(10)
                    }
                    self.weatherData = Dictionary(grouping: datalist, by: predicate)
                    DispatchQueue.main.async {
                        self.showActivityIndicator(show: false)
                        self.tableView.reloadData()
                    }
                default:
                    break
                }
                
            }
        }
        
    }
    
    func locationDidFail(withError error: AppError) {
        switch error.errorCode {
        case .unableToFindLocation:
            print("We're having trouble getting user location.")
        default:
            break
            
        }
    }
}

extension WeatherDataVC: UITableViewDataSource , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.weatherData.keys.count
    }
//    func  tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 50
//    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let keys = Array(self.weatherData.keys)
        return self.getDate(string: "\(keys[section])")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableCell", for: indexPath) as! WeatherTableCell
        let componentArray =  Array(self.weatherData.keys)
        let key  = componentArray[indexPath.row]
        cell.data = self.weatherData[key]!
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func getDate(string: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        let date = dateFormatter.date(from: string)
        return self.dayOfTheWeek(date: date! as NSDate)!
    }
    
    func dayOfTheWeek(date: NSDate) -> String? {
        let weekdays = [
            "Sunday",
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Satudrday,"
        ]
        
        let calendar: NSCalendar = NSCalendar.current as NSCalendar
        let components: NSDateComponents = calendar.components(.weekday, from: date as Date) as NSDateComponents
        return weekdays[components.weekday - 1]
    }
}
