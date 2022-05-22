//
//  SelectAddView.swift
//  memories
//
//  Created by Alina Potapova on 17.04.2022.
//

import SwiftUI

struct SelectAddView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel: FoldersView.FolderModel
//    @ObservedObject var viewModel: MemoriesView.MemoryModel

    
    var body: some View {
        NavigationView {
            ZStack {
                Color.mainBackgroundColor
                    .ignoresSafeArea()
                VStack(spacing: 40) {
                    SelectCellView(
                        page: FolderAddView(viewModel: FoldersView.FolderModel.init(moc: self.viewContext)),
                        image: Image("folder_image"),
                        title: "New Folder",
                        color: Color.clear
                    )
                    SelectCellView(
                        page:  MemoryAddView(folder: FoldersView.FolderModel.init(moc: self.viewContext).getDefaultFolder(), viewFolderModel: FoldersView.FolderModel.init(moc: self.viewContext), viewModel: MemoriesView.MemoryModel.init(moc: self.viewContext, folder: FoldersView.FolderModel.init(moc: self.viewContext).getDefaultFolder()), viewLocationModel: LocationSelectView.LocationModel.init(moc: self.viewContext)),
                        image: Image(systemName: "cloud.fill"),
                        title: "New Memory",
                        color: Color.tabButtonColor
                    )
//                    SelectCellView (
//                        page: Text("Dream Add"),
//                        image: Image(systemName: "moon.fill"),
//                        title: "New Dream",
//                        color: Color.white
//                    )
                }
                .padding(.bottom, 20)
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(.white)
    }
}

struct SelectCellView: View {
    let cellFolderWidth = UIScreen.main.bounds.width / 1.2
    let cellFolderHeight = UIScreen.main.bounds.height / 5.5
    let imageHeight = UIScreen.main.bounds.height / 14

    var page: Any
    var image: Image?
    var title: String
    var color: Color
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundColor(.cellColor)
            .frame(width: cellFolderWidth, height: cellFolderHeight, alignment: .center)
            .overlay(
                NavigationLink(destination: AnyView(_fromValue: page), label: {
                    VStack {
                        image?
                            .resizable()
                            .scaledToFit()
                            .frame(height: imageHeight)
                            .padding(.bottom, 10)
                            .foregroundColor(color)
                        Text(title)
                             .foregroundColor(.white)
                             .font(.montserratBold(18))
                    }
                })
            )
    }
}
