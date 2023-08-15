//
//  StatusItemView.swift
//  StearBoard
//
//  Created by 李毓琪 on 2023/7/2.
//
import SwiftUI
import AppKit

func getStringFromItem(_ input: NSPasteboardItem) -> String {
    if input.types.contains(.png) {
        return "picture cannot preview"
    }
    for type in input.types {
        if type.rawValue == "public.utf8-plain-text" {
            if let strValue = input.string(forType: type) {
                return getType(input)+strValue
            }
        }
    }
    return ""
}

func copyPastedItem(_ pasteboardItem: NSPasteboardItem) -> NSPasteboardItem {
    let copiedItem = NSPasteboardItem()
    for type in pasteboardItem.types {
        copiedItem.setData(pasteboardItem.data(forType: type)!, forType: type)
    }
    return copiedItem
}

func itemsContain(_ items: [NSPasteboardItem], _ item: NSPasteboardItem) -> Bool {
    let des = getStringFromItem(item)
    for existingItem in items {
        if getStringFromItem(existingItem) == des {
            return true
        }
    }
    return false
}

func getType(_ item: NSPasteboardItem) -> String {
    if item.types.contains(.fileURL) {
        return "📁: "
    }else if item.types.contains(.png) {
        return "image cannot preview"
    }
    
    return ""
}
