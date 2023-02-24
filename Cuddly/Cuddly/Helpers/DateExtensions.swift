//
//  Extensions.swift
//  Cuddly
//
//  Created by Mitch on 22/09/2020.
//  Copyright © 2020 Mitch. All rights reserved.
//

import UIKit

extension Date {
    
    static func getTodaysDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .full
        return dateFormatter.string(from: date)
    }
    
     func getHourFrom() -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        var string = dateFormatter.string(from: self)
        if string.last == "M" {
            string = String(string.prefix(string.count - 3))
        }
        return string
    }
    
    func getDayOfWeekFrom() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .full
        var string = dateFormatter.string(from: self)
        
        if let index = string.firstIndex(of: ",") {
            string = String(string.prefix(upTo: index))
            return string
        }
        return "error"
    }
}
