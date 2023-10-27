//
//  SettingsViewController.swift
//  Eris
//
//  Created by Dmitry Chicherin on 15/10/2566 BE.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController {
    @IBOutlet weak var choiceView: UIView!
    @IBOutlet weak var userNameText: UITextField!
    
    @IBOutlet weak var genderPicker: UISegmentedControl!
    

    var lunaChooseButton = CompanionPickButton(companion: enumCompanions.Luna.getModel(), frame: CGRect(x: 0, y: 0, width: 70, height: 85))
    var claraChooseButton = CompanionPickButton(companion: enumCompanions.Clara.getModel(), frame: CGRect(x: 80, y: 0, width: 70, height: 85))
    var aikoChooseButton = CompanionPickButton(companion: enumCompanions.Aiko.getModel(), frame: CGRect(x: 160, y: 0, width: 70, height: 85))
    var watchedCompanion: CompanionModel?
    var nickText = ""
    var companionPickView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 300, height: 400)
        view.layer.cornerRadius = 30
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize.zero
        view.layer.masksToBounds = false
        view.layer.shadowRadius = 2
        view.layer.zPosition = 1.0
        view.backgroundColor = chosenCompanion.shared.companion.primaryColor
        
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.view.backgroundColor = chosenCompanion.shared.companion.primaryColor
        self.view.backgroundColor = UIColor(patternImage: chosenCompanion.shared.companion.bgImage)
        //TBD move to model
        let request = NSFetchRequest<UserData>(entityName: "UserData")
        request.returnsObjectsAsFaults = false
        let context = CoreDataService().context()
        let userInfo = try! context.fetch(request)
        
        if (userInfo.first != nil) {
            userNameText.text = userInfo.first!.user_name
        }
        choiceView.backgroundColor = .clear
        choiceView.addSubview(lunaChooseButton)
        choiceView.addSubview(claraChooseButton)
        choiceView.addSubview(aikoChooseButton)
        lunaChooseButton.addTarget(self, action: #selector(updateChoice), for: .touchUpInside)
        claraChooseButton.addTarget(self, action: #selector(updateChoice), for: .touchUpInside)
        aikoChooseButton.addTarget(self, action: #selector(updateChoice), for: .touchUpInside)
        //Adding saving nickname
        userNameText.text = UserDefaults.standard.string(forKey: "Nickname")
        userNameText.addTarget(self,
                                action: #selector(nameUpdates),
                                for: UIControl.Event.editingChanged)
        genderPicker.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "GenderIndex")
    }
    @objc func updateChoice(sender: CompanionPickButton!) {
        setupShopView(companion: sender.companion)
        
        //companionPickView.backgroundColor = .black
        
    }
    func setupShopView(companion: CompanionModel) {
        self.view.addSubview(companionPickView)
        companionPickView.backgroundColor = companion.primaryColor
        companionPickView.frame = CGRect(x: view.frame.size.width/2 - 150, y: view.frame.size.height/2 - 280, width: 300, height: 440)
        let imageCompanion = companion.defaultImage
        let imageView = UIImageView(frame: CGRect(x: 75, y: 20, width: 150, height: 300))
        imageView.image = imageCompanion
        companionPickView.addSubview(imageView)
        let crossButton = UIButton(frame: CGRect(x: 260, y: 20, width: 30, height: 30))
        crossButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        crossButton.tintColor = .black
        crossButton.addTarget(self, action: #selector(closeChoise), for: .touchUpInside)
        companionPickView.addSubview(crossButton)
        var shopLabel = UILabel(frame: CGRect(x: 20, y: 330, width: 260, height: 38))
        if companion.name == "Luna" {
            shopLabel.text = "Your faithful default companion!"
        }
        if companion.name == "Clara" {
            shopLabel.text = "Things are very blue!"
        }
        if companion.name == "Aiko" {
            shopLabel.text = "Your new younger sister! Pay us money and she might get full body"
        }
        shopLabel.numberOfLines = 0
        shopLabel.lineBreakMode = .byWordWrapping
        shopLabel.textAlignment = .center
        shopLabel.sizeToFit()
        companionPickView.addSubview(shopLabel)
        var chooseButton = UIButton(frame: CGRect(x: 75, y: 395, width: 150, height: 35))
        chooseButton.backgroundColor = companion.darkToneColor
        chooseButton.layer.cornerRadius = 10
        if companion.getPrice() == 0 {
            chooseButton.setTitle("Pick companion", for: .normal)
            chooseButton.addTarget(self, action: #selector(chooseAndClose), for: .touchUpInside)
        } else {
            chooseButton.setTitle("Purchase", for: .normal)
            chooseButton.addTarget(self, action: #selector(purchaseCompanion), for: .touchUpInside)
        }
        watchedCompanion = companion
        companionPickView.addSubview(chooseButton)
        
    }
    func refreshButtons() {
        lunaChooseButton.initialSetup()
        claraChooseButton.initialSetup()
    }
    @objc func closeChoise(sender: UIButton!) {
        companionPickView.subviews.map({ $0.removeFromSuperview() })
        companionPickView.removeFromSuperview()
        
    }
    @objc func chooseAndClose(sender: UIButton!) {
        chosenCompanion.shared.companion = watchedCompanion!
        UserDefaults.standard.set(watchedCompanion!.name, forKey: "Companion")
        AlertView.instance.refreshAvatar()
        self.view.backgroundColor = UIColor(patternImage: chosenCompanion.shared.companion.bgImage)
        refreshButtons()
        companionPickView.subviews.map({ $0.removeFromSuperview() })
        companionPickView.removeFromSuperview()
        
    }
    @objc func purchaseCompanion(sender: UIButton!) {
        //sus code
        
        StoreManager.shared.purchase(product: StoreManager.Product(rawValue: watchedCompanion!.name) ?? .Aiko) { [self] model in
            UserDefaults.standard.set(true, forKey: "Aiko")
            companionPickView.subviews.map({ $0.removeFromSuperview() })
            companionPickView.removeFromSuperview()
            setupShopView(companion: watchedCompanion!)
            
        }/*
        var spinnerView = UIActivityIndicatorView(frame: CGRect(x: self.view.frame.size.width/2 - 30, y: self.view.frame.size.height/2 - 30, width: 60, height: 60))
        
        self.view.addSubview(spinnerView)
        spinnerView.startAnimating()
        spinnerView.layer.zPosition = 1.0
        spinnerView.stopAnimating()*/
    }
    /*@IBAction func lunaChosen(_ sender: Any) {
        chosenCompanion.shared.companion = enumCompanions.Luna.getModel()
        UserDefaults.standard.set("Luna", forKey: "Companion")
        AlertView.instance.refreshAvatar()
        self.view.backgroundColor = chosenCompanion.shared.companion.primaryColor
    }
    
    @IBAction func claraChosen(_ sender: Any) {
        chosenCompanion.shared.companion = enumCompanions.Clara.getModel()
        UserDefaults.standard.set("Clara", forKey: "Companion")
        AlertView.instance.refreshAvatar()
        self.view.backgroundColor = chosenCompanion.shared.companion.primaryColor
    }*/
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func nameUpdates(_ textField: UITextField) {
        if textField.text?.count ?? 0 > 100 {
            textField.text = nickText
            return
        } else {
            nickText = textField.text ?? ""
            UserDefaults.standard.set(textField.text, forKey: "Nickname")
        }
    }
    @IBAction func genderPicked(_ sender: Any) {
        UserDefaults.standard.set(genderPicker.selectedSegmentIndex, forKey: "GenderIndex")
        //UserDefaults.standard.integer(forKey: "GenderIndex")
    }
    
}
