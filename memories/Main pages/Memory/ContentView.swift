//
//  ContentVie.swift
//  memories
//
//  Created by Alina Potapova on 12.08.2021.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var dataController = DataController()
    
    var body: some View {
        FoldersView()
            .environment(\.managedObjectContext, dataController.context)
            .environmentObject(dataController)
//        MemoriesView()
//            .environment(\.managedObjectContext, dataController.context)
//            .environmentObject(dataController)

    }
}
