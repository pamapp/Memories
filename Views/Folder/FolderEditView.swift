//
//  FolderEditView.swift
//  memories
//
//  Created by Alina Potapova on 18.11.2021.
//
import SwiftUI
import Combine

struct FolderEditView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var viewModel: FoldersView.FolderModel
    
    var folder: Folder
    @State var name: String
    @State var isFav: Bool
    @State var selectedColor: Color
    
    @State private var showColorPicker = false
    
    private enum Strings {
        static let name = "Name"
        static let name_footnote = "Enter folder name"
        static let favorite = "Favorite"
        static let favorite_footnote = "Toggle to make folder favorite"
        static let folder_color = "Folder color"
        static let folder_color_footnote = "Select folder color"
    }
    
    var pickerColors: [Color] = [
        .defaultFolderColor,
        .pickerGreen,
        .pickerBlue,
        .pickerPink,
        .pickerCirclePurple
    ]
    
    let sectionWidth = UIScreen.main.bounds.width / 1.1
    let imageHeight = UIScreen.main.bounds.height / 13
    let characterLimit = 15
    
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
                         .foregroundColor(.white)
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
                                    .font(.system(size: 18, design: .serif))
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
                                    .font(Font.callout.weight(.bold))
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
                        .frame(width: sectionWidth, height: sectionWidth / 4.2)
                        .overlay(
                            VStack {
                                HStack {
                                    Text(Strings.folder_color.uppercased())
                                        .font(Font.callout.weight(.bold))
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
                saveToolBar
            }
        }
    }
    
    private var saveToolBar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                self.viewModel.editFolder(
                    folder: folder,
                    name: name,
                    isFav: isFav,
                    color: intByColor(color: selectedColor)
                )
                presentationMode.wrappedValue.dismiss()
            } label: {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.tabButtonColor)
                    .frame(width: 100, height: 32)
                    .overlay(
                        Text("Save")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
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
        default:
            return 0
        }
    }
    
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
}

