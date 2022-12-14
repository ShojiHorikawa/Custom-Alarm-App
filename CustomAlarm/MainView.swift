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
    @State var index_S = ""
//    @State private var selection = "alarm"
    @State private var selection = 1
    init() {
        UITabBar.appearance().backgroundColor = .black.withAlphaComponent(0.5)
        }
    // オリジナル編集・完了ボタン用変数
    @Environment(\.editMode) var editMode
    var body: some View {
            TabView(selection: $selection){
                ContentView(index: $index,selection: $selection)
                    .tag(1)
                    .tabItem{
                            Image(systemName: "alarm.fill")
                                .foregroundColor(Color("DarkOrange"))
                                .font(.largeTitle.weight(.semibold))
                            Text("アラーム")
                                .font(.caption)
                                .fontWeight(.black)
                    }
                SoundListView(index_S: $index_S,selection: $selection)
                    .tag(2)
                    .tabItem{
                            Image(systemName: "headphones")
                                .foregroundColor(Color("DarkOrange"))
                                .font(.largeTitle.weight(.semibold))
                            Text("サウンド")
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
