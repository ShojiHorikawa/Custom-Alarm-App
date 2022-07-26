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

    // 通知済みのものを削除するための宣言
    let center = UNUserNotificationCenter.current()
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
                center.removeAllDeliveredNotifications()
            }
            if phase == .inactive {
//                print("バックグラウンドorフォアグラウンド直前")
                // 全ての通知済みの通知を削除する
                center.removeAllDeliveredNotifications()
            }
        }
    }
}

