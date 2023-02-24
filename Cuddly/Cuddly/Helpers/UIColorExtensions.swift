//
//  UIColorExtensions.swift
//  Cuddly
//
//  Created by Mitchelle Korir on 24/02/2023.
//  Copyright © 2023 Mitch. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init?(hex: String, alpha: CGFloat = 1) {
            var chars = Array(hex.hasPrefix("#") ? hex.dropFirst() : hex[...])
            switch chars.count {
            case 3: chars = chars.flatMap { [$0, $0] }
            case 6: break
            default: return nil
            }
            self.init(red: .init(strtoul(String(chars[0...1]), nil, 16)) / 255,
                    green: .init(strtoul(String(chars[2...3]), nil, 16)) / 255,
                     blue: .init(strtoul(String(chars[4...5]), nil, 16)) / 255,
                    alpha: alpha)
        }
}
