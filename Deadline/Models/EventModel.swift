//
//  EventModel.swift
//  Deadline
//
//  Created by Wang Uiroz on 2022/9/7.
//

import Foundation
import CoreData

/// section為同一事件分區，預計做成同一個section內的事項，順序不拘，但前面section做完才能往下一個做
struct ToDoEvent: Codable {
    var name: String = ""
    var section: [ToDoSection]
    var deadline: Date
}
/// section為分區序號
struct ToDoSection: Codable {
    var section: Int?
    var detail: [ToDoDetail]?
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

