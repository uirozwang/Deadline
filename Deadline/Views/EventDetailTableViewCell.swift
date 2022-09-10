//
//  EventDetailTableViewCell.swift
//  Deadline
//
//  Created by Wang Uiroz on 2022/9/7.
//

import UIKit

protocol EventDetailTableViewCellDelegate {
    func tappedDetailTitleTextField(_ cell: EventDetailTableViewCell)
}

class EventDetailTableViewCell: UITableViewCell {
    
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var detailTitleTextField: UITextField!
    @IBOutlet var detailDatePicker: UIDatePicker!
    
    var delegate: EventDetailTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        detailTitleTextField.addTarget(self, action: #selector(didBeganEditing(_:)), for: .editingDidBegin)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func didBeganEditing(_ sender: UITextField) {
        delegate?.tappedDetailTitleTextField(self)
    }

}
