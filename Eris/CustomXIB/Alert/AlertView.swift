//
//  AlertView.swift
//  Eris
//
//  Created by Dmitry Chicherin on 22/9/2566 BE.
//

import Foundation
import UIKit

class AlertView: UIView {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    static let instance = AlertView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("AlertView", owner: self, options: nil)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func commonInit() {
        self.containerView.layer.cornerRadius = 20.0
        mainView.frame = CGRect(x: UIScreen.main.bounds.width/2 - 130, y: UIScreen.main.bounds.height - 150, width: 260, height: 60)
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    func showAlert(title: String) {
        self.mainView.alpha = 1.0
        self.containerView.alpha = 1.0
        alertLabel.text = title
        UIApplication.shared.keyWindow?.addSubview(mainView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            UIView.animate(withDuration: 2.0) {
                self.mainView.alpha = 0.0
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.mainView.removeFromSuperview()
        }
    }
}
