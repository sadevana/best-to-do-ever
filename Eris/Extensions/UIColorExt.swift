//
//  UIColorExt.swift
//  Eris
//
//  Created by Dmitry Chicherin on 13/10/2566 BE.
//

import Foundation
import UIKit

extension UIColor {
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
}
