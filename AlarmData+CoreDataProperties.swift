//
//  AlarmData+CoreDataProperties.swift
//  CustomAlarm
//
//  Created by パソコンさん on 2022/06/27.
//
//

import Foundation
import CoreData


extension AlarmData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AlarmData> {
        return NSFetchRequest<AlarmData>(entityName: "AlarmData")
    }

    @NSManaged public var alarmTime: Date?
    @NSManaged public var onOff: Bool
    @NSManaged public var label: String?
    @NSManaged public var dayOfWeekRepeat: [String]
    @NSManaged public var snooze: Bool
    @NSManaged public var sound: String?
    @NSManaged public var tagColor: String?

}

extension AlarmData : Identifiable {

}
