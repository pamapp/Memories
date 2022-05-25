//
//  FolderAddView.swift
//  memories
//
//  Created by Alina Potapova on 16.08.2021.
//

import SwiftUI
import Combine

struct FolderAddView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode

    @State private var name: String = ""
    @State private var isFav: Bool = false
    @State private var selectedColor: Color = .defaultFolderColor
    @State private var showColorPicker = false
    @ObservedObject var viewModel: FoldersView.FolderModel
    
    private enum Strings {
        static let name = "Name"
        static let name_footnote = "Enter folder name"
        static let favorite = "Favorite"
        static let favorite_footnote = "Toggle to make folder favorite"
        static let folder_color = "Folder color"
        static let folder_color_footnote = "Select folder color"
    }
    

    
    let sectionWidth = UIScreen.main.bounds.width / 1.1
    let imageHeight = UIScreen.main.bounds.height / 13

    var pickerColors: [Color] = [
        .defaultFolderColor,
        .pickerGreen,
        .pickerBlue,
        .pickerPink,
        .pickerCirclePurple,
        .pickerRed
    ]

    var characterLimit = 13
    
    var body: some View {
        ZStack {
            Color.mainBackgroundColor
                .ignoresSafeArea()
            VStack(spacing: 30) {
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
                            .foregroundColor(selectedColor == .pickerCirclePurple ? .pickerPurple : selectedColor)
                            .opacity(selectedColor == .defaultFolderColor ? 0 : 0.7)
                            .scaledToFit()
                            .frame(height: imageHeight)
                            .padding(.bottom, 10)
                      
                            if isFav {
                                Image(systemName: "star.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.cellColor)
                            }
                    }
                    Text(name != "" ? "\(name)" : "Folder")
                        .font(.montserratBold(18))
                }.padding(.top, 15)
                
                VStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.tabColor)
                        .frame(width: sectionWidth, height: sectionWidth / 7.5)
                        .overlay(
                            HStack() {
                                TextField(Strings.name, text: $name)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(.white)
                                    .accentColor(.white)
                                    .font(.montserrat(17))
                                    .padding(.leading, 20)
                                    .onReceive(name.publisher.collect()) {
                                        let s = String($0.prefix(characterLimit))
                                        if name != s {
                                            name = s
                                        }
                                     }
                                Spacer()
                            }
                        )
                    Text(Strings.name_footnote)
                        .listFootnoteTextStyle()
                }
                
                VStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.tabColor)
                        .frame(width: sectionWidth, height: sectionWidth / 7.5)
                        .overlay(
                            HStack() {
                                Text(Strings.favorite.uppercased())
                                    .font(.montserratBold(16))
                                    .padding(.leading, 20)
                                Spacer()
                                Toggle("", isOn: $isFav)
                                    .padding(.trailing, 20)
                                    .toggleStyle(SwitchToggleStyle(tint: .tabButtonColor))
                            }.padding(.top, 5).padding(.bottom, 5)
                        )
                    Text(Strings.favorite_footnote)
                        .listFootnoteTextStyle()
                }
                
                VStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.tabColor)
                        .frame(width: sectionWidth, height: sectionWidth / 3.8)
                        .overlay(
                            VStack {
                                HStack {
                                    Text(Strings.folder_color.uppercased())
                                        .font(.montserratBold(16))
                                        .padding(.leading, 20)
                                    Spacer()
                                }.padding(.top, 3)
                                HStack(alignment: .top) {
                                    ForEach(pickerColors, id: \.self) { color in
                                        Button(action: {
                                            self.selectedColor = color
                                        }, label: {
                                            ZStack {
                                                Circle()
                                                    .foregroundColor(selectedColor == color ? color : .cellColor)
                                                    .frame(width: 35, height: 35)
                                                Circle()
                                                    .foregroundColor(.cellColor)
                                                    .frame(width: 31, height: 31)
                                                Circle()
                                                    .foregroundColor(color)
                                                    .frame(width: 25, height: 25)
                                            }
                                        })
                                    }
                                    Spacer()
                                }.padding(.leading, 20)
                            }
                        )
                    Text(Strings.folder_color_footnote)
                        .listFootnoteTextStyle()
                }
                Spacer()
            }
            .keyboardAdaptive()
            .padding(.top, 10)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                cancelToolBar
                doneToolBar
            }
        }
    }
    
    private var doneToolBar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                self.viewModel.addNewFolder(
                    name: name == "" ? "Folder" : self.name,
                    isFav: isFav,
                    color: intByColor(color: selectedColor)
                )
                presentationMode.wrappedValue.dismiss()
            } label: {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.tabButtonColor)
                    .frame(width: 100, height: 32)
                    .overlay(
                        Text("Add")
                            .foregroundColor(.white)
                            .font(.montserratBold(16))
                            
                    )
            }
        }
    }
    
    private var cancelToolBar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button() {
                presentationMode.wrappedValue.dismiss()
            } label: {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Cancel")
                        .foregroundColor(.white)
                        .font(.montserratBold(16))
                }
            }
        }
    }
    
    private func intByColor(color: Color) -> Int {
        switch color {
        case .defaultFolderColor: return 0
        case .pickerGreen: return 1
        case .pickerBlue: return 2
        case .pickerPink: return 3
        case .pickerCirclePurple: return 4
        case .pickerRed: return 5
        default:
            return 0
        }
    }

    private func endEditing() {
        UIApplication.shared.endEditing()
    }
}

