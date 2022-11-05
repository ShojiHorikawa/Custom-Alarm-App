//
//  SoundCreatView.swift
//  CustomAlarm
//
//  Created by パソコンさん on 2022/11/05.
//

import SwiftUI
import CoreData

struct SoundCreatView: View {
    // CoreData保存用変数
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(
        //データの取得方法を指定　下記は日付降順
        entity:SoundData.entity(),sortDescriptors: [NSSortDescriptor(keyPath: \SoundData.createdTime_S, ascending: true)],
        animation: .default)
    private var items_S: FetchedResults<SoundData>
    
    //モーダル表示を閉じるdismiss()を使うための変数
    @Environment(\.presentationMode) var presentationMode_S
    
    @ObservedObject var soundDataModel: SoundDataModel
    
    // キャンセルが押されたかどうか判断するBool変数
    @State var cancelSwitch = false
    
/* サウンド設定編集用の変数群(SoundSettingViewと同じ) */
    // 開始時間(タイムスタンプ)入力用変数
    @State var hourInt = 0
    @State var minInt = 0
    @State var secInt = 0
    
    // リピート変数(onApperの時にsoundRepeatTimeが0かどうかで変更)
    @State var RepeatBool = false
    // リピート時間入力用変数
    @State var hourIntRe = 0
    @State var minIntRe = 0
    @State var secIntRe = 0
    
    // picker用bool変数
    @State var showPickerHour: Bool = false
    @State var showPickerMin: Bool = false
    @State var showPickerSec: Bool = false
    
    // タイムスタンプかリピートかpickerを区別するbool変数
    @State var whichPicker: Bool = true
    var body: some View {
        
        GeometryReader { geometry in
            VStack{
                // 「アラームを編集」を真ん中に描写するためのZStack
                ZStack(alignment: .center){
                    HStack{
                        // キャンセルボタンを押したらアラーム設定のデータを更新しない
                        Button("キャンセル") {
                            cancelSwitch = true
                            soundDataModel.isNewData_S = false
                            didTapDismissButton()
                        }
                        // アラーム専用の橙色に設定
                        .foregroundColor(Color("DarkOrange"))
                        .padding()
                        
                        Spacer()
                        
                        // 【未】完了ボタンを押したらアラーム設定のデータを変更する
                        Button("保存") {
                             if(searchIndex() >= 0) {
                             viewContext.delete(items_S[searchIndex()])
                             }
                             soundDataModel.createdTime_S = Date() // 保存日時更新
                             
                             
                             soundDataModel.soundTime_S = hourInt * 3600 + minInt * 60 + secInt
                             
                             soundDataModel.soundRepeatTime_S = hourIntRe * 3600 + minIntRe * 60 + secIntRe
                             
                             soundDataModel.updateItem_S = SoundData(context: viewContext)
                             //                            dataModel.rewrite(dataModel: dataModel,context: viewContext)
                             
                             
                             // disApperでonoff切り替えを行うための処理
                             soundDataModel.writeData(context: viewContext)
                             soundDataModel.isNewData_S.toggle()
                             
                             didTapDismissButton()
                        }
                        // アラーム専用の橙色に設定
                        .foregroundColor(soundDataModel.soundURL_S.contains("https://www.youtube.com/") ||  soundDataModel.soundURL_S.contains("https://youtu.be/") ? Color("DarkOrange") : Color.gray)
                        .font(.headline)
                        .padding()
                        .disabled(!soundDataModel.soundURL_S.contains("https://www.youtube.com/") &&  !soundDataModel.soundURL_S.contains("https://youtu.be/"))
                        
                    } // 画面上部のHStack ここまで
                    
                    Text("サウンドの設定")
                        .foregroundColor(Color.white)
                        .font(.headline)
                        .padding()
                } // ZStackここまで
/*-------------------------------------*/
                // ホイール用ZStack
                ZStack{
                    
                    // 全体VStack
                    VStack(alignment: .leading) {
                        
                        ScrollViewReader { reader in
                            ScrollView(.vertical,showsIndicators: false){
                                
                                // URL・Name設定 全体HStack
                                HStack(alignment: .top){
                                    // "サウンドの設定"に横を揃えるためのクッション用
                                    Image(systemName: "circle.inset.filled")
                                        .foregroundColor(Color.clear)
                                        .font(.caption2)
                                    // URL・Name設定VStack
                                    VStack(alignment: .leading) {
                                        Text("再生する動画のURLを入力")
                                            .bold()
                                            .padding(.top)
                                            .id("top") // スクロール用のポインタ
                                        
                                        // URL入力用TextField ZStack
                                        ZStack(alignment: .trailing){
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color("TextFieldColor"))
                                                .frame(height: 35)
                                                .padding(.trailing)
                                            TextField( "https://www.youtube.com/",text: $soundDataModel.soundURL_S
                                                      ,onEditingChanged: { isEditing in
                                                if isEditing {
                                                } else {
                                                    if(soundDataModel.soundURL_S.contains("https://www.youtube.com/") || soundDataModel.soundURL_S.contains("https://youtu.be/")){
                                                    } else {
                                                        soundDataModel.soundURL_S = ""
                                                    }
                                                }
                                            }
                                                      //                                  ,prompt: Text("")
                                            )
                                            .submitLabel(.done)
                                            .background(Color.clear)
                                            .foregroundColor(Color.white)
                                            .font(.title3)
                                            .padding(.horizontal)
                                            .padding(.trailing) // 消去ボタンと文字が被ることを防ぐ
                                            .padding(.trailing)
                                            .padding(.trailing)
                                            
                                            // URL消去ボタン(設定ONで文字が入力されている時に使用可能)
                                            Button(action: {
                                                soundDataModel.soundURL_S = ""
                                            }){
                                                Image(systemName: "multiply.circle.fill")
                                                    .foregroundColor(soundDataModel.soundURL_S != "" ? Color.gray : Color.clear)
                                            }
                                            .disabled(soundDataModel.soundURL_S == "")
                                            .padding(.horizontal)
                                            .padding(.trailing)
                                            
                                        } // URL入力用TextField ZStack ここまで
                                        Text(soundDataModel.soundURL_S != "" ? "  " : "YoutubeのURLを入力してください")
                                            .foregroundColor( Color.red) // ONなら赤、OFFなら透明
                                        // --------------------------------------------------------
                                        
                                        // soundName設定
                                        Text("サウンド名の設定")
                                            .bold()
                                            .padding(.top)
                                        
                                        // Name入力用TextField ZStack
                                        ZStack(alignment: .trailing){
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color("TextFieldColor"))
                                                .frame(height: 35)
                                                .padding(.trailing)
                                            TextField("",text: $soundDataModel.soundName_S
                                                      //                                  ,onEditingChanged: { isEditing2 in
                                                      //                            if isEditing2 {
                                                      //                            } else {
                                                      //
                                                      //                            }
                                                      //                        }
                                                      ,prompt: Text("名称未設定")
                                            )
                                            .submitLabel(.done)
                                            .background(Color.clear)
                                            .foregroundColor(Color.white)
                                            .font(.title3)
                                            .padding(.horizontal)
                                            .padding(.trailing) // 消去ボタンと文字が被ることを防ぐ
                                            .padding(.trailing)
                                            .padding(.trailing)
                                            
                                            // Name消去ボタン(設定ONで文字が入力されている時に使用可能)
                                            Button(action: {
                                                soundDataModel.soundName_S = ""
                                            }){
                                                Image(systemName: "multiply.circle.fill")
                                                    .foregroundColor(soundDataModel.soundName_S != "" ? Color.gray : Color.clear)
                                            }
                                            .disabled(soundDataModel.soundName_S == "")
                                            .padding(.horizontal)
                                            .padding(.trailing)
                                            
                                        } // Name入力用TextField ZStack ここまで
                                        .padding(.bottom)
                                        
                                        // -------------------------------------------------------
                                        
                                        // timeOnOff Button HStack
                                        HStack{
                                            // タイムスタンプButton
                                            Button(action: {
                                                self.soundDataModel.soundTimeOnOff_S.toggle()
                                                
                                                self.showPickerHour = false
                                                self.showPickerMin = false
                                                self.showPickerSec = false
                                            }){
                                                if(soundDataModel.soundTimeOnOff_S){
                                                    Image(systemName: "circle.inset.filled")
                                                        .foregroundColor(Color.green)
                                                        .font(.title2)
                                                    
                                                } else {
                                                    Image(systemName: "circle")
                                                        .foregroundColor(Color.white)
                                                        .font(.title2)
                                                }
                                                
                                            }
                                            //                        .padding(.trailing)
                                            
                                            Text("タイムスタンプ機能")
                                                .bold()
                                                .font(.headline)
                                                .brightness(soundDataModel.soundTimeOnOff_S ? 0.0 : -0.5)
                                        }// timeOnOff Button HStackここまで
                                        .padding(.top)
                                        
                                        // タイムスタンプ時間設定用HStack
                                        HStack{
                                            // "サウンドの設定"に横を揃えるためのクッション用
                                            Image(systemName: "circle.inset.filled")
                                                .foregroundColor(Color.clear)
                                                .font(.title2)
                                            
                                            // 時間入力 VStack
                                            VStack(alignment: .leading){
                                                Text("開始時間")
                                                    .bold()
                                                    .font(.headline)
                                                    .brightness(soundDataModel.soundTimeOnOff_S ? 0.0 : -0.5)
                                                
                                                // 入力列 HStack
                                                HStack{
                                                    // hour用 ZStack
                                                    ZStack{
                                                        Button(action: {
                                                            self.whichPicker = true
                                                            // picker表示切り替え
                                                            self.showPickerHour.toggle()
                                                            self.showPickerMin = false
                                                            self.showPickerSec = false
                                                        }){
                                                            RoundedRectangle(cornerRadius: 10)
                                                                .fill(Color("TextFieldColor"))
                                                                .frame(height: 35)
                                                                .padding(.trailing)
                                                        }
                                                        .disabled(!soundDataModel.soundTimeOnOff_S)
                                                        .brightness(soundDataModel.soundTimeOnOff_S ? 0.0 : -0.5)
                                                        
                                                        Text("\(hourInt)")
                                                            .padding(.trailing)
                                                            .brightness(soundDataModel.soundTimeOnOff_S ? 0.0 : -0.5)
                                                    } // hour用 ZStackここまで
                                                    
                                                    Text("時")
                                                        .brightness(soundDataModel.soundTimeOnOff_S ? 0.0 : -0.5)
                                                    
                                                    // min用 ZStack
                                                    ZStack{
                                                        Button(action: {
                                                            self.whichPicker = true
                                                            // picker表示切り替え
                                                            self.showPickerMin.toggle()
                                                            self.showPickerHour = false
                                                            self.showPickerSec = false
                                                        }){
                                                            RoundedRectangle(cornerRadius: 10)
                                                                .fill(Color("TextFieldColor"))
                                                                .frame(height: 35)
                                                                .padding(.trailing)
                                                        }
                                                        .disabled(!soundDataModel.soundTimeOnOff_S)
                                                        .brightness(soundDataModel.soundTimeOnOff_S ? 0.0 : -0.5)
                                                        
                                                        Text("\(minInt)")
                                                            .padding(.trailing)
                                                            .brightness(soundDataModel.soundTimeOnOff_S ? 0.0 : -0.5)
                                                    } // min用 ZStackここまで
                                                    
                                                    Text("分")
                                                        .brightness(soundDataModel.soundTimeOnOff_S ? 0.0 : -0.5)
                                                    
                                                    // sec用 ZStack
                                                    ZStack{
                                                        Button(action: {
                                                            self.whichPicker = true
                                                            // picker表示切り替え
                                                            self.showPickerSec.toggle()
                                                            self.showPickerHour = false
                                                            self.showPickerMin = false
                                                        }){
                                                            RoundedRectangle(cornerRadius: 10)
                                                                .fill(Color("TextFieldColor"))
                                                                .frame(height: 35)
                                                                .padding(.trailing)
                                                        }
                                                        .disabled(!soundDataModel.soundTimeOnOff_S)
                                                        .brightness(soundDataModel.soundTimeOnOff_S ? 0.0 : -0.5)
                                                        
                                                        Text("\(secInt)")
                                                            .padding(.trailing)
                                                            .brightness(soundDataModel.soundTimeOnOff_S ? 0.0 : -0.5)
                                                    } // sec用 ZStackここまで
                                                    
                                                    Text("秒")
                                                        .brightness(soundDataModel.soundTimeOnOff_S ? 0.0 : -0.5)
                                                } // 入力列 HStackここまで
                                                .padding(.trailing)
                                                //                                Spacer()
                                                Button(action: {
                                                    hourInt = 0
                                                    minInt = 0
                                                    secInt = 0
                                                    // .actionSheetを使って確認メッセージを表示する
                                                    // https://www.choge-blog.com/programming/swiftuiactionsheetshow/
                                                    
                                                }) {
                                                    Text("リセット")
                                                        .frame(maxWidth: .infinity)
                                                        .frame(height: UIScreen.main.bounds.size.width / 6 * 0.45)
                                                }
                                                .foregroundColor(Color.red)
                                                .buttonStyle(.bordered)
                                                .padding(.top)
                                                .padding(.trailing)
                                                .disabled(!soundDataModel.soundTimeOnOff_S)
                                                .brightness(soundDataModel.soundTimeOnOff_S ? 0.0 : -0.5)
                                                
//                                                Spacer()
//                                                Spacer()
                                            }// 時間入力 VStackここまで
                                            .padding(.top)
                                        }// タイムスタンプ時間設定用HStackここまで
                                        
                                        // --------------------------------------------
                                        // repeatTime(リピート再生時間) Button HStack
                                        HStack{
                                            // タイムスタンプButton
                                            Button(action: {
                                                self.RepeatBool.toggle()
                                                
                                                self.showPickerHour = false
                                                self.showPickerMin = false
                                                self.showPickerSec = false
                                                if(!RepeatBool){
                                                    hourIntRe = 0
                                                    minIntRe = 0
                                                    secIntRe = 0
                                                }
                                            }){
                                                if(RepeatBool){
                                                    Image(systemName: "circle.inset.filled")
                                                        .foregroundColor(Color.green)
                                                        .font(.title2)
                                                    
                                                } else {
                                                    Image(systemName: "circle")
                                                        .foregroundColor(Color.white)
                                                        .font(.title2)
                                                }
                                                
                                            }
                                            //                        .padding(.trailing)
                                            
                                            Text("リピート再生")
                                                .bold()
                                                .font(.headline)
                                        }// repeatTime(リピート再生時間) Button HStackここまで
                                        .padding(.bottom)
                                        // リピート再生時間設定用HStack
                                        HStack{
                                            // "サウンドの設定"に横を揃えるためのクッション用
                                            Image(systemName: "circle.inset.filled")
                                                .foregroundColor(Color.clear)
                                                .font(.title2)
                                            
                                            // 時間入力 VStack
                                            VStack(alignment: .leading){
                                                Text("再生時間")
                                                    .bold()
                                                    .font(.headline)
                                                    .brightness(RepeatBool ? 0.0 : -0.5)
                                                
                                                // 入力列 HStack
                                                HStack{
                                                    // hour用 ZStack
                                                    ZStack{
                                                        Button(action: {
                                                            self.whichPicker = false
                                                            // picker表示切り替え
                                                            self.showPickerHour.toggle()
                                                            self.showPickerMin = false
                                                            self.showPickerSec = false
                                                        }){
                                                            RoundedRectangle(cornerRadius: 10)
                                                                .fill(Color("TextFieldColor"))
                                                                .frame(height: 35)
                                                                .padding(.trailing)
                                                        }
                                                        .disabled(!RepeatBool)
                                                        .brightness(RepeatBool ? 0.0 : -0.5)
                                                        
                                                        Text("\(hourIntRe)")
                                                            .padding(.trailing)
                                                            .brightness(RepeatBool ? 0.0 : -0.5)
                                                    } // hour用 ZStackここまで
                                                    
                                                    Text("時")
                                                        .brightness(RepeatBool ? 0.0 : -0.5)
                                                    
                                                    // min用 ZStack
                                                    ZStack{
                                                        Button(action: {
                                                            self.whichPicker = false
                                                            // picker表示切り替え
                                                            self.showPickerMin.toggle()
                                                            self.showPickerHour = false
                                                            self.showPickerSec = false
                                                        }){
                                                            RoundedRectangle(cornerRadius: 10)
                                                                .fill(Color("TextFieldColor"))
                                                                .frame(height: 35)
                                                                .padding(.trailing)
                                                        }
                                                        .disabled(!RepeatBool)
                                                        .brightness(RepeatBool ? 0.0 : -0.5)
                                                        
                                                        Text("\(minIntRe)")
                                                            .padding(.trailing)
                                                            .brightness(RepeatBool ? 0.0 : -0.5)
                                                    } // min用 ZStackここまで
                                                    
                                                    Text("分")
                                                        .brightness(RepeatBool ? 0.0 : -0.5)
                                                    
                                                    // sec用 ZStack
                                                    ZStack{
                                                        Button(action: {
                                                            self.whichPicker = false
                                                            // picker表示切り替え
                                                            self.showPickerSec.toggle()
                                                            self.showPickerHour = false
                                                            self.showPickerMin = false
                                                        }){
                                                            RoundedRectangle(cornerRadius: 10)
                                                                .fill(Color("TextFieldColor"))
                                                                .frame(height: 35)
                                                                .padding(.trailing)
                                                        }
                                                        .disabled(!RepeatBool)
                                                        .brightness(RepeatBool ? 0.0 : -0.5)
                                                        
                                                        Text("\(secIntRe)")
                                                            .padding(.trailing)
                                                            .brightness(RepeatBool ? 0.0 : -0.5)
                                                    } // sec用 ZStackここまで
                                                    
                                                    Text("秒")
                                                        .brightness(RepeatBool ? 0.0 : -0.5)
                                                } // 入力列 HStackここまで
                                                .padding(.trailing)
                                                Button(action: {
                                                    hourIntRe = 0
                                                    minIntRe = 0
                                                    secIntRe = 0
                                                    // .actionSheetを使って確認メッセージを表示する
                                                    // https://www.choge-blog.com/programming/swiftuiactionsheetshow/
                                                    
                                                }) {
                                                    Text("リセット")
                                                        .frame(maxWidth: .infinity)
                                                        .frame(height: UIScreen.main.bounds.size.width / 6 * 0.45)
                                                }
                                                .foregroundColor(Color.red)
                                                .buttonStyle(.bordered)
                                                .padding(.top)
                                                .padding(.trailing)
                                                .disabled(!RepeatBool)
                                                .brightness(RepeatBool ? 0.0 : -0.5)
                                                Spacer()
                                                Spacer()
                                            }// 時間入力 VStackここまで
                                        }// リピート再生時間設定用HStackここまで
                                    } // URL・Name設定VStackここまで
                                    
                                } // URL・Name設定 全体HStackここまで
                                Spacer().frame(height: UIScreen.main.bounds.size.height / 3)
                                    .id("point")
                            } // ScrollViewここまで
                            // ホイール型キーボードが表示されたときにスクロールする
                            .onChange(of: showPickerHour || showPickerMin || showPickerSec){ _ in
                                withAnimation (.easeInOut){
                                    if(showPickerHour || showPickerMin || showPickerSec){
                                        reader.scrollTo("point")
                                    } else {
                                        reader.scrollTo("top")
                                    }
                                }
                            } // onChangeここまで
                        } // ScrollViewReaderここまで
                        
                    } // 全体VStackここまで
                    
                    // ホイール用VStack (キーボードを浮かせないためのSpacerを入れる)
                    VStack{
                        Spacer()
                        
                        if(showPickerHour){
                            SelectPicker(time: whichPicker ? $hourInt : $hourIntRe, showPicker: $showPickerHour, maxTime: 24, prevPicker: Binding.constant(true),nextPicker: $showPickerMin)
                                .offset(y: self.showPickerHour ? geometry.safeAreaInsets.bottom : SelectPicker.viewHeight + geometry.safeAreaInsets.bottom)
                                .frame(height: SelectPicker.viewHeight)
                                .ignoresSafeArea()
                            //                            .transition(.move(edge: .bottom))
                            //                            .animation(.linear(duration: 3),value: false)
                        } else if(showPickerMin){
                            SelectPicker(time: whichPicker ? $minInt : $minIntRe, showPicker: $showPickerMin, maxTime: 60, prevPicker: $showPickerHour, nextPicker: $showPickerSec)
                                .offset(y: self.showPickerMin ? geometry.safeAreaInsets.bottom : SelectPicker.viewHeight + geometry.safeAreaInsets.bottom)
                                .frame(height: SelectPicker.viewHeight)
                                .ignoresSafeArea()
                                .transition(.move(edge: .bottom))
                                .animation(.linear(duration: 3),value: false)
                        } else if(showPickerSec){
                            SelectPicker(time: whichPicker ? $secInt : $secIntRe, showPicker: $showPickerSec, maxTime: 60, prevPicker: $showPickerMin, nextPicker: Binding.constant(true))
                                .offset(y: self.showPickerSec ? geometry.safeAreaInsets.bottom : SelectPicker.viewHeight + geometry.safeAreaInsets.bottom)
                                .frame(height: SelectPicker.viewHeight)
                                .ignoresSafeArea()
                                .transition(.move(edge: .bottom))
                                .animation(.linear(duration: 3),value: false)
                        } // showPicker if ここまで
                    } // ホイール用VStackここまで
                } // ホイール用ZStackここまで
                .padding(.top)
                .navigationBarTitle("サウンド", displayMode: .inline)
            } // VStackここまで
        } // GeometryReaderここまで
        .onAppear{
            secInt = soundDataModel.soundTime_S % 60
            minInt = soundDataModel.soundTime_S / 60 % 60
            hourInt = soundDataModel.soundTime_S / 3600
            
            if(soundDataModel.soundRepeatTime_S != 0){
                RepeatBool = true
            }
            
            secIntRe = soundDataModel.soundRepeatTime_S % 60
            minIntRe = soundDataModel.soundRepeatTime_S / 60 % 60
            hourIntRe = soundDataModel.soundRepeatTime_S / 3600
        } // Appearここまで
    } // budyここまで
    
    // モーダル遷移を閉じるための関数
    private func didTapDismissButton() {
        presentationMode_S.wrappedValue.dismiss()
    }
    
    // 既存設定用indexサーチ関数 (uuid検索)
    private func searchIndex() -> Int {
        var returnIndex: Int?
        for index in 0 ..< items_S.count {
            if(items_S[index].uuid_S == soundDataModel.uuid_S){
                returnIndex = index
            }
        }
        if(returnIndex == nil) {
            return -1
        } else {
            return returnIndex!
        }
    }
} // structここまで

struct SoundCreatView_Previews: PreviewProvider {
    static var previews: some View {
        SoundCreatView(soundDataModel: SoundDataModel())
    }
}
