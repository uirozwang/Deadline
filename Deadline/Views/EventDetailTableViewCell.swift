//
//  EventDetailTableViewCell.swift
//  Deadline
//
//  Created by Wang Uiroz on 2022/9/7.
//

import UIKit

protocol EventDetailTableViewCellDelegate {
    func tappedDetailTitleTextField(_ cell: EventDetailTableViewCell)
    func completeDetailTitleTextField(_ cell: EventDetailTableViewCell, text: String)
}

class EventDetailTableViewCell: UITableViewCell {
    
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var detailTitleTextField: UITextField!
    @IBOutlet var detailDatePicker: UIDatePicker!
    
    var delegate: EventDetailTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        detailTitleTextField.addTarget(self, action: #selector(didBeganEditing(_:)), for: .editingDidBegin)
        detailTitleTextField.addTarget(self, action: #selector(didEndEditing(_:)), for: .editingDidEnd)
        detailTitleTextField.addTarget(self, action: #selector(didEndEditingOnExit(_:)), for: .editingDidEndOnExit)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func didBeganEditing(_ sender: UITextField) {
        delegate?.tappedDetailTitleTextField(self)
    }
    @objc func didEndEditing(_ sender: UITextField) {
        delegate?.completeDetailTitleTextField(self, text: sender.text ?? "")
    }
    @objc func didEndEditingOnExit(_ sender: UITextField) {
    }

}
