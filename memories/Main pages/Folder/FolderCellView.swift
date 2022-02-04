//
//  FolderCellView.swift
//  memories
//
//  Created by Alina Potapova on 16.08.2021.
//

import SwiftUI

struct FolderCellView: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    var folder: Folder
    
    @State var isFav: Bool
    @State var showEditView: Bool = false
    @ObservedObject var viewModel: FoldersView.FolderModel
    
    @State var showImage: Bool = false
    @State private var inputImage: UIImage?
    @State var image: Image? = Image("test_photo")
    @State var isPressed = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .foregroundColor(Color(UIColor.separator))
            .frame(width: UIScreen.main.bounds.width / 2.5, height: UIScreen.main.bounds.width / 2.2, alignment: .center)
            .onAppear {
                self.loadImage()
            }
            .overlay(
                ZStack {
                    image?
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width / 2.5, height: UIScreen.main.bounds.width / 2.2)
                        .clipped()
                        .cornerRadius(30)
                        .opacity(0.35)
                        .onTapGesture {
                            self.showImage.toggle()
                        }
                    
                     VStack {
                         VStack {
                             HStack() {
                                 Button {
                                     self.isFav.toggle()
                                     self.viewModel.favToggle(folder: folder)
                                 } label: {
                                     Image(systemName: isFav ? "star.fill" : "star")
                                         .foregroundColor(.purple)
                                         .font(.system(size: 25))
                                 }
                                 
                                 Spacer()
           
                                 Button(action: {
                                     self.showEditView.toggle()
                                 }, label: {
                                     Image(systemName: "gear")
                                         .foregroundColor(.white)
                                         .font(.system(size: 25))
                                 }).sheet(isPresented: $showEditView, onDismiss: loadImage) {
                                     FolderEditView(name: folder.name ?? "", image: image, folder: folder, viewModel: FoldersView.FolderModel.init(moc: self.viewContext))
                                 }
                                 
                             }.frame(width: UIScreen.main.bounds.width / 3)
                             Spacer()
                         }
           
                         NavigationLink(destination: MemoriesView(viewModel: MemoriesView.MemoryModel.init(moc: self.viewContext, folder: folder), folder: folder), label: {
                             VStack {
                                 HStack() {
                                     VStack(alignment: .leading) {
                                         Spacer()
                                         Text("\(folder.safeName)")
                                             .foregroundColor(.white)
                                             .font(Font.title.weight(.bold))
                                         Text(self.viewModel.getMemoriesNum(folder: folder))
                                             .foregroundColor(.white)
                                             .font(Font.subheadline.weight(.light))
                                     }.frame(height: 90)
           
                                     Spacer()
                                 }.frame(width: UIScreen.main.bounds.width / 3.2, height: 90)
//                                     .background(Color.tabColor)
                             }
                         }).buttonStyle(FolderButton())
                     }.frame(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.width / 2.5)
                 }
             ).padding(.bottom, 25)
    }
    
    func loadImage() {
        if folder.id == nil {
            print("nil")
        }
        else {
            let data = helper.loadImage(imageIdName: folder.id!.uuidString)
            guard  let loadedData = data else {
                return
            }
            self.inputImage =  UIImage(data: loadedData)
            self.image = Image(uiImage: inputImage!)
        }
    }
}
