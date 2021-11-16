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
    
    @ObservedObject var viewModel: FoldersView.FolderModel
    
    var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .foregroundColor(Color(UIColor.separator))
            .frame(width: 155, height: 155, alignment: .center)
            .overlay(
                VStack {
                    VStack {
                        HStack() {
                            Button {
                                self.isFav.toggle()
                                self.viewModel.favToggle(folder: folder)
//                                dataController.save()
                            } label: {
                                Image(systemName: isFav ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 25))
                            }
                            Spacer()
                            
                            Button(action: {
                                self.viewModel.removeFolder(folder: folder)
                            }, label: {
                                Image(systemName: "minus.circle")
                            })
                        }.frame(width: 130)
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
                                    Text("\( self.viewModel.getMemoriesNum(folder: folder)) memories")
                                        .foregroundColor(.white)
                                        .font(Font.subheadline.weight(.light))
                                }.frame(height: 90)
                                
                                Spacer()
                            }.frame(width: 120, height: 90)
                        }
                    })
                }.frame(width: 130, height: 110)
            )
            .padding(.bottom, 25)
    }
}
