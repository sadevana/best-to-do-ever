//
//  SettingsViewController.swift
//  Eris
//
//  Created by Dmitry Chicherin on 15/10/2566 BE.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController {
    @IBOutlet weak var userNameText: UITextField!
    
    @IBOutlet weak var claraButton: UIButton!
    @IBOutlet weak var lunaButton: UIButton!
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
    }
    
    @IBAction func lunaChosen(_ sender: Any) {
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
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
