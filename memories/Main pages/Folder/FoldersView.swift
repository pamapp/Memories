//
//  SwiftUIView.swift
//  memories
//
//  Created by Alina Potapova on 16.08.2021.
//

import SwiftUI

struct FoldersView: View {
    @EnvironmentObject private var dataController: DataController
    @FetchRequest(entity: Folder.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Folder.isFavorite, ascending: false),]) var folders: FetchedResults<Folder>
    
    @State private var showAddFolderSheet = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(folders) { folder in
                            FolderCellView(folder: folder, isFav: folder.isFavorite)
                                .environmentObject(dataController)
                        }
                        RoundedRectangle(cornerRadius: 30)
                            .stroke()
                            .foregroundColor(Color(UIColor.separator))
                            .frame(width: 155, height: 155, alignment: .center)
                            .overlay (
                                Button {
                                    self.showAddFolderSheet.toggle()
                                } label: {
                                    Image(systemName: "folder.fill.badge.plus")
                                        .foregroundColor(Color(UIColor.separator))
                                        .font(.system(size: 40)) 
                                }.sheet(isPresented: $showAddFolderSheet) {
                                    FolderAddView()
                                }
                            ).padding(.bottom, 25)
                    }
                }
                .padding(.top, 15)

//                Button {
//                    self.showAddFolderSheet.toggle()
//                } label: {
//                    Circle()
//                        .foregroundColor(Color(UIColor.separator))
//                        .frame(width: 80, height: 80, alignment: .center)
//                        .overlay(
//                            Image(systemName: "folder.fill")
//                                .foregroundColor(.white)
//                                .font(.system(size: 30))
//                                .padding(.bottom, 5)
//                        )
//                }.sheet(isPresented: $showAddFolderSheet) {
//                    FolderAddView()
//                }
            }
            .navigationTitle("Folders")
        }
        .accentColor(.red)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
