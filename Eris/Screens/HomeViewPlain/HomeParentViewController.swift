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
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goToSettings(tapGestureRecognizer:)))
        userIcon.isUserInteractionEnabled = true
        userIcon.addGestureRecognizer(tapGestureRecognizer)
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
        //on first launch show intro screen
        //UserDefaults.standard.set(false, forKey: "launchedBefore")
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if !launchedBefore {
            //Go to first launch screen
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FirstLaunchViewController")
            self.navigationController!.pushViewController(nextViewController, animated: true)
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        let firstQuestPending = UserDefaults.standard.bool(forKey: "First quest pending")
        if firstQuestPending {
            AlertView.instance.showAlert(title: "Talk to me to create your first quest!", isSticky: false)
        }
    }
    
    func updateTopBarInfo() {
        //TBD move to model
        let nickName = UserDefaults.standard.string(forKey: "Nickname")
        let totalGold = UserDefaults.standard.integer(forKey: "totalGold")
        if nickName == "" || nickName == nil {
            userNameButton.setTitle("Click here to set a nickname", for: .normal)
        } else {
            userNameButton.setTitle(nickName, for: .normal)
        }
        goldLabel.text = "Current total gold: " + String(totalGold)

    }
    @IBAction func setupUserNameClicked(_ sender: Any) {
        //If user clicks on button while no username is set, open nickname setup
        if UserDefaults.standard.string(forKey: "Nickname") == "" || UserDefaults.standard.string(forKey: "Nickname") == nil{
            LoginView.instance.showAlert(viewToUpdate: self)
        }
        
    }
    lazy var searchBar:UISearchBar = UISearchBar()
    @IBAction func searchButtonTapped(_ sender: Any) {
        if !searchMode {
            if let childVC = self.children.first as? HomeTableViewController {
                //childVC.activateSearch()
                searchBar.searchBarStyle = UISearchBar.Style.default
                searchBar.placeholder = " Title or description"
                
                searchBar.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 45)
                searchBar.translatesAutoresizingMaskIntoConstraints = false
                
                UIView.animate(withDuration: 0.3) {
                    self.children.first?.view.frame = (self.children.first?.view.frame.insetBy(dx: 0, dy: 45))!
                }
                
                //searchBar.searchTextField.tintColor = .red
                searchBar.delegate = self
                searchBar.searchTextField.delegate = self
                searchBar.searchTextField.shouldResignOnTouchOutsideMode = .enabled
                searchBar.searchTextField.backgroundColor = .white
                self.view.addSubview(self.searchBar)
                searchBar.alpha = 0
                UIView.animate(withDuration: 0.3) {
                    self.searchBar.alpha = 1.0
                }
                //Attaching a searchbar to the top of a table view
                searchBar.bottomAnchor.constraint(equalTo: (self.children.first?.view.topAnchor)!, constant: 0).isActive = true
                searchBar.widthAnchor.constraint(equalToConstant: view.frame.size.width).isActive = true
                searchBar.heightAnchor.constraint(equalToConstant: 45).isActive = true
                searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                searchBar.searchTextField.clearButtonMode = .never
                searchBar.searchTextField.rightViewMode = .always
                searchBar.searchTextField.rightView = clearButton
                
                searchBar.barTintColor = UIColor.white
                searchBar.backgroundColor = UIColor.clear
                searchBar.isTranslucent = true
                searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
                //Uncollapsing all data for search mode
                if let childVC = self.children.first as? HomeTableViewController {
                    childVC.uncollapseAll()
                }
                searchBar.becomeFirstResponder()
            }
        }
        searchMode = true
    }
    @objc func clearSearch(sender: UIButton!) {
        searchBar.searchTextField.text = ""
        searchBar.resignFirstResponder()

        UIView.animate(withDuration: 0.2, animations: {
            
            self.searchBar.alpha = 0.0
            
             }, completion: {
                 finished in
                 self.searchBar.removeFromSuperview()
             })
        searchMode = false
        if let childVC = self.children.first as? HomeTableViewController {
            childVC.filterData(searchText: "")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            UIView.animate(withDuration: 0.3) {
                self.children.first?.view.frame = (self.children.first?.view.frame.insetBy(dx: 0, dy: -45))!
            }
        }
    }
    @objc func goToSettings(tapGestureRecognizer: UIGestureRecognizer!) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SettingsViewController")
        self.navigationController!.pushViewController(nextViewController, animated: true)
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
