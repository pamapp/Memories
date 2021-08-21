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
    
    var body: some View {
        NavigationLink(destination: MemoriesView(folder: folder).environmentObject(dataController), label: {
            VStack {
                RoundedRectangle(cornerRadius: 30)
                    .foregroundColor(Color(UIColor.separator))
                    .frame(width: 155, height: 155, alignment: .center)
                    .overlay(
                        ZStack {
                            VStack {
                                HStack() {
//                                    Button {
//                                        changeStatus()
//                                    } label: {
                                        Image(systemName: folder.safeIsFavorite ? "star.fill" : "star")
                                            .foregroundColor(.yellow)
                                            .font(.system(size: 25))
//                                    }
                                    Spacer()
                                    Image(systemName: "ellipsis")
                                        .foregroundColor(.white)
                                        .rotationEffect(Angle(degrees: 90))
                                }.frame(width: 130)
                                Spacer()
                            }
                            HStack() {
                                VStack(alignment: .leading) {
                                    Spacer()
                                    Text("\(folder.safeName)")
                                        .foregroundColor(.white)
                                        .font(Font.title.weight(.bold))
                                    Text("\(folder.safeNotes.count) memories")
                                        .foregroundColor(.white)
                                        .font(Font.subheadline.weight(.light))
                                }.frame(height: 110)
                                Spacer()
                            }.frame(width: 120, height: 130)
                        }.frame(width: 130, height: 130)
                    )
                    .padding(.bottom, 30)
            }
        })
    }

    func changeStatus() {
//        if let folder = folder {
            folder.isFavorite.toggle()
//        }

        dataController.save()
    }
}
//folder.safeName

//struct FolderCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        FolderCellView()
//    }
//}
