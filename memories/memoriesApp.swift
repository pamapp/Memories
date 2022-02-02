//
//  memoriesApp.swift
//  memories
//
//  Created by Alina Potapova on 08.07.2021.
//

import SwiftUI

@main
struct memoriesApp: App {
//    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
//            FoldersView(viewModel: FoldersView.FolderModel.init(moc: persistenceController.container.viewContext))
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//                .preferredColorScheme(.dark)
        }
    }
}
