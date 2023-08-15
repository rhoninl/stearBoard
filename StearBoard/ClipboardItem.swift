//
//  ClipboardItem.swift
//  StearBoard
//
//  Created by 李毓琪 on 2023/7/2.
//

import SwiftUI
import AppKit

struct ClipboardItem: View{
    var item: StearItem
    var choosed: Binding<String>
    
    init(_ item: StearItem, choosed: Binding<String>) {
        self.item = item
        self.choosed = choosed
    }
    
    var body: some View {
        HStack{
            Text(item.GetDescription())
            Spacer()
            if choosed.wrappedValue == item.id {
                Text("✅")
            }
        }
        .padding(1)
    }
}

//struct ClipboardItem_Previews: PreviewProvider {
//    static var previews: some View {
//        ClipboardItem(NSPasteboardItem(), choosed: .constant("item"))
//    }
//}

