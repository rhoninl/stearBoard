//
//  StearWindows.swift
//  StearBoard
//
//  Created by 李毓琪 on 2023/8/15.
//

import Foundation
import AppKit

class StearWindow: ObservableObject {
    @Published var stears: [StearItem] = []
    @Published var choosedId: String = ""
    private var windowsSize: Int
    private var recoder: Recorder
    
    init() {
        windowsSize = PlistGetData("DefaultWindowSize")
        print(windowsSize)
        recoder = Recorder()
        
        recoder.StartRecordingClipboard(self.AddItem)
    }
    
    func AddItem(_ data: NSPasteboardItem) {
        let item = StearItem(data)
        if !ContainsDescription(item.GetDescription()) {
            self.stears.insert(item, at: 0)
            self.choosedId = item.id
        }
    }
    
    func ScaleWindowsSize(_ size: Int) {
        let scaledWindows = Array(self.stears.prefix(size))
        if !isItemInWindows(scaledWindows, self.choosedId) {
            self.choosedId = (scaledWindows.first ?? StearItem(nil)).id
        }
        
        self.stears = scaledWindows
    }
    
    func ChooseItem(_ id: String) {
        self.choosedId = id
    }
    
    private func scaleStears() {
        if self.stears.count > windowsSize {
            self.stears = Array(self.stears.prefix(windowsSize))
        }
    }
    
    private func isItemInWindows(_ window: [StearItem], _ id: String) -> Bool {
        var result: Bool = false
        window.forEach { item in
            if item.id == id {
                result = true
            }
        }
            
        return result
    }
    
    func ContainsDescription(_ des: String) -> Bool {
        for stear in self.stears {
            if stear.GetDescription() == des {
                return true
            }
        }
        
        return false
    }
}
