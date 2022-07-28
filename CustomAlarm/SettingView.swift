//
//  SettingView.swift
//  CustomAlarm
//
//  Created by パソコンさん on 2022/06/27.
//

import SwiftUI
import CoreData

struct SettingView: View {
    // AlarmData管理用のcontext
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: AlarmData.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \AlarmData.alarmTime, ascending: true)],
                  predicate: nil
    )private var items: FetchedResults<AlarmData>
    
    //モーダル表示を閉じるdismiss()を使うための変数
    @Environment(\.presentationMode) var presentationMode
    
    // 通知設定用変数
//    @EnvironmentObject var notificationModel:NotificationModel
    
    //
    @ObservedObject var dataModel: DataModel
    
    @State var cancelSwitch = false
    
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
                            cancelSwitch = true
                            if(searchIndex() >= 0){
                                items[searchIndex()].onOff = dataModel.onOff
                            }
                            dataModel.isNewData = false
                            didTapDismissButton()
                        }
                        // アラーム専用の橙色に設定
                        .foregroundColor(Color("DarkOrange"))
                        .padding()
                        
                        Spacer()
                        
                        // 【未】完了ボタンを押したらアラーム設定のデータを変更する
                        Button("保存") {
                            if(searchIndex() >= 0) {
                                viewContext.delete(items[searchIndex()])
                            }
                            dataModel.alarmTime = secondLoss(willTime: dataModel.alarmTime) // 秒数以下切り捨て
//                            dataModel.onOff = true
                            
                            // 年月日の更新
                            dataModel.alarmTime = updateTime(didAlarmTime: dataModel.alarmTime)
                            
                            dataModel.updateItem = AlarmData(context: viewContext)
                            //                            dataModel.rewrite(dataModel: dataModel,context: viewContext)
                            
                            // 通知の予約
//                            self.notificationModel.setNotification(time: dataModel.alarmTime, dayWeek: dataModel.dayOfWeekRepeat, uuid: dataModel.uuid, label: dataModel.label)
                            
                            // disApperでonoff切り替えを行うための処理
                            dataModel.onOff = false
                            dataModel.writeData(context: viewContext)
                            dataModel.isNewData.toggle()
                            
                            
                            didTapDismissButton()
                            
                            
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
                           selection: $dataModel.alarmTime,
                           displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                
                List{
                    
                    // 【移動】RepeatDaySetting.swiftへ プッシュ遷移
                    NavigationLink(destination: RepeatDaySettingView(dayOfRepeat: $dataModel.dayOfWeekRepeat)) {
                        Text("繰り返し")
                            .foregroundColor(Color.white)
                        
                        Spacer()
                        
                        Text(textWeekDay())
                            .foregroundColor(Color.white)
                            .lineLimit(1)
                            .opacity(0.5)
                        
                    }
                    
                    // 【移動】LabelSetting.swiftへ プッシュ遷移
                    NavigationLink(destination: LabelSettingView(label: $dataModel.label)) {
                        Text("ラベル")
                            .foregroundColor(Color.white)
                        
                        Spacer()
                        
                        Text(dataModel.label)
                            .foregroundColor(Color.white)
                            .lineLimit(1)
                            .opacity(0.5)
                    }
                    .onAppear{
                        if(dataModel.label == "") {
                            dataModel.label = "アラーム"
                        }
                    }
                    
                    
                    // 【移動】SoundSetting.swiftへ プッシュ遷移
                    NavigationLink(destination: SoundSettingView(soundOnOff: $dataModel.soundOnOff, soundURL: $dataModel.soundURL, soundName: $dataModel.soundName,soundTime: $dataModel.soundTime, soundTimeOnOff: $dataModel.soundTimeOnOff,soundReturnTime: $dataModel.soundReturnTime)){
                        Text("サウンド")
                            .foregroundColor(Color.white)
                        
                        Spacer()
                        
                        if(dataModel.soundOnOff) {
                            Text(dataModel.soundName == "" ? "名称未設定" : dataModel.soundName)
                                .foregroundColor(Color.white)
                                .lineLimit(1)
                                .opacity(0.5)
                                .frame(alignment: .trailing)
                        } else {
                            Text("OFF")
                                .foregroundColor(Color.white)
                                .lineLimit(1)
                                .opacity(0.5)
                                .frame(alignment: .trailing)
                        }
                    }
                    .onAppear{
                        if(dataModel.soundURL == "") {
                            dataModel.soundOnOff = false
                        }
                    }
                    
/*2022.7.26 処理の問題で一時的にストップ
                    HStack{
                        // スヌーズのON/OFF切り替え
                        Text("スヌーズ")
                            .foregroundColor(Color.white)
                        Toggle(isOn: $dataModel.snooze) {
                            
                        }
                    }
*/
                    // 【移動】IdentifyTagSetting.swiftへ プッシュ遷移
                    NavigationLink(destination: ColorTagSettingView(tagColor: $dataModel.tagColor)){
                        Text("タグ")
                            .foregroundColor(Color.white)
                        
                        Spacer()
                        
                        Text(textTagColor())
                            .foregroundColor(Color.white)
                            .opacity(0.5)
                            .lineLimit(1)
                            .frame(alignment: .trailing)
                    } // NavigationLinkここまで
                    
                    
                    
                } // List ここまで
                .listStyle(.insetGrouped)  // listの線を左端まで伸ばす
                .navigationBarHidden(true)
                
                
                Spacer()
                
                // 【未】 Listのボタンと同じ角の丸い横長ボタンを上のListと少し話した場所に表示させる
                Button(action: {
                    
                    dataModel.isNewData = false
                    
                    // 通知予約破棄 SettingViewを開いた時にOFFになるので、通知予約は既に破棄されている
//                    self.notificationModel.removeNotification(notificationIdentifier: items[searchIndex()].wrappedUuid)
                    // 既存設定の変更かどうかを判断
                    if(dataModel.updateItem != nil) {
                        viewContext.delete(items[searchIndex()])
                        try! viewContext.save()
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
            // もし、キャンセルボタンを押さずにスライドでキャンセルした場合の処理
            .onDisappear{
                if(!cancelSwitch){
                    if(searchIndex() >= 0){
                        items[searchIndex()].onOff = dataModel.onOff
                    }
                    dataModel.isNewData = false
                }
            }
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
            if(dataModel.dayOfWeekRepeat.contains(weekArray[index].rawValue)) {
                if(dataModel.dayOfWeekRepeat.count == 1) {
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
        if(dataModel.tagColor != DataAccess.TagColor.clear.rawValue) {
            returnString = dataModel.tagColor
        } else {
            returnString = "なし"
        }
        
        return returnString
    }
    
    // 既存設定用indexサーチ関数 (uuid検索)
    private func searchIndex() -> Int {
        var returnIndex: Int?
        for index in 0 ..< items.count {
            if(items[index].uuid == dataModel.uuid){
                returnIndex = index
            }
        }
        if(returnIndex == nil) {
            return -1
        } else {
            return returnIndex!
        }
    }
    
    // アラーム設定時間の秒数以下切り捨て
    private func secondLoss(willTime: Date) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let noSecondTime = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: willTime)
        let newWillTime = calendar.date(from: noSecondTime)
        
        return newWillTime!
    }
    
} // struct ここまで

//struct SettingView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        SettingView(NewSettingBool: false, setUUID: UUID().uuidString, setAlarmTime: Date(), setDayOfWeekRepeat: [], setLabel: "アラーム", setSnooze: false, setTagColor: "clear")
//    }
//}
