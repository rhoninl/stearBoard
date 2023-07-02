//
//  ClipboardHistoryView.swift
//  StearBoard
//
//  Created by 李毓琪 on 2023/7/2.
//

import SwiftUI

struct ClipboardHistoryView: View {
    @EnvironmentObject var clipboardHistory: ClipboardHistory
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Button(action: {
                    NSApplication.shared.terminate(self)
                }) {
                    Text("X")
                        .font(.title2)
                }
                .padding(.trailing,5)
                .buttonStyle(.plain)
            }
            ScrollView {
                ForEach(clipboardHistory.items, id: \.self) { item in
                    ClipboardItem(item, choosed: $clipboardHistory.choosedItem)
                        .onTapGesture {
                            clipboardHistory.setClipBoard(item)
                        }
                    Divider()
                }
            }
            .padding([.leading,.trailing],10)
        }
        .frame(maxWidth: 300, maxHeight: 600)
    }
}

//struct ClipboardHistoryView_Previews:
//    PreviewProvider {
//    static var previews: some View {
//        let testData = [
//            "123",
//            "test",
//            "this is the thins"
//        ]
//        ClipboardHistoryView()
//            .environmentObject(ClipboardHistory(testData))
//    }
//}
