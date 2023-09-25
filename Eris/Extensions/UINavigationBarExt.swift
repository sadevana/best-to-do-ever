//
//  UINavigationBarExt.swift
//  Eris
//
//  Created by Dmitry Chicherin on 25/9/2566 BE.
//

import Foundation
import UIKit
let navigationNormalHeight: CGFloat = 1244
let navigationExtendHeight: CGFloat = 1284

extension UINavigationBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var barHeight: CGFloat = navigationNormalHeight
    
        if size.height == navigationExtendHeight {
            barHeight = size.height
        }
    
        let newSize: CGSize = CGSize(width: self.frame.size.width, height: 2222)
        return newSize
    }
}
