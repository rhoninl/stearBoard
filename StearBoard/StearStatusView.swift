//
//  StearStatusView.swift
//  StearBoard
//
//  Created by 李毓琪 on 2023/8/16.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBar: StatusBarController?
    var stearWindow = StearWindow()

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusBar = StatusBarController.init(stearWindow)
    }
}

class StatusBarController {
    private var statusItem: NSStatusItem
    private var clipboardItems: [String] = []
    private var stearWindow: StearWindow
    private var popover: NSPopover

    init(_ stearWindow: StearWindow) {
        self.stearWindow = stearWindow
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.title="Stear"
        
        let contentView = StearStatusView()
            .environmentObject(stearWindow)
        
        popover = NSPopover()
        popover.contentSize = NSSize(width: 360, height: 360)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)

        if let button = statusItem.button {
            button.action = #selector(togglePopover(_:))
            button.target = self
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
}

struct StearStatusView: View {
    @State private var settingsWindowController: SettingsWindowController?
    @EnvironmentObject var stears: StearWindow
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Button(action: {
                    if settingsWindowController == nil {
                        let controller = SettingsWindowController()
                        controller.onWindowClose = { [weak controller] in
                            if settingsWindowController === controller {
                                settingsWindowController = nil
                            }
                        }
                        settingsWindowController = controller
                    }
                    settingsWindowController?.showWindow(nil)
                    NSApplication.shared.activate(ignoringOtherApps: true)
                }) {
                    Text("Setting")
                }
                Button(action: {
                    NSApplication.shared.terminate(self)
                }) {
                    Text("X")
                        .font(.title2)
                }
                .padding(.trailing,5)
            }
            .buttonStyle(.plain)
            ScrollView {
                ForEach(stears.stears, id: \.self) { item in
                    ClipboardItem(item, choosed: $stears.choosedId)
                        .onTapGesture {
                            stears.ChooseItem(item.id)
                        }
                    Divider()
                }
            }
            .padding([.leading,.trailing],10)
        }
        .frame(maxWidth: 300, maxHeight: 600)
    }
}

struct StearStatusView_Previews: PreviewProvider {
    static var previews: some View {
        StearStatusView()
    }
}
