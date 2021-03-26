//
//  UIViewController+Extension.swift
//  KosmosAssignment
//
//  Created by Hitesh on 25/03/21.
//

import UIKit

extension UIViewController {
    func showAlert(title:String = "Alert",message:String, completion:(() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "Ok", style: .default) { (action) in
            completion?()
        }
        alert.addAction(actionOk)
        self.present(alert, animated: true, completion: nil)
    }
}
