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
    
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var dateLeftButton: UIButton!
    @IBOutlet var dateRightButton: UIButton!
    
    let lineWidth: CGFloat = 2

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateLabel.text = "2022/09/04"
        dayCollectionView.delegate = self
        dayCollectionView.dataSource = self
        weekCollectionView.delegate = self
        weekCollectionView.dataSource = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }

}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0:
            return 7
        default:
            return 49
        }
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let week = ["Sun", "Mon", "Tus", "Wed", "Thu", "Fri", "Sat"]
        switch collectionView.tag {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weekcell", for: indexPath) as! CalenderWeekCollectionViewCell
            cell.backgroundColor = .systemMint
            cell.textLabel.text = week[indexPath.row]
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "daycell", for: indexPath) as! CalenderDayCollectionViewCell
            cell.backgroundColor = .systemCyan
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
            let cellHeight = (screenWidth - 7 * lineWidth) / 6 + 1
            print(cellWidth,cellHeight)
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
