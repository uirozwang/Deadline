//
//  CalenderDayCollectionViewCell.swift
//  Deadline
//
//  Created by Wang Uiroz on 2022/9/4.
//

import UIKit

class CalendarDayCollectionViewCell: UICollectionViewCell {
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var drawView: CalendarDayCollectionViewCellDrawView!
    override func prepareForReuse() {
        
    }
}
