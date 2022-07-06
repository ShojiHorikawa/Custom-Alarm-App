//
//  SoundSettingView.swift
//  CustomAlarm
//
//  Created by パソコンさん on 2022/07/06.
//

import SwiftUI

struct SoundSettingView: View {
    @Binding var soundOnOff: Bool
    @Binding var soundURL: String
    @Binding var soundName: String
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SoundSettingView_Previews: PreviewProvider {
    static var previews: some View {
        SoundSettingView(soundOnOff: Binding.constant(false), soundURL:Binding.constant(""), soundName: Binding.constant(""))
    }
}
