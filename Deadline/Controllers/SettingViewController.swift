//
//  SettingViewController.swift
//  Deadline
//
//  Created by Wang Uiroz on 2022/9/27.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class SettingViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var data = [ToDoEvent]()
    var FBData = [FirebaseToDoEvent]()
    var categoryData = [ToDoCategory]()
    var idDic: [String: String] = [:]
    var idRecord = Identity(id: [])
    
    @IBAction func didResetDefaultButton() {
        let data = [ToDoEvent(category: 0,
                              name: "Event",
                              detail:
                                [ToDoDetail(detailName: "Detail1", needHour: 3, needMin: 15, toDoYear: 23, toDoMonth: 0, toDoDay: 2, toDoHour: 1, toDoMinute: 30),
                                 ToDoDetail(detailName: "Detail2", needHour: 2, needMin: 30, toDoYear: 23, toDoMonth: 0, toDoDay: 5, toDoHour: 20, toDoMinute: 30)],
                              deadline: Date()),
                    ToDoEvent(category: 1,
                                          name: "整理房間",
                                          detail:
                                            [ToDoDetail(detailName: "掃地", needHour: 3, needMin: 15, toDoYear: 23, toDoMonth: 0, toDoDay: 7, toDoHour: 1, toDoMinute: 30),
                                             ToDoDetail(detailName: "拖地", needHour: 2, needMin: 30, toDoYear: 23, toDoMonth: 0, toDoDay: 9, toDoHour: 20, toDoMinute: 30)],
                                          deadline: Date())]
        let category = [ToDoCategory(categoryName: "Work", index: 0, signR: 255.0, signG: 0.0, signB: 0.0),
                        ToDoCategory(categoryName: "Travel", index: 1, signR: 0.0, signG: 100.0, signB: 0.0),
                        ToDoCategory(categoryName: "Housework", index: 2, signR: 255.0, signG: 255.0, signB: 0.0)]
        do {
            print(data.count)
            let data = try JSONEncoder().encode(data)
            UserDefaults.standard.set(data, forKey: "data")
            print("reset data")
        } catch {
            print("Encoding error", error)
        }
        do {
            print(category.count)
            let data = try JSONEncoder().encode(category)
            UserDefaults.standard.set(data, forKey: "category")
            print("reset category data")
        } catch {
            print("Encoding error", error)
        }
    }
    
    @IBAction func tappedTestButton() {
        getData()
        let db = Firestore.firestore()
        
        for i in 0..<data.count {
            do {
                let documentReference = try db.collection("events").addDocument(from: data[i])
                //                idDic[documentReference.documentID] = data[i].name
                idRecord.id.append(documentReference.documentID)
            } catch {
                print(error)
            }
        }
        print(idRecord)
    }
    
    @IBAction func tappedDeleteEventButton() {
        let db = Firestore.firestore()
        
        for FBDatum in FBData {
            if let id = FBDatum.id {
                let documentReference = db.collection("events").document(id)
                documentReference.delete()
            }
        }
        
        let documentReference = db.collection("events").document("identity")
        documentReference.delete()
        
    }
    
    @IBAction func getEvents() {
        let db = Firestore.firestore()
        
        db.collection("events").getDocuments { snapshot, error in
            
            guard let snapshot = snapshot else { return }
            
            let events = snapshot.documents.compactMap { snapshot in
                try? snapshot.data(as: FirebaseToDoEvent.self)
            }
            self.FBData = events
            
        }
    }
    
    @IBAction func tappedUploadIDButton() {
        let db = Firestore.firestore()
        do {
            try db.collection("events").document("identity").setData(from: idRecord)
        } catch {
            print("Error:", error)
        }
    }
    
    @IBAction func tappedDeleteIDButton() {
        let db = Firestore.firestore()
        let documentReference = db.collection("events").document("identity")
        documentReference.delete()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "settingbackup" {
            return true
        } else {
            return false
        }
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
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
         if segue.identifier == "settingbackup" {
             if let backupVC = segue.destination as? SettingBackupTableViewController {
                 if let navigationController = tabBarController?.viewControllers?[1] as? UINavigationController,
                    let eventVC = navigationController.viewControllers[0] as? EventsViewController {
                     backupVC.delegate = eventVC
                 }
             }
         }
         
         
     }
     
    
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                self.performSegue(withIdentifier: "settinggeneral", sender: self)
                break
            case 1:
                // backup & restore
                self.performSegue(withIdentifier: "settingbackup", sender: self)
                break
            default:
                break
            }
        default:
            break
        }
    }
}

extension SettingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingtableviewcell", for: indexPath) as! SettingTableViewCell
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.iconImageView.image = UIImage(systemName: "gearshape")
                cell.optionTextLabel.text = "General"
            case 1:
                cell.iconImageView.image = UIImage(systemName: "icloud.and.arrow.up.fill")
                cell.optionTextLabel.text = "Backup & Restore"
            default: break
            }
        default:
            cell.optionTextLabel.text = "something error"
            print("Error: SettingVCTableViewCellForRowAt")
        }
        return cell
    }
    
}
