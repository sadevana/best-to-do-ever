//
//  TaskViewCell.swift
//  Eris
//
//  Created by Dmitry Chicherin on 13/9/2566 BE.
//

import UIKit

class TaskViewCell: UITableViewCell {
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    @IBOutlet weak var taskTimeLabel: UILabel!
    @IBOutlet weak var taskNameLabel: UILabel!
    var checked = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setup(withtask: TaskUI) {
        taskNameLabel.text = withtask.name
        taskDescriptionLabel.text = withtask.description
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM HH:mm"
        taskTimeLabel.text = dateFormatter.string(from: withtask.datetime ?? Date())
        //Setting up checkbox
        checkboxButton.layer.cornerRadius = 18.0
        let image = UIImage(systemName: "circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 28, weight: .medium))
        checkboxButton.setImage(image, for: .normal)
        
        checkboxButton.tintColor = .green
    }
    @IBAction func checkbox(_ sender: UIButton) {
        if checked == false {
            let image2 = UIImage(systemName: "checkmark.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 28, weight: .medium))
            checkboxButton.setImage(image2, for: .normal)
        } else {
            let image2 = UIImage(systemName: "circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 28, weight: .medium))
            checkboxButton.setImage(image2, for: .normal)
        }
        checked = !checked
    }
}
