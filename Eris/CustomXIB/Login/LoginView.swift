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
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var emptyWarningLabel: UILabel!
    @IBOutlet weak var loginTextField: UITextField!
    var nickText = ""
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
        let image = UIImage(systemName: "xmark.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .medium))
        closeButton.setImage(image, for: .normal)
        //Validation for nickname
        loginTextField.addTarget(self,
                            action: #selector(nameValidation),
                            for: UIControl.Event.editingChanged)
        //focus on input
        loginTextField.becomeFirstResponder()
    }
    func showAlert() {
        UIApplication.shared.keyWindow?.addSubview(mainView)
        print(self.mainView.parentContainerViewController())
    }
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.mainView.removeFromSuperview()
    }
    @IBAction func confirmButtonTapped(_ sender: Any) {
        //Close if empty, do  not close if no nickname entered
        if loginTextField.text == "" {
            emptyWarningLabel.text = "Please enter at least one symbol"
        } else {
            let request = NSFetchRequest<UserData>(entityName: "UserData")
            request.returnsObjectsAsFaults = false
            let context = CoreDataService().context()
            let userInfo = try! context.fetch(request)
            userInfo.first?.user_name = loginTextField.text
            self.mainView.removeFromSuperview()
            print(self.mainView.parentContainerViewController())
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
        
    }
    @objc func nameValidation(_ textField: UITextField) {
        if textField.text?.count ?? 0 > 100 {
            textField.text = nickText
            return
        } else {
            nickText = textField.text ?? ""
        }
    }
}
