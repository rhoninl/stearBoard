//
//  StearItem.swift
//  StearBoard
//
//  Created by 李毓琪 on 2023/8/15.
//

import Foundation
import AppKit

class StearItem: Hashable, Equatable {
    static func == (lhs: StearItem, rhs: StearItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: String
    var data: NSPasteboardItem?
    
    
    init(_ data: NSPasteboardItem?) {
        if data != nil {
            self.data = copyPastedItem(data!)
        }
        self.id = UUID().uuidString
    }
    
    func GetId() -> String {
        return self.id
    }
    
    func GetDescription() -> String {
        if self.data == nil {
            return "no data"
        }
        return getStringFromItem(self.data!)
    }
    
    func GetType() -> String {
        if self.data!.types.contains(.fileURL) {
            return "📁: "
        }else if self.data!.types.contains(.png) {
            return "image cannot preview"
        }
        
        return ""
    }
}

