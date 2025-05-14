//
//  AppDelegate.swift
//  URLDispatcher
//
//  Created by Kate Kiely on 5/13/25.
//

import Cocoa
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSAppleEventManager.shared().setEventHandler(
            self,
            andSelector: #selector(handleGetURLEvent(event:replyEvent:)),
            forEventClass: AEEventClass(kInternetEventClass),
            andEventID: AEEventID(kAEGetURL)
        )

        // Hide Dock icon so app lives in menu bar only
        NSApp.setActivationPolicy(.accessory)
    }

    @objc func handleGetURLEvent(event: NSAppleEventDescriptor, replyEvent: NSAppleEventDescriptor) {
        guard let urlString = event.paramDescriptor(forKeyword: keyDirectObject)?.stringValue,
              let url = URL(string: urlString) else { return }
        route(url: url)
    }

    private func route(url: URL) {
        let host = url.host?.lowercased() ?? ""
        var targetBundleID: String?

        switch host {
        case "app.hubspot.com":
            targetBundleID = "com.google.Chrome.app.ochaflpillnjdnmnebehmfdjnpnhaaff"
        // Add more domains and their bundle IDs here
        default:
            // Fallback to default browser
            NSWorkspace.shared.open(url)
            return
        }

        if let bundleID = targetBundleID,
           let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleID) {
            let config = NSWorkspace.OpenConfiguration()
            // Pass the URL as an argument to the PWA wrapper
            config.arguments = [url.absoluteString]
            config.activates = true
            NSWorkspace.shared.openApplication(at: appURL, configuration: config) { (app, error) in
                if let error = error {
                    NSLog("URLDispatcher failed to open \(appURL) with URL \(url): \(error)")
                }
            }
        }
    }
}
