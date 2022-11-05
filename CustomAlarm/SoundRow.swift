//
//  SoundRow.swift
//  CustomAlarm
//
//  Created by パソコンさん on 2022/11/03.
//

import SwiftUI

struct SoundRow: View {
//    @State var soundName_S: String
//    @State var soundTimeOnOff_S: Bool
//    @State var soundTime_S: Int
//    @State var soundRepeatTime_S: Int
//    Previewを使うために今はコメントアウト
    @ObservedObject var Item_S: SoundData
    
    // 名称のないサウンド設定に番号を割り振る変数
    @State var soundIndex: Int
    
    // 開始時間(タイムスタンプ)入力用変数
    @State var hourInt:Int = 0
    @State var minInt:Int = 0
    @State var secInt:Int = 0
    
    // リピート変数(onApperの時にsoundRepeatTimeが0かどうかで変更)
    @State var RepeatBool = false
    // リピート時間入力用変数
    @State var hourIntRe = 0
    @State var minIntRe = 0
    @State var secIntRe = 0
    
    var body: some View {
        VStack{
            HStack{
                
                // 半角12文字,全角6文字で区切る
                Text(Item_S.wrappedSoundName_S != "" ? cutSoundName(text: Item_S.wrappedSoundName_S) : "サウンド\(String(format: "%02d", soundIndex + 1))")
                    .font(.system(size: 50))
                    .fontWeight(.light)
                Spacer()
            }
            Text(" ")
                .font(.caption2)
            HStack{
                Text("タイムスタンプ \(hourInt):\(String(format: "%02d", minInt)):\(String(format: "%02d", secInt))")
                    .font(.headline)
                    .fontWeight(.light)
                    .brightness(Item_S.soundTimeOnOff_S ? 0.0 : -0.5) // valueの真偽で文字の明るさを変更
//                Spacer()
                Text("    リピート \(RepeatBool ? "\(hourInt):\(String(format: "%02d", minInt)):\(String(format: "%02d", secInt))" : "OFF")")
                    .font(.headline)
                    .fontWeight(.light)
                    .brightness(RepeatBool ? 0.0 : -0.5) // valueの真偽で文字の明るさを変更
                Spacer()
            }
        }
        // タイムスタンプの時刻計算
        .onAppear{
            if(Item_S.soundTimeOnOff_S){
                secInt = Int(Item_S.soundTime_S) % 60
                minInt = Int(Item_S.soundTime_S) / 60 % 60
                hourInt = Int(Item_S.soundTime_S) / 3600
            }
            
            if(Item_S.soundRepeatTime_S != 0){
                RepeatBool = true
            }
                secIntRe = Int(Item_S.soundRepeatTime_S) % 60
                minIntRe = Int(Item_S.soundRepeatTime_S) / 60 % 60
                hourIntRe = Int(Item_S.soundRepeatTime_S) / 3600
            
        }
    }
    
    // 受け取った文字列をギリギリ画面を折り返さない文字列に書き換え
    private func cutSoundName(text: String) -> String{
        var textCount = 0
        var textByte = 0
        
        // ギリギリ画面を折り返さない文字数を計算する
        for character in text{
            textByte += character.utf8.count == 1 ? 1 : 2    // 半角(1バイト)なら1文字分,全角(3バイト)なら2文字分
            if(textByte <= 16){
                textCount += 1
            }
        }
        var returnText = ""
        if(textByte <= 14){
            returnText = text
        } else {
            returnText = String(text.prefix(textCount-1)) + "..."
        }

        return returnText
    }
}

//struct SoundRow_Previews: PreviewProvider {
//    static var previews: some View {
//        Group{
//            SoundRow(soundName_S: "あああ/////aaaあああああああああああ",soundTimeOnOff_S: true,soundTime_S: 3640,soundRepeatTime_S: 0)
//                .previewLayout(.fixed(width: 400, height: 81))
//        }
//    }
//}
