//
//  tanomealApp.swift
//  tanomeal
//
//  Created by 北野正樹 on 2022/08/08.
//

import SwiftUI

@main
struct tanomealApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
