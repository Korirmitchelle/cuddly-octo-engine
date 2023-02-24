//
//  LocationsViewModel.swift
//  Cuddly
//
//  Created by Mitchelle Korir on 23/02/2023.
//  Copyright © 2023 Mitch. All rights reserved.
//

import Foundation
import MapKit

protocol GeocoderDelegate: AnyObject {
    func foundLocation(location: CLLocationCoordinate2D, name: String)
    func locationQueryFailed(with error: Error?)
}

class LocationsViewModel {
    var cities = ["Nairobi","Kampala","Djibouti","Cairo"]
    var geocoder = GeocoderService()
    weak var locationDelegate: GeocoderDelegate?
    
    init(delegate: GeocoderDelegate){
        locationDelegate = delegate
    }
    
    func getCoordinateFrom(address: String) {
        geocoder.getCoordinateFrom(address: address, completion: {location,error in
            guard let location = location, error == nil else {
                self.locationDelegate?.locationQueryFailed(with: error)
                return
            }
            self.locationDelegate?.foundLocation(location: location, name: address)
        })
    }
    
}
