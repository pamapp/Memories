//
//  MemoryView.swift
//  memories
//
//  Created by Alina Potapova on 20.07.2021.
//

import SwiftUI

struct MemoryView: View {
    
    @Environment(\.presentationMode) var isPresented
    @Environment(\.managedObjectContext) private var viewContext

    @State var showImage: Bool = false
    @State var showEditView = false
    
    @State private var inputImage: UIImage?
    @State var image: Image? = Image("test_photo")
    
    @ObservedObject var viewModel: MemoriesView.MemoryModel
    
    var memory: Memory
    
    var folder: Folder
    
    var body: some View {
        ZStack {
            if !showEditView {
                VStack {
                    image?
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .cornerRadius(10)
                        .onTapGesture {
                            self.showImage.toggle()
                        }
                    
                    List {
                        Section(header: Text("MEMORY INFO")) {
                            HStack(alignment: .center) {
                                Text("Date")
                                
                                Spacer()

                                Text(dateString(memory.date))
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
                            ScrollView(.vertical, showsIndicators: true) {
                                Text(memory.safeText)
                                    .font(.system(size: 18, design: .serif))
                            }
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
                .navigationBarTitle(Text(navDateString(memory.date)), displayMode: .inline)

                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button(action: {
        //                        self.isPresented.wrappedValue.dismiss()
        //                        self.deleteMemory()
                                self.showEditView.toggle()
                            }, label: {
                                Label (
                                    title: { Text("Edit") },
                                    icon: { Image(systemName: "pencil") }
                                )
                            })

                            Button(action: {
                                self.isPresented.wrappedValue.dismiss()
                                self.viewModel.removeMemory(memory: memory)
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
                
                if self.showImage {
                    ZStack {
                        Color.black
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
    //                            withAnimation{
                                    self.showImage.toggle()
    //                            }
                            }
                            
                        image?
                            .resizable()
                            .scaledToFit()
                            .frame(height: 350)
                        
                    }
                    .navigationBarHidden(true)
                }
            } else {
                MemoryEditView(showEditView: self.$showEditView, viewModel: MemoriesView.MemoryModel.init(moc: self.viewContext, folder: folder))
                
            }
        }
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
    
    private func dateString(_ date: Date?) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy, EE"
        if let date = date{
            return formatter.string(from: date)
        }
        return "Unknown"
    }
    
    private func navDateString(_ date: Date?) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        if let date = date{
            return formatter.string(from: date)
        }
        return "Unknown"
    }
    
}
