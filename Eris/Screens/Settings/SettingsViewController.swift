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
    

    var lunaChooseButton = CompanionPickButton(companion: enumCompanions.Luna.getModel(), frame: CGRect(x: 0, y: 0, width: 70, height: 85))
    var claraChooseButton = CompanionPickButton(companion: enumCompanions.Clara.getModel(), frame: CGRect(x: 80, y: 0, width: 70, height: 85))
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = chosenCompanion.shared.companion.primaryColor
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
        lunaChooseButton.addTarget(self, action: #selector(updateChoice), for: .touchUpInside)
        claraChooseButton.addTarget(self, action: #selector(updateChoice), for: .touchUpInside)
    }
    @objc func updateChoice(sender: CompanionPickButton!) {
        chosenCompanion.shared.companion = sender.companion
        UserDefaults.standard.set(sender.companion.name, forKey: "Companion")
        AlertView.instance.refreshAvatar()
        self.view.backgroundColor = chosenCompanion.shared.companion.primaryColor
        refreshButtons()
    }
    func refreshButtons() {
        lunaChooseButton.initialSetup()
        claraChooseButton.initialSetup()
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

}
