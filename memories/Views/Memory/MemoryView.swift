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
    @State var showDeleteView = false
    
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

            VStack(spacing: 15) {
                ScrollView(.vertical, showsIndicators: true) {
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
                    }
                    
                    VStack {
                        HStack {
                            Text(memory.safeTitle)
                                .font(.montserratBold(18))
                        }
                    }.padding(.horizontal, 7).padding(.top, 10)
                    
                    Divider()
                       
                    VStack(alignment: .leading) {
                        HStack {
                            Text(memory.safeText)
                                .font(.montserrat(15))
                                .lineSpacing(10)
                            Spacer()
                        }
                    }.padding(.leading, 15)
                }
                .padding(.top, -10)
                
                VStack {
                    HStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 165, height: 35)
                            .foregroundColor(.tabColor)
                            .overlay (
                                HStack(spacing: 2) {
                                    Image(systemName: "mappin")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                    Text(memory.safePlace)
                                        .font(.montserratBold(14))
                                        .fontWeight(.heavy)
                                        .foregroundColor(.white)
                                }
                            )
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 165, height: 35)
                            .foregroundColor(.tabColor)
                            .overlay(
                                Text(dateString(memory.date))
                                    .font(.montserrat(14))
                                    .fontWeight(.heavy)
                                    .foregroundColor(.white)
                            )
                    }
                }
                .padding(.horizontal, 15)
                .padding(.top, 3)
                .padding(.bottom, 75)
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
                                .font(.montserratBold(16))
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            self.showEditView.toggle()
                        }, label: {
                            Label (
                                title: { Text("Edit") },
                                icon: { Image(systemName: "pencil") }
                            )
                        })

                        Button(action: {
                            self.showDeleteView = true
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
                    .background(
                        NavigationLink(destination: MemoryEditView(
                            memoryText: memory.safeText,
                            memoryTitle: memory.safeTitle,
                            placeText: memory.safePlace,
                            date: memory.date ?? Date(),
                            selectedColor: viewModel.getMemoryColor(memory: memory),
                            place: memory.place,
                            longitude: memory.place.longitude,
                            latitude: memory.place.latitude,
                            locationName: memory.place.name ?? "Select",
                            folder: folder,
                            image: viewModel.getMemoryImage(memory: memory),
                            viewFolderModel: FoldersView.FolderModel.init(moc: self.viewContext),
                            viewModel: MemoriesView.MemoryModel.init(moc: self.viewContext, folder: folder),
                            viewLocationModel: LocationSelectView.LocationModel.init(moc: self.viewContext),
                            memory: memory
                        ), isActive: $showEditView) {
                            EmptyView()
                        }
                    )
                }
            }
            .alert(isPresented: $showDeleteView) {
                Alert (
                  title: Text("Delete Memory"),
                  message: Text("Are you sure that you want to delete this memory?"),
                  primaryButton: .cancel(Text("No"), action: {print("No")}),
                  secondaryButton: .destructive(Text("Yes"), action: {
                      self.isPresented.wrappedValue.dismiss()
                      self.viewLocationModel.removeLocation(location: memory.place)
                      self.viewModel.removeMemory(memory: memory)
                  })
                )
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
