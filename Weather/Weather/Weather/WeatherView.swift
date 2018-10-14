//
//  WeatherView.swift
//  Weather
//
//  Created by Mallikarjuna Chilakala on 10/14/18.
//

import UIKit

class WeatherView: UIView {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!

    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - ViewModel
    var viewModel: WeatherViewModel? {
        didSet {
            self.timeLabel.text = viewModel?.timeString ?? ""
            self.locationLabel.text = viewModel?.des
            self.iconLabel.text = viewModel?.weatherIcon
            self.temperatureLabel.text = viewModel?.temp
            
        }
    }

    func loadViewModel(_ viewModel: WeatherViewModel?) {
        self.viewModel = viewModel
    }
}
