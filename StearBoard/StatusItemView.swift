//
//  StatusItemView.swift
//  StearBoard
//
//  Created by 李毓琪 on 2023/7/2.
//
import SwiftUI
import AppKit

class ClipboardHistory: ObservableObject {
    init(_ data: [String]? = nil) {
        guard data != nil else {
            return
        }
        
        items = data!
    }
    
    @Published var items: [String] = []
    @Published var choosedItem = ""
    
    let pasteboard = NSPasteboard.general
    func setClipBoard(_ data: String) {
        pasteboard.clearContents()
        pasteboard.setString(data, forType: .string)
        ChooseItem(data)
    }
    
    func ChooseItem(_ item: String) {
        self.choosedItem = item
    }
    
    func GetChoosedItem() -> String {
        return self.choosedItem
    }
    
    func AddHistory(_ data: String) {
        if !self.items.contains(data) {
            self.items.append(data)
        }
        ChooseItem(data)
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

        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
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
                for type in item.types {
                    if type.rawValue == "public.utf8-plain-text" {
                        if let strValue = item.string(forType: type) {
                            if !clipboardItems.contains(strValue) {
                                clipboardItems.append(strValue)
                                clipboardHistory.AddHistory(strValue)
                            }
                        }
                    }
                }
            }
        }
    }
}
