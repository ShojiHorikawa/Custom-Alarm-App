//
//  SoundSettingView.swift
//  CustomAlarm
//
//  Created by パソコンさん on 2022/07/06.
//

import SwiftUI

struct SoundSettingView: View {
    
    @Environment(\.presentationMode) var presentation
    
    
    @Binding var soundOnOff: Bool
    @Binding var soundURL: String
    @Binding var soundName: String
    @Binding var soundTime: Int
    @Binding var soundTimeOnOff: Bool
    @Binding var soundRepeatTime: Int
    
    
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
        //        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        GeometryReader { geometry in
            // ホイール用ZStack
            ZStack{
                
                // 全体VStack
                VStack(alignment: .leading) {
                    
                    ScrollViewReader { reader in
                        ScrollView(.vertical,showsIndicators: false){
                            HStack{
                                Button(action: {
                                    self.soundOnOff.toggle()
                                    
                                    self.showPickerHour = false
                                    self.showPickerMin = false
                                    self.showPickerSec = false
                                }){
                                    if(soundOnOff){
                                        Image(systemName: "circle.inset.filled")
                                            .foregroundColor(Color.green)
                                            .font(.title)
                                        
                                    } else {
                                        Image(systemName: "circle")
                                            .foregroundColor(Color.white)
                                            .font(.title)
                                    }
                                    
                                }
                                .padding(.horizontal)
                                
                                Text("サウンドの設定")
                                    .bold()
                                    .brightness(soundOnOff ? 0.0 : -0.5)
                                    .font(.title2)
                                    .id("top")
                                
                                
                                Spacer()
                            } // HStackここまで
                            
                            // URL・Name設定 全体HStack
                            HStack(alignment: .top){
                                // "サウンドの設定"に横を揃えるためのクッション用
                                Image(systemName: "circle.inset.filled")
                                    .foregroundColor(Color.clear)
                                    .font(.title)
                                    .padding(.horizontal)
                                
                                // URL・Name設定VStack
                                VStack(alignment: .leading) {
                                    Text("再生する動画のURLを入力")
                                        .bold()
                                        .brightness(soundOnOff ? 0.0 : -0.5)
                                        .padding(.top)
                                    
                                    // URL入力用TextField ZStack
                                    ZStack(alignment: .trailing){
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color("TextFieldColor"))
                                            .frame(height: 35)
                                            .padding(.trailing)
                                        TextField(soundOnOff ? "https://www.youtube.com/" : "",text: $soundURL
                                                  ,onEditingChanged: { isEditing in
                                            if isEditing {
                                            } else {
                                                if(soundURL.contains("https://www.youtube.com/") || soundURL.contains("https://youtu.be/")){
                                                } else {
                                                    soundURL = ""
                                                }
                                            }
                                        }
                                                  //                                  ,prompt: Text("")
                                        )
                                        .submitLabel(.done)
                                        .background(Color.clear)
                                        .foregroundColor(Color.white)
                                        .font(.title3)
                                        .disabled(!soundOnOff)
                                        .brightness(soundOnOff ? 0.0 : -0.5)
                                        .padding(.horizontal)
                                        .padding(.trailing) // 消去ボタンと文字が被ることを防ぐ
                                        .padding(.trailing)
                                        .padding(.trailing)
                                        
                                        // URL消去ボタン(設定ONで文字が入力されている時に使用可能)
                                        Button(action: {
                                            soundURL = ""
                                        }){
                                            Image(systemName: "multiply.circle.fill")
                                                .foregroundColor(soundOnOff && soundURL != "" ? Color.gray : Color.clear)
                                        }
                                        .disabled(!soundOnOff || soundURL == "")
                                        .padding(.horizontal)
                                        .padding(.trailing)
                                        
                                    } // URL入力用TextField ZStack ここまで
                                    Text(soundURL != "" ? "  " : "YoutubeのURLを入力してください")
                                        .foregroundColor(soundOnOff ? Color.red : Color.clear) // ONなら赤、OFFなら透明
                                    
                                    // --------------------------------------------------------
                                    
                                    // soundName設定
                                    Text("サウンド名の設定")
                                        .bold()
                                        .brightness(soundOnOff ? 0.0 : -0.5)
                                        .padding(.top)
                                    
                                    // Name入力用TextField ZStack
                                    ZStack(alignment: .trailing){
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color("TextFieldColor"))
                                            .frame(height: 35)
                                            .padding(.trailing)
                                        TextField("",text: $soundName
                                                  //                                  ,onEditingChanged: { isEditing2 in
                                                  //                            if isEditing2 {
                                                  //                            } else {
                                                  //
                                                  //                            }
                                                  //                        }
                                                  ,prompt: Text(soundOnOff ? "名称未設定" : "")
                                        )
                                        .submitLabel(.done)
                                        .background(Color.clear)
                                        .foregroundColor(Color.white)
                                        .font(.title3)
                                        .disabled(!soundOnOff)
                                        .brightness(soundOnOff ? 0.0 : -0.5)
                                        .padding(.horizontal)
                                        .padding(.trailing) // 消去ボタンと文字が被ることを防ぐ
                                        .padding(.trailing)
                                        .padding(.trailing)
                                        
                                        // Name消去ボタン(設定ONで文字が入力されている時に使用可能)
                                        Button(action: {
                                            soundName = ""
                                        }){
                                            Image(systemName: "multiply.circle.fill")
                                                .foregroundColor(soundOnOff && soundName != "" ? Color.gray : Color.clear)
                                        }
                                        .disabled(!soundOnOff || soundName == "")
                                        .padding(.horizontal)
                                        .padding(.trailing)
                                        
                                    } // Name入力用TextField ZStack ここまで
                                    .padding(.bottom)
                                    
                                    // -------------------------------------------------------
                                    
                                    // timeOnOff Button HStack
                                    HStack{
                                        // タイムスタンプButton
                                        Button(action: {
                                            self.soundTimeOnOff.toggle()
                                            
                                            self.showPickerHour = false
                                            self.showPickerMin = false
                                            self.showPickerSec = false
                                        }){
                                            if(soundTimeOnOff){
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
                                        .brightness(soundOnOff ? 0.0 : -0.5)
                                        .disabled(!soundOnOff)
                                        
                                        Text("タイムスタンプ機能")
                                            .bold()
                                            .font(.headline)
                                            .brightness(soundOnOff && soundTimeOnOff ? 0.0 : -0.5)
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
                                                .brightness(soundOnOff && soundTimeOnOff ? 0.0 : -0.5)
                                            
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
                                                    .disabled(!soundOnOff || !soundTimeOnOff)
                                                    .brightness(soundOnOff && soundTimeOnOff ? 0.0 : -0.5)
                                                    
                                                    Text("\(hourInt)")
                                                        .padding(.trailing)
                                                        .brightness(soundOnOff && soundTimeOnOff ? 0.0 : -0.5)
                                                } // hour用 ZStackここまで
                                                
                                                Text("時")
                                                    .brightness(soundOnOff && soundTimeOnOff ? 0.0 : -0.5)
                                                
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
                                                    .disabled(!soundOnOff || !soundTimeOnOff)
                                                    .brightness(soundOnOff && soundTimeOnOff ? 0.0 : -0.5)
                                                    
                                                    Text("\(minInt)")
                                                        .padding(.trailing)
                                                        .brightness(soundOnOff && soundTimeOnOff ? 0.0 : -0.5)
                                                } // min用 ZStackここまで
                                                
                                                Text("分")
                                                    .brightness(soundOnOff && soundTimeOnOff ? 0.0 : -0.5)
                                                
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
                                                    .disabled(!soundOnOff || !soundTimeOnOff)
                                                    .brightness(soundOnOff && soundTimeOnOff ? 0.0 : -0.5)
                                                    
                                                    Text("\(secInt)")
                                                        .padding(.trailing)
                                                        .brightness(soundOnOff && soundTimeOnOff ? 0.0 : -0.5)
                                                } // sec用 ZStackここまで
                                                
                                                Text("秒")
                                                    .brightness(soundOnOff && soundTimeOnOff ? 0.0 : -0.5)
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
                                            .disabled(!soundOnOff || !soundTimeOnOff)
                                            .brightness(soundOnOff && soundTimeOnOff ? 0.0 : -0.5)
                                            
                                            Spacer()
                                            Spacer()
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
                                        .brightness(soundOnOff ? 0.0 : -0.5)
                                        .disabled(!soundOnOff)
                                        
                                        Text("リピート再生")
                                            .bold()
                                            .font(.headline)
                                            .brightness(soundOnOff ? 0.0 : -0.5)
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
                                                .brightness(soundOnOff && RepeatBool ? 0.0 : -0.5)
                                            
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
                                                    .disabled(!soundOnOff || !RepeatBool)
                                                    .brightness(soundOnOff && RepeatBool ? 0.0 : -0.5)
                                                    
                                                    Text("\(hourIntRe)")
                                                        .padding(.trailing)
                                                        .brightness(soundOnOff && RepeatBool ? 0.0 : -0.5)
                                                } // hour用 ZStackここまで
                                                
                                                Text("時")
                                                    .brightness(soundOnOff && RepeatBool ? 0.0 : -0.5)
                                                
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
                                                    .disabled(!soundOnOff || !RepeatBool)
                                                    .brightness(soundOnOff && RepeatBool ? 0.0 : -0.5)
                                                    
                                                    Text("\(minIntRe)")
                                                        .padding(.trailing)
                                                        .brightness(soundOnOff && RepeatBool ? 0.0 : -0.5)
                                                } // min用 ZStackここまで
                                                
                                                Text("分")
                                                    .brightness(soundOnOff && RepeatBool ? 0.0 : -0.5)
                                                
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
                                                    .disabled(!soundOnOff || !RepeatBool)
                                                    .brightness(soundOnOff && RepeatBool ? 0.0 : -0.5)
                                                    
                                                    Text("\(secIntRe)")
                                                        .padding(.trailing)
                                                        .brightness(soundOnOff && RepeatBool ? 0.0 : -0.5)
                                                } // sec用 ZStackここまで
                                                
                                                Text("秒")
                                                    .brightness(soundOnOff && RepeatBool ? 0.0 : -0.5)
                                            } // 入力列 HStackここまで
                                            .padding(.trailing)
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
                        }
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
        } // GeometryReaderここまで
        .onAppear{
            secInt = soundTime % 60
            minInt = soundTime / 60 % 60
            hourInt = soundTime / 3600
            
            if(soundRepeatTime != 0){
                RepeatBool = true
            }
            secIntRe = soundRepeatTime % 60
            minIntRe = soundRepeatTime / 60 % 60
            hourIntRe = soundRepeatTime / 3600
        }
        .onDisappear{
            soundTime = hourInt * 3600 + minInt * 60 + secInt
            
            soundRepeatTime = hourIntRe * 3600 + minIntRe * 60 + secIntRe
        }
    }
}

//ユーザを入力するキーボード
struct SelectPicker: View {
    
    static let viewHeight: CGFloat = 253
    @Binding  var time: Int
    @Binding  var showPicker: Bool
    let maxTime: Int
    
    // キーボード切り替え用Bool変数 移動先がない場合はtrueを渡す
    @Binding var prevPicker: Bool
    @Binding var nextPicker: Bool
    
    var body: some View {
        VStack {
            VStack {
                Rectangle().fill(Color(UIColor.systemGray3)).frame(height: 1)
                
                Spacer().frame(height: 12)
                
                HStack{
                    
                    Spacer().frame(width: 20)
                    
                    // ∧ Button
                    Button(action: {
                        self.showPicker = false
                        self.prevPicker = true
                    }){
                        Image(systemName: "chevron.up")
                            .font(.title2)
                            .foregroundColor(prevPicker ? Color.gray : Color("DarkOrange"))
                    }
                    .disabled(prevPicker)
                    
                    Spacer().frame(width: 20)
                    // ∨ Button
                    Button(action: {
                        self.showPicker = false
                        self.nextPicker = true
                    }){
                        Image(systemName: "chevron.down")
                            .font(.title2)
                            .foregroundColor(nextPicker ? Color.gray : Color("DarkOrange"))
                    }
                    .disabled(nextPicker)
                    Spacer()
                    
                    // Done Button
                    Button(action: {
                        self.showPicker = false
                    }) {
                        
                        Text("Done")
                            .font(.headline)
                        
                        Spacer().frame(width: 20)
                        
                    }
                } // HStackここまで
                Spacer().frame(height: 12)
                
            } // 2nd VStackここまで
            .background(Color("TextFieldColor"))
            //入力するピッカー
            Picker(selection: self.$time, label: Text("")) {
                ForEach(0 ..< maxTime, id: \.self) {
                    Text("\($0)").tag($0)
                }
            } // Pickerここまで
            .pickerStyle(.wheel)
            .background(Color.black)
            .labelsHidden()
        } // 1st VStackここまで
    } // bodyここまで
} // structここまで


struct SoundSettingView_Previews: PreviewProvider {
    static var previews: some View {
        SoundSettingView(soundOnOff: Binding.constant(true), soundURL:Binding.constant(""), soundName: Binding.constant(""),soundTime: Binding.constant(0),soundTimeOnOff: Binding.constant(true),soundRepeatTime: Binding.constant(0))
    }
}
