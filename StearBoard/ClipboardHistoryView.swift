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
        ScrollView {
            ForEach(clipboardHistory.items, id: \.self) { item in
                ClipboardItem(item, choosed: $clipboardHistory.choosedItem)
                    .onTapGesture {
                        clipboardHistory.setClipBoard(item)
                    }
                
                Divider()
            }
        }
        .frame(maxWidth: 300, maxHeight: 600)
        .padding()
    }
}

struct ClipboardHistoryView_Previews:
    PreviewProvider {
    static var previews: some View {
        let testData = [
            "123",
            "test",
            "this is the thins"
        ]
        ClipboardHistoryView()
            .environmentObject(ClipboardHistory(testData))
    }
}
