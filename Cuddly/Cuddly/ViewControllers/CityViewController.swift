//
//  CityViewController.swift
//  Cuddly
//
//  Created by Mitch on 22/09/2020.
//  Copyright © 2020 Mitch. All rights reserved.
//

import UIKit
import MapKit

class CityViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bottomSectionView: UIView!
    @IBOutlet weak var topSectionView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherTableView: UITableView!
    
    @IBOutlet weak var maximumTemperatureLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var minimumTemperatureLabel: UILabel!

    var city = ""
    var weatherResult: Result?
    var currentlocation: CLLocation?
    var cityViewModel: CityViewModel?
    
    private lazy var cellProvider: CityCellProvider = {
        let provider = CityCellProvider(tableView: weatherTableView)
        return provider
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        setupUI()
    }
    
    func setupUI() {
        topSectionView.isHidden = true
        bottomSectionView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if cityViewModel == nil {
            self.cityViewModel = CityViewModel(delegate: self)
        }
        guard let latitude = currentlocation?.coordinate.latitude, let longitude = currentlocation?.coordinate.longitude else {return}
        NetworkService.shared.setLatitude(latitude)
        NetworkService.shared.setLongitude(longitude)
        cityViewModel?.getWeather()
    }
    
    func updateCurrentView(currentWeather: Current, city: String) {
        cityLabel.text = city
        dateLabel.text = Date.getTodaysDate()
        guard currentWeather.weather.indices.contains(0) else {
            return
        }
        weatherLabel.text = currentWeather.weather[0].description.capitalized
        let weather = currentWeather.weather[0].main.getWeatherType()
        bottomSectionView.backgroundColor = weather.backgroundColor
        topSectionView.backgroundColor = UIColor(patternImage: UIImage(named: weather.imageName) ?? UIImage())
        currentTemperatureLabel.text = "\(currentWeather.temp)°C"
        let temperatures = weatherResult?.hourly.map{($0.temp)}.sorted()
        if let minimumTemperature = temperatures?.first{
            minimumTemperatureLabel.text = "\(minimumTemperature)°C"
        }
        if let maximumTemperature = temperatures?.last{
            maximumTemperatureLabel.text = "\(maximumTemperature)°C"
        }
    }
    
    func updateViews() {
        updateCurrentWeather()
        weatherTableView.reloadData()
    }
    
    func updateCurrentWeather() {
        guard let weatherResult = weatherResult else {
            return
        }
        self.updateCurrentView(currentWeather: weatherResult.current, city: city)
    }
    
    
}
extension CityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellProvider.itemsForSections(numberOfItemsInSection: section, weatherResult: weatherResult)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellProvider.cellForRowAt(cellForItemAt: indexPath, weatherResult: weatherResult)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension CityViewController: CityDelegate{
    func foundResult(result: Result) {
        self.weatherResult = result
        self.updateViews()
        activityIndicator.stopAnimating()
        topSectionView.isHidden = false
        bottomSectionView.isHidden = false
    }
    
    func requestFailed(with error: String) {
        self.showAlert(alertText: "Failed", alertMessage: error)
    }
}
