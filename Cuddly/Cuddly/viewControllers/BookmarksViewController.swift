//
//  BookmarksViewController.swift
//  Cuddly
//
//  Created by Mitch on 22/09/2020.
//  Copyright © 2020 Mitch. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class BookmarksViewController: UIViewController {
    var locations = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let saved = UserDefaults.standard.value(forKey: "locations") as? [String]{
            locations = saved
        }
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let saved = UserDefaults.standard.value(forKey: "locations") as? [String]{
            locations = saved
            tableView.reloadData()
        }
    }
    func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(address) { completion($0?.first?.location?.coordinate, $1) }
    }
}



extension BookmarksViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bookscell") as? BookMarksTableViewCell else {return UITableViewCell()}
        cell.label.text = locations[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = locations[indexPath.row]
        getCoordinateFrom(address: name, completion: {location,error in
            guard let cityController = self.storyboard?.instantiateViewController(identifier: "CityViewController") as? CityViewController else {return}
            guard let lat = location?.latitude ,let lon = location?.longitude else {return}
            cityController.currentlocation = CLLocation(latitude: lat, longitude: lon)
            cityController.city = name
            self.present(cityController, animated: true, completion: nil)
        })
        
    }
}
