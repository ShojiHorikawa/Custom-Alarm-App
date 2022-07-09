//
//  RepeatDaySettingView.swift
//  CustomAlarm
//
//  Created by パソコンさん on 2022/07/06.
//

import SwiftUI

struct RepeatDaySettingView: View {
    @Binding var dayOfRepeat: [String]
    
    let weekArray: [DataAccess.DayOfWeek] = DataAccess.DayOfWeek.allCases
    
    var body: some View {
        //        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        List(weekArray, id: \.self){ day in
            HStack {
                Button(action: {
                    // 曜日タグを付与する/解除する
                    if(dayOfRepeat.contains(day.rawValue)){
                        dayOfRepeat.removeAll(where: {$0 == day.rawValue})
                    } else {
                        dayOfRepeat.append(day.rawValue)
                    }
                }){
                    Text(day.rawValue)
                        .foregroundColor(Color.white)
                }
                
                Spacer()
                
                if(dayOfRepeat.contains(day.rawValue)){
                    Image(systemName: "checkmark")
                        .foregroundColor(Color("DarkOrange"))
                        .font(.title3.weight(.semibold))
                }
            } // HStackここまで
        } // Listここまで
        .navigationTitle("繰り返し")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RepeatDaySettingView_Previews: PreviewProvider {
    static var previews: some View {
        RepeatDaySettingView(dayOfRepeat: Binding.constant([]))
    }
}
