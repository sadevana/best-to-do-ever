//
//  CharchterButton.swift
//  Eris
//
//  Created by Dmitry Chicherin on 18/10/2566 BE.
//

import Foundation
import UIKit

class CompanionPickButton: UIButton {
    var companion: CompanionModel
    init(companion: CompanionModel, frame: CGRect) {
        self.companion = companion
        super.init(frame: frame)
        initialSetup()
    }
    func initialSetup() {
        let image = companion.portrait
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        imageView.image = image
        self.addSubview(imageView)
        let label = UILabel()
        label.text = companion.name
        self.addSubview(label)
        label.textAlignment = .center
        label.frame = CGRect(x: 0, y: 70, width: 70, height: 15)
        if (chosenCompanion.shared.companion.name == companion.name) {
            self.backgroundColor = .white
        } else {
            self.backgroundColor = .clear
        }
        self.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
