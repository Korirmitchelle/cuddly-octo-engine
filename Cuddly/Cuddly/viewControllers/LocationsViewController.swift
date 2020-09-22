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
    var cities = ["Nairobi","Kampala","Djibouti","Cairo"]
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(address) { completion($0?.first?.location?.coordinate, $1) }
    }
    
}
extension LocationsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "locationscell") as? LocationsTableViewCell else {return UITableViewCell()}
        cell.label.text = cities[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = cities[indexPath.row]
        getCoordinateFrom(address: name, completion: {location,error in
            guard let cityController = self.storyboard?.instantiateViewController(identifier: "CityViewController") as? CityViewController else {return}
            guard let lat = location?.latitude ,let lon = location?.longitude else {return}
            cityController.currentlocation = CLLocation(latitude: lat, longitude: lon)
            cityController.city = name
            self.present(cityController, animated: true, completion: nil)
        })
        
    }
}
