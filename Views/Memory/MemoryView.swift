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
    @ObservedObject var viewLocationModel: LocationSelectView.LocationModel
    
    let imageHeight = UIScreen.main.bounds.height / 4
    let infoWidth = UIScreen.main.bounds.width / 2

    
    var memory: Memory
    
    var folder: Folder
    
    var body: some View {
        ZStack {
            Color.mainBackgroundColor
                .ignoresSafeArea()
            if !showEditView {
                VStack(spacing: 15) {
                    VStack(alignment: .center) {
                        image?
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width / 1.1, height: imageHeight)
                            .clipped()
                            .cornerRadius(15)
                            .onTapGesture {
                                self.showImage.toggle()
                            }
                    }.padding(.top, 0)
                    
                    VStack {
                        HStack(alignment: .center) {
                            HStack(spacing: 2) {
                                Image(systemName: "mappin")
                                    .font(.system(size: 15))
                                    .foregroundColor(.tabButtonColor)
                                Text(memory.safePlace)
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(.tabButtonColor)
                            }
                            Spacer()
                            Text(dateString(memory.date))
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.tabButtonColor)
                        }
                    }.padding(.horizontal, 25)
                    
                    Divider()
                    
                    VStack {
                        HStack {
                            Text(memory.safeTitle)
                                .font(.montserrat(18))
//                                .font(.system(size: 18, weight: .bold, design: .serif))
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        HStack {
                            ScrollView(.vertical, showsIndicators: true) {
                                Text(memory.safeText)
                                    .font(.montserrat(18))
                                    .lineSpacing(10)
//                                    .font(.system(size: 18, weight: .regular, design: .serif))
                            }
                            Spacer()
                        }
                    }.padding(.leading, 15).padding(.bottom, 50)
                    
                    Spacer()
                }
                .onAppear {
                    self.loadImage()
                }
                
                .navigationBarTitle(Text(navDateString(memory.date)), displayMode: .inline)
                .navigationBarBackButtonHidden(true)
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button() {
                            self.isPresented.wrappedValue.dismiss()
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
                                self.viewLocationModel.removeLocation(location: memory.place)
                                self.viewModel.removeMemory(memory: memory)
                            }, label: {
                                Label (
                                    title: { Text("Delete") },
                                    icon: { Image(systemName: "xmark.bin") }
                                )
                            })
                            
                            Button(action: {
                                if !memory.isFavorite {
                                    self.viewModel.addtoFavorites(memory: memory)
                                } else {
                                    self.viewModel.removeFromFavorites(memory: memory)
                                }
                            }, label: {
                                Label (
                                    title: {
                                        if !memory.isFavorite {
                                            Text("Add to favorites")
                                        } else {
                                            Text("Remove from favorites")
                                        }
                                    },
                                    icon: { Image(systemName: "star") }
                                )
                            })
                        } label: {
                            Label (
                                title: { Text("Menu") },
                                icon: { Image(systemName: "ellipsis").foregroundColor(.white) }
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
                                withAnimation{
                                    self.showImage.toggle()
                                }
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
        formatter.dateFormat = "MMMM d, yyyy"
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


//ссылка на источник рядом с картинкой
