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
    @IBOutlet weak var locationPinImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    
    
    var viewModel:AddlocationsViewModel?
    
    var locationManager: CLLocationManager {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = .leastNormalMagnitude
        manager.requestAlwaysAuthorization()
        manager.distanceFilter = 50
        manager.startUpdatingLocation()
        return manager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = AddlocationsViewModel(delegate: self)
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        mapView.delegate = self
    }
    
    @IBAction func done(_ sender: Any) {
        showWeather()
    }
    
    
    func showWeather(){
        viewModel?.saveLocationName(locationName: locationLabel.text)
        guard let location = viewModel?.lastLocation else {
            return
        }
        guard let cityController = storyboard?.instantiateViewController(identifier: "CityViewController") as? CityViewController else {return}
        cityController.currentlocation = location
        cityController.city = locationLabel.text ?? ""
        self.present(cityController, animated: true, completion: nil)
    }
    
}
extension AddLocationViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let mapView = self.mapView ,let lastLocation = locations.last{
            self.viewModel?.lastLocation = lastLocation
            let region = MKCoordinateRegion(center: lastLocation.coordinate, latitudinalMeters: AppConstants.distanceSpan, longitudinalMeters: AppConstants.distanceSpan)
            mapView.setRegion(region, animated: true)
            mapView.showsUserLocation = true
        }
    }
    
}
extension AddLocationViewController:MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        self.viewModel?.geocode(from: location)
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
}


extension AddLocationViewController: PlaceDelegate {
    func foundPlace(place: [CLPlacemark]) {
        self.locationLabel.text = place.first?.locality
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
    }
    
    func placeQueryFailed(with error: Error?) {
        //TODO: Error handling
    }
}
