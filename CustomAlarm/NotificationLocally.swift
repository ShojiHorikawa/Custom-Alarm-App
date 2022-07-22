//
//  NotificationLocally.swift
//  CustomAlarm
//
//  Created by パソコンさん on 2022/07/14.
//
// 参考サイトhttps://thwork.net/2021/08/28/swiftui_local_notification/
import UserNotifications
import AudioToolbox

//フォアグラウンド通知用、バックグラウンドのみなら不要
class ForegroundNotificationDelegate:NSObject,UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //completionHandler([.alert, .list, .badge, .sound]) //~iOS13
        completionHandler([.banner, .list, .sound]) //iOS14~
    }
}

class NotificationModel: ObservableObject {

    // notificationIdentifierはローカル通知用のid
//    let notificationIdentifier = "NotificationTest"
    
    var notificationDelegate = ForegroundNotificationDelegate()

    init() {
        //フォアグラウンド通知用、バックグラウンドのみなら不要
        UNUserNotificationCenter.current().delegate = self.notificationDelegate
    }

    func setNotification(time: Date, dayWeek: [String],uuid: String, label: String){

        // 通知許可の確認
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound]){
            (granted, _) in
            if granted {
                //許可
                self.makeNotification(time: time, dayWeek: dayWeek,notificationIdentifier: uuid,label: label)
            }else{
                //非許可
            }
        }

    }

    func makeNotification(time: Date, dayWeek: [String],notificationIdentifier: String,label: String){
        
        var durringTime: Double = 8.0
        //日時
        if(dayWeek == []){
            // 曜日指定がない時
            durringTime = time.timeIntervalSinceNow//目標の時間との時間差(秒)
        } else {
            
            
            // 今日の曜日を取得 (日曜日=0,月曜日=1,....土曜日=6 を返す)
            let weekDay = Calendar.current.component(.weekday, from: Date()) % 7
            let weekArray: [DataAccess.DayOfWeek] = DataAccess.DayOfWeek.allCases // 検索用 曜日配列
            
            var num = 0 // Loop用変数(指定した曜日が何日後か調べる)
            while durringTime == 8.0{
                if(dayWeek.contains(weekArray[(weekDay+num) % 7].rawValue)){
                    durringTime = Double(num * 24 * 60 * 60) + time.timeIntervalSinceNow
                }
                num += 1
            }
            
            
        }
        
        let notificationDate = Date().addingTimeInterval(durringTime)//目標の時間との時間差(秒)
        let dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: notificationDate)

        //日時でトリガー指定
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)

        //通知内容
        let content = UNMutableNotificationContent()
        content.title = "CustomAlarm"
        content.body = label
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "Cave2.mp3"))

        //リクエスト作成
        let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)

        //通知をセット
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    func removeNotification(notificationIdentifier:String){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
    }
}
