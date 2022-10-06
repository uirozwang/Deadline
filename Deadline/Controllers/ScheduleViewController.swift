//
//  ScheduleViewController.swift
//  Deadline
//
//  Created by Wang Uiroz on 2022/10/3.
//

import UIKit

struct Position {
    var year = 2019
    var month = 9
    var day = 20
}

class ScheduleViewController: UIViewController {
    
    @IBOutlet var eventTableView: UITableView!
    @IBOutlet var dateTableView: UITableView!
    
    @IBOutlet var yearPopUpButton: UIButton!
    @IBOutlet var monthPopUpButton: UIButton!
    @IBOutlet var dayPopUpButton: UIButton!
    
    @IBAction func tappedButton(_ sender: Any) {
        print(#function)
    }
    
    var data = [ToDoEvent]()
    var index: Int?
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    let days = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30 ,31]
    
    var position = Position(year: 2019, month: 9, day: 20)

    override func viewDidLoad() {
        super.viewDidLoad()
        eventTableView.delegate = self
        eventTableView.dataSource = self
        dateTableView.delegate = self
        dateTableView.dataSource = self
        updateDatePopUpButton()
    }
    // MARK: - Many Functions
    private func updateDatePopUpButton() {
        // yearPopUpButton
        let yearActions: [UIAction] = {
            var actions = [UIAction]()
            for i in 0..<101 {
                let action = UIAction(title: "\(2000+i)",
                                      state: position.year==2000+i ? .on:.off,
                                      handler: { action in
                    self.position.year = 2000+i
                    self.updateDatePopUpButton()
                })
                actions.append(action)
            }
            return actions
        }()
        yearPopUpButton.menu = UIMenu(children: yearActions)
        // monthPopUpButton
        let monthActions: [UIAction] = {
            var actions = [UIAction]()
            for i in 0..<months.count {
                let action = UIAction(title: "\(months[i])",
                                      state: position.month==1+i ? .on:.off,
                                      handler: { action in
                    self.position.month = 1+i
                    
                    if self.position.day > self.days[i] {
                        self.position.day = 1
                    }
                    
                    self.updateDatePopUpButton()
                    // 可能需要做當月天數檢查
                })
                actions.append(action)
            }
            return actions
        }()
        monthPopUpButton.menu = UIMenu(children: monthActions)
        // dayPopUpButton
        let dayActions: [UIAction] = {
            var actions = [UIAction]()
            for i in 0..<days[position.month-1] {
                let action = UIAction(title: "\(i+1)",
                                      state: position.day==1+i ? .on:.off,
                                      handler: { action in
                    self.position.day = 1+i
                    self.updateDatePopUpButton()
                })
                actions.append(action)
            }
            return actions
        }()
        dayPopUpButton.menu = UIMenu(children: dayActions)
        
    }
}
// MARK: - Extensions
extension ScheduleViewController: UITableViewDelegate {
    
}

extension ScheduleViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == dateTableView {
            return 1
        }
        if tableView == eventTableView,
           let index = index{
            return data[index].section.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == dateTableView {
            return 96
        }
        if tableView == eventTableView,
           let index = index {
            return data[index].section[section].detail?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == dateTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "scheduledatecell", for: indexPath) as! ScheduleDateTableViewCell
            cell.dateLabel.text = "\(indexPath.row/4):\(indexPath.row%4*15)"
            if indexPath.row%4 == 0 {
                cell.dateLabel.text = cell.dateLabel.text! + "0"
            }
            if indexPath.row/4 < 10 {
                cell.dateLabel.text = "0" + cell.dateLabel.text!
            }
            return cell
        }
        
        if tableView == eventTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "scheduledetailcell", for: indexPath) as! ScheduleEventDetailTableViewCell
            if let index = index {
                let name = data[index].section[indexPath.section].detail![indexPath.row].detailName
                cell.detailNameLabel.text = name
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
        
}

