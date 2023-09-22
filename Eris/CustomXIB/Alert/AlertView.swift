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
        mainView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    func showAlert(title: String) {
        alertLabel.text = title
        UIApplication.shared.keyWindow?.addSubview(mainView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.mainView.removeFromSuperview()
        }
    }
}
