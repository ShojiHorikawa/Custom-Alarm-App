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
    
    // 開始時間(タイムスタンプ)入力用変数
    @State var hourInt = 0
    @State var minInt = 0
    @State var secInt = 0
    
    // picker用bool変数
    @State var showPickerHour: Bool = false
    @State var showPickerMin: Bool = false
    @State var showPickerSec: Bool = false
    
    var body: some View {
        //        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                HStack{
                    Button(action: {
                        self.soundOnOff.toggle()
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
                    
                    
                    Spacer()
                } // HStackここまで
                
                // URL・Name設定 全体VStack
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
                                Spacer()
                                
                                
                            }// 時間入力 VStackここまで
                            .padding(.top)
                        }// タイムスタンプ時間設定用HStackここまで
                    } // URL・Name設定VStackここまで
                } // URL・Name設定 全体HStackここまで
                Spacer()
                
                if(showPickerHour){
                        SelectPicker(time: $hourInt, showPicker: $showPickerHour, maxTime: 24)
                            .offset(y: self.showPickerHour ? geometry.safeAreaInsets.bottom : SelectPicker.viewHeight + geometry.safeAreaInsets.bottom)
                            .frame(height: SelectPicker.viewHeight)
                            .ignoresSafeArea()
//                            .transition(.move(edge: .bottom))
//                            .animation(.linear(duration: 3),value: false)
                } else if(showPickerMin){
                        SelectPicker(time: $minInt, showPicker: $showPickerMin, maxTime: 60)
                            .offset(y: self.showPickerMin ? geometry.safeAreaInsets.bottom : SelectPicker.viewHeight + geometry.safeAreaInsets.bottom)
                            .frame(height: SelectPicker.viewHeight)
                            .ignoresSafeArea()
                            .transition(.move(edge: .bottom))
                            .animation(.linear(duration: 3),value: false)
                } else if(showPickerSec){
                        SelectPicker(time: $secInt, showPicker: $showPickerSec, maxTime: 60)
                            .offset(y: self.showPickerSec ? geometry.safeAreaInsets.bottom : SelectPicker.viewHeight + geometry.safeAreaInsets.bottom)
                            .frame(height: SelectPicker.viewHeight)
                            .ignoresSafeArea()
                            .transition(.move(edge: .bottom))
                            .animation(.linear(duration: 3),value: false)
                }
            } // VStackここまで
            .padding(.top)
            
            .navigationBarTitle("サウンド", displayMode: .inline)
        }
        .onAppear{
            secInt = soundTime % 60
            minInt = soundTime / 60 % 60
            hourInt = soundTime / 3600
        }
        .onDisappear{
            soundTime = hourInt * 3600 + minInt * 60 + secInt
        }
    }
}

//ユーザを入力するキーボード
struct SelectPicker: View {
    
    static let viewHeight: CGFloat = 253
    @Binding  var time: Int
    @Binding  var showPicker: Bool
    let maxTime: Int
    
    var body: some View {
        VStack {
            VStack {
                Rectangle().fill(Color(UIColor.systemGray4)).frame(height: 1)
                
                Spacer().frame(height: 10)
                
                Button(action: {
                    self.showPicker = false
                }) {
                    HStack {
                        Spacer()
                        
                        Text("Done")
                            .font(.headline)
                        
                        Spacer().frame(width: 20)
                    }
                }
                
                Spacer().frame(height: 10)
            }
            .background(Color(UIColor.systemGray6))
            //入力するピッカー
            Picker(selection: self.$time, label: Text("")) {
                ForEach(0 ..< maxTime, id: \.self) {
                    Text("\($0)").tag($0)
                }
            }
            .pickerStyle(.wheel)
//            .background(Color(UIColor.systemGray4))
            .labelsHidden()
        }
    }
}


struct SoundSettingView_Previews: PreviewProvider {
    static var previews: some View {
        SoundSettingView(soundOnOff: Binding.constant(true), soundURL:Binding.constant(""), soundName: Binding.constant(""),soundTime: Binding.constant(0),soundTimeOnOff: Binding.constant(true))
    }
}
