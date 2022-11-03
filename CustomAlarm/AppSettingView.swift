//
//  AppSettingView.swift
//  CustomAlarm
//
//  Created by パソコンさん on 2022/11/03.
//

import SwiftUI

struct AppSettingView: View {
    // CoreData保存用変数
    @Environment(\.managedObjectContext) var viewContext
    
    @StateObject private var soundDataModel = SoundDataModel()
    
    @FetchRequest(
        //データの取得方法を指定　下記は日付降順
        entity:SoundData.entity(),sortDescriptors: [NSSortDescriptor(keyPath: \SoundData.createdTime_S, ascending: true)],
        animation: .default)
    private var items_S: FetchedResults<SoundData>
    
    // 新規作成用のモーダル遷移起動変数
    @State var isModalSubviewNew_S = false
    // 既存設定用のモーダル遷移起動変数
    @State var isModalSubview_S = false
    
    // SettingView遷移のために押されたButtonの番号と引数に渡すデータの番号を一致させるための変数
    //Bindingにすることでindexの値を保持する
    @Binding var index2: String
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct AppSettingView_Previews: PreviewProvider {
    static var previews: some View {
        AppSettingView(index2: Binding.constant("")).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
