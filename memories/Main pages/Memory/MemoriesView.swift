//
//  MemoriesView.swift
//  memories
//
//  Created by Alina Potapova on 09.07.2021.
//

import SwiftUI

struct MemoriesView: View {
    
    @EnvironmentObject private var dataController: DataController
    @FetchRequest(entity: Memory.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Memory.date, ascending: false),]) var memories: FetchedResults<Memory>
    
    @State private var selectedMemories = Set<Memory>()
    @State private var showingAddMemoryView = false
    
    @State var folder: Folder
    
    @State var date = Date()
    
//    let folder: Folder?
    
//    init(folder: Folder? = nil) {
//        self.folder = folder
//
////        let predicate: NSPredicate
////        if let safeFolder = folder {
////            predicate = NSPredicate(format: "folder == %@ AND isInTrash == NO", safeFolder)
////        } else {
////            predicate = NSPredicate(format: "isInTrash == NO")
////        }
//
//        self._memories = FetchRequest(
//            sortDescriptors: [SortDescriptor<Memory>(\.date, order: .reverse)]
////            predicate: predicate,
////            animation: .default
//        )
//    }
//    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(alignment: .center, spacing: 15) {
                    ForEach(memories, id: \.self) { item in
                        MemoryCellView(memory: item)
                    }
                }
            }.padding(.top, 15)
            
            NavigationLink(destination: MemoryAddView(), label: {
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
            .navigationTitle("Memories")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            deleteFolder()
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

    func deleteFolder() {
        dataController.delete(folder)
        dataController.save()
    }
}

