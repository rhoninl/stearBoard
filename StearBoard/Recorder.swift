//
//  Recorder.swift
//  StearBoard
//
//  Created by 李毓琪 on 2023/8/16.
//

import Foundation
import AppKit

class Recorder {
    var timer: Timer?
    
    func StartRecordingClipboard(_ callback: @escaping ((NSPasteboardItem) -> Void)) {
        let pasteboard = NSPasteboard.general
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if let items = pasteboard.pasteboardItems, items.count > 0 {
                for item in items {
                    callback(item)
                }
            }
        }
    }
    
    func StopRecordClipboard() {
        timer?.invalidate()
        timer = nil
    }
}
