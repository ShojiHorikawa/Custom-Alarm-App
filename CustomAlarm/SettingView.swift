//
//  SettingView.swift
//  CustomAlarm
//
//  Created by パソコンさん on 2022/06/27.
//

import SwiftUI
import CoreData

struct SettingView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \AlarmData.alarmTime, ascending: true)],
        animation: .default)
    private var items: FetchedResults<AlarmData>
    
    // モーダル表示を閉じるdismiss()を使うための変数
    @Environment(\.presentationMode) var presentationMode
    
    // 新規作成か否かを示すBool引数(新規作成:true,既存設定:false)
    var NewSettingBool:Bool
    
    // CoreData番号
    var offsets: Int
    
    
    @State var setAlarmTime : Date
    @State var setDayOfWeekRepeat : [DataAccess.DayOfWeek.RawValue]
    @State var setLabel : String
//    @State var setOnOff : Bool
    @State var setSnooze : Bool
    @State var setSound : String?
    @State var setTagColor : DataAccess.TagColor.RawValue
    
    // itemsから任意のitemを見つけるためのid
    var objectID: NSManagedObjectID?
    
    var body: some View {
//        Text("Hello")
        // 【解決】モーダル遷移のページ上部に謎の余白発生（NavigationLinkとList追加後に発生)
        NavigationView{
            VStack {
                // 「アラームを編集」を真ん中に描写するためのZStack
                ZStack(alignment: .center){
                    HStack{
                        // キャンセルボタンを押したらアラーム設定のデータを更新しない
                        Button("キャンセル") {
                            // 新規作成の場合、追加した設定を配列から削除
                            if(NewSettingBool){
//                                viewContext.delete(items[offsets])

                                do{
                                    try viewContext.save()
                                }catch{
                                    print(error)
                                }
                            }
                            didTapDismissButton()
                        }
                        // アラーム専用の橙色に設定
                        .foregroundColor(Color("DarkOrange"))
                        .padding()

                        Spacer()

                        // 【未】完了ボタンを押したらアラーム設定のデータを変更する
                        Button("保存") {
//                            // CoreData更新のためのforループ(DayOfWeek用)
//                            var weekValue: [String] = []
//                            for index in 0 ..< weekArray.count {
//                                if(setDayOfWeekRepeat.contains(weekArray[index].rawValue)) {
//                                    weekValue.append(weekArray[index].rawValue)
//                                }
//                            }

                            // CoreData更新
//                            items[offsets].alarmTime = setAlarmTime
//                            items[offsets].dayOfWeekRepeat = weekValue
//                            items[offsets].label = setLabel
//                            items[offsets].snooze = setSnooze
//                            items[offsets].sound = setSound != nil ? setSound : "アラーム"
//                            items[offsets].tagColor = setTagColor
                            if(NewSettingBool) {
                                addAlarmData()
                            } else {
//                                items[searchIndex()].alarmTime = setAlarmTime
//                                items[searchIndex()].dayOfWeekRepeat = setDayOfWeekRepeat
//                                items[searchIndex()].label = setLabel
//                                items[searchIndex()].snooze = setSnooze
//                                items[searchIndex()].sound = setSound ?? ""
//                                items[searchIndex()].tagColor = setTagColor
                            }

                            // 更新したCoreData保存
                            do{
                                try viewContext.save()
                            }catch{
                                print(error)
                            }

                            didTapDismissButton()

                            if(items[offsets].onOff) {
                                // アラームセット　無限ループの制限
                                //                                let spanTime = AlarmDate.alarmTime.timeIntervalSince(Date())
                                //                                AlarmArray[alarmId].startCountUp(willTime: AlarmDate.alarmTime, url: URL(string: AlarmDate.sound),moreDay: spanTime <= 0 )
                            }
                        }
                        // アラーム専用の橙色に設定
                        .foregroundColor(Color("DarkOrange"))
                        .font(.headline)
                        .padding()

                    } // 画面上部のHStack ここまで

                    Text("アラームを編集")
                        .foregroundColor(Color.white)
                        .font(.headline)
                        .padding()
                } // ZStackここまで

                // 時間設定（ホイール）
                DatePicker("",
                           selection: $setAlarmTime,
                           displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.wheel)
                .labelsHidden()

                List{

                    // 【移動】RepeatDaySetting.swiftへ プッシュ遷移
                    //                    NavigationLink(destination: RepeatDaySetting(alarmId: alarmId, AlarmDate: $AlarmDate)) {
                    //                    Text("繰り返し")
                    //                        .foregroundColor(Color.white)
                    //
                    //                    Spacer()
                    //
                    //                    Text(textWeekDay())
                    //                        .foregroundColor(Color.white)
                    //                        .opacity(0.5)
                    //
                    //                }

                    // 【移動】LabelSetting.swiftへ プッシュ遷移
//                    NavigationLink(destination: LabelSetting()) {
//                        Text("ラベル")
//                            .foregroundColor(Color.white)
//
//                        Spacer()
//
//                        Text(AlarmDate.label)
//                            .foregroundColor(Color.white)
//                            .opacity(0.5)
//                    }


                    // 【移動】SoundSetting.swiftへ プッシュ遷移
//                    NavigationLink(destination: SoundSetting()){
//                        Text("サウンド")
//                            .foregroundColor(Color.white)
//
//                        Spacer()
//
//                        Text("朝ココ")
//                            .foregroundColor(Color.white)
//                            .opacity(0.5)
//                    }
                    HStack{
                        // スヌーズのON/OFF切り替え
                        Text("スヌーズ")
                            .foregroundColor(Color.white)
                        Toggle(isOn: $setSnooze) {

                        }
                    }

                    // 【移動】IdentifyTagSetting.swiftへ プッシュ遷移
//                    NavigationLink(destination: colorTagSetting(alarmId: alarmId, AlarmDate: $AlarmDate)){
//                        Text("タグ")
//                            .foregroundColor(Color.white)
//
//                        Spacer()
//
//                        Text(textTagColor())
//                            .foregroundColor(Color.white)
//                            .opacity(0.5)
//                    } // NavigationLinkここまで



                } // List ここまで
                .listStyle(.insetGrouped)  // listの線を左端まで伸ばす
                .navigationBarHidden(true)


                Spacer()

                // 【未】 Listのボタンと同じ角の丸い横長ボタンを上のListと少し話した場所に表示させる
                Button(action: {
                    if(NewSettingBool) {} else {
                        viewContext.delete(items[offsets])
                        do{
                            try viewContext.save()
                        }catch{
                            print(error)
                        }
                    }

                    didTapDismissButton()
                    // .actionSheetを使って確認メッセージを表示する
                    // https://www.choge-blog.com/programming/swiftuiactionsheetshow/

                }) {
                    Text("アラームを削除")
                        .frame(width: UIScreen.main.bounds.size.width / 6 * 5,
                               height: UIScreen.main.bounds.size.width / 6 * 0.5)
                }
                .foregroundColor(Color.red)
                .buttonStyle(.bordered)

                Spacer()
            } // VStack ここまで

            // NavigationBarのTitleを消すためのコードはNavigationViewの範囲内のListやVStackの{}の後ろに付ける
            .navigationBarHidden(true)
        } // NavigationView ここまで

    } // body ここまで
    
    // モーダル遷移を閉じるための関数
    private func didTapDismissButton() {
        presentationMode.wrappedValue.dismiss()
    }
    
    // 設定済み繰り返し曜日を示す文字列作成関数
    func textWeekDay() -> String {
        var returnString = "しない"    // returnする文字列 登録済みの曜日
        let start = 2                 // 2(3)番目の文字列（曜日）を取得する
        
        for index in 0 ..< weekArray.count {
            let stringDay = weekArray[index].rawValue
            if(setDayOfWeekRepeat.contains(weekArray[index].rawValue)) {
                if(setDayOfWeekRepeat.count == 1) {
                    returnString = weekArray[index].rawValue
                } else {
                    if(returnString == "しない") {
                        returnString = ""
                    }
                    let addInt = stringDay.index(stringDay.startIndex, offsetBy: start, limitedBy: stringDay.endIndex) ?? stringDay.endIndex
                    returnString += " "
                    returnString += String(stringDay[addInt])
                }
            }
        }
        return returnString
    } //func textWeekDayここまで
    
    // 設定済み識別色を示す文字列作成関数
    func textTagColor() -> String{
        var returnString = " "
        if(setTagColor != "clear") {
            returnString = setTagColor
        }
        
        return returnString
    }
    
    // データ追加
    private func addAlarmData() {
        withAnimation {
            let newAlarmData = AlarmData(context: viewContext)
            newAlarmData.alarmTime = setAlarmTime
            newAlarmData.dayOfWeekRepeat = setDayOfWeekRepeat
            newAlarmData.label = setLabel
            newAlarmData.onOff = true
            newAlarmData.snooze = setSnooze
            newAlarmData.sound = setSound ?? ""
            newAlarmData.tagColor = setTagColor

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
    private func searchIndex() -> Int {
        var returnIndex: Int = items.count
        for index in 0 ..< items.count {
            if(items[index] == objectID){
                returnIndex = index
            }
        }
        return returnIndex
    }
    
} // struct ここまで

struct SettingView_Previews: PreviewProvider {
    
    static var previews: some View {
        SettingView(NewSettingBool: false, offsets: 0, setAlarmTime: Date(), setDayOfWeekRepeat: [], setLabel: "アラーム", setSnooze: false, setTagColor: "clear")
    }
}
