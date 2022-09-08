//
//  EventModel.swift
//  Deadline
//
//  Created by Wang Uiroz on 2022/9/7.
//

import Foundation

struct ToDoDetail {
    var detailName: String = "NoDetailTitle"
    var needTime: Int?
    var toDoYear: Int?
    var toDoMonth: Int?
    var toDoDay: Int?
    var toDoHour: Int?
    var toDoMinute: Int?
}

struct ToDoEvent {
    var name: String = "NoTitle"
    var detail: [ToDoDetail]?
}
