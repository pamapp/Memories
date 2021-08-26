//
//  FolderCellView.swift
//  memories
//
//  Created by Alina Potapova on 16.08.2021.
//

import SwiftUI

struct FolderCellView: View {
    
    @EnvironmentObject private var dataController: DataController

    @State var folder: Folder
    
    @State var isFav: Bool
    
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
                                folder.isFavorite.toggle()
                                dataController.save()
                            } label: {
                                Image(systemName: isFav ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 25))
                            }
                            Spacer()
                            Image(systemName: "ellipsis")
                                .foregroundColor(.white)
                                .rotationEffect(Angle(degrees: 90))
                        }.frame(width: 130)
                        Spacer()
                    }
                
                    NavigationLink(destination: MemoriesView(folder: folder).environmentObject(dataController), label: {
                        VStack {
                            HStack() {
                                VStack(alignment: .leading) {
                                    Spacer()
                                    Text("\(folder.safeName)")
                                        .foregroundColor(.white)
                                        .font(Font.title.weight(.bold))
                                    Text("\(folder.safeNotes.count) memories")
                                        .foregroundColor(.white)
                                        .font(Font.subheadline.weight(.light))
                                }.frame(height: 90)
                                
                                Spacer()
                            }.frame(width: 120, height: 90)
                        }
                    })
                }.frame(width: 130, height: 110)
        )
    }
}
