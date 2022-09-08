//
//  ViewController.swift
//  Deadline
//
//  Created by Wang Uiroz on 2022/9/4.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var weekCollectionView: UICollectionView!
    @IBOutlet var dayCollectionView: UICollectionView!
    @IBOutlet var toDoTableView: UITableView!
    
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var dateLeftButton: UIButton!
    @IBOutlet var dateRightButton: UIButton!
    
    @IBAction func tappedDateLeftButton(sender: UIButton) {
        monthAndYear(positive: false)
    }
    @IBAction func tappedDateRightButton(sender: UIButton) {
        monthAndYear(positive: true)
    }
    
    var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    let days = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30 ,31]
    
    /*
    var mockData = [ToDoEvent(name: "做APP", detail: [(name: "草稿", needTime: 2), (name: "Storyboard", needTime: 2), (name: "gua", needTime: 5)]),
                    ToDoEvent(name: "做APP", detail: [(name: "草稿", needTime: 2), (name: "Storyboard", needTime: 2), (name: "gua", needTime: 5)])]
     */
    var mockData = [ToDoEvent]()
    
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
        toDoTableView.delegate = self
        toDoTableView.dataSource = self
        NeedmockData()
        
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
    
    func NeedmockData() {
        for i in 0..<10 {
            let data = ToDoEvent(name: "Test \(i)", detail: [ToDoDetail(detailName: "Test Detail Title \(i)", needTime: 1, toDoYear: 2022, toDoMonth: i+1, toDoDay: i+5, toDoHour: i+10, toDoMinute: i+1)])
            mockData.append(data)
        }
    }

}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0:
            return 7
        default:
            return 42
        }
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
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
            cell.backgroundColor = .systemCyan
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

extension ViewController: UICollectionViewDelegateFlowLayout {
    
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
//            print(cellWidth,cellHeight)
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

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mockData.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todocell", for: indexPath) as! ToDoTableViewCell
        cell.titleLabel.text = "\(mockData[indexPath.row].name)"
        return cell
    }
}
