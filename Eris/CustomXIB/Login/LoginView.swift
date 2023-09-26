//
//  LoginView.swift
//  Eris
//
//  Created by Dmitry Chicherin on 27/9/2566 BE.
//

import UIKit
import CoreData

class LoginView: UIView {

    @IBOutlet weak var windowView: UIView!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var confirmationButton: UIButton!
    @IBOutlet weak var loginTextField: UITextField!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    static let instance = LoginView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("LoginView", owner: self, options: nil)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func commonInit() {
        self.windowView.layer.cornerRadius = 20.0
        mainView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    func showAlert() {
        UIApplication.shared.keyWindow?.addSubview(mainView)
    }
    @IBAction func confirmButtonTapped(_ sender: Any) {
        let request = NSFetchRequest<UserData>(entityName: "UserData")
        request.returnsObjectsAsFaults = false
        let context = CoreDataService().context()
        let userInfo = try! context.fetch(request)
        userInfo.first?.user_name = loginTextField.text
        self.mainView.removeFromSuperview()
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}
