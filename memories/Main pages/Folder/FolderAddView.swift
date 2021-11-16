//
//  FolderAddView.swift
//  memories
//
//  Created by Alina Potapova on 16.08.2021.
//

import SwiftUI

struct FolderAddView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode

    @State private var name: String = ""
    
//    private let folder: Folder?
    //    @FetchRequest(entity: Folder.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Folder.name, ascending: false),]) var folders: FetchedResults<Folder>
    @ObservedObject var viewModel: FoldersView.FolderModel
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
            }
            .navigationTitle(self.name == "" ? "New Folder" : "\(self.name)")
            .toolbar {
                doneToolBar
            }
        }
    }
    
    private var doneToolBar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Done") {
                self.viewModel.addNewFolder(name: name == "" ? "Folder" : self.name)
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
//    func addMemory() {
//        let newFolder = Folder(context: dataController.context)
//        newFolder.name = self.name
//        dataController.save()
//    }
}

