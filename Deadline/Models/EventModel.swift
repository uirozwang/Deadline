//
//  EventModel.swift
//  Deadline
//
//  Created by Wang Uiroz on 2022/9/7.
//

import Foundation
import CoreData
import UIKit

/// section為同一事件分區，預計做成同一個section內的事項，順序不拘，但前面section做完才能往下一個做
struct ToDoEvent: Codable {
    var category: Int?
    var name: String = ""
    var detail: [[ToDoDetail]]
    var deadline: Date
}

/// need代表用時，toDo為實際排程的時間
struct ToDoDetail: Codable {
    var detailName: String = ""
    var needHour: Int?
    var needMin: Int?
    var toDoYear: Int?
    var toDoMonth: Int?
    var toDoDay: Int?
    var toDoHour: Int?
    var toDoMinute: Int?
}

/// 分類
struct ToDoCategory: Codable {
    var categoryName: String
    var index: Int?
    var signR: CGFloat = 255.0
    var signG: CGFloat = 0.0
    var signB: CGFloat = 0.0
}

/// 每15分鐘一個區間
struct CalendarPartition {
    var eventIndex: Int?
    var detailSection: Int?
    var detailRow: Int?
}
