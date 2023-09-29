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
    
    private let addButton: UIButton = {
        //Creating a floating button
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        button.backgroundColor = .red
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 30
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(addButton)
        //Initial setup
        tableView.rowHeight = 100.0
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let offset = self.tableView.contentOffset.y
        addButton.frame = CGRect(x: view.frame.size.width - 60 - 20, y: view.frame.size.height - 80, width: 60, height: 60)
        //Going to todays task by default
        if(sectionedTasks.count > 2) {
            if(sectionedTasks[0].sectionName == "Overdue" && sectionedTasks[1].sectionName == "Today") {
                let indexPath = IndexPath(row: 0, section: 1)
                self.tableView.setContentOffset(CGPoint.zero, animated: true)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }
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
    }
    func updateDataInCells() {
        self.tasksToShow = []
        //Getting data from db
        self.tasksToShow = homeViewModel.getTasksDB()
        self.sectionedTasks = []
        //Putting tasks into sections
        self.sectionedTasks = homeViewModel.sortTasks(tasks: self.tasksToShow)
        self.tableView.reloadData()
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
        addButton.frame = CGRect(x: self.view.frame.size.width - 60 - 20, y: self.view.frame.size.height - 60 - 20 + offset, width: 60, height: 60)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sectionedTasks[section].tasks.count
    }
    //Section style
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let sectionLabel = UILabel(frame: CGRect(x: 8, y: 10, width:
        tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerView.backgroundColor = .init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.05)
        sectionLabel.text = sectionedTasks[section].sectionName
        sectionLabel.font = .boldSystemFont(ofSize: 18.0)
        sectionLabel.sizeToFit()
        headerView.layer.zPosition = 1.0
        headerView.addSubview(sectionLabel)
        headerView.isUserInteractionEnabled = false
        return headerView
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
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
}
