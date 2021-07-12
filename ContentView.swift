//
//  ContentView.swift
//  memories
//
//  Created by Alina Potapova on 08.07.2021.
//

import SwiftUI

struct ContentView: View {
    @State private var showingProfile = true
    var body: some View {
        ZStack {
            TabBarView(pages: .constant([
                TabBarPage(
                    page: ProfileView(),
                    icon: "person.fill",
                    tag: "Profile"
                ),
                TabBarPage(
                    page: MemoriesView(),
                    icon: "cloud.fill",
                    tag: "Memories"
                ),
                TabBarPage(
                    page: SettingsView(),
                    icon: "gear",
                    tag: "Settings"
                )
            ]))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
