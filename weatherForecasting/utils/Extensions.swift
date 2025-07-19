//
//  Extensions.swift
//  weatherForecasting
//
//  Created by Niranjan Kumar on 19/07/25.
//

import Foundation
import UIKit

extension UIView{
    func  roundCorners(radius: CGFloat){
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}
