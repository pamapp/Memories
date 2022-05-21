//
//  MemoriesView.swift
//  memories
//
//  Created by Alina Potapova on 09.07.2021.
//

import SwiftUI

struct MemoriesView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    
    @ObservedObject var viewModel: MemoryModel
    @ObservedObject var viewFolderModel: FoldersView.FolderModel
    @ObservedObject var viewLocationModel: LocationSelectView.LocationModel
    
    @State private var searchText: String = ""
    @State private var showAddMemory = false
    @State private var showEditFolder = false
    @State private var showDeleteFolder = false
    
    @State var date = Date()
    
    var folder: Folder
    
    let imageHeight = UIScreen.main.bounds.height / 4
    let infoWidth = UIScreen.main.bounds.width / 2
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var searchResult: [Memory] {
        if searchText.isEmpty {
            return viewModel.memories
        } else {
            print("here i am")
            return viewModel.memories.filter{
                ($0.place.name?.localizedCaseInsensitiveContains(searchText))! ||
                ($0.content?.localizedCaseInsensitiveContains(searchText))! ||
                ($0.title?.localizedCaseInsensitiveContains(searchText))! || searchText == ""
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color.mainBackgroundColor
                .ignoresSafeArea()
          
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: columns) {
                        ForEach(searchResult, id: \.self) { memory in
                            NavigationLink(destination: MemoryView(
                                viewModel: MemoriesView.MemoryModel.init(moc: self.viewContext, folder: folder),
                                viewLocationModel: LocationSelectView.LocationModel.init(moc: self.viewContext),
                                memory: memory,
                                folder: folder)) {
                                    MemoryCellView(memory: memory,
                                               viewModel: MemoriesView.MemoryModel.init(moc: self.viewContext, folder: folder),
                                               width: UIScreen.main.bounds.width,
                                               height: UIScreen.main.bounds.height)
                                }.padding(.top, 10)
                        }
                    }
                }.searchable(text: $searchText, placement: .navigationBarDrawer).padding(.horizontal, 10)
            }
            .navigationTitle("\(folder.safeName)")
            .navigationBarBackButtonHidden(true)

            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button() {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                            Text("Back")
                                .foregroundColor(.white)
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            self.showDeleteFolder = true
                        }, label: {
                            Label (
                                title: { Text("Delete Folder") },
                                icon: { Image(systemName: "xmark.bin") }
                            )
                        })
                        
                        Button {
                            self.showEditFolder = true
                        } label: {
                            Label (
                                title: { Text("Edit Folder") },
                                icon: { Image(systemName: "pencil") }
                            )
                        }
                        
                        Button {
                            self.showAddMemory = true
                        } label: {
                            Label (
                                title: { Text("Add new Memory") },
                                icon: { Image(systemName: "cloud.fill") }
                            )
                        }
                    } label: {
                        Label (
                            title: { Text("Menu") },
                            icon: { Image(systemName: "ellipsis").foregroundColor(.white) }
                        )
                    }.background(
                        ZStack {
                            NavigationLink(destination: MemoryAddView(folder: folder, viewFolderModel: FoldersView.FolderModel.init(moc: self.viewContext), viewModel: MemoriesView.MemoryModel.init(moc: self.viewContext, folder: folder), viewLocationModel: LocationSelectView.LocationModel.init(moc: self.viewContext)), isActive: $showAddMemory) {
                                EmptyView()
                            }
                            NavigationLink(destination: FolderEditView(viewModel: FoldersView.FolderModel.init(moc: self.viewContext), folder: folder, name: folder.safeName, isFav: folder.isFavorite, selectedColor: self.viewFolderModel.getFolderColor(folder: folder)), isActive: $showEditFolder) {
                                EmptyView()
                            }
                        }
                            
                    )
                }
            }
            .alert(isPresented: $showDeleteFolder) {
                Alert (
                  title: Text("Delete Folder"),
                  message: Text("Are you sure that you want to delete this folder?"),
                  primaryButton: .cancel(Text("No"), action: {print("No")}),
                  secondaryButton: .destructive(Text("Yes"), action: {
                      presentationMode.wrappedValue.dismiss()
                      for memory in self.viewModel.memories {
                          self.viewLocationModel.removeLocation(location: memory.place)
                      }
                      self.viewFolderModel.removeFolder(folder: folder)
                  })
                )
            }
        }
    }
}
