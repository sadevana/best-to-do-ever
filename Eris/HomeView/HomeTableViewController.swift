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
    var sectionedTasks = [[TaskUI](), [TaskUI](), [TaskUI](), [TaskUI]()]
    let sections: Array<String> = ["Today", "Later", "No date", "Expired"]
    
    private let addButton: UIButton = {
        //Creating button
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
        view.addSubview(addButton)
        //Initial setup
        tableView.rowHeight = 100.0
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tasksToShow = []
        //Getting data from db
        let request = NSFetchRequest<Task>(entityName: "Task")
        request.returnsObjectsAsFaults = false
        let tasksDB = try! CoreDataService().context().fetch(request)
        for taskDBIns in tasksDB {
            tasksToShow.append(TaskUI(taskDB: taskDBIns))
        }
        //Putting tasks into sections
        tasksToShow.sort {
            $0.datetime ?? Date() < $1.datetime ?? Date()
        }
        let todayList = tasksToShow.filter{$0.datetime ?? Date() + Double(86400) < Date() + Double(86400) && $0.datetime ?? Date() - 1 > Date()}
        sectionedTasks[0] = todayList
        let laterList = tasksToShow.filter{$0.datetime ?? Date() - 2 >= Date() + Double(86400) }
        sectionedTasks[1] = laterList
        let noDate = tasksToShow.filter{$0.datetime == nil}
        sectionedTasks[2] = noDate
        let expiredList = tasksToShow.filter{$0.datetime ?? Date() - 1 < Date()}
        sectionedTasks[3] = expiredList
        self.tableView.reloadData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //addButton.frame = CGRect(x: view.frame.size.width - 60 - 20, y: view.frame.size.height - 60 - 120, width: 60, height: 60)
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "TaskViewCell")
        if let tableCell = tableCell as? TaskViewCell {
            tableCell.setup(withtask: sectionedTasks[indexPath.section][indexPath.row])
        }
        return tableCell!
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //Making scroll button stay in place
        let offset = scrollView.contentOffset.y
        addButton.frame = CGRect(x: view.frame.size.width - 60 - 20, y: view.frame.size.height - 60 - 20 + offset, width: 60, height: 60)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sectionedTasks[section].count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    @objc func buttonAction(sender: UIButton!) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddTaskViewController") 
        //self.present(nextViewController, animated:true, completion:nil)
        self.navigationController?.pushViewController(nextViewController, animated: true)
        //HomeTableViewController.self.navigationController?.pushViewController(nextViewController, animated: true)
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
