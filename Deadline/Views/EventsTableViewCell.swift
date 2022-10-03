//
//  EventsTableViewCell.swift
//  Deadline
//
//  Created by Wang Uiroz on 2022/9/21.
//

import UIKit

class EventsTableViewCell: UITableViewCell {
    
    @IBOutlet var colorView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var scheduleButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        colorView.layer.cornerRadius = colorView.bounds.height/2
        scheduleButton.layer.cornerRadius = scheduleButton.bounds.height/3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
