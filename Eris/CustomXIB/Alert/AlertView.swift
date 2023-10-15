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
    private var inited = false
    private var mascotImage: UIImageView = {
        let view = UIImageView()
        let image = chosenCompanion.shared.companion.defaultImage
        view.image = image
        return view
    }()
    private var coverScreen: UIView = {
        return UIView()
    }()
    private var navController: UINavigationController?
    private let addQuestActionButton: UIButton = {
        //Creating a floating button
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        button.backgroundColor = #colorLiteral(red: 0.9627156854, green: 0.9567889571, blue: 0.968844831, alpha: 1)
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.layer.cornerRadius = 20
        button.tintColor = .black
        button.setTitle("Let's create a new task", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.0862745098, green: 0.0215686275, blue: 0.0705882353, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(goToCreateNew), for: .touchUpInside)
        button.layer.zPosition = 2.0
        return button
    }()
    private let goToSettingsButton: UIButton = {
        //Creating a floating button
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        button.backgroundColor = #colorLiteral(red: 0.9627156854, green: 0.9567889571, blue: 0.968844831, alpha: 1)
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.layer.cornerRadius = 20
        button.tintColor = .black
        button.setTitle("I want to change settings", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.0862745098, green: 0.0215686275, blue: 0.0705882353, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(goToSettings), for: .touchUpInside)
        button.layer.zPosition = 2.0
        return button
    }()
    
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
        mainView.frame = CGRect(x: UIScreen.main.bounds.width/2 - 150, y: UIScreen.main.bounds.height - 280, width: 300, height: 60)
        mascotImage.frame = CGRect(x: UIScreen.main.bounds.width - 180 - 20, y: UIScreen.main.bounds.height - 230 - 20, width: 250, height: 500)
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        containerView.isHidden = true
        mainView.isUserInteractionEnabled = false
        //alertLabel.isHidden = true
        //containerView.isUserInteractionEnabled = false
        //alertLabel.isUserInteractionEnabled = false
        
        //let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        //mascotImage.addGestureRecognizer(tapGestureRecognizer)
        //mascotImage.isUserInteractionEnabled = true
    }
    func initAlertView(navcontroller: UINavigationController){
        if !inited {
            UIApplication.shared.keyWindow?.addSubview(mainView)
            UIApplication.shared.keyWindow?.addSubview(mascotImage)
            inited = true
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        navController = navcontroller
        mascotImage.addGestureRecognizer(tapGestureRecognizer)
        mascotImage.isUserInteractionEnabled = true
        let image = chosenCompanion.shared.companion.defaultImage
        mascotImage.image = image
    }
    func showAlert(title: String) {
        //Only showing new alert if previous one is over otherwise check if it's needed later on
        containerView.isUserInteractionEnabled = false
        let dif = DispatchTime.now().uptimeNanoseconds - self.startTime.uptimeNanoseconds
        if dif > 3000000000 {
            //Show alert and change picture
            //self.mainView.alpha = 1.0
            self.mascotImage.image = chosenCompanion.shared.companion.talkingImage
            self.containerView.isHidden = false
            startTime = DispatchTime.now()
            alertLabel.setTyping(text: title, characterDelay: 7)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                let dif = DispatchTime.now().uptimeNanoseconds - self.startTime.uptimeNanoseconds
                //In russian it's called 'kostyl'
                if dif > 3000000000 {
                    self.containerView.isHidden = true
                    self.mascotImage.image = chosenCompanion.shared.companion.defaultImage
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.showAlert(title: title)
            }
        }
    }
    func refreshAvatar() {
        let image = chosenCompanion.shared.companion.defaultImage
        mascotImage.image = image
        showAlert(title: "Yay, let's go!")
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        coverScreen.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        UIApplication.shared.keyWindow?.addSubview(coverScreen)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(coverTapped(tapGestureRecognizer:)))
        coverScreen.addGestureRecognizer(tapGestureRecognizer)
        coverScreen.isUserInteractionEnabled = true
        addQuestActionButton.frame = CGRect(x: UIScreen.main.bounds.width/2 - 150, y: UIScreen.main.bounds.height - 180, width: 220, height: 40)
        goToSettingsButton.frame = CGRect(x: UIScreen.main.bounds.width/2 - 150, y: UIScreen.main.bounds.height - 130, width: 220, height: 40)
        coverScreen.addSubview(addQuestActionButton)
        coverScreen.addSubview(goToSettingsButton)
        addQuestActionButton.addTarget(self, action: #selector(goToCreateNew), for: .touchUpInside)
        goToSettingsButton.addTarget(self, action: #selector(goToSettings), for: .touchUpInside)
        showAlert(title: "Hey there!")
    }
    @objc func coverTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        coverScreen.removeFromSuperview()
    }
    @objc func goToCreateNew(sender: UIButton!) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddTaskViewController")
        navController?.pushViewController(nextViewController, animated: true)
        coverScreen.removeFromSuperview()
    }
    @objc func goToSettings(sender: UIButton!) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SettingsViewController")
        navController?.pushViewController(nextViewController, animated: true)
        coverScreen.removeFromSuperview()
    }
}
