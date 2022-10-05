//
//  ScheduleDateCollectionViewCell.swift
//  Deadline
//
//  Created by Wang Uiroz on 2022/10/3.
//

import UIKit

protocol ScheduleDateCollectionViewCellDelegate {
    func tappedScheduleDateCollectionViewCell(indexPath: IndexPath)
}

class ScheduleDateCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    var textArray: [String]?
    
    var delegate: ScheduleDateCollectionViewCellDelegate?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduledatetableviewcell", for: indexPath) as! ScheduleDateTableViewCell
        if let textArray = textArray {
            print(textArray.count)
            print(indexPath)
            cell.dateLabel.text = textArray[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.tappedScheduleDateCollectionViewCell(indexPath: indexPath)
    }
    
}
