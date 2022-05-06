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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
//            FoldersView(viewModel: FoldersView.FolderModel.init(moc: persistenceController.container.viewContext))
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//                .preferredColorScheme(.dark)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
        
    static var orientationLock = UIInterfaceOrientationMask.all //By default you want all your views to rotate freely

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}
