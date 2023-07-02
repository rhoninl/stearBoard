//
//  ClipboardManager.swift
//  StearBoard
//
//  Created by 李毓琪 on 2023/7/2.
//

import Combine
import AppKit

class ClipboardManager: ObservableObject {
    var pasteboard: NSPasteboard
    var cancellable: AnyCancellable?
    var lastChangeCount: Int

    @Published var history: [String] = []

    init() {
        self.pasteboard = NSPasteboard.general
        self.lastChangeCount = pasteboard.changeCount
        startMonitoring()
    }

    func startMonitoring() {
        cancellable = Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .sink { _ in
                if self.pasteboard.changeCount != self.lastChangeCount {
                    self.lastChangeCount = self.pasteboard.changeCount
                    let content = self.readFromClipboard()
                    self.history.append(content)
                }
            }
    }

    func copyToClipboard(content: String) {
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(content, forType: .string)
    }

    func readFromClipboard() -> String {
        guard let items = pasteboard.pasteboardItems else {
            return ""
        }
        for item in items {
            if let str = item.string(forType: .string) {
                return str
            }
        }
        return ""
    }
}
