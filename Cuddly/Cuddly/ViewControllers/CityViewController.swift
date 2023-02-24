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
    var locationManger: CLLocationManager!
    var currentlocation: CLLocation?
    
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
        guard let latitude = currentlocation?.coordinate.latitude, let longitude = currentlocation?.coordinate.longitude else {return}
        NetworkService.shared.setLatitude(latitude)
        NetworkService.shared.setLongitude(longitude)
        self.getWeather()
    }
    
    
    func updateCurrentView(currentWeather: Current, city: String) {
        cityLabel.text = city
        dateLabel.text = Date.getTodaysDate()
        weatherLabel.text = currentWeather.weather[0].description.capitalized
        todayImageView.image = UIImage(named: currentWeather.weather[0].icon)
    }
    
  
    func getWeather() {
        NetworkService.shared.getWeather(onSuccess: { (result) in
            self.weatherResult = result
            self.weatherResult?.sortDailyArray()
            self.weatherResult?.sortHourlyArray()
            self.updateViews()
            print("weather result here \(result)")
            
        }) { (errorMessage) in
            debugPrint(errorMessage)
        }
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
        let index = segmentedControl.selectedSegmentIndex
        let segmentTitle = segmentedControl.titleForSegment(at: index) ?? ""
        var count = 4
        if segmentTitle == "Today"{
            count = weatherResult?.hourly.count ?? 4
        }
        else if segmentTitle == "Weekly"{
            count = weatherResult?.daily.count ?? 4
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weathercell", for: indexPath) as? WeatherCollectionViewCell else {
            return UICollectionViewCell()
        }
        let segmentTitle = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex) ?? ""
        if segmentTitle == "Today"{
            if let humidity = weatherResult?.hourly[indexPath.row].humidity{
                cell.topLabel.text = String(humidity)
            }
            if let temperature = weatherResult?.hourly[indexPath.row].temp{
                cell.bottomLabel.text = String(temperature)
            }
            if let hour = weatherResult?.hourly[indexPath.row]{
                cell.weatherImageView.image = UIImage(named: hour.weather[0].icon)
            }

        }
        else if segmentTitle == "Weekly"{
            if let day = weatherResult?.daily[indexPath.row] {
                cell.weatherImageView.image = UIImage(named: day.weather[0].icon)
            }

            if let humidity = weatherResult?.daily[indexPath.row].humidity{
                cell.topLabel.text = String(humidity)
            }
            if let temperature = weatherResult?.daily[indexPath.row].temp.day{
                cell.bottomLabel.text = String(temperature)
            }
        }
        return cell
    }
}
