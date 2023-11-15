//
//  MoviesAppApp.swift
//  MoviesApp
//
//  Created by Vitalii Navrotskyi on 15.11.2023.
//

import SwiftUI

@main
struct MoviesAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
