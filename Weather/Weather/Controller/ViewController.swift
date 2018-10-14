//
//  ViewController.swift
//  Weather
//
//  Created by Mallikarjuna Chilakala on 10/14/18.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Weather Forcast"
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    /// Returns the List of Cities from Cities json file
    private var cities: [CityViewModel]  {
        if let url = Bundle.main.url(forResource: "Cities", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let cityModels = try JSONDecoder().decode([City].self, from: data)
                let viewModels = cityModels.map { CityViewModel(with:  $0) }
                return viewModels
            } catch {
            }
        }
        return []
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard  let cell = sender as? UITableViewCell, let indexpath = self.tableView.indexPath(for: cell), WeatherFetchType(rawValue: indexpath.section) == .userCity else {
            return
        }
        
        if let weatherDtailVc = segue.destination as? WeatherDataVC {
            weatherDtailVc.selectedCity = cities[indexpath.row]
        }
    }
}


//MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
          return "Get Weather Forecast Based on Location"
        } else {
            return "Select City To Get Weather Forecast"
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch  WeatherFetchType(rawValue: section)! {
        case .userLocation:
            return 1
        case .userCity:
            return cities.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        switch  WeatherFetchType(rawValue: indexPath.section)! {
        case .userLocation:
            cell.textLabel?.text = "CurrentLocation"
        case .userCity:
            cell.textLabel?.text = cities[indexPath.row].description
        }
        return cell
        
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

