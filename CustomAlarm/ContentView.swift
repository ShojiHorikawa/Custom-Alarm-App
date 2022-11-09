//
//  ContentView.swift
//  CustomAlarm
//
//  Created by パソコンさん on 2022/06/27.
//

import SwiftUI
import CoreData
import YouTubePlayerKit

struct ContentView: View {
    // CoreData保存用変数
    @Environment(\.managedObjectContext) var viewContext
    
    // アプリの起動状態検知用の変数
    @Environment(\.scenePhase) private var scenePhase
    
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
//    @State var editMode: EditMode = .inactive
    
    
    // 識別色タグの分類表示用変数
    @State var viewTagColor: DataAccess.TagColor = DataAccess.TagColor.clear
    
    @State var youTubePlayer: YouTubePlayer = ""
    // アラームが鳴るとアラーム設定がOFFになる
//    @State var timer: Timer!
    // 通知設定用変数
    @EnvironmentObject var notificationModel:NotificationModel
    
    // AlarmRow Youtube起動用Bool配列(toggleスイッチを手動で押した時のみOnOffと同期)
//    @State var rowToggleArray:[Bool] = []
    
    // 新規作成後にそのアラームをONにするため、既に作成している設定のuuidを保存しておくString配列
    @State var setUuidArray:[String] = []
    
    
    // -----------ConstenViewの引数---------------
    
    // SettingView遷移のために押されたButtonの番号と引数に渡すデータの番号を一致させるための変数
    //Bindingにすることでindexの値を保持する
    @Binding var index: String
    // TabViewの切り替えを検知するためのString変数
    @State var selection:String
    
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
                                viewTagColor = DataAccess.TagColor.clear
                            } else {
                                viewTagColor = colorArray[index]
                            }
                        }) {
                            if(index == 0) {
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(width: 30, height: 30)
                                    .opacity(viewTagColor == DataAccess.TagColor.clear || viewTagColor == .white ? 1 : 0.5) // 透明度調整（0.0~1.0)
                            } else if(index == 1) {
                                Rectangle()
                                    .fill(Color.red)
                                    .frame(width: 30, height: 30)
                                    .opacity(viewTagColor == DataAccess.TagColor.clear || viewTagColor == .red ? 1 : 0.5) // 透明度調整（0.0~1.0)
                            } else if(index == 2) {
                                Rectangle()
                                    .fill(Color.blue)
                                    .frame(width: 30, height: 30)
                                    .opacity(viewTagColor == DataAccess.TagColor.clear || viewTagColor == .blue ? 1 : 0.5) // 透明度調整（0.0~1.0)
                            } else if(index == 3) {
                                Rectangle()
                                    .fill(Color.yellow)
                                    .frame(width: 30, height: 30)
                                    .opacity(viewTagColor == DataAccess.TagColor.clear || viewTagColor == .yellow ? 1 : 0.5) // 透明度調整（0.0~1.0)
                            }
                        }
                        Spacer()
                    }
                    
                } // HStack ここまで
                .padding(.vertical)
                
                List {
                    // 設定済みアラームList表示
                    ForEach(items) {item in
                        if(item.wrappedTagColor == viewTagColor.rawValue || viewTagColor == DataAccess.TagColor.clear) {
                            Button(action: {
                                // SettingViewへ渡すdataModelを作成
                                dataModel.editItem(item: item)
                                self.isModalSubview.toggle()
                                
                                item.onOff = false
//                                rowToggleArray[searchIndex(item: item)] = false
                                
                                viewTagColor = DataAccess.TagColor.clear
                                
                                // indexは今は使わないが、念の為残している 2022.08.11
                                // .sheetをForEachの外へ移した時にitemの代わりにindexを使って、itemsの配列から指定
                                index = item.wrappedUuid
                                
                            }) {
                                AlarmRow(dataModel: dataModel, Item: item, youTubePlayer: $youTubePlayer)
                                    .environmentObject(NotificationModel()) // 通知用
                            }
                            
                            
                            
                        } // ifここまで
                    } // ForEachここまで
                    .onDelete(perform: deleteAlarmData)
                    .sheet(isPresented: self.$isModalSubview) {
                        
                        //↓ ifの条件から「item.wrappedUuid == index」を削除 2022.08.11
                        //  2022.10.31 if(items.count > 0&& item.alarmTime != nil)からif(items.count > 0)に書き換え。
                        //  2022.10.31 item.alarmTimeがnilとなっていたことが原因(その理由は不明)
                        
                        // 既存のアラーム設定がある場合の設定ページを開く処理
                        if(items.count > 0 && items[searchIndex(uuid: index)].alarmTime != nil){
//                                if(items.count > 0) {
                            SettingView(dataModel: dataModel)
                                .onDisappear{
                                    print("Setting画面を閉じました")
                                    // rowToggleArrayの更新 & OnOffの更新
                                    for item in items{
                                        if(item.onOff){
                                            // アラームの設定 年月日を更新
                                            item.alarmTime = updateTime(didAlarmTime: item.wrappedAlarmTime)
                                        }
                                    }
                                    try! viewContext.save()
                                    
                                    if(dataModel.isNewData){
                                        items[searchIndex(uuid: index)].onOff = true
                                        dataModel.isNewData.toggle()
                                    }
                                } // onDisapperここまで
                        }
                    } // sheetここまで
                }// List ここまで
                .listStyle(PlainListStyle())  // listの表示スタイルを指定
                .edgesIgnoringSafeArea(.top)
//                .navigationBarItems(trailing: Button.init(action: { self.editMode = self.editMode.isEditing ? .inactive : .active }, label: {
//                                if self.editMode.isEditing {
//                                    Image.init(systemName: "checkmark")
//                                } else {
//                                    Image.init(systemName: "square.and.pencil")
//                                }
//                            }))
//                            .environment(\.editMode, self.$editMode)
                .toolbar {
                    // 「編集」ボタン
                    ToolbarItem(placement: .navigationBarLeading) {
                        if(!isModalSubviewNew && !isModalSubview && selection == "alarm"){
                            MyEditButton()
                        } else {
                            Text("編集")
                                .foregroundColor(Color("DarkOrange"))
                        }
                    }
                    // 「＋」ボタン
                    ToolbarItem {
                        Button(action: {
                            for item in items {
                                setUuidArray.append(item.wrappedUuid)
                            }
                            
                            dataModel.isNewData.toggle()
                            self.isModalSubviewNew.toggle()
                            viewTagColor = DataAccess.TagColor.clear
                            
                        }) {
                            Label("Add AlarmData", systemImage: "plus")
                        }
                        .sheet(isPresented: $isModalSubviewNew) {
                            SettingView(dataModel: DataModel())
//                                .environmentObject(NotificationModel()) // 通知用
                                .onDisappear{
                                    
                                    //新規作成設定の検索 → ONに変更
                                    for item in items{
                                        if(!setUuidArray.contains(item.wrappedUuid)){
                                            item.onOff = true
                                        }
                                    }
                                }
                        } // sheetここまで
                    } // ToolbarItemここまで
                } // toolbarここまで
            } // VStackここまで
            
            .navigationBarTitle("アラーム")
        } // NavigationViewここまで
        .onChange(of: scenePhase) { phase in
            if phase == .inactive {
                for item in items{
                    if(item.onOff){
/* UserDefaultsでAlarmRowのtoggleスイッチやアラーム設定の変更・新規作成をした時間〜NowTimeの間のアラーム設定をOFFに変える
                        // アラームの設定をOFFにする
                        if(item.wrappedAlarmTime.timeIntervalSinceNow < 0 && item.dayOfWeekRepeat == []){
                            item.onOff = false
                        }
*/
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
                // itemsのデータ更新
                try! viewContext.save()
            }
        }
    } // bodyここまで
    
    // データ削除
    private func deleteAlarmData(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                items[index].onOff = false
                viewContext.delete(items[index])
            }
            
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
    private func searchIndex(uuid: String) -> Int {
        // itemsから任意のitemを見つけるためのid
        var returnIndex: Int = 0
        for index in 0 ..< items.count {
            if(items[index].alarmTime != nil) {
                if(items[index].wrappedUuid == uuid){
                    returnIndex = index
                }
            }
        }
        return returnIndex
    }
} // structここまで


// 時間、分、秒以外を更新（新規作成時の年,月,日が保存されている状態なので、それを変更） ただし繰り返し曜日で設定されるはずの年月日はitemに記録されない
func updateTime(didAlarmTime: Date)->Date{
    let elapsedDays = Calendar.current.dateComponents([.day], from: resetTime(date: didAlarmTime), to: Date()).day
    let setAlarmTime = Calendar.current.date(byAdding: .day, value: elapsedDays!, to: didAlarmTime)!
    
    
    // 「setAlarmTimeが現在時刻(〇時〇分)と同じ、またはそれ以前の場合は1日分の時間を足す」という処理は通知作成処理にて行われる
    
    return setAlarmTime
}

func resetTime(date: Date) -> Date {
    let calendar: Calendar = Calendar(identifier: .gregorian)
    var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)

    components.hour = 0
    components.minute = 0
    components.second = 0

    return calendar.date(from: components)!
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(index: Binding.constant(""),selection: "alarm").environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

//func scheduleOnOff(items: FetchedResults<AlarmData>){
//    var setAlarmNowTime:[Int] = []
//    for item in items{
//        setAlarmNowTime.push(Int(item.wrappedAlarmTime.timeIntervalSinceNow))
//    }
//}



 // オリジナルEditButton
struct MyEditButton: View {
    @Environment(\.editMode) private var editMode
    
    
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
        .onDisappear{
//            if editMode?.wrappedValue.isEditing == true {
                editMode?.wrappedValue = .inactive
//            }
        }
        .onAppear{
//            editMode?.wrappedValue = .inactive
        }
    }
}
/*
 // アラーム設定画面へ移行した時、もし「完了」ボタンが表示されていたら「編集」ボタンへ戻す
 func changeEditMode() {
 if editMode?.wrappedValue.isEditing == false{
 editMode?.wrappedValue = .active
 }
 }
 }
 */
