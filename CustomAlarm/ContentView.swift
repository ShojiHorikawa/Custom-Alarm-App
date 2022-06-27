//
//  ContentView.swift
//  CustomAlarm
//
//  Created by パソコンさん on 2022/06/27.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \AlarmData.alarmTime, ascending: true)],
        animation: .default)
    private var items: FetchedResults<AlarmData>

    // 新規作成用のモーダル遷移起動変数
    @State var isModalSubview = false

    var body: some View {
//        Text("Hello")
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("AlarmData at \(item.alarmTime!)")
                    } label: {
                        Text(item.alarmTime!, formatter: itemFormatter)
                    }
                }
                .onDelete(perform: deleteAlarmData)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    MyEditButton() // オリジナルEditButtonに置き換え
                }
                ToolbarItem {
                    Button(action: addAlarmData) {
                        Label("Add AlarmData", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
    }

    // データ追加
    private func addAlarmData() {
        withAnimation {
            let newAlarmData = AlarmData(context: viewContext)
            newAlarmData.alarmTime = Date()
            newAlarmData.dayOfWeekRepeat = []
            newAlarmData.label = "アラーム"
            newAlarmData.onOff = true
            newAlarmData.snooze = false
            newAlarmData.sound = ""
            newAlarmData.tagColor = "clear"

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    // データ削除
    private func deleteAlarmData(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

// オリジナルEditButton
struct MyEditButton: View {
    @Environment(\.editMode) var editMode
    
    var body: some View {
        Button(action: {
            withAnimation() {
                if editMode?.wrappedValue.isEditing == true {
                    editMode?.wrappedValue = .inactive
                } else {
                    editMode?.wrappedValue = .active
                }
            }
        }) {
            if editMode?.wrappedValue.isEditing == true {
                Text("完了")
            } else {
                Text("編集")
            }
        }
    }
}
