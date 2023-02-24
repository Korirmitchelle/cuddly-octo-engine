//
//  ViewControllerExtension.swift
//  Cuddly
//
//  Created by Mitchelle Korir on 24/02/2023.
//  Copyright © 2023 Mitch. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(alertText : String, alertMessage : String) {
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Got it", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
