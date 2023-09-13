//
//  TaskViewCell.swift
//  Eris
//
//  Created by Dmitry Chicherin on 13/9/2566 BE.
//

import UIKit

class TaskViewCell: UITableViewCell {
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    @IBOutlet weak var taskTimeLabel: UILabel!
    @IBOutlet weak var taskNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setup(withtask: Task) {
        taskNameLabel.text = withtask.title
        taskDescriptionLabel.text = withtask.task_description
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "DD/MM/YYY HH:mm:ss"
        taskTimeLabel.text = dateFormatter.string(from: withtask.due_date ?? Date())
    }
}
