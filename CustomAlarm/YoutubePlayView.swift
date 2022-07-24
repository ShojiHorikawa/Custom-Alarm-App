//
//  YoutubePlayView.swift
//  CustomAlarm
//
//  Created by パソコンさん on 2022/07/24.
//

import SwiftUI
import YouTubePlayerKit


struct YoutubePlayView: View {
    //モーダル表示を閉じるdismiss()を使うための変数
    @Environment(\.presentationMode) var presentationModeYT
    //    let youTubePlayer = YouTubePlayer(
    //        source: .url("https://youtu.be/lDay8RVfhv4?t=2542"),
    //        configuration : .init(
    //            isUserInteractionEnabled: false,
    //            autoPlay: false,
    //            loopEnabled: true
    //        )
    //    )
    let youTubePlayer : YouTubePlayer
    let IntervalTime: Int16
    let seekTime: Int16
    
    
    var body: some View {
        VStack{
            HStack{
                // キャンセルボタンを押したらアラーム設定のデータを更新しない
                Button("キャンセル") {
                    didTapDismissButton()
                }
                // アラーム専用の橙色に設定
                .foregroundColor(Color("DarkOrange"))
                .padding()
                Spacer()
            }
            YouTubePlayerView(self.youTubePlayer) { state in
                // Overlay ViewBuilder closure to place an overlay View
                // for the current `YouTubePlayer.State`
                switch state {
                case .idle:
                    ProgressView()
                case .ready:
                    EmptyView()
                case .error(_):
                    Text(verbatim: "YouTube player couldn't be loaded")
                }
            }
        }
        .onAppear{
            youTubePlayer.seek(to: Double(seekTime), allowSeekAhead: true)
            if(IntervalTime != 0) {
                _ = Timer.scheduledTimer(
                    withTimeInterval: TimeInterval(IntervalTime),
                    repeats: true){ _ in
                                                youTubePlayer.seek(to: Double(seekTime), allowSeekAhead: true)
                    }
            }
        }
        .onDisappear{
            youTubePlayer.stop()
        }
    }
    // モーダル遷移を閉じるための関数
    private func didTapDismissButton() {
        presentationModeYT.wrappedValue.dismiss()
    }
}


//struct YoutubePlayView_Previews: PreviewProvider {
//    static var previews: some View {
//        YoutubePlayView(youTubePlayer: YouTubePlayer("https://youtu.be/lDay8RVfhv4?t=2542"),IntervalTime: 10,seekTime: 600)
//    }
//}
