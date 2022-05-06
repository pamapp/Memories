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
    
    let cellFolderWidth = UIScreen.main.bounds.width / 2.35
    let cellFolderHeight = UIScreen.main.bounds.height / 4.9
    
    let imageHeight = UIScreen.main.bounds.height / 13
    
    @State var isFav: Bool
    @State var showEditView: Bool = false
    @State var isPressed = false
    
    @State var color = Color.red
    
    @ObservedObject var viewModel: FoldersView.FolderModel
    
    
    var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .foregroundColor(.cellColor)
            .frame(width: cellFolderWidth, height: cellFolderHeight, alignment: .center)
            .overlay(
                NavigationLink(destination: MemoriesView(viewModel: MemoriesView.MemoryModel.init(moc: self.viewContext, folder: folder),
                                                         viewFolderModel: FoldersView.FolderModel.init(moc: self.viewContext),
                                                         viewLocationModel: LocationSelectView.LocationModel.init(moc: self.viewContext),
                                                         folder: folder), label: {
                    VStack {
                        ZStack {
                            Image("folder_image")
                                .resizable()
                                .scaledToFit()
                                .frame(height: imageHeight)
                                .padding(.bottom, 10)
                            Image("folder_image")
                                .renderingMode(.template)
                                .resizable()
                                .foregroundColor(self.viewModel.getFolderColor(folder: folder))
                                .opacity(0.7)
                                .scaledToFit()
                                .frame(height: imageHeight)
                                .padding(.bottom, 10)
                            if folder.isFavorite {
                                Image(systemName: "star.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.cellColor)
                            }
                        }
                        Text("\(folder.safeName)")
                             .foregroundColor(.white)
                             .font(.montserrat(18))
                             
                    }.padding(.top, 15)
                })

            )
    }

}
//FolderEditView(name: folder.name ?? "", image: image, folder: folder, viewModel: FoldersView.FolderModel.init(moc: self.viewContext))

           
//         NavigationLink(destination: MemoriesView(viewModel: MemoriesView.MemoryModel.init(moc: self.viewContext, folder: folder), folder: folder), label: {
//             VStack {
//                 HStack() {
//                     VStack(alignment: .leading) {
//                         Spacer()
//                         Text("\(folder.safeName)")
//                             .foregroundColor(.white)
//                             .font(Font.title.weight(.bold))
//                         Text(self.viewModel.getMemoriesNum(folder: folder))
//                             .foregroundColor(.white)
//                             .font(Font.subheadline.weight(.light))
//                     }.frame(height: 90)
//
//                     Spacer()
//                 }.frame(width: UIScreen.main.bounds.width / 3, height: 90)
//             }
//         }).buttonStyle(FolderButton())
                    
                    
