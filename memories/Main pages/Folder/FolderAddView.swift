//
//  FolderAddView.swift
//  memories
//
//  Created by Alina Potapova on 16.08.2021.
//

import SwiftUI

struct FolderAddView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode

    @State private var name: String = ""
    
    @State private var inputImage: UIImage?
    @State private var image: Image? = Image("test_photo")
    
    @State var isShowPicker: Bool = false
    
    @ObservedObject var viewModel: FoldersView.FolderModel
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section {
                        HStack() {
                            Text("Name")
                            
                            Spacer()
                            
                            TextField("Name", text: $name)

                                .multilineTextAlignment(.trailing)
                                .foregroundColor(.secondary)
                                .font(.system(size: 18, design: .serif))
                         
                        }.padding(.top, 5).padding(.bottom, 5)
                        
                        HStack(alignment: .center) {
                            Text("Image")
                            
                            Spacer()
                            
                            Button {
                                self.endEditing()
                                self.isShowPicker.toggle()
                                
                            } label: {
                                image?
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 50)
                                    .cornerRadius(10)
                            }
                            .sheet(isPresented: $isShowPicker, onDismiss: loadImage) {
                                ImagePicker(image: self.$inputImage)
                                    .accentColor(.red)
                            }
                        }.padding(.top, 5).padding(.bottom, 5)
                    }
                }
            }
            .padding(.top, 20)
            .navigationTitle(self.name == "" ? "New Folder" : "\(self.name)")
            .toolbar {
                doneToolBar
            }
        }.accentColor(.purple)
    }
    

    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }

    private var doneToolBar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Done") {
                self.viewModel.addNewFolder(name: name == "" ? "Folder" : self.name, image: inputImage)
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
}

