//
//  EventModel.swift
//  Deadline
//
//  Created by Wang Uiroz on 2022/9/7.
//

import Foundation

struct ToDoDetail {
    var detailName: String = ""
    var needTime: Int?
    var toDoYear: Int?
    var toDoMonth: Int?
    var toDoDay: Int?
    var toDoHour: Int?
    var toDoMinute: Int?
}

struct ToDoSection {
    var section: Int?
    var detail: [ToDoDetail]?
}

struct ToDoEvent {
    var name: String = ""
    var section: [ToDoSection]
    var deadline: Date
}
