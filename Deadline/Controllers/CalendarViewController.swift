//
//  ViewController.swift
//  Deadline
//
//  Created by Wang Uiroz on 2022/9/4.
//

import UIKit
import CoreData

class CalendarViewController: UIViewController {
    
    @IBOutlet var weekCollectionView: UICollectionView!
    @IBOutlet var dayCollectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var dateLeftButton: UIButton!
    @IBOutlet var dateRightButton: UIButton!
    
    @IBAction func tappedDateLeftButton(sender: UIButton) {
        monthAndYear(positive: false)
    }
    @IBAction func tappedDateRightButton(sender: UIButton) {
        monthAndYear(positive: true)
    }
    @IBAction func tappedTabbarCalenlarButton(sender: Any) {
        
    }
    @IBAction func animateFrame(_ sender: UIButton) {
        //        let diceRoll = CGFloat(Int(arc4random_uniform(7))*30)
        //        let circleEdge = CGFloat(200)
        //
        //        // 直接指定 frame 布局
        //        let statusView = CalendarDayCollectionViewCellDrawView(frame: CGRect(x: 50, y: diceRoll, width: circleEdge, height: circleEdge))
        //
        //        view.addSubview(statusView)
        //
        //        // 开始动画
        //        statusView.animateCircle(duration: 1.0)
        dayCollectionView.reloadData()
        print(#function)
    }
    
    var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    let days = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30 ,31]
    // 事項資料
    var data = [ToDoEvent]()
    // 事項分類
    var categoryData = [ToDoCategory]()
    // 行事曆表格，每一格15分鐘
    var table = [[[[CalendarPartition]]]]()
    var tableBackup = [[[[CalendarPartition]]]]()
    //
    var currentMonthEvents: [Int] = []
    var currentDayDetails: [CalendarPartition] = []
    // tableView顯示當月event或指定日期的detail，false為month，true則為detail
    var monthOrDay: Bool = false
    var clickedDay: Int = 0
    
    let lineWidth: CGFloat = 2
    
    let currentYear = Calendar.current.component(.year, from: Date())
    let currentMonth = Calendar.current.component(.month, from: Date())
    let currentDay = Calendar.current.component(.day, from: Date())
    let currentWeekday = Calendar.current.component(.weekday, from: Date())
    
    var positionYear = 2022
    var positionMonth = 12
    var positionDay = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateLabel.text = "\(months[positionMonth - 1]) \(positionYear)"
        dayCollectionView.delegate = self
        dayCollectionView.dataSource = self
        weekCollectionView.delegate = self
        weekCollectionView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        getData()
        initialCalendarTable()
        tableBackup = table
        updateCalendarTable()
        
        if let tabBarController = tabBarController as? TabBarController {
            tabBarController.delegate = self
            // 暫時廢棄
            tabBarController.tabBarDelegate = self
        }
        
        if let navigationController = tabBarController?.viewControllers?[1] as? UINavigationController,
           let eventVC = navigationController.viewControllers[0] as? EventsViewController {
            eventVC.delegate = self
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    func checkWeekday(year: Int, month: Int, day: Int) -> Int{
        // 查詢指定日期星期幾
        let dateComponents = NSDateComponents()
        dateComponents.day = day
        dateComponents.month = month
        dateComponents.year = year
        
        if let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian),
           let date = gregorianCalendar.date(from: dateComponents as DateComponents) {
            let weekday = gregorianCalendar.component(.weekday, from: date)
            return weekday
        }
        return 20
    }
    
    func monthAndYear(positive: Bool) {
        if positive {
            positionMonth += 1
            if positionMonth > 12 {
                positionMonth = 1
                positionYear += 1
            }
        } else {
            positionMonth -= 1
            if positionMonth < 1 {
                positionMonth = 12
                positionYear -= 1
            }
        }
        updateCalender()
    }
    func updateCalender() {
        dateLabel.text = "\(months[positionMonth - 1]) \(positionYear)"
        updateCalendarTable()
        dayCollectionView.reloadData()
        tableView.reloadData()
    }
    
    func getData() {
        
        if let data = UserDefaults.standard.data(forKey: "data") {
            do {
                let data = try JSONDecoder().decode([ToDoEvent].self, from: data)
                self.data = data
            } catch {
                print("Decoding error:", error)
            }
        }
        if let categoryData = UserDefaults.standard.data(forKey: "category") {
            do {
                let categoryData = try JSONDecoder().decode([ToDoCategory].self, from: categoryData)
                self.categoryData = categoryData
            } catch {
                print("Decoding error:", error)
            }
        }
        
    }
    // 每天切成96塊
    func initialCalendarTable() {
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
        for i in 0..<data.count {
            for j in 0..<data[i].detail.count {
                for k in 0..<data[i].detail[j].count {
                    if data[i].detail[j][k].toDoYear != nil {
                        if var year = data[i].detail[j][k].toDoYear,
                           var month = data[i].detail[j][k].toDoMonth,
                           var day = data[i].detail[j][k].toDoDay,
                           let hour = data[i].detail[j][k].toDoHour,
                           let min = data[i].detail[j][k].toDoMinute,
                           let needHour = data[i].detail[j][k].needHour,
                           let needMin = data[i].detail[j][k].needMin {
                            let needTime = needHour * 4 + needMin / 15
                            for l in 0..<needTime {
                                if hour*4+min/15+l==96 {
                                    day = day + 1
                                }
                                if i%4 != 0 && j == 1  && day == 27{
                                    day = 1
                                    month = month + 1
                                }
                                if day > days[j] {
                                    day = 1
                                    month = month + 1
                                }
                                if month > 11 {
                                    month = 1
                                    year = year + 1
                                }
                                table[year][month][day][hour*4+min/15+l].eventIndex = i
                                table[year][month][day][hour*4+min/15+l].detailSection = j
                                table[year][month][day][hour*4+min/15+l].detailRow = k
                            }
                        }
                    }
                }
            }
        }
        updateCurrentMonthEvent()
    }
    // 整理當前顯示月份有出現event
    func updateCurrentMonthEvent() {
        let year = positionYear - 2000
        let month = positionMonth - 1
        var events: Set<Int> = []
        
        for i in 0..<table[year][month].count {
            for j in 0..<96 {
                if let eventIndex = table[year][month][i][j].eventIndex {
                    events.insert(eventIndex)
                }
            }
        }
        var indexs: [Int] = []
        for event in events {
            indexs.append(event)
        }
        indexs.sort(){$0<$1}
        currentMonthEvents = indexs
    }
    
}

extension CalendarViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0:
            return 7
        default:
            return 42
        }
    }
    
}

extension CalendarViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let week = ["Sun", "Mon", "Tus", "Wed", "Thu", "Fri", "Sat"]
        switch collectionView.tag {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weekcell", for: indexPath) as! CalendarWeekCollectionViewCell
            cell.backgroundColor = .systemGray3
            cell.textLabel.text = week[indexPath.row]
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "daycell", for: indexPath) as! CalendarDayCollectionViewCell
            cell.backgroundColor = .systemBackground
            
            // 標示被點擊的日期
            if monthOrDay && indexPath.row == clickedDay {
                cell.textLabel.backgroundColor = UIColor.systemIndigo
            } else {
                cell.textLabel.backgroundColor = UIColor.systemBackground
            }
            
            let firstDayPosition = checkWeekday(year: positionYear,
                                                month: positionMonth,
                                                day: 1)
            // 日～六為1～7，故+1
            if (indexPath.row+1 >= firstDayPosition) &&
                (indexPath.row+1 < (firstDayPosition + days[positionMonth-1])) {
                if positionYear%4 != 0 && positionMonth == 2 && (indexPath.row-firstDayPosition+2)==29 {
                    cell.textLabel.text = ""
                } else {
                    cell.textLabel.text = "\(indexPath.row-firstDayPosition+2)"
                    cell.backgroundColor = UIColor.systemBackground
                    
                    // 統整各分類的數量，對cell的drawView而言，資料只有各分類的數量以及該分類的顏色，所以好像也能直接把percentage的篩選寫在這？
                    let year = positionYear - 2000
                    let month = positionMonth - 1
                    let day = indexPath.row-firstDayPosition+1
                    
                    
                    // 用來記錄當天事項在各個分類中個別有幾個
                    var preIndexCount: [Int] = []
                    // 篩選後，實際的分類次數，只傳遞顏色的部分
                    var indexCount: [CGFloat] = []
                    var signR: [CGFloat] = []
                    var signG: [CGFloat] = []
                    var signB: [CGFloat] = []
                    // 空陣列，用來記錄次數
                    for _ in 0..<categoryData.count {
                        let num = Int()
                        preIndexCount.append(num)
                    }
                    // 計算次數
                    for i in 0..<table[year][month][day].count {
                        if let index = table[year][month][day][i].eventIndex,
                           let categoryIndex = data[index].category {
                            preIndexCount[categoryIndex] = preIndexCount[categoryIndex] + 1
                        }
                    }
                    // 篩選掉0的部分
                    for i in 0..<preIndexCount.count {
                        if preIndexCount[i] != 0 {
                            indexCount.append(CGFloat(preIndexCount[i]))
                            signR.append(categoryData[i].signR)
                            signG.append(categoryData[i].signG)
                            signB.append(categoryData[i].signB)
                        }
                    }
                    
                    var needTime = 0
                    
                    for count in indexCount {
                        needTime = needTime + Int(count)
                    }
                    
                    var total: CGFloat = 0
                    for index in indexCount {
                        total = total + index
                    }
                    
                    var percentages: [CGFloat] = []
                    for index in indexCount {
                        let percentage = index/total*100
                        percentages.append(percentage)
                    }
                    
                    cell.drawView.percentages = percentages
                    cell.drawView.signR = signR
                    cell.drawView.signG = signG
                    cell.drawView.signB = signB
                    cell.drawView.needTimeLabel.text = "\(needTime)"
                    
                    if percentages.count == 0 {
                        cell.drawView.percentages = [100]
                        cell.drawView.signR = [333]
                        cell.drawView.signG = [333]
                        cell.drawView.signB = [333]
                        cell.drawView.needTimeLabel.text = ""
                    }
                    
                }
            } else {
                cell.textLabel.text = " "
                cell.drawView.percentages = [100]
                cell.drawView.signR = [333]
                cell.drawView.signG = [333]
                cell.drawView.signB = [333]
                cell.drawView.needTimeLabel.text = ""
                
            }
            
            return cell
        default:
            break
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 弄一個陣列儲存該日的detail
        // 一個bool儲存顯示當月event或者選定日期的detail
        // 通知tableView刷新
        // 搜尋該日的所有detail的evnet section row，到時候顯示開始到結束的時間
        
        let firstDayPosition = checkWeekday(year: positionYear,
                                            month: positionMonth,
                                            day: 1)
        let year = positionYear - 2000
        let month = positionMonth - 1
        let day = indexPath.row-firstDayPosition+1
        var check = 1
        currentDayDetails = []
        
        for i in 0..<table[year][month][day].count {
            check = 1
            for j in 0..<currentDayDetails.count {
                if table[year][month][day][i].eventIndex == currentDayDetails[j].eventIndex &&
                    table[year][month][day][i].detailSection == currentDayDetails[j].detailSection &&
                    table[year][month][day][i].detailRow == currentDayDetails[j].detailRow {
                    check = 0
                }
            }
            if check == 1 && table[year][month][day][i].eventIndex != nil {
                currentDayDetails.append(table[year][month][day][i])
            }
        }
        
        clickedDay = indexPath.row
        monthOrDay.toggle()
        tableView.reloadData()
        dayCollectionView.reloadData()
        
    }
    
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.tag {
        case 0:
            let screenWidth = view.frame.width
            let cellWidth = (screenWidth - 6 * lineWidth) / 7
            return CGSize(width: cellWidth, height: 35)
        default:
            let screenWidth = view.frame.width
            let cellWidth = (screenWidth - 6 * lineWidth) / 7
            let cellHeight = (screenWidth - 7 * lineWidth) / 6 + 2
            return CGSize(width: cellWidth, height: cellHeight)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        lineWidth
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        lineWidth
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionView.tag {
        case 0:
            let inset = UIEdgeInsets(top: lineWidth,
                                     left: 0,
                                     bottom: 0,
                                     right: 0)
            return inset
        default:
            let inset = UIEdgeInsets(top: lineWidth, left: 0, bottom: lineWidth, right: 0)
            return inset
        }
    }
}

extension CalendarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if monthOrDay {
            return currentDayDetails.count
        } else {
            return currentMonthEvents.count
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if monthOrDay {
            return "Day Details"
        } else {
            return "Month Events"
        }
    }
}

extension CalendarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todocell", for: indexPath) as! CalendarEventTableViewCell
        
        if monthOrDay == true {
            if let eventIndex = currentDayDetails[indexPath.row].eventIndex,
               let section = currentDayDetails[indexPath.row].detailSection,
               let row = currentDayDetails[indexPath.row].detailRow {
                let eventName = data[eventIndex].name
                let detailName = data[eventIndex].detail[section][row].detailName
                let todoYear = data[eventIndex].detail[section][row].toDoYear
                let todoMonth = data[eventIndex].detail[section][row].toDoMonth
                let todoDay = data[eventIndex].detail[section][row].toDoDay
                let todoHour = data[eventIndex].detail[section][row].toDoHour
                let todoMin = data[eventIndex].detail[section][row].toDoMinute
                cell.titleLabel.text = "\(eventName)-\(detailName)  Start: \(todoMonth!+1)/\(todoDay!+1) \(todoHour!):\(todoMin!)"
                if let categoryIndex = data[eventIndex].category {
                    let signR = categoryData[categoryIndex].signR
                    let signG = categoryData[categoryIndex].signG
                    let signB = categoryData[categoryIndex].signB
                    let color = UIColor(red: signR/255,
                                        green: signG/255,
                                        blue: signB/255,
                                        alpha: 1.0)
                    cell.colorView.backgroundColor = color
                }
            }
        } else {
            cell.titleLabel.text = "\(data[currentMonthEvents[indexPath.row]].name)"
            if let categoryIndex = data[currentMonthEvents[indexPath.row]].category {
                let signR = categoryData[categoryIndex].signR
                let signG = categoryData[categoryIndex].signG
                let signB = categoryData[categoryIndex].signB
                let color = UIColor(red: signR/255,
                                    green: signG/255,
                                    blue: signB/255,
                                    alpha: 1.0)
                cell.colorView.backgroundColor = color
            }
        }
        
        
        
        return cell
    }
}

extension CalendarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        //        print("CalendarVC UITabBarControllerDelegate", #function)
        let tag = viewController.tabBarItem.tag
        if tag == 0 {
            dayCollectionView.reloadData()
        }
    }
    
}

// 暫時廢棄
extension CalendarViewController: TabBarControllerDelegate {
    func tapTabBarItem(previousVC: String, tag: Int) {
        //        print(#function)
        //        print("CalendarVC:",previousVC, tag)
        if tag == 0 {
            // 可能要重新讀取資料
            dayCollectionView.reloadData()
        }
    }
}

extension CalendarViewController: EventsViewControllerDelegate {
    func updateCalendarTableView(data: [ToDoEvent]) {
        //        print("CalendarVC EventsViewControllerDelegate", #function)
        self.data = data
        table = tableBackup
        updateCalendarTable()
        dayCollectionView.reloadData()
        tableView.reloadData()
    }
}
