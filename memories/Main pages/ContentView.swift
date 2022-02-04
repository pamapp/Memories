//
//  ContentView.swift
//  memories
//
//  Created by Alina Potapova on 02.02.2022.
//

import SwiftUI

struct ContentView: View {
    
    let persistenceController = PersistenceController.shared
    
    var body: some View {
        TabBarView(pages: .constant([
            TabBarPage(
                page: LocationView()
                    .preferredColorScheme(.dark),
                icon: "map",
                fillIcon: "map.fill",
                tag: "Location"
            ),
            TabBarPage(
                page:
                    FoldersView(viewModel: FoldersView.FolderModel.init(moc: persistenceController.container.viewContext))
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .preferredColorScheme(.dark),
                icon: "cloud",
                fillIcon: "cloud.fill",
                tag: "Memories"
            ),
            TabBarPage(
                page:
                    Text("Add View")
                    .preferredColorScheme(.dark),
                icon: "plus",
                fillIcon: "plus",
                tag: "Add"
            ),
            TabBarPage(
                page:
                    Text("Dreams View")
                    .preferredColorScheme(.dark),
                icon: "moon",
                fillIcon: "moon.fill",
                tag: "Dreams"
            ),TabBarPage(
                page:
                    Text("Settings View")
                    .preferredColorScheme(.dark),
                icon: "gearshape",
                fillIcon: "gearshape.fill",
                tag: "Settings"
            )
        ]))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
