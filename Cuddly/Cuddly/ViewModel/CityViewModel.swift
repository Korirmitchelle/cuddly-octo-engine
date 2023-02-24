//
//  CityViewModel.swift
//  Cuddly
//
//  Created by Mitchelle Korir on 24/02/2023.
//  Copyright © 2023 Mitch. All rights reserved.
//

import Foundation

enum SegmentType: Int {
    case today
    case weekly
}

protocol CityDelegate: AnyObject {
    func foundResult(result: Result)
    func requestFailed(with error: String)
}

class CityViewModel {
    weak var cityDelegate: CityDelegate?
    
    init(delegate: CityDelegate){
        cityDelegate = delegate
    }
    func getWeather() {
        NetworkService.shared.getWeather(onSuccess: { (result) in
            self.cityDelegate?.foundResult(result: result)
            print("weather result here \(result)")
            
        }) { (errorMessage) in
            self.cityDelegate?.requestFailed(with: errorMessage)
            debugPrint(errorMessage)
        }
    }
    
}
