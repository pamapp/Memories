//
//  FoldersView.swift
//  memories
//
//  Created by Alina Potapova on 16.08.2021.
//

import SwiftUI

struct FoldersView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel: FolderModel
    
    @State private var searchText: String = ""
    @State private var showAddFolderSheet = false
 
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.mainBackgroundColor
                    .ignoresSafeArea()
            
                VStack {
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach(viewModel.folders.filter{($0.name?.hasPrefix(searchText))! || searchText == ""}) { folder in
                                FolderCellView(folder: folder, isFav: folder.isFavorite, viewModel: FoldersView.FolderModel.init(moc: self.viewContext))
                                    .buttonStyle(FolderButton())
                                    .accentColor(.white)
                                    .padding(.top, 10)
                            }
                        }.searchable(text: $searchText, placement: .navigationBarDrawer)
                    }
                    .padding(.bottom, UIScreen.main.bounds.height / 5 / 7.1)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                }
                
                .navigationTitle("Folders")
                .specialNavBar()
            }
            .accentColor(.white)
        }.navigationViewStyle(.stack)
    }
}
