//
//  AddLocationsViewModel.swift
//  Cuddly
//
//  Created by Mitchelle Korir on 24/02/2023.
//  Copyright © 2023 Mitch. All rights reserved.
//

import Foundation
import MapKit

protocol PlaceDelegate: AnyObject {
    func foundPlace(place: [CLPlacemark])
    func placeQueryFailed(with error: Error?)
}

class AddlocationsViewModel {
    var lastLocation:CLLocation?
    var geocoder = GeocoderService()
    weak var placeDelegate: PlaceDelegate?
    
    init(delegate: PlaceDelegate){
        placeDelegate = delegate
    }
    
    func geocode(from location: CLLocation) {
        let distanceFromPrevious = location.distance(from: self.lastLocation ?? location)
        self.lastLocation = location
        guard distanceFromPrevious > 500 else {
            return
        }
        
        geocoder.geocode(from: location){place, error in
            guard let place = place, error == nil else {
                self.placeDelegate?.placeQueryFailed(with: error)
                return
            }
            self.placeDelegate?.foundPlace(place: place)
        }
    }
    
    func saveLocationName(locationName: String?) {
        guard let locationName = locationName, locationName != "label" else {
            return
        }

        let userDefaults = UserDefaults.standard
        if let saved = UserDefaults.standard.value(forKey: "locations") as? [String]{
            var savedMutable = saved
            savedMutable.append(locationName)
            userDefaults.set(savedMutable, forKey: "locations")
        }
        else{
            var array = [String]()
            array.append(locationName)
            userDefaults.set(array, forKey: "locations")
        }
    }
    
}
