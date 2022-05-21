//
//  TabBarView.swift
//  memories-appstore-version
//
//  Created by Alina Potapova on 29.01.2022.
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
            
            ZStack {
                HStack {
                    ForEach(pages) { item in
                        Button(action: {
                            self.selectedTab = item.tag
                        }) {
                            VStack {
                                if item.tag != "Add" {
                                    Image(systemName: self.selectedTab == item.tag ? item.fillIcon : item.icon)
                                        .foregroundColor(.white)
                                        .font(Font.system(size: 28))
                                }
                            }
                            .padding(15)
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding(.top, 4)
                .padding(.bottom, 18)
                .background(Color.tabColor)
                .cornerRadius(20)
                
                HStack {
                    Circle()
                        .frame(width: 80, height: 80)
                        .offset(y: -22)
                        .foregroundColor(.tabButtonColor)
                        .overlay(
                            ForEach(pages) { item in
                                Button(action: {
                                    self.selectedTab = item.tag
                                }) {
                                    VStack() {
                                        if item.tag == "Add" {
                                            Image(systemName: item.icon)
                                                .foregroundColor(.white)
                                                .font(.system(size: 30))
                                        }
                                    }
                                }
                                .frame(width: 80, height: 80)
                                .padding(.bottom, 44)
                            }
                        )
                }
            }
        }.edgesIgnoringSafeArea(.all)
    }
}

struct TabBarPage: Identifiable {
    var id = UUID()
    var page: Any
    var icon: String
    var fillIcon: String
    var tag: String
}
