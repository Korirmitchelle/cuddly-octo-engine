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
    
    weak var collectionView: UICollectionView!
    let reuseId = "weathercell"
    
    init(collectionView: UICollectionView,
         parent: UIViewController) {
        self.collectionView = collectionView
    }
    
    
    func cellForRowAt(cellForItemAt indexPath: IndexPath, segmentType: SegmentType?, weatherResult: Result?) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as? WeatherCollectionViewCell, let segmentType = segmentType else {
            return UICollectionViewCell()
        }
        switch segmentType {
        case .today:
           
            if let humidity = weatherResult?.hourly[indexPath.row].humidity {
                cell.topLabel.text = String(humidity)
            }
            
            if let temperature = weatherResult?.hourly[indexPath.row].temp {
                cell.bottomLabel.text = String(temperature)

            }
            
            if let hour = weatherResult?.hourly[indexPath.row], hour.weather.indices.contains(0) {
                cell.weatherImageView.image = UIImage(named: hour.weather[0].icon)
            }

            
        case .weekly:
            
            if let day = weatherResult?.daily[indexPath.row], day.weather.indices.contains(0) {
                cell.weatherImageView.image = UIImage(named: day.weather[0].icon)

            }
            
            
            if let humidity = weatherResult?.daily[indexPath.row].humidity {
                cell.topLabel.text = String(humidity)
            }
            
            if let temperature = weatherResult?.daily[indexPath.row].temp.day {
                cell.bottomLabel.text = String(temperature)
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
