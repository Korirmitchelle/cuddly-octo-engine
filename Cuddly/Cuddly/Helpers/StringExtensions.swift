//
//  WeatherUtilities.swift
//  Cuddly
//
//  Created by Mitchelle Korir on 24/02/2023.
//  Copyright © 2023 Mitch. All rights reserved.
//

import Foundation

extension String {
    
    func getWeatherType() -> ProbableWeather {
        if self.lowercased().contains("cloud"){
            return .cloudy
        }
        if self.lowercased().contains("rain"){
            return .rainy
        }
        if self.lowercased().contains("sun"){
            return .sunny
        }
        return .sunny
    }
}
