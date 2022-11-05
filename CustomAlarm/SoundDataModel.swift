//
//  SoundDataModel.swift
//  CustomAlarm
//
//  Created by パソコンさん on 2022/11/03.
//

import Foundation
import SwiftUI
import CoreData

class SoundDataModel : ObservableObject{
    @Published var createdTime_S = Date()
    @Published var soundURL_S = ""
    @Published var soundName_S = ""
    @Published var soundTime_S: Int = 0
    @Published var soundTimeOnOff_S = false
    @Published var soundRepeatTime_S: Int = 0
    @Published var uuid_S = UUID().uuidString

    @Published var isNewData_S = false
    @Published var updateItem_S : SoundData!
    
    func writeData(context :NSManagedObjectContext){
//データが新規か編集かで処理を分ける
        if updateItem_S != nil {
            
            updateItem_S.createdTime_S = createdTime_S
            updateItem_S.soundName_S = soundName_S
            updateItem_S.soundURL_S = soundURL_S
            updateItem_S.soundTime_S = Int16(soundTime_S)
            updateItem_S.soundTimeOnOff_S = soundTimeOnOff_S
            updateItem_S.soundRepeatTime_S = Int16(soundRepeatTime_S)
            updateItem_S.uuid_S = uuid_S
            
            
            try! context.save()
            
            updateItem_S = nil
            isNewData_S.toggle()
            
            createdTime_S = Date()
            soundURL_S = ""
            soundName_S = ""
            soundTime_S = 0
            soundTimeOnOff_S = false
            soundRepeatTime_S = 0
            uuid_S = UUID().uuidString
 
            return
        }
//データ新規作成
        let newSoundData = SoundData(context: context)
        newSoundData.createdTime_S = Date()
        newSoundData.soundURL_S = ""
        newSoundData.soundName_S = ""
        newSoundData.soundTime_S = 0
        newSoundData.soundTimeOnOff_S = false
        newSoundData.soundRepeatTime_S = 0
        newSoundData.uuid_S = UUID().uuidString
        
        do{
            try context.save()
            
            isNewData_S.toggle()
            
            createdTime_S = Date()
            soundURL_S = ""
            soundName_S = ""
            soundTime_S = 0
            soundTimeOnOff_S = false
            soundRepeatTime_S = 0
            uuid_S = UUID().uuidString
            
            
        }
        catch {
            print(error.localizedDescription)
            
        }
    }
//編集の時は既存データを利用する
    func editItem(item: SoundData){
        updateItem_S = item
        
        createdTime_S = item.wrappedCreatedTime_S
        soundURL_S = item.wrappedSoundURL_S
        soundName_S = item.wrappedSoundName_S
        soundTime_S = Int(item.soundTime_S)
        soundTimeOnOff_S = item.soundTimeOnOff_S
        soundRepeatTime_S = Int(item.soundRepeatTime_S)
        uuid_S = item.wrappedUuid_S

        isNewData_S.toggle()
    }
    
    
}

