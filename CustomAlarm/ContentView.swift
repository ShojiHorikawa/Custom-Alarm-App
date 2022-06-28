//
//  ContentView.swift
//  CustomAlarm
//
//  Created by パソコンさん on 2022/06/27.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \AlarmData.alarmTime, ascending: true)],
        animation: .default)
    var items: FetchedResults<AlarmData>

    // 新規作成用のモーダル遷移起動変数
    @State var isModalSubview = false
    // 識別色タグの分類表示用変数
    @State var viewTagColor: DataAccess.TagColor = .clear

    var body: some View {
        NavigationView{
//        Text("Hello")
        VStack{
//            Text("アラーム")
//                .font(.title)
//                .fontWeight(.bold)
            
            // 【未】識別タグ(IdentifyTag)を設定したアラームラベルのみ表示へ切り替える
            HStack{
                Spacer()
                
                // 【未】選択された識別タグ以外の透明度(.opacity)を0.5にする
                ForEach(0 ..< colorArray.count - 1, id: \.self) {index in
                    Button(action: {
                        if(viewTagColor == colorArray[index]) {
                            viewTagColor = .clear
                        } else {
                            viewTagColor = colorArray[index]
                        }
                    }) {
                        if(index == 0) {
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 30, height: 30)
                                .opacity(viewTagColor == .clear || viewTagColor == .white ? 1 : 0.5) // 透明度調整（0.0~1.0)
                        } else if(index == 1) {
                            Rectangle()
                                .fill(Color.red)
                                .frame(width: 30, height: 30)
                                .opacity(viewTagColor == .clear || viewTagColor == .red ? 1 : 0.5) // 透明度調整（0.0~1.0)
                        } else if(index == 2) {
                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: 30, height: 30)
                                .opacity(viewTagColor == .clear || viewTagColor == .blue ? 1 : 0.5) // 透明度調整（0.0~1.0)
                        } else if(index == 3) {
                            Rectangle()
                                .fill(Color.yellow)
                                .frame(width: 30, height: 30)
                                .opacity(viewTagColor == .clear || viewTagColor == .yellow ? 1 : 0.5) // 透明度調整（0.0~1.0)
                        }
                    }
                    Spacer()
                }
                
            } // HStack ここまで
            .padding(.top)
            
            List {
                // 設定済みアラームList表示
//                ForEach(0 ..< items.count, id: \.self) { index in
                ForEach(items) {item in
                    Button(action: {
                        self.isModalSubview.toggle()
                        
                        viewTagColor = .clear
                        
                    }) {
                        AlarmRow(AlarmTime: item.alarmTime!, DayOfWeekRepeat: item.dayOfWeekRepeat , Label: item.label!, OnOff: Binding<Bool>(
                            
                            get: { item.onOff },
                            set: {
                                item.onOff = $0
                                try? self.viewContext.save()
                            }), Snooze: item.snooze, Sound: item.sound ?? "", TagColor: item.tagColor!)
                    }
                    .sheet(isPresented: $isModalSubview) {
                        if(items.count > 0) {
                            SettingView(
                                        NewSettingBool: false
                                        ,offsets: items.count
                                        ,setAlarmTime: item.alarmTime!
                                        ,setDayOfWeekRepeat: item.dayOfWeekRepeat
                                        ,setLabel: item.label!
                                        ,setSnooze: item.snooze
                                        ,setSound: item.sound ?? ""
                                        ,setTagColor: item.tagColor!
                                        ,objectID: item.objectID
                            )
                        }
                    } // sheetここまで
//                    NavigationLink {
//                        Text("AlarmData at \(item.alarmTime!)")
                    
                    
//                    } label: {
//                        Text(item.alarmTime!, formatter: itemFormatter)
//                    }
                }
                .onDelete(perform: deleteAlarmData)
            }// List ここまで
            .listStyle(PlainListStyle())  // listの表示スタイルを指定
            .edgesIgnoringSafeArea(.top)
            .toolbar {
                // 「編集」ボタン
                ToolbarItem(placement: .navigationBarLeading) {
                    MyEditButton() // オリジナルEditButtonに置き換え
                }
                // 「＋」ボタン
                ToolbarItem {
                    Button(action: {
                        self.isModalSubview.toggle()
                        
                        viewTagColor = .clear
                        
                    }) {
                        Label("Add AlarmData", systemImage: "plus")
                    }
                    .sheet(isPresented: $isModalSubview) {
                         
//                        if(items.count > 0) {
                            SettingView(
                                        NewSettingBool: true
                                        ,offsets: items.count
                                        ,setAlarmTime: Date()
                                        ,setDayOfWeekRepeat: []
                                        ,setLabel: "アラーム"
                                        ,setSnooze: false
                                        ,setSound: ""
                                        ,setTagColor: "clear"
                            )
//                        }
                    } // sheetここまで
                        
                }
            }
        } // VStackここまで
//            Text("Select an item")
            
        .navigationBarTitle("アラーム")
        } // NavigationViewここまで
    } // bodyここまで

//    // データ追加
//    private func addAlarmData() {
//        withAnimation {
//            let newAlarmData = AlarmData(context: viewContext)
//            newAlarmData.alarmTime = Date()
//            newAlarmData.dayOfWeekRepeat = []
//            newAlarmData.label = "アラーム"
//            newAlarmData.onOff = true
//            newAlarmData.snooze = false
//            newAlarmData.sound = ""
//            newAlarmData.tagColor = "clear"
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }

    // データ削除
    func deleteAlarmData(offsets: IndexSet) {
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
    
//    // CoreData更新のためのforループ(DayOfWeek用)
//    func inputWeekArray() -> [String] {
//        var weekValue: [String] = []
//        for index in 0 ..< weekArray.count {
//            if(items[items.count - 1].dayOfWeekRepeat.contains(weekArray[index].rawValue)) {
//                weekValue.append(weekArray[index].rawValue)
//            }
//        }
//        return weekValue
//    }
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
