//
//  CityCellProvider.swift
//  Cuddly
//
//  Created by Mitchelle Korir on 24/02/2023.
//  Copyright © 2023 Mitch. All rights reserved.
//

import Foundation
import UIKit

final class CityCellProvider {
    
    weak var tableView: UITableView!
    let reuseId = "weathercell"
    
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    
    func cellForRowAt(cellForItemAt indexPath: IndexPath, weatherResult: Result?) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as? WeatherTableViewCell else {
            return UITableViewCell()
        }
        if let day = weatherResult?.daily[indexPath.row], day.weather.indices.contains(0) {
            cell.weatherImageView.image = UIImage(named: day.weather[0].icon)
        }
        
        if let time = weatherResult?.daily[indexPath.row].dt {
            let date = Date(timeIntervalSince1970: TimeInterval(time))
            cell.dayLabel.text = date.getDayOfWeekFrom()
            
        }
        
        if let temperature = weatherResult?.daily[indexPath.row].temp.day {
            cell.temperatureLabel.text = String(temperature) + "°C"
        }
        
       
        return cell
    }
    
    
    func itemsForSections(numberOfItemsInSection section: Int, weatherResult: Result?) -> Int {
        return weatherResult?.daily.count ?? 4
    }

}
