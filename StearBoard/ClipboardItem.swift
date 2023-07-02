//
//  ClipboardItem.swift
//  StearBoard
//
//  Created by 李毓琪 on 2023/7/2.
//

import SwiftUI
import AppKit

struct ClipboardItem: View{
    var item: NSPasteboardItem
    var choosed: Binding<String>
    var des: String
    
    init(_ item: NSPasteboardItem, choosed: Binding<String>) {
        self.item = item
        self.choosed = choosed
        self.des = getStringFromItem(item)
    }
    
    var body: some View {
        HStack{
            Text(des)
            Spacer()
            if choosed.wrappedValue == des {
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

