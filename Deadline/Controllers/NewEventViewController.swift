//
//  NewEventViewController.swift
//  Deadline
//
//  Created by Wang Uiroz on 2022/9/7.
//

import UIKit

// 需要一個protocol來通知viewcontroller更新資料，重新讀取or打包替換
protocol NewEventViewControllerDelegate {
    func newEventVCTappedSaveButton(state: String, data: ToDoEvent, categoryData: [ToDoCategory])
}

class NewEventViewController: UIViewController {
    
    var delegate: NewEventViewControllerDelegate?
    
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
    @IBOutlet var colorButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var positionView: UIView!
    
    @IBAction func tappedSaveButton(sender: UIButton) {
        
        resignFirstResponder()
        
        let date = datePicker.date
        // 修改時區失敗，暫時先自己加8小時
//        date = date + 8*3600
        data.deadline = date
        if let text = titleTextField.text {
            data.name = text
        }
        delegate?.newEventVCTappedSaveButton(state: state, data: data, categoryData: categoryData)
        
        state = ""
        print(#function)
    }
    
    @IBAction func tappedJustView(_ sender: Any) {
        view.endEditing(true)
    }
    
    var indexPath: IndexPath?
    
    var data = ToDoEvent(category: 0,
                         name: "",
                         section: [ToDoSection(section: 0,
                                               detail: [ToDoDetail(detailName: "",
                                                                   needHour: 0,
                                                                   needMin: 0)
                                               ]
                                              )
                         ],
                         deadline: Date())
    
    var categoryData = [ToDoCategory]()
    
    var state = ""
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        scrollView.delegate = self
        // 消除tableview上面的空白處，只會出現在group
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        // 感覺跟storyboard裡面設定cell的class+id一樣意思
        tableView.register(EventDetailTableViewFooterView.self, forHeaderFooterViewReuseIdentifier: "mySectionFooter")
        tableView.register(EventDetailTableViewFooterViewBottom.self, forHeaderFooterViewReuseIdentifier: "mySectionFooterBottom")
        view.backgroundColor = .systemBackground
        tableView.backgroundColor = .systemBackground
        
        titleTextField.addTarget(self, action: #selector(titleTextFieldEditingDidEndOnExit), for: .editingDidEndOnExit)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardEvent), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardEvent), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        titleTextField.text = data.name
        datePicker.date = data.deadline
        updateColorView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillChangeFrameNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showeventcolor" {
            if let colorVC = segue.destination as? NewEventColorViewController {
                colorVC.categoryData = self.categoryData
                colorVC.categoryPosition = self.data.category
                colorVC.delegate = self
            }
        }
    }
    
    // MARK: - Many Function
    
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
            self.tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
            self.tableView.scrollIndicatorInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        // 判斷游標在哪
        if let indexPath = indexPath,
           let cell = tableView.cellForRow(at: indexPath) as? EventDetailTableViewCell,
           cell.detailTitleTextField.isFirstResponder {
            
            // scrollView滾動到cell第一格能顯示完全的位置
//            scrollView.scrollRectToVisible(positionView.frame, animated: true)
            // 把cell推到最上面
//            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
//            self.scrollView.contentInset.bottom = -keyboardViewEndFrame.height
//            self.scrollView.verticalScrollIndicatorInsets.bottom = -keyboardViewEndFrame.height
//            print(self.scrollView.verticalScrollIndicatorInsets)
            
        }
        
        if titleTextField.isFirstResponder {
            scrollView.scrollRectToVisible(titleTextField.frame, animated: true)
        }
        
    }
    
    @objc func titleTextFieldEditingDidEndOnExit() {
        if let text = titleTextField.text {
            data.name = text
        }
    }
    
    private func updateColorView() {
        if let category = data.category {
            let color = UIColor(red: categoryData[category].signR/255,
                                green: categoryData[category].signG/255,
                                blue: categoryData[category].signB/255,
                                alpha: 1.0)
            colorButton.backgroundColor = color
        }
    }
    
    // 失效，因為觸控事件被tableview接收了
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
        
}

// MARK: -- Extension

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
        
        let hourActions: [UIAction] = {
            var actions = [UIAction]()
            for i in 0..<5 {
                if self.data.section[indexPath.section].detail![indexPath.row].needHour == i {
                    let action = UIAction(title: "\(i)", state: .on, handler: { action in
                        self.data.section[indexPath.section].detail![indexPath.row].needHour = i
                        if i == 4 && self.data.section[indexPath.section].detail![indexPath.row].needMin != 0 {
                            self.data.section[indexPath.section].detail![indexPath.row].needMin = 0
                            // 當PopUpButton的menu朝上的時候，tableView.reloadData()會導致動畫錯誤
                            tableView.reloadData()
                        }
                    })
                    actions.append(action)
                } else {
                    let action = UIAction(title: "\(i)", handler: { action in
                        self.data.section[indexPath.section].detail![indexPath.row].needHour = i
                        if i == 4 && self.data.section[indexPath.section].detail![indexPath.row].needMin != 0 {
                            self.data.section[indexPath.section].detail![indexPath.row].needMin = 0
                            tableView.reloadData()
                        }
                    })
                    actions.append(action)
                }
            }
            return actions
        }()
        cell.hourPopUpButton.menu = UIMenu(children: hourActions)
        
        let minActions: [UIAction] = {
            var actions = [UIAction]()
            for i in 0..<4 {
                if self.data.section[indexPath.section].detail![indexPath.row].needMin == 15*i {
                    let action = UIAction(title: "\(15*i)", state: .on, handler: { action in
                        self.data.section[indexPath.section].detail![indexPath.row].needMin = 15*i
                        if self.data.section[indexPath.section].detail![indexPath.row].needHour == 4 && self.data.section[indexPath.section].detail![indexPath.row].needMin != 0 {
                            self.data.section[indexPath.section].detail![indexPath.row].needMin = 0
                            tableView.reloadData()
                        }
                    })
                    actions.append(action)
                } else {
                    let action = UIAction(title: "\(15*i)", handler: { action in
                        self.data.section[indexPath.section].detail![indexPath.row].needMin = 15*i
                        if self.data.section[indexPath.section].detail![indexPath.row].needHour == 4 && self.data.section[indexPath.section].detail![indexPath.row].needMin != 0 {
                            self.data.section[indexPath.section].detail![indexPath.row].needMin = 0
                            tableView.reloadData()
                        }
                    })
                    actions.append(action)
                }
            }
            return actions
        }()
        cell.minutePopUpButton.menu = UIMenu(children: minActions)
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
        if section == data.section.count - 1 {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "mySectionFooterBottom") as! EventDetailTableViewFooterViewBottom
            view.delegate = self
            view.addDetailButton.tag = section
            return view
        } else {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "mySectionFooter") as! EventDetailTableViewFooterView
            view.delegate = self
            view.addDetailButton.tag = section
            return view
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if section == data.section.count - 1 {
            return 92
        } else {
            return 50
        }
        
    }
}

extension NewEventViewController: EventDetailTableViewCellDelegate {
    // 還沒想到辦法觸發這個
    func changedTimePopUpButton(_ cell: EventDetailTableViewCell) {
        tableView.reloadData()
        print(#function)
    }
    
    func tappedDetailTitleTextField(_ cell: EventDetailTableViewCell) {
        indexPath = tableView.indexPath(for: cell)
    }
    
    func completeDetailTitleTextField(_ cell: EventDetailTableViewCell, text: String) {
        
        data.section[indexPath!.section].detail![indexPath!.row].detailName = cell.detailTitleTextField.text!
        
    }
    
}

extension NewEventViewController: EventDetailTableViewFooterViewDelegate {
    func tappedFooterViewAddDetailButton(_ cell: EventDetailTableViewFooterView, section: Int) {
        data.section[section].detail?.append(ToDoDetail(detailName: "", needHour: 0))
        tableView.reloadData()
    }
}

extension NewEventViewController: EventDetailTableViewFooterViewBottomDelegate {
    
    func tappedFooterViewAddDetailButton(_ cell: EventDetailTableViewFooterViewBottom, section: Int) {
        data.section[section].detail?.append(ToDoDetail(detailName: "", needHour: 0))
        tableView.reloadData()
    }
    func tappedFooterViewAddSectionButton(_ view: EventDetailTableViewFooterViewBottom, section: Int) {
        data.section.append(ToDoSection(section: data.section.count, detail: [ToDoDetail(detailName: "", needHour: 0)]))
        tableView.reloadData()
    }
}

extension NewEventViewController: NewEventColorViewControllerDelegate {
    func tappedColorViewSaveButton(position: Int, data: [ToDoCategory]) {
        self.categoryData = data
        self.data.category = position
        updateColorView()
    }
}
