//
//  HomeTableViewController.swift
//  Eris
//
//  Created by Dmitry Chicherin on 31/8/2566 BE.
//

import UIKit
import CoreData

class HomeTableViewController: UITableViewController {
    //All tasks
    var tasksToShow = [TaskUI]()
    //Tasks divided into sections
    var sectionedTasks = [TaskSections]()
    //Indexes of collapsed secctions
    var hiddenSections = Set<Int>()
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
        tableView.rowHeight = 80.0
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = .black
        //self.tableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 0.8666666667, alpha: 1)
        self.tableView.separatorColor = .clear
        tableView.contentInset.bottom = 240
        
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
        let imageView = UIImageView(image: UIImage(named: "background"))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.zPosition = -1.0
        self.tableView.backgroundColor = .clear
        UIApplication.shared.keyWindow?.addSubview(imageView)
        //self.tableView.backgroundView = imageView
    }
    override func viewWillAppear(_ animated: Bool) {
        //Clearing Hidden sections
        hiddenSections.removeAll()
        super.viewWillAppear(animated)
        tasksToShow = []
        //Getting data from db
        tasksToShow = homeViewModel.getTasksDB()
        //Putting tasks into sections
        sectionedTasks = homeViewModel.sortTasks(tasks: tasksToShow)
        self.tableView.reloadData()
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
            tableCell.setIndexPath(index: indexPath)
        }
        tableCell?.layer.shadowColor = UIColor.black.cgColor
        tableCell?.layer.shadowOpacity = 0.5
        tableCell?.layer.shadowOffset = CGSize(width: 20, height: 20)
        tableCell?.layer.masksToBounds = false
        tableCell?.layer.shadowRadius = 2
        return tableCell!
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //If section is collapsed
        if self.hiddenSections.contains(section) {
            return 0
        }
        //Returns number of tasks in section
        return sectionedTasks[section].tasks.count
    }
    //Section style
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerParent = UIView()
        let headerView = UIView()
        headerView.frame = CGRect(x: 15, y: 0, width:
                                            tableView.bounds.size.width - 10, height: 35)
        let sectionLabel = UILabel(frame: CGRect(x: 10, y: 7, width:
        tableView.bounds.size.width/2, height: tableView.bounds.size.height))
        sectionLabel.textColor = chosenCompanion.shared.companion.darkToneColor
        sectionLabel.text = sectionedTasks[section].sectionName
        sectionLabel.font = .boldSystemFont(ofSize: 18.0)
        sectionLabel.sizeToFit()
        headerView.layer.zPosition = 1.0
        headerView.layer.cornerRadius = 16
        headerView.addSubview(sectionLabel)
        headerView.isUserInteractionEnabled = true
        headerParent.addSubview(headerView)
        //Button to collapse things
        let sectionButton = UIButton()
        let chackmarkImage = UIImage(systemName: "chevron.down", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .medium))
        sectionButton.setImage(chackmarkImage, for: .normal)
        sectionButton.frame = CGRect(x: tableView.bounds.size.width - 50, y: 0, width:
                                        35, height: 35)
        sectionButton.tintColor = chosenCompanion.shared.companion.darkToneColor
        if self.hiddenSections.contains(section) {
            sectionButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 0.9999)
        }
        sectionButton.tag = section
        sectionButton.addTarget(self, action: #selector(self.hideSection(sender:)),
                                for: .touchUpInside)
        headerParent.addSubview(sectionButton)
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
    @objc func hideSection(sender: UIButton!) {
        //Function for collapse/uncollapse functionality
        let section = sender.tag
        func indexPathsForSection() -> [IndexPath] {
            var indexPaths = [IndexPath]()
            
            for row in 0..<self.sectionedTasks[section].tasks.count {
                indexPaths.append(IndexPath(row: row, section: section))
            }
            
            return indexPaths
        }
        //Rotating button and collapsing sections
        if self.hiddenSections.contains(section) {
            self.hiddenSections.remove(section)
            self.tableView.insertRows(at: indexPathsForSection(), with: .fade)
            UIView.animate(withDuration: 0.35, animations: {
                sender.transform = CGAffineTransform(rotationAngle: 0)
            })
        } else {
            self.hiddenSections.insert(section)
            self.tableView.deleteRows(at: indexPathsForSection(), with: .fade)
            UIView.animate(withDuration: 0.35, animations: {
                sender.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 0.9999)
            })
        }
    }
    func uncollapseAll() {
        hiddenSections.removeAll()
        self.tableView.reloadData()
    }
    @objc func buttonAction(sender: UIButton!) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddTaskViewController")
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func filterData(searchText: String) {
        if searchText != "" {
            //Filter results that contain matching description or name
            var filteredData = tasksToShow.filter({$0.name?.uppercased().contains(searchText.uppercased()) ?? false || $0.description?.uppercased().contains(searchText.uppercased()) ?? false})
            self.sectionedTasks = homeViewModel.sortTasks(tasks: filteredData)
            self.tableView.reloadData()
        } else {
            self.sectionedTasks = homeViewModel.sortTasks(tasks: self.tasksToShow)
            self.tableView.reloadData()
        }
        
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //Setting up solors of cell elements
        if let myCell = cell as? TaskViewCell {
            myCell.iconImage.tintColor = chosenCompanion.shared.companion.darkToneColor
            myCell.goldLabel.textColor = chosenCompanion.shared.companion.darkToneColor
            myCell.taskNameLabel.textColor = chosenCompanion.shared.companion.darkToneColor
            myCell.taskTimeLabel.textColor = chosenCompanion.shared.companion.darkToneColor
        }
    }
}

