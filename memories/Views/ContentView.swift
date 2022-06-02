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
                page:
                    LocationView(
                        viewLocationModel: LocationSelectView.LocationModel.init(
                            moc: persistenceController.container.viewContext
                        )
                    )
                    .preferredColorScheme(.dark),
                icon: "map",
                fillIcon: "map.fill",
                tag: "Location"
            ),
            TabBarPage(
                page:
                    FoldersView(
                        viewModel: FoldersView.FolderModel.init(
                            moc: persistenceController.container.viewContext
                        )
                    )
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .preferredColorScheme(.dark),
                icon: "cloud",
                fillIcon: "cloud.fill",
                tag: "Memories"
            ),
            TabBarPage(
                page:
                    SelectAddView(
                        viewModel: FoldersView.FolderModel.init(
                            moc: persistenceController.container.viewContext
                        )
                    )
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .preferredColorScheme(.dark),
                icon: "plus",
                fillIcon: "plus",
                tag: "Add"
            ),
            TabBarPage(
                page:
                    ProfileView(
                        viewLocationModel: LocationSelectView.LocationModel.init(
                            moc: persistenceController.container.viewContext
                        ),
                        viewFolderModel: FoldersView.FolderModel.init(
                            moc: persistenceController.container.viewContext
                        ),
                        viewMemoryModel: MemoriesView.MemoryModel.init(
                            moc: persistenceController.container.viewContext,
                            folder: FoldersView.FolderModel.init(
                                moc: persistenceController.container.viewContext
                            ).getDefaultFolder()
                        ),
                        viewUserModel: ProfileView.UserModel.init(
                            moc: persistenceController.container.viewContext
                        )
                    )
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .preferredColorScheme(.dark),
                icon: "person",
                fillIcon: "person.fill",
                tag: "Profile"
            ),TabBarPage(
                page:
                    SettingsView(
                        viewUserModel: ProfileView.UserModel.init(
                            moc: persistenceController.container.viewContext
                        ),
                        image: ProfileView.UserModel.init(
                            moc: persistenceController.container.viewContext
                        ).getDefaultUserImage(),
                        name: ProfileView.UserModel.init(
                            moc: persistenceController.container.viewContext
                        ).getDefaultUser().name ?? "Username",
                        user: ProfileView.UserModel.init(
                            moc: persistenceController.container.viewContext
                        ).getDefaultUser()
                    )
                    .preferredColorScheme(.dark),
                icon: "gearshape",
                fillIcon: "gearshape.fill",
                tag: "Settings"
            )
        ])).onAppear {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            AppDelegate.orientationLock = .portrait
        }
    }
}


