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
    @StateObject private var dataModel = DataModel()
    
    @FetchRequest(
        //データの取得方法を指定　下記は日付降順
        entity:AlarmData.entity(),sortDescriptors: [NSSortDescriptor(keyPath: \AlarmData.alarmTime, ascending: true)],
        animation: .default)
    private var items: FetchedResults<AlarmData>
    

     // 新規作成用のモーダル遷移起動変数
     @State var isModalSubviewNew = false
     // 既存設定用のモーダル遷移起動変数
     @State var isModalSubview = false
    
    // オリジナル編集・完了ボタン用変数
    @Environment(\.editMode) var editMode

     // SettingView遷移のために押されたButtonの番号と引数に渡すデータの番号を一致させるための変数
     @Binding var index: String
    // 識別色タグの分類表示用変数
    @State var viewTagColor: DataAccess.TagColor = .clear
    
    var body: some View {
        NavigationView{
            //        Text("Hello")
            VStack{
                
                // 【未】識別タグ(IdentifyTag)を設定したアラームラベルのみ表示へ切り替える
                HStack{
                    Spacer()
                    
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
                    ForEach(items) {item in
                        Button(action: {
                             
                            dataModel.editItem(item: item)
                            self.isModalSubview.toggle()
                            
                            viewTagColor = .clear
                            
                            index = item.wrappedUuid
                            
                        }) {
                            AlarmRow(dataModel: dataModel, Items: item)
                        }
                        .sheet(isPresented: $isModalSubview) {
                            if(items.count > 0 && item.alarmTime != nil && item.wrappedUuid == index) {
                                SettingView(dataModel: dataModel)
                            }
                        } // sheetここまで
                    } // ForEachここまで
                    .onDelete(perform: deleteAlarmData)
                }// List ここまで
                .listStyle(PlainListStyle())  // listの表示スタイルを指定
                .edgesIgnoringSafeArea(.top)
                .toolbar {
                    // 「編集」ボタン
                    ToolbarItem(placement: .navigationBarLeading) {
                        // オリジナルEditButtonに置き換え
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
                    // 「＋」ボタン
                    ToolbarItem {
                        Button(action: {
                            
                            // 「完了」ボタンが表示されている場合、「編集」ボタンへ戻す
                            if editMode?.wrappedValue.isEditing == true {
                                editMode?.wrappedValue = .inactive
                            }
                            
                            dataModel.isNewData.toggle()
                            self.isModalSubviewNew.toggle()
                            viewTagColor = .clear
                        }) {
                            Label("Add AlarmData", systemImage: "plus")
                        }
                        .sheet(isPresented: $isModalSubviewNew) {
                            SettingView(dataModel: DataModel())
                        } // sheetここまで
                    } // ToolbarItemここまで
                }
            } // VStackここまで
            
            .navigationBarTitle("アラーム")
        } // NavigationViewここまで
    } // bodyここまで
    
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
    
    // 既存設定用indexサーチ関数
    private func searchIndex(objectID: NSManagedObjectID) -> Int {
        // itemsから任意のitemを見つけるためのid
        var returnIndex: Int = 0
        for index in 0 ..< items.count {
            if(items[index].alarmTime != nil) {
                if(items[index].objectID == objectID){
                    returnIndex = index
                }
            }
        }
        return returnIndex
    }
//    // アラーム設定画面へ移行した時、もし「完了」ボタンが表示されていたら「編集」ボタンへ戻す
//    func changeEditMode() {
//        if editMode?.wrappedValue.isEditing == false{
//            editMode?.wrappedValue = .active
//        }
//    }
} // structここまで

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(index: Binding.constant("")).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}



/*
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
    
    // アラーム設定画面へ移行した時、もし「完了」ボタンが表示されていたら「編集」ボタンへ戻す
    func changeEditMode() {
        if editMode?.wrappedValue.isEditing == false{
            editMode?.wrappedValue = .active
        }
    }
}
*/
