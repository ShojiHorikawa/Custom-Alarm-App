//
//  AlarmRow.swift
//  CustomAlarm
//
//  Created by パソコンさん on 2022/06/27.
//

import SwiftUI
import CoreData
import YouTubePlayerKit

struct AlarmRow: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \AlarmData.alarmTime, ascending: true)],
        animation: .default)
    private var items: FetchedResults<AlarmData>
    
    // 通知設定用変数
    @EnvironmentObject var notificationModel:NotificationModel
    
    
    // 7/1 試しに実装
    @ObservedObject var dataModel: DataModel
    @ObservedObject var Item: AlarmData
    
    // アラームが鳴るとアラーム設定がOFFになるカウントダウン処理変数
    @State var timer: Timer!
    
    // Youtube再生用のモーダル遷移起動変数
    @State var isModalSubviewYT = false
    
    @Binding var youTubePlayer : YouTubePlayer
    
    let colorArray: [DataAccess.TagColor] = DataAccess.TagColor.allCases
    
    // AlarmRow Youtube起動用　一致確認Bool変数(toggleスイッチを手動で押してON → OFFにした時はtrueの状態)
//    @Binding var rowToggleBool:Bool
    
    var body: some View {
        ZStack(alignment: .trailing) {
            HStack{
                VStack(alignment: .leading){
                    
                    HStack(alignment: .bottom){
                        // 12時間表記ならtrue、24時間表記ならfalseを返すTimejudge関数で判別
                        if(Timejudge()) {
                            Text(timeText(dt:Item.wrappedAlarmTime,AmPm: true))
                                .font(.system(size: 35))
                                .fontWeight(.light)
                                .brightness(Item.onOff ? 0.0 : -0.5) // valueの真偽で文字の明るさを変更
                                .padding(.bottom,5)
                            Text(timeText(dt:Item.wrappedAlarmTime,AmPm: false))
                                .font(.system(size: 50))
                                .fontWeight(.light)
                                .brightness(Item.onOff ? 0.0 : -0.5) // valueの真偽で文字の明るさを変更
                        } else {
                            Text(Item.wrappedAlarmTime.formatted(.dateTime.hour().minute()))
                                .font(.system(size: 50))
                                .fontWeight(.light)
                                .brightness(Item.onOff ? 0.0 : -0.5) // valueの真偽で文字の明るさを変更
                        }
                    }
                    
                    Text(Item.wrappedLabel)
                        .font(.body)
                        .fontWeight(.light)
                        .brightness(Item.onOff ? 0.0 : -0.5) // valueの真偽で文字の明るさを変更
                } // VStack ここまで
                Spacer()
            } // HStack ここまで
            
            // AlarmRow.swiftのcanvasではONとOFFを切り替えることができないので注意
            Toggle("",isOn: $Item.onOff)
                .onChange(of: Item.onOff){ OnOff in
                    if(OnOff){
                        // 一致確認用Bool変数をtrueへ
                        Item.rowToggleBool = true
                        
                        // 全ての年月日更新(並び順を崩さないため)
                        for item in items {
                            item.alarmTime = updateTime(didAlarmTime: item.wrappedAlarmTime)
                        }
                        
                        // 通知予約
                        self.notificationModel.setNotification(time: Item.wrappedAlarmTime, dayWeek: Item.dayOfWeekRepeat, uuid: Item.wrappedUuid, label: Item.wrappedLabel)
                        
                        // itemsを更新する方法を模索中
                        
                        // 最も時間の早いONのアラーム設定(shortTime)を探す
                        let shortTime:AlarmData? = searchShortTime(items: items)
                       
                        // shortTimeが存在する時、そのアラームのOFF予約をする
                        if(shortTime != nil){
//                            startCountUp(item: shortTime!)
                            // Timerの実態があるときは停止させる
                            self.timer?.invalidate()
                            
                            // NotificationLocally.swiftに書かれている処理
                            let countDown = startCountUp(time: shortTime!.wrappedAlarmTime, dayWeek: shortTime!.dayOfWeekRepeat)
                            self.timer = Timer.scheduledTimer(withTimeInterval: countDown, repeats: false){ _ in
                                Item.rowToggleBool = false
                                Item.onOff = false
                            }
                        }
                        
                    } else {
                        // 通知予約破棄
                        self.notificationModel.removeNotification(notificationIdentifier: Item.wrappedUuid)
                        if(Item.soundOnOff){
                            print(Item.wrappedAlarmTime.timeIntervalSinceNow)
                            if(!Item.rowToggleBool){
//                            youTubePlayer = YouTubePlayer(
//                                source: .url(Item.wrappedSoundURL),
//                                configuration: .init(
//                                    isUserInteractionEnabled: false,
//                                    autoPlay: true,
//                                    loopEnabled: true
//                                )
//                                )
                            // Youtube再生画面起動
                            self.isModalSubviewYT = true
                            }
                        }
                        // 一致確認用Bool変数をfalseへ
                        Item.rowToggleBool = false
                        
                        timer?.invalidate()
                        timer = nil
                        // 最も時間の早いONのアラーム設定(shortTime)を探す
                        let shortTime:AlarmData? = searchShortTime(items: items)
                       
                        // shortTimeが存在する時、そのアラームのOFF予約をする
                        if(shortTime != nil){
//                            startCountUp(item: shortTime!)
                            // Timerの実態があるときは停止させる
                            self.timer?.invalidate()
                            
                            // NotificationLocally.swiftに書かれている処理
                            let countDown = startCountUp(time: shortTime!.wrappedAlarmTime, dayWeek: shortTime!.dayOfWeekRepeat)
                            self.timer = Timer.scheduledTimer(withTimeInterval: countDown, repeats: false){ _ in
                                Item.onOff = false
                            }
                        }
                        
                    }
                    try! viewContext.save()
                }// Toggle ここまで
            .sheet(isPresented: $isModalSubviewYT) {
                YoutubePlayView(url: Item.wrappedSoundURL, IntervalTime: Item.soundReturnTime, seekTime: Item.soundTime)
            } // sheetここまで
            
            ForEach(colorArray,id: \.self){ color in
                if(Item.wrappedTagColor == color.rawValue && Item.wrappedTagColor != DataAccess.TagColor.clear.rawValue){
                    Rectangle()
                        .fill(Color(Item.wrappedTagColor))
                        .frame(width: 30, height: 30)
                        .offset(x: -60, y: 0) // toggleに隣接する位置に表示
                        .opacity(Item.onOff ? 1.0 : 0.5) // 透明度調整（0.0~1.0)
                }
            }
        } // ZStackここまで
    } // body ここまで
    
    private func stop(){
        timer?.invalidate()
        timer = nil
    }
}

// 12時間表示かどうかを判定 12時間表示:true,24時間表示:false
func Timejudge() -> Bool {
    let dateFormmater = DateFormatter()
    dateFormmater.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    // 12時間表記の際に date == nil となる.
    guard dateFormmater.date(from: "2000-01-01 10:00:00") != nil else { return true }
    
    return false
}

// 午前午後だけ、時間だけを返す関数
func timeText(dt: Date, AmPm:Bool) -> String{
    let formatter = DateFormatter()
    if(AmPm) {
        formatter.dateFormat = "a"
    } else {
        formatter.dateFormat = "h:mm"
    }
    return formatter.string(from: dt)
    
    
}

// 最も早いONのアラーム時刻設定を検索
func searchShortTime(items: FetchedResults<AlarmData>) -> AlarmData?{
    let shortTime:AlarmData? = nil
    var shortTimeIndex: Int?
    // 今日の曜日を取得 (日曜日=0,月曜日=1,....土曜日=6 を返す)
    let weekDay = Calendar.current.component(.weekday, from: Date()) % 7
    // 検索用 曜日配列
    let weekArray: [DataAccess.DayOfWeek] = DataAccess.DayOfWeek.allCases
    // それぞれのitems.dayOfRepeartに含まれる曜日を数字に変換
    var itemsDayWeek:[[Int]] = []
    for i in 0 ..< items.count{
        itemsDayWeek.append([])
        for j in 0 ..< weekArray.count{
            if(items[i].dayOfWeekRepeat.contains(weekArray[j].rawValue)){
                itemsDayWeek[i].append(j)
            }
        }
    }
//        print(itemsDayWeek) //確認用
    
    // 日付を跨がないON設定のshortTimeIndex検索 (設定時間が現在時刻より遅い場合、その日の曜日も含む)
    for i in 0 ..< items.count{
        if(items[i].onOff && items[i].wrappedAlarmTime.timeIntervalSinceNow >= 0){
            if(itemsDayWeek[i].contains(weekDay) || itemsDayWeek[i] == []){
                if(shortTimeIndex == nil){
                    shortTimeIndex = i
                } else if(items[shortTimeIndex!].wrappedAlarmTime.timeIntervalSinceNow > items[i].wrappedAlarmTime.timeIntervalSinceNow) {
                    shortTimeIndex = i
                }
            }
        }
    }
    
//    // もし、現在時刻よりも前の場合は初期化(最も時間の早いアラーム設定を探すため) items[i].wrappedAlarmTime.timeIntervalSinceNow >= 0条件を追加したので不要
//    if(shortTime != nil && shortTime!.wrappedAlarmTime.timeIntervalSinceNow < 0){
//        shortTime = nil
//    }
    
    // 上の検索ループで見つからなかった場合、現在時刻に最も近い設定を探す
    if(shortTimeIndex == nil){
        for after in 1 ..< weekArray.count + 1{
            if(shortTimeIndex == nil){
            for i in 0 ..< items.count{
//                if(shortTimeIndex == nil){
                    if(items[i].onOff){
                        if(itemsDayWeek[i] == [] || itemsDayWeek[i].contains((weekDay+after) % 7)){
                            if(shortTimeIndex == nil){
                                shortTimeIndex = i
                            } else if(items[shortTimeIndex!].wrappedAlarmTime.timeIntervalSinceNow > items[i].wrappedAlarmTime.timeIntervalSinceNow){
                                shortTimeIndex = i
                            }
                        }
                    }
//                }
            }
            }
        }
    }
//    if(shortTime != nil){
//        print(shortTime!)
//    }
    if(shortTimeIndex != nil) {
        return items[shortTimeIndex!]
    } else {
        return shortTime
    }
}

//struct AlarmRow_Previews: PreviewProvider {
//    static var previews: some View {
////        AlarmRow(offsets: 0)  ,OnOff: Binding.constant(true)
//        AlarmRow(AlarmTime: Date(), DayOfWeekRepeat: [], Label: "ラベル",OnOff: Binding.constant(true), Snooze: false, Sound: "",TagColor: "red")
//            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//            .previewLayout(.fixed(width: 400, height: 81))
//    }
//}
