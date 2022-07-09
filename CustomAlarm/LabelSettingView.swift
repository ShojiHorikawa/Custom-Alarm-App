//
//  LabelSettingView.swift
//  CustomAlarm
//
//  Created by パソコンさん on 2022/07/03.
//

import SwiftUI

struct LabelSettingView: View {
    @Environment(\.presentationMode) var presentation
    
    // フォーカス状態プロパティ
    @FocusState private var nameFieldIsForcused: Bool
    // 戻り値用
    @Binding var label: String
    // 入力用変数
//    @State var inputText: String
    
    var body: some View {
        VStack {
            Spacer()
            //            Spacer()
            //            Spacer()
            ZStack(alignment: .trailing){
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color("TextFieldColor"))
                //                        .fill(Color.secondary)
                    .frame(height: 50)
                    .padding()
                TextField("",text: $label
                          ,onEditingChanged: { isEditing in
                    if isEditing {
                    } else {
                        self.presentation.wrappedValue.dismiss()
                        
                    }
                }
//              ,prompt: Text("")
                )
                .submitLabel(.done)
                .background(Color.clear)
                .focused($nameFieldIsForcused)
                .foregroundColor(Color.white)
                .font(.title2)
                .padding()
                .padding()
                .padding(.trailing) // 消去ボタンと文字が被ることを防ぐ
                .padding(.trailing)
                
                Button(action: {
                    label = ""
                }){
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(Color.gray)
                }
                .padding()
                .padding()
                
            } // ZStackここまで
            Spacer()
        } // VStackここまで
        .navigationTitle("ラベル")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            /// 0.5秒の遅延発生後TextFieldに初期フォーカスをあてる
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                nameFieldIsForcused = true
            }
        }
    }
}
/*
struct TextFieldClearButton: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        HStack{
            content
            
            //クリアボタン
            if !text.isEmpty {
                Button(
                    action: {
                        self.text = ""
                    }
                ){
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(Color.gray)
                        .font(.title)
                }
                
            }
        }
    }
}
*/

struct LabelSettingView_Previews: PreviewProvider {
    static var previews: some View {
        LabelSettingView(label:  Binding.constant("hello"))
    }
}
