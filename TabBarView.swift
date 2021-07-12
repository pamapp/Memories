//
//  TabBarView.swift
//  memories
//
//  Created by Alina Potapova on 08.07.2021.
//

import SwiftUI

struct TabBarView: View {
    @Binding var pages: [TabBarPage]
    @State var selectedTab = "Memories"
    
    init(pages: Binding<[TabBarPage]>) {
        UITabBar.appearance().isHidden = true
        self._pages = pages
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                ForEach(pages) { item in
                    AnyView(_fromValue: item.page)
                        .tabItem{
                            EmptyView()
                        }.tag(item.tag)
                }
            }
            
            HStack {
                ForEach(pages) { item in
                    Button(action: {
                        self.selectedTab = item.tag
                    }) {
                        VStack {
                            Image(systemName: item.icon)
                                .foregroundColor(self.selectedTab == item.tag ? .black : .gray)
                                .font(Font.system(size: 32))
                                
                        }.padding(10)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 5)
            .padding(.bottom, 20)
            .background(Color.white)
            .cornerRadius(30)
        }.edgesIgnoringSafeArea(.all)
    }
}

struct TabBarPage: Identifiable {
    var id = UUID()
    var page: Any
    var icon: String
    var tag: String
}
