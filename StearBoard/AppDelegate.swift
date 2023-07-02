//
//  AppDelegate.swift
//  StearBoard
//
//  Created by 李毓琪 on 2023/7/2.
//

import Foundation
import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    // 为了简便，我们只保留最近的五个剪切板条目
    var clipHistory: [String] = []

    // 每隔一秒检查一次剪切板
    var timer: Timer?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // 在启动时检查一次剪切板
        checkPasteboard()

        // 然后每隔一秒检查一次
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.checkPasteboard()
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // 在程序终止时取消计时器
        timer?.invalidate()
    }

    func checkPasteboard() {
        let pasteboard = NSPasteboard.general
        let pasteboardItems = pasteboard.pasteboardItems
        let pasteboardString = pasteboardItems?.first?.string(forType: .string)

        if let string = pasteboardString, !clipHistory.contains(string) {
            clipHistory.append(string)

            // 如果我们超过了5个条目，那就移除最旧的一个
            if clipHistory.count > 5 {
                clipHistory.removeFirst()
            }

            print("剪切板历史: \(clipHistory)")
        }
    }
}
