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

    var body: some Scene {
        WindowGroup {
            ContentView(index: $index)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { phase in
            if phase == .background {
                print("バックグラウンド！")
            }
            if phase == .active {
                print("フォアグラウンド！")
            }
            if phase == .inactive {
                print("バックグラウンドorフォアグラウンド直前")
            }
        }
    }
}

