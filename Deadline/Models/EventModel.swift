//
//  EventModel.swift
//  Deadline
//
//  Created by Wang Uiroz on 2022/9/7.
//

import Foundation
import CoreData
/*
public class ToDoEvent: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoEvent> {
        return NSFetchRequest<ToDoEvent>(entityName: "ToDoEvent")
    }
    
    @NSManaged public var name: String
    @NSManaged public var section: [ToDoSection]
    @NSManaged public var deadline: Date
    
}
*/


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

struct ToDoSection: Codable {
    var section: Int?
    var detail: [ToDoDetail]?
}

struct ToDoEvent: Codable {
    var name: String = ""
    var section: [ToDoSection]
    var deadline: Date
}

