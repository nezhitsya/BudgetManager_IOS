//
//  Budget_ManagerApp.swift
//  Budget_Manager
//
//  Created by 이다영 on 2021/05/28.
//

import SwiftUI

@main
struct Budget_ManagerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
