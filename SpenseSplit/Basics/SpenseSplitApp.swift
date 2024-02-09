//
//  SpenseSplitApp.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 9/2/24.
//

import SwiftUI

@main
struct SpenseSplitApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let container = CoreDataStack.shared.persistentContainer
    
    var body: some Scene {
        WindowGroup {
            PartiesView()
                .environment(\.managedObjectContext, container.viewContext)
        }
    }
}
