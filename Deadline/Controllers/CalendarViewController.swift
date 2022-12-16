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
    @IBAction func animateFrame(_ sender: UIButton) {
        let diceRoll = CGFloat(Int(arc4random_uniform(7))*30)
        let circleEdge = CGFloat(200)
        
        // 直接指定 frame 布局
        let statusView = CalendarDayCollectionViewCellDrawView(frame: CGRect(x: 50, y: diceRoll, width: circleEdge, height: circleEdge))
        
        view.addSubview(statusView)
        
        // 开始动画
        statusView.animateCircle(duration: 1.0)
    }
    
    var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    let days = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30 ,31]
    // 事項資料
    var data = [ToDoEvent]()
    // 事項分類
    var categoryData = [ToDoCategory]()
    // 行事曆表格，每一格15分鐘
    var table = [[[[CalendarPartition]]]]()
    
    let lineWidth: CGFloat = 2
    
    let currentYear = Calendar.current.component(.year, from: Date())
    let currentMonth = Calendar.current.component(.month, from: Date())
    let currentDay = Calendar.current.component(.day, from: Date())
    let currentWeekday = Calendar.current.component(.weekday, from: Date())
    
    var positionYear = 2022
    var positionMonth = 11
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
        updateCalendarTable()
//        print(table[22][11][5])
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
        dayCollectionView.reloadData()
    }
    
    func getData() {
        
        if let data = UserDefaults.standard.data(forKey: "data") {
            do {
                let data = try JSONDecoder().decode([ToDoEvent].self, from: data)
                self.data = data
//                print("get data")
            } catch {
                print("Decoding error:", error)
            }
        }
        if let categoryData = UserDefaults.standard.data(forKey: "category") {
            do {
                let categoryData = try JSONDecoder().decode([ToDoCategory].self, from: categoryData)
                self.categoryData = categoryData
//                print("get category data")
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
                            for i in 0..<needTime {
                                if hour*4+min/15+i==96 {
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
                                table[year][month][day][hour*4+min/15+i].eventIndex = i
                                table[year][month][day][hour*4+min/15+i].detailSection = j
                                table[year][month][day][hour*4+min/15+i].detailRow = k
                            }
                        }
                    }
                }
            }
        }
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
            cell.backgroundColor = .systemMint
            cell.textLabel.text = week[indexPath.row]
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "daycell", for: indexPath) as! CalendarDayCollectionViewCell
            cell.backgroundColor = .systemBackground
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
                    
                    
                    // 統整各分類的數量
                    let year = positionYear - 2001
                    let month = positionMonth - 1
                    let day = positionDay - 1
                    
                    var preIndexCount: [Int] = []
                    var indexCount: [CGFloat] = []
                    var signR: [CGFloat] = []
                    var signG: [CGFloat] = []
                    var signB: [CGFloat] = []
                    
                    for _ in 0..<categoryData.count {
                        let num = Int()
                        preIndexCount.append(num)
                    }
                    
                    for i in 0..<table[year][month][day].count {
                        if let index = table[year][month][day][i].eventIndex {
                            preIndexCount[index] = preIndexCount[index] + 1
                        }
                    }
                    
                    for i in 0..<preIndexCount.count {
                        if preIndexCount[i] != 0 {
                            indexCount.append(CGFloat(preIndexCount[i]))
                            signR.append(categoryData[i].signR)
                            signG.append(categoryData[i].signG)
                            signB.append(categoryData[i].signB)
                        }
                    }
                    
//                    print("indexCount:",indexCount)
//                    print("signR",signR)
                    
                    cell.drawView.proportion = indexCount
                    cell.drawView.signR = signR
                    cell.drawView.signG = signG
                    cell.drawView.signB = signB
                    
                }
            } else {
                cell.textLabel.text = ""
            }
            
            return cell
        default:
            break
        }
        return UICollectionViewCell()
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
        data.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension CalendarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todocell", for: indexPath) as! CalendarEventTableViewCell
        cell.titleLabel.text = "\(data[indexPath.row].name)"
        if let categoryIndex = data[indexPath.row].category {
//            print(categoryIndex)
            let signR = categoryData[categoryIndex].signR
            let signG = categoryData[categoryIndex].signG
            let signB = categoryData[categoryIndex].signB
            let color = UIColor(red: signR/255,
                                green: signG/255,
                                blue: signB/255,
                                alpha: 1.0)
            cell.colorView.backgroundColor = color
        }
        return cell
    }
}
