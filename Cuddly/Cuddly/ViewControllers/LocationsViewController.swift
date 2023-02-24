//
//  LocationsViewController.swift
//  Cuddly
//
//  Created by Mitch on 22/09/2020.
//  Copyright © 2020 Mitch. All rights reserved.
//

import UIKit
import MapKit

class LocationsViewController: UIViewController {
    var locationsViewModel: LocationsViewModel?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationsViewModel = LocationsViewModel(delegate: self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}
extension LocationsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationsViewModel?.cities.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "locationscell") as? LocationsTableViewCell else {return UITableViewCell()}
        cell.selectionStyle = .none
        cell.label.text = locationsViewModel?.cities[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let name = locationsViewModel?.cities[indexPath.row] else {
            return
        }
        locationsViewModel?.getCoordinateFrom(address: name)
    }
}


extension LocationsViewController: GeocoderDelegate {
    func foundLocation(location: CLLocationCoordinate2D, name: String) {
        guard let cityController = self.storyboard?.instantiateViewController(identifier: "CityViewController") as? CityViewController else {return}
        cityController.currentlocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        cityController.city = name
        self.present(cityController, animated: true, completion: nil)
    }
    
    func locationQueryFailed(with error: Error?) {
        self.showAlert(alertText: "Failed", alertMessage: error?.localizedDescription ?? "Something went wrong")
    }
}
