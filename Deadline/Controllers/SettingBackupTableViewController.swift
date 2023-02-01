//
//  SettingBackupTableViewController.swift
//  Deadline
//
//  Created by Wang Uiroz on 2023/1/10.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol SettingBackupTableViewControllerDelegate {
    func SettingBackupTableViewControllerUpdateData(data: [ToDoEvent], categoryData: [ToDoCategory])
}

class SettingBackupTableViewController: UITableViewController {
    
    var delegate: SettingBackupTableViewControllerDelegate?
    
    var data = [ToDoEvent]()
    var fbData = [FirebaseToDoEvent]()
    var categoryData = [ToDoCategory]()
    var fbCategoryData = [FirebaseToDoCategory]()
    var idRecord = Identity(id: [])
    //    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 1
        default:
            print("Error: SettingBackupTableViewController: numberOfRowsInSection")
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingtableviewcell", for: indexPath) as! SettingTableViewCell
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.iconImageView.image = UIImage(systemName: "")
                cell.optionTextLabel.text = "Reset local data"
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell.iconImageView.image = UIImage(systemName: "")
                cell.optionTextLabel.text = "Backup to Firebase"
            case 1:
                cell.iconImageView.image = UIImage(systemName: "")
                cell.optionTextLabel.text = "Restore from Firebase"
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0:
                cell.iconImageView.image = UIImage(systemName: "")
                cell.optionTextLabel.text = "Delete Firebase backup"
            default:
                break
            }
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Reset Data"
        case 1:
            return "Firebase: Backup & Restore"
        case 2:
            return "Delete Data"
        default:
            return "Nothing"
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                resetDataAndSaveToCoreData()
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                backupDataToFirebaseA()
            case 1:
                restoreDataFromFirebaseA()
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0:
                deleteFirebaseBackupA()
            default:
                break
            }
        default:
            break
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - Backup & Restore & Delete
    func resetDataAndSaveToCoreData() {
        print("start", #function)
        data = [ToDoEvent(category: 0,
                          name: "Event",
                          detail:
                            [ToDoDetail(detailName: "Detail1", needHour: 3, needMin: 15, toDoYear: 23, toDoMonth: 1, toDoDay: 2, toDoHour: 1, toDoMinute: 30),
                             ToDoDetail(detailName: "Detail2", needHour: 2, needMin: 30, toDoYear: 23, toDoMonth: 1, toDoDay: 5, toDoHour: 20, toDoMinute: 30)],
                          deadline: Date()),
                ToDoEvent(category: 1,
                          name: "整理房間",
                          detail:
                            [ToDoDetail(detailName: "掃地", needHour: 3, needMin: 15, toDoYear: 23, toDoMonth: 1, toDoDay: 7, toDoHour: 1, toDoMinute: 30),
                             ToDoDetail(detailName: "拖地", needHour: 2, needMin: 30, toDoYear: 23, toDoMonth: 1, toDoDay: 9, toDoHour: 20, toDoMinute: 30)],
                          deadline: Date())]
        categoryData = [ToDoCategory(categoryName: "Work", index: 0, signR: 255.0, signG: 0.0, signB: 0.0),
                        ToDoCategory(categoryName: "Travel", index: 1, signR: 0.0, signG: 100.0, signB: 0.0),
                        ToDoCategory(categoryName: "Housework", index: 2, signR: 255.0, signG: 255.0, signB: 0.0)]
        delegate?.SettingBackupTableViewControllerUpdateData(data: data, categoryData: categoryData)
        print("end  ", #function)
    }
    
    func backupDataToFirebaseA() {
        print("start", #function)
        // 用來確認兩個逃逸閉包皆已完成，才呼叫下一個階段
        var eventsFirst = false
        var categoryFirst = false
        
        // 取得Firebase資料，把資料讀進FBData
        let db = Firestore.firestore()
        
        db.collection("events").getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            
            let events = snapshot.documents.compactMap { snapshot in
                try? snapshot.data(as: FirebaseToDoEvent.self)
            }
            self.fbData = events
            eventsFirst = true
            if categoryFirst {
                print("categoryFirst")
                self.backupDataToFirebaseB()
            }
        }
        
        db.collection("categorys").getDocuments { snapshot, error in
            
            guard let snapshot = snapshot else { return }
            
            let categorys = snapshot.documents.compactMap { snapshot in
                try? snapshot.data(as: FirebaseToDoCategory.self)
            }
            self.fbCategoryData = categorys
            categoryFirst = true
            if eventsFirst {
                print("eventsFirst")
                self.backupDataToFirebaseB()
            }
        }
        // 順便先讀取本地資料
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
    
    func backupDataToFirebaseB() {
        print("start", #function)
        // 檢查本地以及Firebase的資料現況，如果Firebase有資料，詢問是否覆蓋
        if !fbData.isEmpty {
            let alertController = UIAlertController(title: "Firebase have \(fbData.count) data.", message: "The date of the data is XXXX/XX/XX XX:XX.\nDo you want to replace Firebase data?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Yes", style: .default) { [self] _ in
                // 透過id刪除Firebase現有資料
                let db = Firestore.firestore()
                for i in 0..<fbData.count {
                    if let id = fbData[i].id {
                        //                print(id)
                        let documentReference = db.collection("events").document(id)
                        documentReference.delete()
                    }
                }
                for i in 0..<fbCategoryData.count {
                    if let id = fbCategoryData[i].id {
                        //                print(id)
                        let documentReference = db.collection("categorys").document(id)
                        documentReference.delete()
                    }
                }
                backupDataToFirebaseC()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
        } else {
            backupDataToFirebaseC()
        }
        
    }
    
    func backupDataToFirebaseC() {
        print("start", #function)
        // 寫入Firebase
        let db = Firestore.firestore()
        for i in 0..<data.count {
            do {
                let _ = try db.collection("events").addDocument(from: data[i])
            } catch {
                print(error)
            }
        }
        for i in 0..<categoryData.count {
            do {
                let _ = try db.collection("categorys").addDocument(from: categoryData[i])
            } catch {
                print(error)
            }
        }
    }
    
    // 取得Firebase裡面的內容，轉換為一般型別，寫入CoreData
    func restoreDataFromFirebaseA() {
        
        var eventsFirst = false
        var categoryFirst = false
        
        print("start", #function)
        // 讀取Firebase資料
        let db = Firestore.firestore()
        
        db.collection("events").getDocuments { snapshot, error in
            
            guard let snapshot = snapshot else { return }
            
            let events = snapshot.documents.compactMap { snapshot in
                try? snapshot.data(as: FirebaseToDoEvent.self)
            }
            self.fbData = events
            eventsFirst = true
            if categoryFirst {
                self.restoreDataFromFirebaseB()
            }
        }
        
        db.collection("categorys").getDocuments { snapshot, error in
            
            guard let snapshot = snapshot else { return }
            
            let categorys = snapshot.documents.compactMap { snapshot in
                try? snapshot.data(as: FirebaseToDoCategory.self)
            }
            self.fbCategoryData = categorys
            categoryFirst = true
            if eventsFirst {
                self.restoreDataFromFirebaseB()
            }
        }
        // 讀取本地資料
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
    
    func restoreDataFromFirebaseB() {
        // 檢查本地以及Firebase資料現況
        if !fbData.isEmpty && !data.isEmpty {
            let alertController = UIAlertController(title: "Firebase have \(fbData.count) data.\nLocal have \(data.count) data.", message: "The date of the Firebase data is XXXX/XX/XX XX:XX.\nDo you want to replace local data?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Yes", style: .default) { [self] _ in
                fbDataToGeneralData()
                writeToCoreData()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        } else if !fbData.isEmpty && data.isEmpty {
            fbDataToGeneralData()
            writeToCoreData()
        } else if fbData.isEmpty {
            let alertController = UIAlertController(title: "Firebase have no data.", message: "Please perform the backup.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        }
        delegate?.SettingBackupTableViewControllerUpdateData(data: data, categoryData: categoryData)
        print("end  ", #function)
        
    }
    
    
    // 取得Firebase裡面的內容，再根據id全部刪除
    func deleteFirebaseBackupA(){
        
        var eventsFirst = false
        var categoryFirst = false
        
        print("start", #function)
        // 讀取Firebase資料
        let db = Firestore.firestore()
        
        db.collection("events").getDocuments { snapshot, error in
            
            guard let snapshot = snapshot else { return }
            
            let events = snapshot.documents.compactMap { snapshot in
                try? snapshot.data(as: FirebaseToDoEvent.self)
            }
            self.fbData = events
            eventsFirst = true
            if categoryFirst {
                self.deleteFirebaseBackupB()
            }
        }
        
        db.collection("categorys").getDocuments { snapshot, error in
            
            guard let snapshot = snapshot else { return }
            
            let categorys = snapshot.documents.compactMap { snapshot in
                try? snapshot.data(as: FirebaseToDoCategory.self)
            }
            self.fbCategoryData = categorys
            categoryFirst = true
            if eventsFirst {
                self.deleteFirebaseBackupB()
            }
        }
        print("end  ", #function)
    }
    
    func deleteFirebaseBackupB() {
        
        // 刪除Firebase資料
        let db = Firestore.firestore()
        for i in 0..<fbData.count {
            if let id = fbData[i].id {
                //                print(id)
                let documentReference = db.collection("events").document(id)
                documentReference.delete()
            }
        }
        for i in 0..<fbCategoryData.count {
            if let id = fbCategoryData[i].id {
                //                print(id)
                let documentReference = db.collection("categorys").document(id)
                documentReference.delete()
            }
        }
    }
    
    // MARK: - Many Functions
    
    func writeToCoreData() {
        print("start", #function)
        do {
            let data = try JSONEncoder().encode(data)
            UserDefaults.standard.set(data, forKey: "data")
        } catch {
            print("Encoding error", error)
        }
        do {
            let data = try JSONEncoder().encode(categoryData)
            UserDefaults.standard.set(data, forKey: "category")
        } catch {
            print("Encoding error", error)
        }
        print("end  ", #function)
        
        // call eventsVC update
        
    }
    
    func readFromCoreData() {
        print("start", #function)
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
        print("end  ", #function)
    }
    
    func fbDataToGeneralData() {
        print("start", #function)
        self.data = []
        for i in 0..<self.fbData.count {
            let name = self.fbData[i].name
            let category = self.fbData[i].category
            let detail = self.fbData[i].detail
            let deadline = self.fbData[i].deadline
            self.data.append(ToDoEvent(category: category, name: name, detail: detail, deadline: deadline))
        }
        self.categoryData = []
        for i in 0..<self.fbData.count {
            let index = self.fbCategoryData[i].index
            let categoryName = self.fbCategoryData[i].categoryName
            let signR = self.fbCategoryData[i].signR
            let signG = self.fbCategoryData[i].signG
            let signB = self.fbCategoryData[i].signB
            self.categoryData.append(ToDoCategory(categoryName: categoryName, index: index, signR: signR, signG: signG, signB: signB))
        }
        print("end  ", #function)
    }
    
}
