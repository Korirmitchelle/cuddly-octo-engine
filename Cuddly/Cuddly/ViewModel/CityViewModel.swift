//
//  CityViewModel.swift
//  Cuddly
//
//  Created by Mitchelle Korir on 24/02/2023.
//  Copyright © 2023 Mitch. All rights reserved.
//

import Foundation
import UIKit

enum SegmentType: Int {
    case today
    case weekly
}

enum ProbableWeather {
    case sunny
    case rainy
    case cloudy
    
    var imageName: String {
        switch self {
        case .sunny:
            return "background_sunny"
        case .rainy:
            return "background_rainy"
        case .cloudy:
            return "background_cloudy"
        }
    }
    
    var backgroundColor: UIColor? {
        switch self {
        case .sunny:
            return UIColor(hex: "#47AB2F")
        case .rainy:
            return UIColor(hex: "#57575D")
        case .cloudy:
            return UIColor(hex: "#54717A")

        }
    }
    
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
