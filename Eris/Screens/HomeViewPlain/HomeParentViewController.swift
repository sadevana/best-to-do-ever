//
//  HomeParentViewController.swift
//  Eris
//
//  Created by Dmitry Chicherin on 25/9/2566 BE.
//

import UIKit
import CoreData

class HomeParentViewController: UIViewController {

    @IBOutlet weak var goldLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        //Getting user data
        let request = NSFetchRequest<UserData>(entityName: "UserData")
        request.returnsObjectsAsFaults = false
        let context = CoreDataService().context()
        let userInfo = try! context.fetch(request)
        if (userInfo.first != nil) {
            goldLabel.text = "Current total gold: " + String(userInfo.first!.total_gold)
            userNameLabel.text = userInfo.first!.user_name ?? "No username set"
        } else {
            //setting it up if it doesn't exist yet
            let userData = UserData(context: context)
            userData.total_gold = 0
            goldLabel.text = "Current total gold: 0"
            userNameLabel.text = "No username set"
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
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
