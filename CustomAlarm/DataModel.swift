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

/*
 
 newAlarmData.alarmTime = Date()
 newAlarmData.dayOfWeekRepeat = []
 newAlarmData.label = "アラーム"
 newAlarmData.onOff = true
 newAlarmData.snooze = false
 newAlarmData.sound = ""
 newAlarmData.tagColor = "red"
 newAlarmData.uuid = UUID().uuidString
 
 */
class DataModel : ObservableObject{
    @Published var alarmTime = Date()
    @Published var dayOfWeekRepeat: [String] = []
    @Published var label = "アラーム"
    @Published var onOff = true
    @Published var snooze = false
    @Published var sound = ""
    @Published var tagColor: String = "clear"
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
            updateItem.snooze = snooze
            updateItem.sound = sound
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
            sound = ""
            tagColor = "clear"
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
        newAlarmData.sound = ""
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
            sound = ""
            tagColor = "clear"
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
        sound = item.wrappedSound
        tagColor = item.wrappedTagColor
        uuid = item.wrappedUuid

        isNewData.toggle()
    }
}

