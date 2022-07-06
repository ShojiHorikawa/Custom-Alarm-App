//
//  LabelSettingView.swift
//  CustomAlarm
//
//  Created by パソコンさん on 2022/07/03.
//

import SwiftUI

struct LabelSettingView: View {
    @Environment(\.presentationMode) var presentation
    // 戻り値用
    @Binding var label: String
    // 入力用変数
    @State var inputText: String
    
    var body: some View {
        VStack {
            Spacer()
//            Spacer()
//            Spacer()
            ZStack(alignment: .trailing){
                TextField("ラベル",text: $inputText
                      ,onEditingChanged: { isEditing in
                                          if isEditing {
                                              self.label = inputText
                                          } else {
                                              self.label = inputText
                                              self.presentation.wrappedValue.dismiss()
                                          }
                                      }
//                    ,prompt: Text("ラベル")
                )
                    .textFieldStyle(RoundedBorderTextFieldStyle())
    //                .background(Color.secondary)
//                    .modifier(TextFieldClearButton(text: $inputText))
                    .font(.system(size: 25))
                    .padding()
    //                .colorMultiply(Color(red: 44/255, green: 44/255, blue: 46/255))
                    .onSubmit {
                        label = inputText
                    }
                
                Button(action: {
                    inputText = ""
                }){
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(Color.gray)
                }
                .padding()
                .padding()
            }
//            Spacer()
            Spacer()
        } // VStackここまで
        .navigationTitle("ラベル")
        .navigationBarTitleDisplayMode(.inline)
    }
}

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
                }
                
            }
        }
    }
    
    
}

struct LabelSettingView_Previews: PreviewProvider {
    static var previews: some View {
        LabelSettingView(label:  Binding.constant("hello"),inputText: "hello")
    }
}
