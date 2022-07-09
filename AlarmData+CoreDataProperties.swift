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
    @NSManaged public var soundOnOff: Bool
    @NSManaged public var soundURL: String?
    @NSManaged public var soundName: String?
    @NSManaged public var soundTime: Int16
    @NSManaged public var soundTimeOnOff: Bool
    @NSManaged public var tagColor: String?
    @NSManaged public var uuid: String?

}

//毎回nilの場合の処理を考えるのが面倒なのでまとめて設定
extension AlarmData {
    public var wrappedAlarmTime: Date {alarmTime ?? Date()}
    public var wrappedLabel: String {label ?? "アラーム"}
    public var wrappedSoundURL: String {soundURL ?? ""}
    public var wrappedSoundName: String {soundName ?? ""}
    public var wrappedTagColor: String {tagColor ?? DataAccess.TagColor.clear.rawValue}
    public var wrappedUuid: String {uuid ?? UUID().uuidString}
}

extension AlarmData : Identifiable {

}
