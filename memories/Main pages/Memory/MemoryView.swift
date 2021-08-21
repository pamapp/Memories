//
//  MemoryView.swift
//  memories
//
//  Created by Alina Potapova on 20.07.2021.
//

import SwiftUI

struct MemoryView: View {
    
    @Environment(\.presentationMode) var isPresented
    @EnvironmentObject private var dataController: DataController
    @FetchRequest(entity: Memory.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Memory.date, ascending: false),]) var memories: FetchedResults<Memory>

    @State private var inputImage: UIImage?
    @State private var image: Image? = Image("test_photo")
    
    let memory: Memory
    
    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
                .frame(height: 150)
                .cornerRadius(10)
            
            List {
                Section(header: Text("MEMORY INFO")) {
                    HStack(alignment: .center) {
                        Text("Date")
                        
                        Spacer()

                        Text(memory.safeDate)
                            .font(.system(size: 18, design: .serif))
                            .foregroundColor(.secondary)
                    }
                    
                    HStack() {
                        Text("Place")
                        
                        Spacer()
                        
                        Text(memory.safePlace)
                            .foregroundColor(.secondary)
                            .font(.system(size: 18, design: .serif))
                    }
                }
                
                Section(header: Text("MEMORY")) {
                    Text(memory.safeText)
                        .font(.system(size: 18, design: .serif))
                }
            }
            .listStyle(.grouped)
            .padding(.top, 10)
            .hasScrollEnabled(false)

            Spacer()
            
        }
        .onAppear {
            self.loadImage()
        }
        .navigationBarTitle(Text(memory.safeNavDate), displayMode: .inline)

        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: {
//                        self.isPresented.wrappedValue.dismiss()
//                        self.deleteMemory()
                    }, label: {
                        Label (
                            title: { Text("Edit") },
                            icon: { Image(systemName: "pencil") }
                        )
                    })

                    Button(action: {
                        self.isPresented.wrappedValue.dismiss()
                        self.deleteMemory()
                    }, label: {
                        Label (
                            title: { Text("Delete") },
                            icon: { Image(systemName: "xmark.bin") }
                        )
                    })
                    
                    Button(action: {
//                        self.isPresented.wrappedValue.dismiss()
//                        self.deleteMemory()
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
        .padding(.top, 30)
    }
    
    func loadImage() {
        let data = helper.loadImage(imageIdName: memory.id!.uuidString)
        guard  let loadedData = data else {
            return
        }
        self.inputImage =  UIImage(data: loadedData)
        self.image = Image(uiImage: inputImage!)

    }
    
    func deleteFromDirectory(Name: String) {
        let fileName = helper.getDocumentsDirectory().appendingPathComponent(Name)
        let filePath = fileName.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            try? fileManager.removeItem(atPath: filePath)
        } else {
            print("File at path \(filePath) does not exist")
        }
    }
    
    func deleteMemory() {
        deleteFromDirectory(Name: memory.id!.uuidString)
        dataController.delete(memory)
        dataController.save()
    }
}
