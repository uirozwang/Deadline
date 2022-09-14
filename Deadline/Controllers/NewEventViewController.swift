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
    @IBOutlet var positionView: UIView!
    
    @IBAction func tappedSaveButton(sender: UIButton) {
        let date = datePicker.date
        if let indexPath = indexPath {
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            print(indexPath)
        }
        print(date)
    }
    @IBAction func tappedJustView(_ sender: Any) {
        view.endEditing(true)
    }
    
    var indexPath: IndexPath?
    
    var data = ToDoEvent(name: "test title",
                         section: [ToDoSection(section: 0,
                                               detail: [ToDoDetail(detailName: "test detail1",
                                                                   needTime: 0),
                                                        ToDoDetail(detailName: "test detail2",
                                                                   needTime: 0)
                                               ]
                                              ),
                                   ToDoSection(section: 1,
                                               detail: [ToDoDetail(detailName: "test detail1",
                                                                   needTime: 0),
                                                        ToDoDetail(detailName: "test detail2",
                                                                   needTime: 0)
                                               ]
                                              ),
                                   ToDoSection(section: 2,
                                               detail: [ToDoDetail(detailName: "test detail1",
                                                                   needTime: 0),
                                                        ToDoDetail(detailName: "test detail2",
                                                                   needTime: 0)
                                               ]
                                              )
                         ],
                         deadline: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        scrollView.delegate = self
        // 消除tableview上面的空白處，只會出現在group
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        // 感覺跟storyboard裡面設定cell的class+id一樣意思
        tableView.register(EventDetailTableViewFooterView.self, forHeaderFooterViewReuseIdentifier: "mySectionFooter")
        tableView.backgroundColor = .systemGray
        
//        tableView.sectionFooterHeight = UITableView.automaticDimension
//        tableView.tableFooterView = EventDetailTableViewFooterView()
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
        // 在scrollView底部增加與鍵盤等高的空間
        if notification.name == UIResponder.keyboardWillHideNotification {
            self.scrollView.contentInset = UIEdgeInsets.zero
            self.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
            self.tableView.contentInset = UIEdgeInsets.zero
            self.tableView.scrollIndicatorInsets = UIEdgeInsets.zero
        } else {
            self.scrollView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
            self.scrollView.scrollIndicatorInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
            self.tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 300, right: 0)
            self.tableView.scrollIndicatorInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 300, right: 0)
        }
        // 判斷游標在哪
        if let indexPath = indexPath,
           let cell = tableView.cellForRow(at: indexPath) as? EventDetailTableViewCell,
           cell.detailTitleTextField.isFirstResponder {
            
            // scrollView滾動到cell第一格的位置
            scrollView.scrollRectToVisible(positionView.frame, animated: true)
            // 把cell推到最上面
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            print(indexPath)
//            tableView.scrollsToTop
            
        }
        
        if titleTextField.isFirstResponder {
            scrollView.scrollRectToVisible(titleTextField.frame, animated: true)
        }
        print(#function)
        
    }
    // 失效，因為觸控事件被tableview接收了
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension NewEventViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
            data.section.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailcell", for: indexPath) as! EventDetailTableViewCell
        cell.delegate = self
        cell.numberLabel.text = "\(indexPath.row+1)"
        cell.detailTitleTextField.tag = (indexPath.section * 1000) + indexPath.row
        cell.detailTitleTextField.text = data.section[indexPath.section].detail![indexPath.row].detailName
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.section[section].detail!.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "mySectionFooter") as! EventDetailTableViewFooterView
        view.delegate = self
        view.addDetailButton.tag = section
        return view
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        50
    }
}

extension NewEventViewController: EventDetailTableViewCellDelegate {
    func tappedDetailTitleTextField(_ cell: EventDetailTableViewCell) {
        print(#function)
        if let indexPath = tableView.indexPath(for: cell) {
            print(indexPath)
        }
        print(#function)
        
        indexPath = tableView.indexPath(for: cell)
        
    }
    
    func completeDetailTitleTextField(_ cell: EventDetailTableViewCell, text: String) {
        print(#function)
        if let indexPath = tableView.indexPath(for: cell) {
            print(indexPath)
        }
        print(cell)
        print(cell.detailTitleTextField.text)
        print(#function)
        data.section[indexPath!.section].detail![indexPath!.row].detailName = cell.detailTitleTextField.text!
    }
    
}

extension NewEventViewController: EventDetailTableViewFooterViewDelegate {
    func tappedFooterViewAddDetailButton(_ cell: EventDetailTableViewFooterView, section: Int) {
        data.section[section].detail?.append(ToDoDetail(detailName: "", needTime: 0))
        tableView.reloadData()
    }
}
