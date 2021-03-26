//
//  UIImageView+Extension.swift
//  KosmosAssignment
//
//  Created by Hitesh on 25/03/21.
//

import UIKit

extension UIImageView {
    func loadImage(
        url: URL,completion: ((UIImage?, Error?) -> Void)? = nil)  {
        DownloadImage.loadImage(url: url) { (image, error) in
            self.image = image
            completion?(image,error)
        }
    }
}
