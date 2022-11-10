//
//  AppSettingView.swift
//  CustomAlarm
//
//  Created by パソコンさん on 2022/11/03.
//

import SwiftUI
import CoreData

struct SoundListView: View {
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
    
    // オリジナル編集・完了ボタン用変数
//    @Environment(\.editMode) var editMode
    
    // -----------ConstenViewの引数---------------
    
    // SettingView遷移のために押されたButtonの番号と引数に渡すデータの番号を一致させるための変数
    //Bindingにすることでindexの値を保持する
    @Binding var index_S: String
    // TabViewの切り替えを検知するためのString変数
//    @State var selection:String
    @Binding var selection:Int
    
    var body: some View {
        NavigationView{
            VStack{
                List{
                    // 設定済みサウンドList表示
                    ForEach(items_S){ item_S in
                        Button(action: {
                            // Sound設定を開く
                            // SettingViewへ渡すdataModelを作成
                            soundDataModel.editItem(item: item_S)
                            self.isModalSubview_S.toggle()
                            
                            // .sheetをForEachの外へ移した時にitemの代わりにindexを使って、itemsの配列から指定
                            index_S = item_S.wrappedUuid_S
                        }){
                            SoundRow(Item_S: item_S,soundIndex: searchIndex(uuid_S: item_S.wrappedUuid_S))
                        }
                    } // ForEachここまで
                    .onDelete(perform: deleteSoundData)
                    .sheet(isPresented: self.$isModalSubview_S) {
                        // 既存のアラーム設定がある場合の設定ページを開く処理
                        if(items_S.count > 0 && items_S[searchIndex(uuid_S: index_S)].createdTime_S != nil){
                            SoundCreatView(soundDataModel: soundDataModel)
                                .onDisappear{
                                    print("SoundCreat画面を閉じました")
                                    try! viewContext.save()
                                    
                                    if(soundDataModel.isNewData_S){
                                        soundDataModel.isNewData_S.toggle()
                                    }
                                } // onDisapperここまで
                        } // sheet if ここまで
                    } // sheetここまで
                } // Listここまで
                .listStyle(PlainListStyle())  // listの表示スタイルを指定
//                .edgesIgnoringSafeArea(.top)
                .toolbar {
                    // 「編集」ボタン
                    ToolbarItem(placement: .navigationBarLeading) {
                        // モーダル遷移・TabView切り替えがされた時にMyEditButtonを消す(onDisapper処理を誘発)
                        if(!isModalSubview_S && !isModalSubviewNew_S && selection == 2){
                            // ContentView.swift内に書いたstructを使う
                            MyEditButton()
                        } else {
                            Text("編集")
//                                .foregroundColor(Color("DarkOrange"))
                        }
                    }
                    // 「＋」ボタン
                    ToolbarItem {
                        Button(action: {
                            
                            soundDataModel.isNewData_S.toggle()
                            self.isModalSubviewNew_S.toggle()
                        }) {
                            Label("Add SoundData", systemImage: "plus")
                        }
                        .sheet(isPresented: $isModalSubviewNew_S) {
                            SoundCreatView(soundDataModel: SoundDataModel())
                        } // sheetここまで
                    } // ToolbarItemここまで
                } // toolbarここまで
            }
//            .navigationBarTitle("\(selection)")
            .navigationBarTitle("サウンドリスト")
        } // NavigationView ここまで
    } // body ここまで
    
    // データ削除
    private func deleteSoundData(offsets: IndexSet) {
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

struct SoundListView_Previews: PreviewProvider {
    static var previews: some View {
        SoundListView(index_S: Binding.constant(""),selection:Binding.constant(2)).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
