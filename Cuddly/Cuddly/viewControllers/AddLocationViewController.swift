//
//  AddLocationViewController.swift
//  Cuddly
//
//  Created by Mitch on 22/09/2020.
//  Copyright © 2020 Mitch. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBAction func done(_ sender: Any) {
        showWeather()
    }
    @IBOutlet weak var locationPinImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    
    let distanceSpan: Double = 5000
    var lastLocation:CLLocation?
    
    
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager = CLLocationManager()
        if let locationManager = self.locationManager {
            locationManager.delegate = self
            mapView.delegate = self
            locationManager.desiredAccuracy = .leastNormalMagnitude
            locationManager.requestAlwaysAuthorization()
            locationManager.distanceFilter = 50
            locationManager.startUpdatingLocation()
        }
    }
    func showWeather(){
        let userDefaults = UserDefaults.standard
        if let saved = UserDefaults.standard.value(forKey: "locations") as? [String]{
            var savedMutable = saved
            savedMutable.append(locationLabel.text!)
            userDefaults.set(savedMutable, forKey: "locations")
        }
        else{
            var array = [String]()
            array.append(locationLabel.text!)
            userDefaults.set(array, forKey: "locations")
        }
        guard lastLocation?.coordinate.latitude != nil,lastLocation?.coordinate.longitude != nil else {return}
        guard let cityController = storyboard?.instantiateViewController(identifier: "CityViewController") as? CityViewController else {return}
        cityController.currentlocation = self.lastLocation
        cityController.city = locationLabel.text ?? ""
        self.present(cityController, animated: true, completion: nil)
    }
    
}
extension AddLocationViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let mapView = self.mapView ,let lastLocation = locations.last{
            self.lastLocation = lastLocation
            let region = MKCoordinateRegion(center: lastLocation.coordinate, latitudinalMeters: self.distanceSpan, longitudinalMeters: self.distanceSpan)
            mapView.setRegion(region, animated: true)
            mapView.showsUserLocation = true
        }
    }
    
}
extension AddLocationViewController:MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        let distanceFromPrevious = location.distance(from: self.lastLocation ?? location)
        if distanceFromPrevious > 500 {
            location.geocode(completion: {place,error in
                self.locationLabel.text = place?.first?.locality
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            })
        }
        self.lastLocation = location
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
}

extension CLLocation {
    func geocode(completion: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> Void)  {
        CLGeocoder().reverseGeocodeLocation(self, completionHandler: completion)
    }
}
