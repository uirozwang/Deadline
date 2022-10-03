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
    
    var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    let days = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30 ,31]
    var data = [ToDoEvent]()
    var categoryData = [ToDoCategory]()
    
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
        readData()
        
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
    
    func readData() {
        
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
