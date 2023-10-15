//
//  HomeParentViewController.swift
//  Eris
//
//  Created by Dmitry Chicherin on 25/9/2566 BE.
//

import UIKit
import CoreData

class HomeParentViewController: UIViewController {

    @IBOutlet weak var userNameButton: UIButton!
    @IBOutlet weak var goldLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
        userNameButton.contentHorizontalAlignment = .left
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if !launchedBefore {
            LoginView.instance.showAlert(viewToUpdate: self)
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        //Getting user data
        updateTopBarInfo()
    }
    
    func updateTopBarInfo() {
        //TBD move to model
        let request = NSFetchRequest<UserData>(entityName: "UserData")
        request.returnsObjectsAsFaults = false
        let context = CoreDataService().context()
        let userInfo = try! context.fetch(request)
        
        if (userInfo.first != nil) {
            goldLabel.text = "Current total gold: " + String(userInfo.first!.total_gold)
            if userInfo.first!.user_name == "" || userInfo.first!.user_name == nil {
                userNameButton.setTitle("Click here to set a nickname", for: .normal)
            } else {
                userNameButton.setTitle(userInfo.first!.user_name, for: .normal)
            }
        } else {
            //setting it up if it doesn't exist yet
            let userData = UserData(context: context)
            userData.total_gold = 0
            goldLabel.text = "Current total gold: 0"
            userNameButton.setTitle("Click here to set a nickname", for: .normal)
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
    @IBAction func setupUserNameClicked(_ sender: Any) {
        //If user clicks on button while no username is set, open nickname setup
        let request = NSFetchRequest<UserData>(entityName: "UserData")
        request.returnsObjectsAsFaults = false
        let context = CoreDataService().context()
        let userInfo = try! context.fetch(request)
        if (userInfo.first != nil) {
            if userInfo.first!.user_name == "" || userInfo.first!.user_name == nil {
                LoginView.instance.showAlert(viewToUpdate: self)
            }
        }
        
    }
    
}
