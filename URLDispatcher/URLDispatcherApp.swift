//
//  URLDispatcherApp.swift
//  URLDispatcher
//
//  Created by Kate Kiely on 5/13/25.
//

import SwiftUI
import AppKit

@main
struct URLDispatcherApp: App {
    // Hook in our AppDelegate to handle URL events
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            Text("URL Dispatcher is running in the menu bar.")
                .padding()
        }
    }
}
