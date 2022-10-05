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
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    
    @IBAction func tappedButton(_ sender: Any) {
        print(#function)
        collectionView.scrollToItem(at: IndexPath(item: 2, section: 0), at: .left, animated: true)
    }
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    let days = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30 ,31]
    
    var position = Position(year: 2019, month: 9, day: 20)

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
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

extension ScheduleViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width / 2
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
    
}

extension ScheduleViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
    
}

extension ScheduleViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "scheduledatecell", for: indexPath) as! ScheduleDateCollectionViewCell
        switch indexPath.row {
        case 0:
            var array: [String] = []
            for i in 0..<101 {
                array.append("\(2000+i)")
            }
            cell.textArray = array
        case 1:
            cell.textArray = months
        case 2:
            var array: [String] = []
            for i in 0..<days[position.month-1] {
                array.append("\(i+1)")
            }
            cell.textArray = array
        case 3:
            var array: [String] = []
            for i in 0..<24 {
                array.append("\(i)")
            }
            cell.textArray = array
        default:
            print("ScheduleCollectionView IndexPath OutOfIndex.")
        }
        cell.delegate = self
        // 可能是多tableView的問題，需要在這刷新才能正常讀取資料
        // 不過如果indexPath未超過範圍，有可能會導致tableView停在之前另一個tableView停的位置
        cell.tableView.reloadData()
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
}

extension ScheduleViewController: UITableViewDelegate {
    
}

extension ScheduleViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduledetailcell", for: indexPath) as! ScheduleEventDetailTableViewCell
        cell.detailNameLabel.text = "Detail\(indexPath)"
        
        return cell
    }
        
}

extension ScheduleViewController: ScheduleDateCollectionViewCellDelegate {
    func tappedScheduleDateCollectionViewCell(indexPath: IndexPath) {
        
    }
}
