//
//  NewEventViewController.swift
//  Deadline
//
//  Created by Wang Uiroz on 2022/9/7.
//

import UIKit

class NewEventViewController: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView! {
        didSet {
        }
    }
    @IBOutlet var justView: UIView! {
        didSet {
        }
    }
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
    @IBAction func tappedJustView(_ sender: Any) {
        view.endEditing(true)
    }
    
    var indexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        scrollView.delegate = self
        scrollView.contentSize.width = view.bounds.width
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardEvent), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardEvent), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillChangeFrameNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
    }
    
    
    
    @objc func keyboardEvent(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        // get keyboard's frame
        let keyboardScreenEndFrame: CGRect = keyboardFrame.cgRectValue
        // 取得鍵盤轉換後的frame，相對於UIWindow，是因為UIWindow是用來接收鍵盤事件的
        let keyboardViewEndFrame: CGRect = view.convert(keyboardScreenEndFrame, to: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            self.scrollView.contentInset = UIEdgeInsets.zero
            self.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        } else {
            self.scrollView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
            self.scrollView.scrollIndicatorInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
            print("keyboardViewEndFrame:\(keyboardViewEndFrame)")
        }
        if titleTextField.isFirstResponder {
            scrollView.scrollRectToVisible(titleTextField.frame, animated: true)
//            print(titleTextField)
        }
        
        if let indexPath = indexPath {
            if let cell = tableView.cellForRow(at: indexPath) {
                print("tableViewFrame:\(tableView.frame)")
//                let frame = CGRect(x: cell.frame.origin.x,
//                                   y: cell.frame.origin.y + tableView.frame.origin.y,
//                                   width: cell.frame.width,
//                                   height: cell.frame.height)
                let frame = cell.convert(cell.frame, to: self.view)
                print("new cell frame:\(frame)")
                scrollView.scrollRectToVisible(frame, animated: true)
                print("cell:\(cell)")
            }
        }
        print(#function)
        
    }
    // 失效，因為觸控事件被tableview接收了
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension NewEventViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailcell", for: indexPath) as! EventDetailTableViewCell
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        view.endEditing(true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}

extension NewEventViewController: EventDetailTableViewCellDelegate {
    func tappedDetailTitleTextField(_ cell: EventDetailTableViewCell) {
        
        indexPath = tableView.indexPath(for: cell)
        scrollView.scrollRectToVisible(cell.frame, animated: true)
        print(#function)
        
    }
}
