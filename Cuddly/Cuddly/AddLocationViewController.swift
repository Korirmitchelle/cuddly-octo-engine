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
        getweather()
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
    func getweather(){
        guard let latitude = lastLocation?.coordinate.latitude, let longitude = lastLocation?.coordinate.longitude else {return}
       
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
                self.locationLabel.text = place?.first?.name
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                NetworkService.shared.getWeather(onSuccess: <#T##(Result) -> Void#>, onError: <#T##(String) -> Void#>)
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
