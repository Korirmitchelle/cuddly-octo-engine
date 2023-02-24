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
    var bookMarksViewModel: BookMarksViewModel?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bookMarksViewModel = BookMarksViewModel(delegate: self)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        saveLocations()
    }
    
    func saveLocations(){
        if let saved = UserDefaults.standard.value(forKey: "locations") as? [String] {
            bookMarksViewModel?.locations = saved
            tableView.reloadData()
        }
    }
    
}

extension BookmarksViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookMarksViewModel?.locations.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bookscell") as? BookMarksTableViewCell else {return UITableViewCell()}
        cell.label.text = bookMarksViewModel?.locations[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let name = bookMarksViewModel?.locations[indexPath.row] else {
            return
        }
        bookMarksViewModel?.getCoordinateFrom(address: name)
        
    }
}

extension BookmarksViewController: GeocoderDelegate {
    func foundLocation(location: CLLocationCoordinate2D, name: String) {
        guard let cityController = self.storyboard?.instantiateViewController(identifier: "CityViewController") as? CityViewController else {return}
        cityController.currentlocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        cityController.city = name
        self.present(cityController, animated: true, completion: nil)
    }
    
    func locationQueryFailed(with error: Error?) {
        //TODO: Error handling

    }
    
}
