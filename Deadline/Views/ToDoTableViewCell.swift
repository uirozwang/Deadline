//
//  ToDoTableViewCell.swift
//  Deadline
//
//  Created by Wang Uiroz on 2022/9/5.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {
    
    @IBOutlet var colorView: UIView! {
        didSet {
            colorView.layer.cornerRadius = colorView.bounds.height / 2
        }
    }
    @IBOutlet var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
