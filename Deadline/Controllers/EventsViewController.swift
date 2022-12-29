//
//  EventsViewController.swift
//  Deadline
//
//  Created by Wang Uiroz on 2022/9/22.
//

import UIKit

protocol EventsViewControllerDelegate {
    func updateCalendarTableView(data: [ToDoEvent])
}

class EventsViewController: UIViewController {
    
    var delegate: EventsViewControllerDelegate?
    
    @IBOutlet var tableView: UITableView!
    
    @IBAction func close(segue: UIStoryboardSegue) {
        dismiss(animated: true)
    }
    
    var data = [ToDoEvent]()
    var categoryData = [ToDoCategory]()
    var indexPath = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        checkCategoryData()
        
        if let tabBarController = tabBarController as? TabBarController {
            tabBarController.delegate = self
            // 暫時廢棄
            tabBarController.tabBarDelegate = self
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editevent" {
            if let editVC = segue.destination as? NewEventViewController {
                if let cell = sender as? EventsTableViewCell {
                    if let indexPath = tableView.indexPath(for: cell) {
                        editVC.data = data[indexPath.row]
                        editVC.categoryData = self.categoryData
                        editVC.state = "edit"
                        editVC.delegate = self
                    }
                }
            }
        }
        if segue.identifier == "newevent" {
            if let newVC = segue.destination as? NewEventViewController {
                newVC.state = "new"
                newVC.categoryData = self.categoryData
                newVC.delegate = self
            }
        }
        if segue.identifier == "scheduleevent" {
            if let scheduleVC = segue.destination as? ScheduleViewController {
                // 應該是Button
                if let sender = sender as? UIButton {
                    let index = sender.tag - 1000
                    scheduleVC.data = data
                    scheduleVC.index = index
                    scheduleVC.delegate = self
                }
            }
        }
    }
    
    private func checkCategoryData() {
        if categoryData.isEmpty {
            categoryData = [ToDoCategory(categoryName: "Work", index: 0, signR: 255.0, signG: 0.0, signB: 0.0),
                            ToDoCategory(categoryName: "Travel", index: 1, signR: 0.0, signG: 100.0, signB: 0.0),
                            ToDoCategory(categoryName: "Housework", index: 2, signR: 255.0, signG: 255.0, signB: 0.0)]
        }
    }
    
    private func getData() {
        
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
    
    private func saveData() {
        do {
//            print(data.count)
            let data = try JSONEncoder().encode(data)
            UserDefaults.standard.set(data, forKey: "data")
        } catch {
            print("Encoding error", error)
        }
        do {
//            print(categoryData.count)
            let data = try JSONEncoder().encode(categoryData)
            UserDefaults.standard.set(data, forKey: "category")
        } catch {
            print("Encoding error", error)
        }
    }
    
}

extension EventsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.indexPath = indexPath
    }
    
}

extension EventsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventcell", for: indexPath) as! EventsTableViewCell
        
        
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
        cell.nameLabel.text = data[indexPath.row].name
        let date = data[indexPath.row].deadline
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/dd"
        cell.dateLabel.text = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "HH:mm"
        cell.timeLabel.text = dateFormatter.string(from: date)
        cell.scheduleButton.tag = indexPath.row + 1000
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, sourceView, completionHandler in
            self.data.remove(at: indexPath.row)
            self.saveData()
            tableView.reloadData()
            completionHandler(true)
        }
        
        let swipeActionConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeActionConfiguration
    }
    
}

extension EventsViewController: NewEventViewControllerDelegate {
    func newEventVCTappedSaveButton(state: String, data: ToDoEvent, categoryData: [ToDoCategory]) {
        print(#function)
        if state == "edit" {
            self.data[indexPath.row] = data
//            print("Events NEVCD: ", data)
            tableView.reloadData()
        }
        if state == "new" {
            self.data.append(data)
            tableView.reloadData()
        }
        self.categoryData = categoryData
        tableView.reloadData()
        saveData()
    }
}

extension EventsViewController: ScheduleViewControllerDelegate {
    func scheduleVCTappedSaveButton(data: [ToDoEvent]) {
        print(#function)
        self.data = data
        tableView.reloadData()
        saveData()
    }
}
// 暫時廢棄
extension EventsViewController: TabBarControllerDelegate {
    func tapTabBarItem(previousVC: String, tag: Int) {
    }
}

extension EventsViewController: UITabBarControllerDelegate {
    
    // 點到Events時，VC不管什麼時候都是NavigationController
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        print("EventsVC UITabBarControllerDelegate:", #function)
        
        // 上一動是誰
        var previousVC = ""
        if let objVC = UIApplication.topViewController(),
           let objVCTitle = objVC.title {
//            print("objVCTitle:", objVCTitle)
            previousVC = objVCTitle
        }
        // 這一動點了哪個tab
        let tag = viewController.tabBarItem.tag
//        print("which tag tapped:", tag)
        
        // 防止資料修改到一半時被取消，也許是不必要的事，先做起來放著
        if (previousVC == "NewEvent" || previousVC == "Schedule") && tag == 1 {
            return false
        }
        // 來考慮一下什麼條件下呼叫這個function
        if previousVC == "Events" && tag == 0 {
            delegate?.updateCalendarTableView(data: data)
        }
        
        return true
    }
    
}
