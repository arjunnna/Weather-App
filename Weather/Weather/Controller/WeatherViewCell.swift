//
//  WeatherViewCell.swift
//  Weather
//
//  Created by Mallikarjuna Chilakala on 10/14/18.
//

import UIKit

class WeatherViewCell: UICollectionViewCell {
    @IBOutlet weak var weatherView:WeatherView!
    func loadDataModel(dataModel: List) {
        self.weatherView.loadViewModel(WeatherViewModel(with: dataModel))
    }
}
