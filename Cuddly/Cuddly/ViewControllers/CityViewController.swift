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
    
    @IBOutlet weak var todayImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var city = ""
    var weatherResult: Result?
    var currentlocation: CLLocation?
    var cityViewModel: CityViewModel?
    
    private lazy var cellProvider: CityCellProvider = {
        let provider = CityCellProvider(collectionView: collectionView)
        return provider
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        segmentedControl.addTarget(self, action: #selector(reload), for: .valueChanged)
    }
    
    @objc func reload(){
        collectionView.reloadData()
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
        todayImageView.image = UIImage(named: currentWeather.weather[0].icon)
    }
    
    func updateViews() {
        updateCurrentWeather()
        collectionView.reloadData()
    }
    
    func updateCurrentWeather() {
        guard let weatherResult = weatherResult else {
            return
        }
        self.updateCurrentView(currentWeather: weatherResult.current, city: city)
    }
    
    
}
extension CityViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let segmentType = SegmentType(rawValue: segmentedControl.selectedSegmentIndex)
        return cellProvider.itemsForSections(numberOfItemsInSection: section, segmentType: segmentType, weatherResult: weatherResult)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let segmentType = SegmentType(rawValue: segmentedControl.selectedSegmentIndex)
        return cellProvider.cellForRowAt(cellForItemAt: indexPath, segmentType: segmentType, weatherResult: weatherResult)
    }
}

extension CityViewController: CityDelegate{
    func foundResult(result: Result) {
        self.weatherResult = result
        self.updateViews()
    }
    
    func requestFailed(with error: String) {
        //TODO: Error Handling
    }
}
