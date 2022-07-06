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
        List{
            ForEach(0 ..< weekArray.count, id: \.self) { index in
                HStack {
                    Button(action: {
                        // 曜日タグを付与する/解除する
                        if(dayOfRepeat.contains(weekArray[index].rawValue)){
                            dayOfRepeat.removeAll(where: {$0 == weekArray[index].rawValue})
                        } else {
                            dayOfRepeat.append(weekArray[index].rawValue)
                        }
                    }){
                        Text(weekArray[index].rawValue)
                            .foregroundColor(Color.white)
                    }
                    
                    Spacer()
                    
                    if(dayOfRepeat.contains(weekArray[index].rawValue)){
                        
                            Image(systemName: "checkmark")
                                .foregroundColor(Color("DarkOrange"))
                                .font(.title3.weight(.semibold))
                    }
                } // HStackここまで
            } // ForEachここまで
            .navigationTitle("繰り返し")
            .navigationBarTitleDisplayMode(.inline)
        } // Listここまで
    }
}

struct RepeatDaySettingView_Previews: PreviewProvider {
    static var previews: some View {
        RepeatDaySettingView(dayOfRepeat: Binding.constant([]))
    }
}
