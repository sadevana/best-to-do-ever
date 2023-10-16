//
//  HomeTableViewController.swift
//  Eris
//
//  Created by Dmitry Chicherin on 31/8/2566 BE.
//

import UIKit
import CoreData

class HomeTableViewController: UITableViewController {
    var tasksToShow = [TaskUI]()
    var sectionedTasks = [TaskSections]()
    let homeViewModel = HomeViewModel()
    
    private lazy var noTasksView: UIImageView = {
        //View to show on screen when no tasks are present
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 160))
        let image = UIImage(named: "mascot_start")
        //view.image = image
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 350, height: 21))
        label.center = CGPoint(x: 120, y: -40)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.text = "You have no quests! Let's create some\n using that plus button!"
        label.sizeToFit()
    
        view.addSubview(label)
        return view
    }()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //self.searchBar.shouldResignOnTouchOutsideMode = .enabled
        //self.view.addSubview(mascotImage)
        //Initial setup
        tableView.rowHeight = 110.0
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = chosenCompanion.shared.companion.primaryColor
        //self.tableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 0.8666666667, alpha: 1)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //addButton.frame = CGRect(x: view.frame.size.width - 60 - 20, y: view.frame.size.height - 80, width: 60, height: 60)
        //Going to todays task by default
        if(sectionedTasks.count > 2) {
            if(sectionedTasks[0].sectionName == "Overdue" && sectionedTasks[1].sectionName == "Today") {
                let indexPath = IndexPath(row: 0, section: 1)
                self.tableView.setContentOffset(CGPoint.zero, animated: true)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }
        if sectionedTasks.count > 0 {
            noTasksView.removeFromSuperview()
        } else {
            //adding picture if there's no tasks
            noTasksView.frame = CGRect(x: view.frame.size.width/2 - view.frame.size.width/2.6, y: -20, width: view.frame.size.width/1.3, height: view.frame.size.height)
            print(view.frame.size.width)
            print(view.frame.size.height)
            self.view.addSubview(noTasksView)
        }
        //Loading common alert view
        AlertView.instance.initAlertView(navcontroller: self.navigationController!)
        self.tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tasksToShow = []
        //Getting data from db
        tasksToShow = homeViewModel.getTasksDB()
        //Putting tasks into sections
        sectionedTasks = homeViewModel.sortTasks(tasks: tasksToShow)
        self.tableView.reloadData()
        //navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tableView.backgroundColor = chosenCompanion.shared.companion.primaryColor
    }
    func updateDataInCells() {
        self.tasksToShow = []
        //Getting data from db
        self.tasksToShow = homeViewModel.getTasksDB()
        self.sectionedTasks = []
        //Putting tasks into sections
        self.sectionedTasks = homeViewModel.sortTasks(tasks: self.tasksToShow)
        self.tableView.reloadData()
        //Update data in parent controller
        weak var parentVC = self.parent as? HomeParentViewController
        parentVC?.updateTopBarInfo()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionedTasks.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "TaskViewCell")
        if let tableCell = tableCell as? TaskViewCell {
            tableCell.setup(withtask: sectionedTasks[indexPath.section].tasks[indexPath.row], parentController: self)
        }
        return tableCell!
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //Making scroll button stay in place
        let offset = scrollView.contentOffset.y
        //mascotImage.frame = CGRect(x: self.view.frame.size.width - 180 - 20, y: self.view.frame.size.height - 230 - 20 + offset, width: 200, height: 400)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sectionedTasks[section].tasks.count
    }
    //Section style
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerParent = UIView()
        let headerView = UIView()
        headerView.frame = CGRect(x: 5, y: 0, width:
                                            tableView.bounds.size.width - 10, height: 35)
        let sectionLabel = UILabel(frame: CGRect(x: 10, y: 7, width:
        tableView.bounds.size.width/2, height: tableView.bounds.size.height))
        sectionLabel.textColor = .white
        headerView.backgroundColor = chosenCompanion.shared.companion.darkToneColor
        sectionLabel.text = sectionedTasks[section].sectionName
        sectionLabel.font = .boldSystemFont(ofSize: 18.0)
        sectionLabel.sizeToFit()
        headerView.layer.zPosition = 1.0
        headerView.layer.cornerRadius = 16
        headerView.addSubview(sectionLabel)
        headerView.isUserInteractionEnabled = false
        headerParent.addSubview(headerView)
        return headerParent
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "EditTaskViewController") as! EditTaskViewController
        nextViewController.taskUI = sectionedTasks[indexPath.section].tasks[indexPath.row]
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @objc func buttonAction(sender: UIButton!) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddTaskViewController")
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func filterData(searchText: String) {
        if searchText != "" {
            var filteredData = tasksToShow.filter({$0.name?.uppercased().contains(searchText.uppercased()) ?? false})
            self.sectionedTasks = homeViewModel.sortTasks(tasks: filteredData)
            self.tableView.reloadData()
        } else {
            self.sectionedTasks = homeViewModel.sortTasks(tasks: self.tasksToShow)
            self.tableView.reloadData()
        }
        
    }
}

