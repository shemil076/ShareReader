//
//  ShareReaderApp.swift
//  ShareReader
//
//  Created by Pramuditha Karunarathna on 2024-09-23.
//

import SwiftUI

@main
struct ShareReaderApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ImageItem.self)
    }
}
