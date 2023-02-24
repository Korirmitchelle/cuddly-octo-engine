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
    
    
    func cellForRowAt(cellForItemAt indexPath: IndexPath, segmentType: SegmentType?, weatherResult: Result?) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as? WeatherTableViewCell, let segmentType = segmentType else {
            return UITableViewCell()
        }
        switch segmentType {
        case .today:
           
            if let time = weatherResult?.hourly[indexPath.row].dt {
                let date = Date(timeIntervalSince1970: TimeInterval(time))
                cell.dayLabel.text = date.getHourFrom()

            }
            
            if let temperature = weatherResult?.hourly[indexPath.row].temp {
                cell.temperatureLabel.text = String(temperature)
            }
            
            if let hour = weatherResult?.hourly[indexPath.row], hour.weather.indices.contains(0) {
                cell.weatherImageView.image = UIImage(named: hour.weather[0].icon)
            }

            
        case .weekly:
            
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
            
        }
        return cell
    }
    
    
    func itemsForSections(numberOfItemsInSection section: Int, segmentType: SegmentType?, weatherResult: Result?) -> Int {
        var count: Int?
        switch segmentType {
        case .today:
            count = weatherResult?.hourly.count
        case .weekly:
            count = weatherResult?.daily.count
        case .none:
            break
        }
        return count ?? 4
    }

}
