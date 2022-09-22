//
//  EventsTableViewCell.swift
//  Deadline
//
//  Created by Wang Uiroz on 2022/9/21.
//

import UIKit

class EventsTableViewCell: UITableViewCell {
    
    @IBOutlet var eventNameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
