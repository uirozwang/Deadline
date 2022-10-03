//
//  SettingViewController.swift
//  Deadline
//
//  Created by Wang Uiroz on 2022/9/27.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBAction func didResetDefaultButton() {
        let data = [ToDoEvent(category: 0, name: "Default", section: [ToDoSection(section: 0, detail: [ToDoDetail(detailName: "Detail")])], deadline: Date())]
        let category = [ToDoCategory(categoryName: "Work", index: 0, signR: 255.0, signG: 0.0, signB: 0.0),
                        ToDoCategory(categoryName: "Travel", index: 1, signR: 0.0, signG: 100.0, signB: 0.0),
                        ToDoCategory(categoryName: "Housework", index: 2, signR: 255.0, signG: 255.0, signB: 0.0)]
        do {
            print(data.count)
            let data = try JSONEncoder().encode(data)
            UserDefaults.standard.set(data, forKey: "data")
        } catch {
            print("Encoding error", error)
        }
        
        do {
            print(category.count)
            let data = try JSONEncoder().encode(category)
            UserDefaults.standard.set(data, forKey: "category")
        } catch {
            print("Encoding error", error)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
