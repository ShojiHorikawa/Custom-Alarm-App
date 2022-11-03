//
//  MainView.swift
//  CustomAlarm
//
//  Created by パソコンさん on 2022/11/02.
//

import SwiftUI

struct MainView: View {
    //使用するシンボル 時計:alarm.fill 歯車:gearshape.fill
    // SettingView遷移のために押されたButtonの番号と引数に渡すデータの番号を一致させるための変数
    @State var index = ""
    @State var index2 = ""
    @State private var selection = 0
    init() {
        UITabBar.appearance().backgroundColor = .black.withAlphaComponent(0.5)
        }
    var body: some View {
            TabView{
                ContentView(index: $index)
                    .tabItem{
                            Image(systemName: "alarm.fill")
                                .foregroundColor(Color("DarkOrange"))
                                .font(.largeTitle.weight(.semibold))
                            Text("アラーム")
                                .font(.caption)
                                .fontWeight(.black)
                    }
                AppSettingView(index2: $index2)
                    .tabItem{
                            Image(systemName: "gearshape.fill")
                                .foregroundColor(Color("DarkOrange"))
                                .font(.largeTitle.weight(.semibold))
                            Text("設定")
                                .font(.caption)
                                .fontWeight(.black)
                    }
            } // TabViewここまで
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
