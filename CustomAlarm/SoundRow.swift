//
//  SoundRow.swift
//  CustomAlarm
//
//  Created by パソコンさん on 2022/11/03.
//

import SwiftUI

struct SoundRow: View {
    @State var SoundName: String
    
//    Previewを使うために今はコメントアウト
//    @ObservedObject var Item_S: SoundData
    
    var body: some View {
        HStack{
            // 半角12文字,全角6文字で区切る
            Text(SoundName != "" ? cutSoundName(text: SoundName) : "名称未設定")
                .font(.system(size: 50))
                .fontWeight(.light)
            Spacer()
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

struct SoundRow_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            SoundRow(SoundName: "あああ/////aaaあああああああああああ")
                .previewLayout(.fixed(width: 400, height: 81))
        }
    }
}
