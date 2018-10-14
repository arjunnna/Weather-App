//
//  WeatherDataCell.swift
//  Weather
//
//  Created by Malli on 14/10/18.
//

import UIKit

class WeatherDataCell: UICollectionViewCell {

    @IBOutlet weak var weatherView:WeatherView!
    // MARK: - init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - ViewModel
  
    func loadDataModel(dataModel: List) {
        self.loadViewModel(WeatherViewModel(with: dataModel))
    }
    
    // MARK: - ViewModel
    var viewModel: WeatherViewModel? {
        didSet {
            weatherView.loadViewModel(viewModel)
        }
    }
    
    func loadViewModel(_ viewModel: WeatherViewModel) {
        self.viewModel = viewModel
    }

}
