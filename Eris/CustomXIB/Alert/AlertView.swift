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
    
    var startTime = DispatchTime.now() - 5000000000
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
        mainView.frame = CGRect(x: UIScreen.main.bounds.width/2 - 150, y: UIScreen.main.bounds.height - 250, width: 300, height: 60)
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    func showAlert(title: String) {
        //Only showing new alert if previous one is over otherwise check if it's needed later on
        let dif = DispatchTime.now().uptimeNanoseconds - self.startTime.uptimeNanoseconds
        if dif > 5000000000 {
            //Show alert and later set it to be more transparent
            self.mainView.alpha = 1.0
            self.containerView.alpha = 1.0
            startTime = DispatchTime.now()
            alertLabel.setTyping(text: title, characterDelay: 7)
            UIApplication.shared.keyWindow?.addSubview(mainView)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                let dif = DispatchTime.now().uptimeNanoseconds - self.startTime.uptimeNanoseconds
                if dif > 3000000000{
                    UIView.animate(withDuration: 2.0) {
                        self.mainView.alpha = 0.0
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                let dif = DispatchTime.now().uptimeNanoseconds - self.startTime.uptimeNanoseconds
                //In russian it's called 'kostyl'
                if self.mainView.alpha == 0 && dif > 5000000000 {
                    self.mainView.removeFromSuperview()
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.showAlert(title: title)
            }
        }
    }
}
