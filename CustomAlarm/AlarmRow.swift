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
    
    // Youtube再生用のモーダル遷移起動変数
//    @State var isModalSubviewYT = false
    
    @Binding var youTubePlayer : YouTubePlayer
    
    let colorArray: [DataAccess.TagColor] = DataAccess.TagColor.allCases
    
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
                        // 全ての年月日更新(並び順を崩さないため)
                        for item in items {
                            item.alarmTime = updateTime(didAlarmTime: item.wrappedAlarmTime)
                        }
                        
                        // 通知予約
                        self.notificationModel.setNotification(time: Item.wrappedAlarmTime, dayWeek: Item.dayOfWeekRepeat, uuid: Item.wrappedUuid, label: Item.wrappedLabel)
                        
                        // itemsを更新する方法を模索中
                        
//                        // 最も時間の早いアラームのOFF予約
                        var shortTime = items[0]
                        for item in items{
                            if(shortTime.wrappedAlarmTime.timeIntervalSinceNow < 0 && item.onOff){
                                shortTime = item
                            }
                        }
                        if(shortTime == Item){
                            startCountUp()
                        }
                    } else {
                        // 通知予約破棄
                        self.notificationModel.removeNotification(notificationIdentifier: Item.wrappedUuid)
                        if(Item.soundOnOff){
                            youTubePlayer = YouTubePlayer(
                                source: .url(Item.wrappedSoundURL),
                                configuration: .init(
                                    isUserInteractionEnabled: false,
                                    autoPlay: true,
                                    loopEnabled: true
                                )
                                )
                            // Youtube再生画面起動
//                            self.isModalSubviewYT = true
                        }
                        var shortTime = items[0]
                        for item in items{
                            if(shortTime.wrappedAlarmTime.timeIntervalSinceNow < 0 && item.onOff){
                                shortTime = item
                            }
                        }
                        if(shortTime.onOff || shortTime == Item){
                            stop()
                        }
                        
                    }
                    try! viewContext.save()
                }// Toggle ここまで
//            .sheet(isPresented: $isModalSubviewYT) {
//                YoutubePlayView(youTubePlayer: youTubePlayer, IntervalTime: Item.soundReturnTime, seekTime: Item.soundTime)
//            } // sheetここまで
            
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
    
    // アラームが鳴るとアラーム設定がOFFになる
    @State var timer: Timer!
    func startCountUp(){
        // 設定時刻までの時間計算
        var setTime = Item.wrappedAlarmTime
        // timeが現在時刻(〇時〇分)と同じ、またはそれ以前の場合は1日分の時間を足す
        if(setTime.timeIntervalSinceNow <= 0){
            setTime = Calendar.current.date(byAdding: .day, value: 1, to: setTime)!
        }
        var durringTime: Double = 0.0
        if(Item.dayOfWeekRepeat == []){ //日時
            // 曜日指定がない時
            durringTime = setTime.timeIntervalSinceNow//目標の時間との時間差(秒)
        } else {
            // 今日の曜日を取得 (日曜日=0,月曜日=1,....土曜日=6 を返す)
            let weekDay = Calendar.current.component(.weekday, from: Date()) % 7
            let weekArray: [DataAccess.DayOfWeek] = DataAccess.DayOfWeek.allCases // 検索用 曜日配列
            
            var num = 0 // Loop用変数(指定した曜日が何日後か調べる)
            while durringTime == 0.0{
                if(Item.dayOfWeekRepeat.contains(weekArray[(weekDay+num) % 7].rawValue)){
                    durringTime = Double(num * 24 * 60 * 60) + setTime.timeIntervalSinceNow
                }
                num += 1
            }
        }

        // Timerの実態があるときは停止させる
        self.timer?.invalidate()
        
        // 既存設定用indexサーチ関数 (uuid検索)
        var returnIndex: Int?
        for index in 0 ..< items.count {
            if(items[index].uuid == Item.uuid){
                returnIndex = index
            }
        }
        
        self.timer = Timer.scheduledTimer(withTimeInterval: durringTime, repeats: false){ _ in
            if(Item.wrappedAlarmTime.timeIntervalSinceNow > 0 && returnIndex != nil){
                self.items[returnIndex!].onOff = false
            }
        }
    }

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

//struct AlarmRow_Previews: PreviewProvider {
//    static var previews: some View {
////        AlarmRow(offsets: 0)  ,OnOff: Binding.constant(true)
//        AlarmRow(AlarmTime: Date(), DayOfWeekRepeat: [], Label: "ラベル",OnOff: Binding.constant(true), Snooze: false, Sound: "",TagColor: "red")
//            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//            .previewLayout(.fixed(width: 400, height: 81))
//    }
//}
