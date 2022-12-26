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

protocol ScheduleViewControllerDelegate {
    func scheduleVCTappedSaveButton(data: [ToDoEvent])
}

class ScheduleViewController: UIViewController {
    
    var delegate: ScheduleViewControllerDelegate?
    
    @IBOutlet var eventTableView: UITableView!
    @IBOutlet var dateTableView: UITableView!
    
    @IBOutlet var yearPopUpButton: UIButton!
    @IBOutlet var monthPopUpButton: UIButton!
    @IBOutlet var dayPopUpButton: UIButton!
    
    @IBAction func tappedButton(_ sender: Any) {
        print(#function)
    }
    // 為了顯示全部已知的排程，先把全部資料帶進來
    var data = [ToDoEvent]()
    // 
    var table = [[[[CalendarPartition]]]]()
    
    var restoreKey = 0
    var restoreEventIndex: Int? = nil
    var restoreDetailSection: Int? = nil
    var restoreDetailRow: Int? = nil
    var restoreEventIndex2: Int? = nil
    var restoreDetailSection2: Int? = nil
    var restoreDetailRow2: Int? = nil
    var dataBackup = [ToDoEvent]()
    var tableBackup = [[[[CalendarPartition]]]]()
    
    // 當前正在排程的資料序號
    var index: Int?
    
    var position = Position(year: 2019,
                            month: 9,
                            day: 20)
    // 準備要排上去的detail位置
    var schedulePosition: IndexPath?
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    let days = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30 ,31]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventTableView.delegate = self
        eventTableView.dataSource = self
        dateTableView.delegate = self
        dateTableView.dataSource = self
        setToday()
        updateDatePopUpButton()
        initialCalendarTable()
        updateCalendarTable()
        dataBackup = data
        tableBackup = table
        navigationItem.title = data[index!].name
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
                    self.dateTableView.scrollToRow(at: IndexPath(row: 0, section: 0) , at: .top, animated: false)
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
                    self.dateTableView.scrollToRow(at: IndexPath(row: 0, section: 0) , at: .top, animated: false)
                })
                actions.append(action)
            }
            return actions
        }()
        monthPopUpButton.menu = UIMenu(children: monthActions)
        // dayPopUpButton
        let dayActions: [UIAction] = {
            var actions = [UIAction]()
            if position.year%4 != 0 && position.month == 2 {
                for i in 0..<28 {
                    let action = UIAction(title: "\(i+1)",
                                          state: position.day==1+i ? .on:.off,
                                          handler: { action in
                        self.position.day = 1+i
                        self.updateDatePopUpButton()
                        self.dateTableView.scrollToRow(at: IndexPath(row: 0, section: 0) , at: .top, animated: false)
                    })
                    actions.append(action)
                }
            } else {
                for i in 0..<days[position.month-1] {
                    let action = UIAction(title: "\(i+1)",
                                          state: position.day==1+i ? .on:.off,
                                          handler: { action in
                        self.position.day = 1+i
                        self.updateDatePopUpButton()
                        self.dateTableView.scrollToRow(at: IndexPath(row: 0, section: 0) , at: .top, animated: false)
                    })
                    actions.append(action)
                }
            }
            return actions
        }()
        dayPopUpButton.menu = UIMenu(children: dayActions)
        
    }
    // 可以加點限制
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        print(#function)
        print(identifier.description)
        if identifier == "schedulesavebutton" {
            delegate?.scheduleVCTappedSaveButton(data: data)
            print("delegate success")
        }
        return true
    }
    func setToday() {
        let currentYear = Calendar.current.component(.year, from: Date())
        let currentMonth = Calendar.current.component(.month, from: Date())
        let currentDay = Calendar.current.component(.day, from: Date())
        position.year = currentYear
        position.month = currentMonth
        position.day = currentDay
    }
    // 每天切成96塊
    func initialCalendarTable() {
        table = [[[[CalendarPartition]]]]()
        for i in 0..<101 {
            var year = [[[CalendarPartition]]]()
            for j in 0..<12 {
                var month = [[CalendarPartition]]()
                for k in 0..<days[j] {
                    var day = [CalendarPartition]()
                    if i%4 != 0 && j==1 && k==28 {
                        break
                    } else {
                        for _ in 0..<96 {
                            let partition = CalendarPartition()
                            day.append(partition)
                        }
                        month.append(day)
                    }
                }
                year.append(month)
            }
            table.append(year)
        }
    }
    // 把事項的data填進table
    func updateCalendarTable() {
        restoreKey = 0
        for i in 0..<data.count {
            if restoreKey == 1 { break }
            for j in 0..<data[i].detail.count {
                if restoreKey == 1 { break }
                for k in 0..<data[i].detail[j].count {
                    if restoreKey == 1 { break }
                    if data[i].detail[j][k].toDoYear != nil {
                        if restoreKey == 1 { break }
                        if var year = data[i].detail[j][k].toDoYear,
                           var month = data[i].detail[j][k].toDoMonth,
                           var day = data[i].detail[j][k].toDoDay,
                           let hour = data[i].detail[j][k].toDoHour,
                           let min = data[i].detail[j][k].toDoMinute,
                           let needHour = data[i].detail[j][k].needHour,
                           let needMin = data[i].detail[j][k].needMin {
                            let needTime = needHour * 4 + needMin / 15
                            for l in 0..<needTime {
                                if restoreKey == 1 { break }
                                if hour*4+min/15+l==96 {
                                    day = day + 1
                                }
                                if i%4 != 0 && j == 1  && day == 27{
                                    day = 0
                                    month = month + 1
                                }
                                if day > days[j] {
                                    day = 0
                                    month = month + 1
                                }
                                if month > 11 {
                                    month = 0
                                    year = year + 1
                                }
                                
                                if table[year][month][day][(hour*4+min/15+l)%96].eventIndex == nil,
                                   table[year][month][day][(hour*4+min/15+l)%96].detailSection == nil,
                                   table[year][month][day][(hour*4+min/15+l)%96].detailRow == nil {
                                    
                                    table[year][month][day][(hour*4+min/15+l)%96].eventIndex = i
                                    table[year][month][day][(hour*4+min/15+l)%96].detailSection = j
                                    table[year][month][day][(hour*4+min/15+l)%96].detailRow = k
                                } else {
                                    restoreKey = 1
                                    restoreEventIndex = table[year][month][day][(hour*4+min/15+l)%96].eventIndex
                                    restoreDetailSection = table[year][month][day][(hour*4+min/15+l)%96].detailSection
                                    restoreDetailRow = table[year][month][day][(hour*4+min/15+l)%96].detailRow
                                    restoreEventIndex2 = i
                                    restoreDetailSection2 = j
                                    restoreDetailRow2 = k
                                    break
                                }
                            }
                        }
                    }
                }
            }
        }
//        for i in 0..<20 {
//            print(self.table[22][11][14][i].detailRow)
//        }
//        print(self.data[index!].detail[0])
//        for i in 0..<self.data[index!].detail[0].count {
//            print(self.data[index!].detail[0][i])
//        }
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
            return data[index].detail.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == dateTableView {
            return 96
        }
        if tableView == eventTableView,
           let index = index {
            return data[index].detail[section].count
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
            let year = position.year - 2000
            let month = position.month - 1
            let day = position.day - 1
            if let detailSection =  table[year][month][day][indexPath.row].detailSection,
               let detailRow = table[year][month][day][indexPath.row].detailRow,
               let index = table[year][month][day][indexPath.row].eventIndex
            {
//                print(detailSection, detailRow)
                let detailName = data[index].detail[detailSection][detailRow].detailName
                cell.detailNameLabel.text = "\(detailName)"
            } else {
                cell.detailNameLabel.text = ""
            }
            
            return cell
        }
        
        if tableView == eventTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "scheduledetailcell", for: indexPath) as! ScheduleEventDetailTableViewCell
            if let index = index {
                let name = data[index].detail[indexPath.section][indexPath.row].detailName
                cell.detailNameLabel.text = name
                cell.cursorImageView.image = self.schedulePosition == indexPath ? UIImage(systemName: "arrowshape.backward.fill") : nil
                if data[index].detail[indexPath.section][indexPath.row].toDoYear != nil{
                    print(index, indexPath.section, indexPath.row, data[index].detail[indexPath.section][indexPath.row])
                    cell.checkImageView.image = UIImage(systemName: "checkmark")
                } else {
                    cell.checkImageView.image = nil
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        // 選決定要選個細項來排程
        if tableView == eventTableView {
            schedulePosition = schedulePosition != indexPath ? indexPath : nil
            eventTableView.reloadData()
        }
        // 排程的時間
        if tableView == dateTableView,
           let schedulePosition = self.schedulePosition,
           let index = index {
            // 如果點的是同一個時間，取消排程
            if  data[index].detail[schedulePosition.section][schedulePosition.row].toDoYear == position.year - 2000 &&
                data[index].detail[schedulePosition.section][schedulePosition.row].toDoMonth == position.month - 1 &&
                data[index].detail[schedulePosition.section][schedulePosition.row].toDoDay == position.day - 1 &&
                data[index].detail[schedulePosition.section][schedulePosition.row].toDoHour == indexPath.row/4 &&
                data[index].detail[schedulePosition.section][schedulePosition.row].toDoMinute == indexPath.row%4*15 {
                
                data[index].detail[schedulePosition.section][schedulePosition.row].toDoYear = nil
                data[index].detail[schedulePosition.section][schedulePosition.row].toDoMonth = nil
                data[index].detail[schedulePosition.section][schedulePosition.row].toDoDay = nil
                data[index].detail[schedulePosition.section][schedulePosition.row].toDoHour = nil
                data[index].detail[schedulePosition.section][schedulePosition.row].toDoMinute = nil
            } else {
                data[index].detail[schedulePosition.section][schedulePosition.row].toDoYear = position.year - 2000
                data[index].detail[schedulePosition.section][schedulePosition.row].toDoMonth = position.month - 1
                data[index].detail[schedulePosition.section][schedulePosition.row].toDoDay = position.day - 1
                data[index].detail[schedulePosition.section][schedulePosition.row].toDoHour = indexPath.row/4
                data[index].detail[schedulePosition.section][schedulePosition.row].toDoMinute = indexPath.row%4*15
            }
            initialCalendarTable()
            updateCalendarTable()
            
            if restoreKey == 1 {
                data = dataBackup
                table = tableBackup
                // 顯示排程重複通知，可藉由restore來顯示具體衝突的事項，且使用alert提供覆蓋
                // schedulePosition:剛排程的事項
                // restore:即將被覆蓋的事項
                if var index = restoreEventIndex,
                   var section = restoreDetailSection,
                   var row = restoreDetailRow,
                   let newIndex = self.index {
                    let newSection = schedulePosition.section
                    let newRow = schedulePosition.row
                    let newDetailName = data[newIndex].detail[newSection][newRow].detailName
                    // 在update檢查時遇到先後問題，兩個都存起來，排除掉剛點擊的那個就是被覆蓋的事項
                    if index == newIndex,
                       section == newSection,
                       row == newRow {
                        index = restoreEventIndex2!
                        section = restoreDetailSection2!
                        row = restoreDetailRow2!
                    }
                    
                    let detailName = data[index].detail[section][row].detailName
                    let controller = UIAlertController(title: "發現排程重複", message: "是否以\(newDetailName)覆蓋\(detailName)？", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "覆蓋", style: .default) { _ in
                        self.data[index].detail[section][row].toDoYear = nil
                        self.data[index].detail[section][row].toDoMonth = nil
                        self.data[index].detail[section][row].toDoDay = nil
                        self.data[index].detail[section][row].toDoHour = nil
                        self.data[index].detail[section][row].toDoMinute = nil
                        self.data[index].detail[schedulePosition.section][schedulePosition.row].toDoYear = self.position.year - 2000
                        self.data[index].detail[schedulePosition.section][schedulePosition.row].toDoMonth = self.position.month - 1
                        self.data[index].detail[schedulePosition.section][schedulePosition.row].toDoDay = self.position.day - 1
                        self.data[index].detail[schedulePosition.section][schedulePosition.row].toDoHour = indexPath.row/4
                        self.data[index].detail[schedulePosition.section][schedulePosition.row].toDoMinute = indexPath.row%4*15
                        self.initialCalendarTable()
                        self.updateCalendarTable()
                        self.dateTableView.reloadData()
                        self.eventTableView.reloadData()
                        self.dataBackup = self.data
                        self.tableBackup = self.table
                        print("覆蓋")
                    }
                    controller.addAction(okAction)
                    let cancelAction = UIAlertAction(title: "取消", style: .cancel) { _ in
                        self.dateTableView.reloadData()
                        self.eventTableView.reloadData()
                    }
                    controller.addAction(cancelAction)
                    present(controller, animated: true)
                    restoreKey = 0
                }
            } else {
                dataBackup = data
                tableBackup = table
                dateTableView.reloadData()
                eventTableView.reloadData()
            }
        }
    }
}

