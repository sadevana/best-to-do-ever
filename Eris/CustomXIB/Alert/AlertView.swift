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
        //view.backgroundColor = #colorLiteral(red: 0.9708492772, green: 0.3215686275, blue: 0.8705882353, alpha: 0.4768470613)
        return view
    }()
    private var coverScreen: UIView = {
        return UIView()
    }()
    private var clickableView = UIView()
    private var navController: UINavigationController?
    private var randomChatter = chosenCompanion.shared.companion.getRandomChatter()
    private let addQuestActionButton: UIButton = {
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
    private let randomChatterButton: UIButton = {
        //Button for randon conversation topics
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        button.backgroundColor = #colorLiteral(red: 0.9627156854, green: 0.9567889571, blue: 0.968844831, alpha: 1)
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.layer.cornerRadius = 20
        button.tintColor = .black
        //button.setTitle(randomChatter[0], for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.0862745098, green: 0.0215686275, blue: 0.0705882353, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(randomChatterAnswer), for: .touchUpInside)
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
        clickableView.frame = CGRect(x: UIScreen.main.bounds.width - 145, y: UIScreen.main.bounds.height - 220, width: 130, height: 500)
        //clickableView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5013451987)
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        containerView.isHidden = true
        mainView.isUserInteractionEnabled = false
        alertLabel.lineBreakMode = .byWordWrapping
        //alertLabel.sizeToFit()
    }
    func initAlertView(navcontroller: UINavigationController){
        if !inited {
            UIApplication.shared.keyWindow?.addSubview(mainView)
            UIApplication.shared.keyWindow?.addSubview(mascotImage)
            UIApplication.shared.keyWindow?.addSubview(clickableView)
            inited = true
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        containerView.backgroundColor = chosenCompanion.shared.companion.primaryColor
        //Saving nav controller of main screen
        navController = navcontroller
        clickableView.addGestureRecognizer(tapGestureRecognizer)
        clickableView.isUserInteractionEnabled = true
        //mascotImage.isUserInteractionEnabled = true
        let image = chosenCompanion.shared.companion.defaultImage
        mascotImage.image = image
    }
    func showAlert(title: String, isSticky: Bool) {
        //Adding time if string is long
        var timeShowing = 3.0
        if title.count > 40 {
            let addTime = (Double(title.count)/10.0) * 0.75
            timeShowing = addTime
        }
        let timeNanoShowing = Int64(timeShowing * 1000000000)
        //Only showing new alert if previous one is over otherwise check if it's needed later on
        containerView.isUserInteractionEnabled = false
        let dif = DispatchTime.now().uptimeNanoseconds - self.startTime.uptimeNanoseconds
        if dif > timeNanoShowing {
            //Show alert and change picture
            //self.mainView.alpha = 1.0
            self.mascotImage.image = chosenCompanion.shared.companion.talkingImage
            self.containerView.isHidden = false
            startTime = DispatchTime.now()
            alertLabel.setTyping(text: title, characterDelay: 5)
            DispatchQueue.main.asyncAfter(deadline: .now() + timeShowing) {
                let dif = DispatchTime.now().uptimeNanoseconds - self.startTime.uptimeNanoseconds
                //In russian it's called 'kostyl'
                if dif > timeNanoShowing  {
                    if !isSticky {
                        self.containerView.isHidden = true
                    }
                    self.mascotImage.image = chosenCompanion.shared.companion.defaultImage
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.showAlert(title: title, isSticky: isSticky)
            }
        }
    }
    func refreshAvatar() {
        containerView.backgroundColor = chosenCompanion.shared.companion.primaryColor
        let image = chosenCompanion.shared.companion.defaultImage
        mascotImage.image = image
        showAlert(title: "Yay, let's go!", isSticky: false)
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view!
        coverScreen.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        UIApplication.shared.keyWindow?.addSubview(coverScreen)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(coverTapped(tapGestureRecognizer:)))
        coverScreen.addGestureRecognizer(tapGestureRecognizer)
        coverScreen.isUserInteractionEnabled = true
        addQuestActionButton.frame = CGRect(x: UIScreen.main.bounds.width/2 - 150, y: UIScreen.main.bounds.height - 180, width: 220, height: 40)
        goToSettingsButton.frame = CGRect(x: UIScreen.main.bounds.width/2 - 150, y: UIScreen.main.bounds.height - 130, width: 220, height: 40)
        randomChatterButton.frame = CGRect(x: UIScreen.main.bounds.width/2 - 150, y: UIScreen.main.bounds.height - 80, width: 220, height: 60)
        randomChatterButton.setTitle(randomChatter[0], for: .normal)
        randomChatterButton.titleLabel!.lineBreakMode = .byWordWrapping
        randomChatterButton.titleLabel?.sizeToFit()
        coverScreen.addSubview(randomChatterButton)
        coverScreen.addSubview(addQuestActionButton)
        coverScreen.addSubview(goToSettingsButton)
        addQuestActionButton.addTarget(self, action: #selector(goToCreateNew), for: .touchUpInside)
        goToSettingsButton.addTarget(self, action: #selector(goToSettings), for: .touchUpInside)
        randomChatterButton.addTarget(self, action: #selector(randomChatterAnswer), for: .touchUpInside)
        showAlert(title: "Hey there!", isSticky: true)
    }
    @objc func coverTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        coverScreen.removeFromSuperview()
        self.containerView.isHidden = true
    }
    @objc func goToCreateNew(sender: UIButton!) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddTaskViewController")
        navController?.pushViewController(nextViewController, animated: true)
        coverScreen.removeFromSuperview()
        showAlert(title: "Yay, I like making new quests!", isSticky: false)
    }
    @objc func goToSettings(sender: UIButton!) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SettingsViewController")
        navController?.pushViewController(nextViewController, animated: true)
        coverScreen.removeFromSuperview()
        showAlert(title: "Sure!", isSticky: false)
    }
    @objc func randomChatterAnswer(sender: UIButton!) {
        coverScreen.removeFromSuperview()
        showAlert(title: randomChatter[1], isSticky: false)
    }
}
