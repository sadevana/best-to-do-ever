//
//  CircularCheckbox.swift
//  Eris
//
//  Created by Dmitry Chicherin on 18/9/2566 BE.
//

import UIKit

final class CircularCheckbox: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.red.cgColor
        layer.cornerRadius = frame.size.width / 2.0
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setChecked(_ isChecked: Bool) {
        
    }
}
