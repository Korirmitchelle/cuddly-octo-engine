//
//  GeoCoderService.swift
//  Cuddly
//
//  Created by Mitchelle Korir on 23/02/2023.
//  Copyright © 2023 Mitch. All rights reserved.
//

import Foundation
import MapKit

class GeocoderService {
    
    func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(address) { completion($0?.first?.location?.coordinate, $1) }
    }
    
    func geocode(from location: CLLocation, completion: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> Void)  {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: completion)
    }
    
}
