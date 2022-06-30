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
    @State var index = ""

    var body: some Scene {
        WindowGroup {
            ContentView(index: $index)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
