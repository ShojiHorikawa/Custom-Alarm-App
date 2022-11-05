//
//  SoundData+CoreDataProperties.swift
//  CustomAlarm
//
//  Created by パソコンさん on 2022/11/03.
// 参考にしたサイト
// https://zenn.dev/tomsan96/articles/e76a1088bcf78d

import Foundation
import CoreData


extension SoundData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SoundData> {
        return NSFetchRequest<SoundData>(entityName: "SoundData")
    }

    @NSManaged public var createdTime_S: Date?
    @NSManaged public var soundName_S: String?
    @NSManaged public var soundRepeatTime_S: Int16
    @NSManaged public var soundTime_S: Int16
    @NSManaged public var soundTimeOnOff_S: Bool
    @NSManaged public var soundURL_S: String?
    @NSManaged public var uuid_S: String?

}

//毎回nilの場合の処理を考えるのが面倒なのでまとめて設定
extension SoundData {
    public var wrappedCreatedTime_S: Date {createdTime_S ?? Date()}
    
    public var wrappedSoundURL_S: String {soundURL_S ?? ""}
    public var wrappedSoundName_S: String {soundName_S ?? ""}
    public var wrappedUuid_S: String {uuid_S ?? UUID().uuidString}
}

extension SoundData : Identifiable {

}
