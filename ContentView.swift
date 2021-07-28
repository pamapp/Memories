//
//  ContentView.swift
//  memories
//
//  Created by Alina Potapova on 08.07.2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MemoriesView()
            .environmentObject(MemoryData()).preferredColorScheme(.dark)
    }
}


//
//struct ContentView: View {
//    @State private var showingProfile = true
//    var body: some View {
//        ZStack {
//            TabBarView(pages: .constant([
//                TabBarPage(
//                    page: MemoriesView()
//                        .environmentObject(MemoryData()),
//                    icon: "cloud.fill",
//                    tag: "Memories"
//                )
//            ]))
//        }
//    }
//}
