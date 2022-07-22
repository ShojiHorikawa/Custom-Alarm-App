//
//  AlarmRow.swift
//  CustomAlarm
//
//  Created by パソコンさん on 2022/06/27.
//

import SwiftUI
import CoreData

struct AlarmRow: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \AlarmData.alarmTime, ascending: true)],
        animation: .default)
    private var items: FetchedResults<AlarmData>
    
    // CoreData番号
    //    var offsets: Int
    /*
     @State var AlarmTime : Date
     @State var DayOfWeekRepeat : [DataAccess.DayOfWeek.RawValue]
     @State var Label : String
     @Binding var OnOff : Bool
     @State var Snooze : Bool
     @State var Sound : String?
     @State var TagColor : DataAccess.TagColor.RawValue
     */
    // itemsから任意のitemを見つけるためのid
    //    var objectID: NSManagedObjectID
    
    // 通知設定用変数
    @EnvironmentObject var notificationModel:NotificationModel
    
    
    // 7/1 試しに実装
    @ObservedObject var dataModel: DataModel
    @ObservedObject var Items: AlarmData
    
    let colorArray: [DataAccess.TagColor] = DataAccess.TagColor.allCases
    
    var body: some View {
        /*
         VStack{
         if(TagColor == "white") {
         Rectangle()
         .fill(Color.white)
         .frame(width: 30, height: 30)
         .offset(x: -60, y: 0) // toggleに隣接する位置に表示
         //                .opacity(items[offsets].onOff ? 1.0 : 0.5) // 透明度調整（0.0~1.0)
         
         } else if(TagColor == "red") {
         Rectangle()
         .fill(Color.red)
         .frame(width: 30, height: 30)
         .offset(x: -60, y: 0) // toggleに隣接する位置に表示
         //                .opacity(items[offsets].onOff ? 1.0 : 0.5) // 透明度調整（0.0~1.0)
         } else if(TagColor == "blue") {
         Rectangle()
         .fill(Color.blue)
         .frame(width: 30, height: 30)
         .offset(x: -60, y: 0) // toggleに隣接する位置に表示
         //                .opacity(items[offsets].onOff ? 1.0 : 0.5) // 透明度調整（0.0~1.0)
         } else if(TagColor == "yellow") {
         Rectangle()
         .fill(Color.yellow)
         .frame(width: 30, height: 30)
         .offset(x: -60, y: 0) // toggleに隣接する位置に表示
         //                .opacity(items[offsets].onOff ? 1.0 : 0.5) // 透明度調整（0.0~1.0)
         } // tagColor ifここまで
         Spacer()
         }
         */
        ZStack(alignment: .trailing) {
            HStack{
                VStack(alignment: .leading){
                    
                    HStack(alignment: .bottom){
                        // 12時間表記ならtrue、24時間表記ならfalseを返すTimejudge関数で判別
                        if(Timejudge()) {
                            Text(timeText(dt:Items.wrappedAlarmTime,AmPm: true))
                                .font(.system(size: 35))
                                .fontWeight(.light)
                                .brightness(Items.onOff ? 0.0 : -0.5) // valueの真偽で文字の明るさを変更
                                .padding(.bottom,5)
                            Text(timeText(dt:Items.wrappedAlarmTime,AmPm: false))
                                .font(.system(size: 50))
                                .fontWeight(.light)
                                .brightness(Items.onOff ? 0.0 : -0.5) // valueの真偽で文字の明るさを変更
                        } else {
                            Text(Items.wrappedAlarmTime.formatted(.dateTime.hour().minute()))
                                .font(.system(size: 50))
                                .fontWeight(.light)
                                .brightness(Items.onOff ? 0.0 : -0.5) // valueの真偽で文字の明るさを変更
                        }
                    }
                    
                    Text(Items.wrappedLabel)
                        .font(.body)
                        .fontWeight(.light)
                        .brightness(Items.onOff ? 0.0 : -0.5) // valueの真偽で文字の明るさを変更
                } // VStack ここまで
                Spacer()
            } // HStack ここまで
            
            // AlarmRow.swiftのcanvasではONとOFFを切り替えることができないので注意
            Toggle("",isOn: $Items.onOff)
                .onChange(of: Items.onOff){ OnOff in
                    if(OnOff){
                        // 全ての年月日更新(並び順を崩さないため)
                        for item in items {
                            item.alarmTime = updateTime(didAlarmTime: item.wrappedAlarmTime)
                        }
                        
                        self.notificationModel.setNotification(time: Items.wrappedAlarmTime, dayWeek: Items.dayOfWeekRepeat, uuid: Items.wrappedUuid, label: Items.wrappedLabel)
                    } else {
                        self.notificationModel.removeNotification(notificationIdentifier: Items.wrappedUuid)
                    }
                    try! viewContext.save()
                }// Toggle ここまで
            
            
//             .onChange(of: Items.onOff){ OnOff in
//                 if(OnOff){
//                     self.notificationModel.setNotification(item: Items)
//                 } else {
//                     self.notificationModel.removeNotification(notificationIdentifier: Items.wrappedUuid)
//                 }
////             try! viewContext.save()
//             }
             
            
            //                .onChange(of: items[offsets].onOff) { OnOff in
            //                    let spanTime = alarmValue.alarmTime.timeIntervalSince(Date())
            //                    if(OnOff) {
            //                        alarmValue.startCountUp(willTime: alarmValue.alarmTime, url: URL(string: alarmValue.sound),moreDay: spanTime <= 0)
            //                    } else {
            //                        alarmValue.stop()
            //                    }
            //                }
            
            ForEach(colorArray,id: \.self){ color in
                if(Items.wrappedTagColor == color.rawValue && Items.wrappedTagColor != DataAccess.TagColor.clear.rawValue){
                    Rectangle()
                        .fill(Color(Items.wrappedTagColor))
                        .frame(width: 30, height: 30)
                        .offset(x: -60, y: 0) // toggleに隣接する位置に表示
                        .opacity(Items.onOff ? 1.0 : 0.5) // 透明度調整（0.0~1.0)
                }
            }
            /*
             if(Items.wrappedTagColor == "white") {
             Rectangle()
             .fill(Color.white)
             .frame(width: 30, height: 30)
             .offset(x: -60, y: 0) // toggleに隣接する位置に表示
             .opacity(Items.onOff ? 1.0 : 0.5) // 透明度調整（0.0~1.0)
             
             } else if(Items.wrappedTagColor == "red") {
             Rectangle()
             .fill(Color.red)
             .frame(width: 30, height: 30)
             .offset(x: -60, y: 0) // toggleに隣接する位置に表示
             .opacity(Items.onOff ? 1.0 : 0.5) // 透明度調整（0.0~1.0)
             } else if(Items.wrappedTagColor == "blue") {
             Rectangle()
             .fill(Color.blue)
             .frame(width: 30, height: 30)
             .offset(x: -60, y: 0) // toggleに隣接する位置に表示
             .opacity(Items.onOff ? 1.0 : 0.5) // 透明度調整（0.0~1.0)
             } else if(Items.wrappedTagColor == "yellow") {
             Rectangle()
             .fill(Color.yellow)
             .frame(width: 30, height: 30)
             .offset(x: -60, y: 0) // toggleに隣接する位置に表示
             .opacity(Items.onOff ? 1.0 : 0.5) // 透明度調整（0.0~1.0)
             } // tagColor ifここまで
             */
            
        } // ZStackここまで
    } // body ここまで
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
