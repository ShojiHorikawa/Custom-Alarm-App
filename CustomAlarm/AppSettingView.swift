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
    } // body ここまで
    
    // データ削除
    private func deleteAlarmData(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                viewContext.delete(items_S[index])
            }
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    } // delet func ここまで
    
    // 既存設定用indexサーチ関数
    private func searchIndex(uuid_S: String) -> Int {
        // itemsから任意のitemを見つけるためのid
        var returnIndex: Int = 0
        for index in 0 ..< items_S.count {
            if(items_S[index].createdTime_S != nil) {
                if(items_S[index].wrappedUuid_S == uuid_S){
                    returnIndex = index
                }
            }
        }
        return returnIndex
    } // search func ここまで
    
}

struct AppSettingView_Previews: PreviewProvider {
    static var previews: some View {
        AppSettingView(index2: Binding.constant("")).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
