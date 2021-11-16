//
//  MemoriesView.swift
//  memories
//
//  Created by Alina Potapova on 09.07.2021.
//

import SwiftUI

struct MemoriesView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var viewModel: MemoryModel
    
    @State private var showingAddMemoryView = false
    
    var folder: Folder
    
    @State var date = Date()
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(alignment: .center, spacing: 15) {
                    ForEach(self.viewModel.memories) { memory in
                        NavigationLink(destination: MemoryView(viewModel: MemoriesView.MemoryModel.init(moc: self.viewContext, folder: folder), memory: memory, folder: folder)) {
                            MemoryCellView(memory: memory)
                        }
//                        .swipeActions(allowsFullSwipe: false) {
//                            Button {
//                                print("Muting conversation")
//                            } label: {
//                                Label("Mute", systemImage: "bell.slash.fill")
//                            }
//                            .tint(.indigo)
//
//                            Button(role: .destructive) {
//                                print("Deleting conversation")
//                            } label: {
//                                Label("Delete", systemImage: "trash.fill")
//                            }
//                        }
                    }
                }
            }.padding(.top, 15)

            NavigationLink(destination: MemoryAddView(folder: folder, viewModel: MemoriesView.MemoryModel.init(moc: self.viewContext, folder: folder)), label: {
                Circle()
                    .foregroundColor(Color(UIColor.separator))
                    .frame(width: 900, height: 90, alignment: .center)
                    .overlay(
                        Image(systemName: "cloud.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                            .padding(.bottom, 5)
                    )
            })
            .navigationTitle("\(folder.safeName) memories")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
//                            self.viewModel.removeFolder(folder: folder)
                        }, label: {
                            Label (
                                title: { Text("Delete") },
                                icon: { Image(systemName: "xmark.bin") }
                            )
                        })
                        
                        Button(action: {
                            print("favs")
                        }, label: {
                            Label (
                                title: { Text("Add to the favorites") },
                                icon: { Image(systemName: "star") }
                            )
                        })
                    } label: {
                        Label (
                            title: { Text("Menu") },
                            icon: { Image(systemName: "ellipsis") }
                        )
                    }
                }
            }
        }
    }
}

