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
    func changedTimePopUpButton(_ cell: EventDetailTableViewCell)
}

class EventDetailTableViewCell: UITableViewCell {
    
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var detailTitleTextField: UITextField!
    @IBOutlet var hourPopUpButton: UIButton!
    @IBOutlet var minutePopUpButton: UIButton!
    
    var delegate: EventDetailTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        detailTitleTextField.addTarget(self, action: #selector(didBeganEditing(_:)), for: .editingDidBegin)
        detailTitleTextField.addTarget(self, action: #selector(didEndEditing(_:)), for: .editingDidEnd)
        detailTitleTextField.addTarget(self, action: #selector(didEndEditingOnExit(_:)), for: .editingDidEndOnExit)
        hourPopUpButton.addTarget(self, action: #selector(didTimePopUpButtonValueChanged(_:)), for: .valueChanged)
        minutePopUpButton.addTarget(self, action: #selector(didTimePopUpButtonValueChanged(_:)), for: .valueChanged)
        hourPopUpButton.showsMenuAsPrimaryAction = true
        hourPopUpButton.changesSelectionAsPrimaryAction = true
        minutePopUpButton.showsMenuAsPrimaryAction = true
        minutePopUpButton.changesSelectionAsPrimaryAction = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func didBeganEditing(_ sender: UITextField) {
        delegate?.tappedDetailTitleTextField(self)
    }
    @objc func didEndEditing(_ sender: UITextField) {
        delegate?.completeDetailTitleTextField(self, text: sender.text ?? "")
    }
    @objc func didEndEditingOnExit(_ sender: UITextField) {
    }
    @objc func didTimePopUpButtonValueChanged(_ sender: UIButton) {
        delegate?.changedTimePopUpButton(self)
    }

}
