//
//  StatusItemView.swift
//  StearBoard
//
//  Created by 李毓琪 on 2023/7/2.
//
import SwiftUI
import AppKit


class ClipboardHistory: ObservableObject {
    init(_ data: [NSPasteboardItem]? = nil) {
        guard data != nil else {
            return
        }
        
        items = data!
    }
    
    @Published var items: [NSPasteboardItem] = []
    @Published var choosedItem: String = ""
    
    let pasteboard = NSPasteboard.general
    func setClipBoard(_ data: NSPasteboardItem) {
        pasteboard.clearContents()
        pasteboard.writeObjects([copyPastedItem(data)])
        ChooseItem(data)
    }
    
    func ChooseItem(_ item: NSPasteboardItem) {
        let des = getStringFromItem(item)
        if self.choosedItem != des {
            self.choosedItem = des
        }
    }
    
    func AddHistory(_ data: NSPasteboardItem) {
        let cp = copyPastedItem(data)
        if !itemsContain(self.items,data) {
            self.items.insert(cp, at: 0)
        }
        if self.items.count >= 30 {
            self.items = Array(self.items.prefix(30))
        }
        ChooseItem(cp)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBar: StatusBarController?
    var clipboardHistory = ClipboardHistory()

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusBar = StatusBarController.init(clipboardHistory)
    }
}

class StatusBarController {
    private var statusItem: NSStatusItem
    private var clipboardItems: [String] = []
    private var clipboardHistory: ClipboardHistory
    private var popover: NSPopover

    let pasteboard = NSPasteboard.general


    init(_ clipboardHistory: ClipboardHistory) {
        self.clipboardHistory = clipboardHistory
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.title="Stear"
        
        let contentView = ClipboardHistoryView()
            .environmentObject(clipboardHistory)
        
        popover = NSPopover()
        popover.contentSize = NSSize(width: 360, height: 360)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)

        if let button = statusItem.button {
            button.action = #selector(togglePopover(_:))
            button.target = self
        }

        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.updateClipBoard()
        }
    }

    @objc func togglePopover(_ sender: AnyObject) {
        if popover.isShown {
            popover.performClose(sender)
        } else {
            if let button = statusItem.button {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }

    @objc func updateClipBoard() {
        if let items = pasteboard.pasteboardItems, items.count > 0 {
            for item in items {
                clipboardHistory.AddHistory(item)
            }
        }
    }
}

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
