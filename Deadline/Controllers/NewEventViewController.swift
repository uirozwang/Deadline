//
//  NewEventViewController.swift
//  Deadline
//
//  Created by Wang Uiroz on 2022/9/7.
//

import UIKit

class NewEventViewController: UIViewController {
    
    @IBOutlet var datePicker: UIDatePicker! {
        didSet {
        }
    }
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var newDetailButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    @IBAction func tappedSaveButton(sender: UIButton) {
        let date = datePicker.date
        print(date)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        datePicker.timeZone = TimeZone.current
        datePicker.calendar = Calendar.current
        datePicker.locale = Locale.current
    }

}

extension NewEventViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailcell", for: indexPath) as! EventDetailTableViewCell
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
}

extension NewEventViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
