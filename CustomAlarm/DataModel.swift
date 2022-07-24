//
//  DataModel.swift
//  CustomAlarm
//
//  Created by パソコンさん on 2022/06/30.
//
//　CoreDataへの保存・編集の処理

import Foundation
import SwiftUI
import CoreData

class DataModel : ObservableObject{
    @Published var alarmTime = Date()
    @Published var dayOfWeekRepeat: [String] = []
    @Published var label = "アラーム"
    @Published var onOff = true
    @Published var snooze = false
    @Published var soundOnOff = false
    @Published var soundURL = ""
    @Published var soundName = ""
    @Published var soundTime: Int = 0
    @Published var soundTimeOnOff = false
    @Published var soundReturnTime: Int = 0
    @Published var tagColor: String = DataAccess.TagColor.clear.rawValue
    @Published var uuid = UUID().uuidString

    @Published var isNewData = false
    @Published var updateItem : AlarmData!
    
    func writeData(context :NSManagedObjectContext){
//データが新規か編集かで処理を分ける
        if updateItem != nil {
            
            updateItem.alarmTime = alarmTime
            updateItem.dayOfWeekRepeat = dayOfWeekRepeat
            updateItem.label = label
            updateItem.onOff = onOff
            updateItem.soundOnOff = soundOnOff
            updateItem.snooze = snooze
            updateItem.soundName = soundName
            updateItem.soundURL = soundURL
            updateItem.soundTime = Int16(soundTime)
            updateItem.soundTimeOnOff = soundTimeOnOff
            updateItem.soundReturnTime = Int16(soundReturnTime)
            updateItem.tagColor = tagColor
            updateItem.uuid = uuid
            
            
            try! context.save()
            
            updateItem = nil
            isNewData.toggle()
            
            alarmTime = Date()
            dayOfWeekRepeat = []
            label = "アラーム"
            onOff = true
            snooze = false
            soundOnOff = false
            soundURL = ""
            soundName = ""
            soundTime = 0
            soundTimeOnOff = false
            soundReturnTime = 0
            tagColor = DataAccess.TagColor.clear.rawValue
            uuid = UUID().uuidString
 
            return
        }
//データ新規作成
        let newAlarmData = AlarmData(context: context)
        newAlarmData.alarmTime = Date()
        newAlarmData.dayOfWeekRepeat = []
        newAlarmData.label = "アラーム"
        newAlarmData.onOff = true
        newAlarmData.snooze = false
        newAlarmData.soundOnOff = false
        newAlarmData.soundURL = ""
        newAlarmData.soundName = ""
        newAlarmData.soundTime = 0
        newAlarmData.soundTimeOnOff = false
        newAlarmData.soundReturnTime = 0
        newAlarmData.tagColor = "red"
        newAlarmData.uuid = UUID().uuidString
        
        do{
            try context.save()
            
            isNewData.toggle()
            
            alarmTime = Date()
            dayOfWeekRepeat = []
            label = "アラーム"
            onOff = true
            snooze = false
            soundOnOff = false
            soundURL = ""
            soundName = ""
            soundTime = 0
            soundTimeOnOff = false
            soundReturnTime = 0
            tagColor = DataAccess.TagColor.clear.rawValue
            uuid = UUID().uuidString
            
            
        }
        catch {
            print(error.localizedDescription)
            
        }
    }
//編集の時は既存データを利用する
    func editItem(item: AlarmData){
        updateItem = item
        
        alarmTime = item.wrappedAlarmTime
        dayOfWeekRepeat = item.dayOfWeekRepeat
        label = item.wrappedLabel
        onOff = item.onOff
        snooze = item.snooze
        soundOnOff = item.soundOnOff
        soundURL = item.wrappedSoundURL
        soundName = item.wrappedSoundName
        tagColor = item.wrappedTagColor
        soundTime = Int(item.soundTime)
        soundTimeOnOff = item.soundTimeOnOff
        soundReturnTime = Int(item.soundReturnTime)
        uuid = item.wrappedUuid

        isNewData.toggle()
    }
    
    
}

