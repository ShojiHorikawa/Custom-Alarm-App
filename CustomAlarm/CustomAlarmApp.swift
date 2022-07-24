//
//  CustomAlarmApp.swift
//  CustomAlarm
//
//  Created by パソコンさん on 2022/06/27.
//

import SwiftUI

@main
struct CustomAlarmApp: App {
    let persistenceController = PersistenceController.shared
    @Environment(\.scenePhase) private var scenePhase
    @State var index = ""
    
    @FetchRequest(
        //データの取得方法を指定　下記は日付降順
        entity:AlarmData.entity(),sortDescriptors: [NSSortDescriptor(keyPath: \AlarmData.alarmTime, ascending: true)],
        animation: .default)
    private var items: FetchedResults<AlarmData>

    // 通知設定用変数
    @EnvironmentObject var notificationModel:NotificationModel
    var body: some Scene {
        WindowGroup {
            ContentView(index: $index)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { phase in
            if phase == .background {
//                print("バックグラウンド！")
            }
            if phase == .active {
//                print("フォアグラウンド！")
                
                for item in items{
                    if(item.onOff){
                        // アラームの設定をOFFにする
                        if(item.wrappedAlarmTime.timeIntervalSinceNow < 0 && item.dayOfWeekRepeat == []){
                            item.onOff = false
                        }
                    }
                    // ↓の処理を入れるためにわざとifを分断
                    // アラームの設定 年月日を更新
                    item.alarmTime = updateTime(didAlarmTime: item.wrappedAlarmTime)
                    
                    if(item.onOff){
                        // 曜日繰り返しがある場合、通知を更新or予約する
                        if(item.dayOfWeekRepeat != []){
                            // 通知予約・更新
                            self.notificationModel.setNotification(time: item.wrappedAlarmTime, dayWeek: item.dayOfWeekRepeat, uuid: item.wrappedUuid, label: item.wrappedLabel)
                        }
                    }
                }
                // itemsのデータ更新はContentView()のonChangeで行う(viewContexがここでは使えないため)
            }
            if phase == .inactive {
//                print("バックグラウンドorフォアグラウンド直前")
            }
        }
    }
}

