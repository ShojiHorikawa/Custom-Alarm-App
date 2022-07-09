//
//  ColorTagSettingView.swift
//  CustomAlarm
//
//  Created by パソコンさん on 2022/07/09.
//

import SwiftUI

struct ColorTagSettingView: View {
    @Binding var tagColor: DataAccess.TagColor.RawValue
    
    let colorArray: [DataAccess.TagColor] = [.white,.red,.blue,.yellow]
    
    var body: some View {
        //        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        VStack{
            List(colorArray, id: \.self){ setColor in
                HStack{
                    Button(action: {
                        if(tagColor == setColor.rawValue){
                            tagColor = DataAccess.TagColor.clear.rawValue
                        } else {
                            tagColor = setColor.rawValue
                        }
                    }){
                        Text("\(setColor.rawValue)")
                            .foregroundColor(Color.white)
                    }
                    
                    Spacer()
                    
                    // チェックマーク表示切り替え
                    
                    if(tagColor == setColor.rawValue){
                        Image(systemName: "checkmark")
                            .foregroundColor(Color("DarkOrange"))
                            .font(.title3.weight(.semibold))
                        
                        Rectangle()
                            .fill(Color(setColor.rawValue))
                            .frame(width: 30, height: 30)
                    }
                }
            } // Listここまで
            .navigationBarTitleDisplayMode(.inline)
        } // VStackここまで
        .navigationTitle("色タグ")
    }
}

struct ColorTagSettingView_Previews: PreviewProvider {
    static var previews: some View {
        ColorTagSettingView(tagColor: Binding.constant(DataAccess.TagColor.red.rawValue))
    }
}
