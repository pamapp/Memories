//
//  SettingsView.swift
//  memories
//
//  Created by Alina Potapova on 18.05.2022.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var viewUserModel: ProfileView.UserModel
    
    @State private var inputImage: UIImage?
    
    @State var image: Image?
    
    @State var name: String
    
    @State var isShowPicker: Bool = false
    
    var characterLimit = 15
    
    var user: User
    
    let sectionWidth = UIScreen.main.bounds.width / 1.1
    
    private enum Strings {
        static let name_footnote = "Enter your name"
    }
    
    var body: some View {
        ZStack {
            Color.mainBackgroundColor
                .ignoresSafeArea()
            VStack() {
                VStack(spacing: 40) {
                    image?
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 125, height: 125)
                        .clipped()
                        .mask(Circle())
                        .overlay(
                            Button (action: {
                                self.isShowPicker.toggle()
                            }, label: {
                                Circle()
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(.cellColor)
                                    .overlay(Image(systemName: "pencil").foregroundColor(.tabButtonColor))
                            })
                            .offset(x: 42, y: -42)
                            .sheet(isPresented: $isShowPicker, onDismiss: loadImage) {
                                ImagePicker(image: self.$inputImage)
                                    .accentColor(.white)
                            }
                            
                        )
                    
                    VStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.tabColor)
                            .frame(width: sectionWidth, height: sectionWidth / 7.5)
                            .overlay(
                                HStack() {
                                    TextField(viewUserModel.userName, text: $name)
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
                }
                .onAppear {
                    self.loadImage()
                }
                .padding(.top, 70)
                Spacer()
            }
            HStack {
                Spacer()
                VStack {
                    doneToolBar
                        .padding(.horizontal)
                        .padding(.top, 5)
                    Spacer()
                }
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    private var doneToolBar: some View {
        Button {
            self.endEditing()
            self.viewUserModel.editUserData(
                user: user,
                name: name == "" ? "Username" : self.name,
                image: inputImage
            )
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
    
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
    
}
