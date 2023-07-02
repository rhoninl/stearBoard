//
//  StearBoardApp.swift
//  StearBoard
//
//  Created by 李毓琪 on 2023/7/2.
//

import SwiftUI

@main
struct ClipboardApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appDelegate.clipboardHistory)
        }
    }
}

struct ContentView: View {
    var body: some View {
        Text("Clipboard history app is running...")
    }
}
