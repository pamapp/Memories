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
                        ForEach(viewModel.folders) { folder in
                            FolderCellView(folder: folder, isFav: folder.isFavorite, viewModel: FoldersView.FolderModel.init(moc: self.viewContext))
                        }
                        RoundedRectangle(cornerRadius: 30)
                            .stroke()
                            .foregroundColor(Color(UIColor.separator))
                            .frame(width: UIScreen.main.bounds.width / 2.5, height: UIScreen.main.bounds.width / 2.2, alignment: .center)
                            .overlay (
                                Button {
                                    self.showAddFolderSheet.toggle()
                                } label: {
                                    Image(systemName: "folder.fill.badge.plus")
                                        .foregroundColor(Color(UIColor.separator))
                                        .font(.system(size: 40))
                                }
                                .sheet(isPresented: $showAddFolderSheet) {
                                    FolderAddView(viewModel: FoldersView.FolderModel.init(moc: self.viewContext))
                                }
                            ).padding(.bottom, 25)
                    }
                }
                .offset(y: 10)

//                Button {
//                    self.showAddFolderSheet.toggle()
//                } label: {
//                     Circle()
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
        .accentColor(.purple)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
