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
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var goldLabel: UILabel!
    var searchMode = false
    lazy var clearButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let image = UIImage(systemName: "xmark")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(clearSearch), for: .touchUpInside)
        button.tintColor = .red
        return button
    }()
    
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
        //let imageView = UIImageView(image: chosenCompanion.shared.companion.bgImage)
        //imageView.contentMode = .scaleAspectFill
        //self.view.backgroundColor = UIColor(patternImage: chosenCompanion.shared.companion.bgImage)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        //Getting user data
        updateTopBarInfo()
        
        //Updating colors
        //self.view.backgroundColor = chosenCompanion.shared.companion.primaryColor
        userIcon.tintColor = chosenCompanion.shared.companion.darkToneColor
        let labels = self.view.subviews.compactMap({$0 as? UILabel?})
        for label in labels {
            label?.textColor = chosenCompanion.shared.companion.darkToneColor
        }
        searchButton.tintColor = chosenCompanion.shared.companion.darkToneColor
        userNameButton.tintColor = chosenCompanion.shared.companion.darkToneColor
        self.view.backgroundColor = UIColor(patternImage: chosenCompanion.shared.companion.bgImage)
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
    lazy var searchBar:UISearchBar = UISearchBar()
    @IBAction func searchButtonTapped(_ sender: Any) {
        if !searchMode {
            if let childVC = self.children.first as? HomeTableViewController {
                //childVC.activateSearch()
                searchBar.searchBarStyle = UISearchBar.Style.default
                searchBar.placeholder = " Search..."
                searchBar.frame = CGRect(x: 0, y: 115, width: view.frame.size.width, height: 45)
                self.children.first?.view.frame = (self.children.first?.view.frame.insetBy(dx: 0, dy: 45))!
                searchBar.isTranslucent = false
                searchBar.backgroundImage = UIImage()
                searchBar.barTintColor = .white//chosenCompanion.shared.companion.primaryColor
                searchBar.searchTextField.tintColor = .white
                searchBar.delegate = self
                searchBar.searchTextField.delegate = self
                searchBar.searchTextField.shouldResignOnTouchOutsideMode = .enabled
                
                self.view.addSubview(searchBar)
                searchBar.searchTextField.clearButtonMode = .never
                searchBar.searchTextField.rightViewMode = .always
                searchBar.searchTextField.rightView = clearButton
                searchBar.becomeFirstResponder()
            }
        }
        searchMode = true
    }
    @objc func clearSearch(sender: UIButton!) {
        searchBar.searchTextField.text = ""
        searchBar.resignFirstResponder()
        searchBar.removeFromSuperview()
        searchMode = false
        if let childVC = self.children.first as? HomeTableViewController {
            childVC.filterData(searchText: "")
        }
        self.children.first?.view.frame = (self.children.first?.view.frame.insetBy(dx: 0, dy: -45))!
    }
}
extension HomeParentViewController: UISearchBarDelegate, UITextFieldDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let childVC = self.children.first as? HomeTableViewController {
            childVC.filterData(searchText: searchText)
        }
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchBar.resignFirstResponder()
        searchBar.removeFromSuperview()
        self.children.first?.view.frame = (self.children.first?.view.frame.insetBy(dx: 0, dy: -45))!
        return true
    }
}
