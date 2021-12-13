//
//  MemoryAddView.swift
//  memories
//
//  Created by Alina Potapova on 16.07.2021.
//

import SwiftUI

struct MemoryAddView: View {
    
    @Environment(\.presentationMode) var isPresented
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var memoryText: String = ""
    @State private var placeText: String = ""
    @State private var date: Date = Date()
    
    var folder: Folder
    
    @State var isShowPicker: Bool = false
    @State var showDatePicker: Bool = false
    
    @State private var inputImage: UIImage?
    @State private var image: Image? = Image("test_photo")
    
    @ObservedObject var viewModel: MemoriesView.MemoryModel
    
    var timeFormat: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy, HH:mm"
        return formatter.string(from: self.date)
    }

    var body: some View {
        ZStack {
            VStack {
                List {
                    Section(header: Text("MEMORY INFO")) {
                        HStack(alignment: .center) {
                            Text("Date")
                            
                            Spacer()
                            
                            Button {
                                self.endEditing()
                                self.showDatePicker.toggle()
                            } label: {
                                Text(timeFormat)
                                    .font(.system(size: 18, design: .serif))
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        HStack() {
                            Text("Place")
                            
                            Spacer()
                            
                            TextField("Somewhere", text: $placeText)
                                .multilineTextAlignment(.trailing)
                                .foregroundColor(.secondary)
                                .font(.system(size: 18, design: .serif))
                         
                        }
                        
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
                    
                    Section(header: Text("MEMORY")) {
                        TextEditor(text: $memoryText)
                            .foregroundColor(.white)
                            .frame(height: UIScreen.main.bounds.height / 6.5)
                            .onAppear() {
                               UITextView.appearance().backgroundColor = .clear
                             }
                    }
                }
                .listStyle(.grouped)
                .padding(.top, 10)
                .hasScrollEnabled(false)

                Spacer()
            }
            .navigationBarTitle(Text("New Memory"), displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    self.viewModel.addNewMemory(
                        place: placeText,
                        text: memoryText,
                        date: date,
                        folder: folder,
                        image: inputImage)
                    self.isPresented.wrappedValue.dismiss()
                }, label: {
                    Text("Save")
                })
            )
            
            if self.showDatePicker {
                ZStack {
                    Color.black
                        .edgesIgnoringSafeArea(.all)
                        
                    
                    VStack() {
                        DatePicker("Prompt Text", selection: $date, displayedComponents: [.date])
                            .accentColor(.red)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.blue)
                                    .opacity(0.1)
                            )
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .frame(width: 300, height: 400)
                        
                        Button {
                            self.showDatePicker.toggle()
                        } label: {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(.red)
                                .frame(width: 70, height: 30)
                                .overlay(
                                    Text("Save")
                                        .foregroundColor(.white)
                                )
                        }
                    }
                }.navigationBarHidden(true)
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    func savesImage(Name: String, inputImage: UIImage?) {
        let fileName = helper.getDocumentsDirectory().appendingPathComponent(Name)
        do {
            if let jpegData = inputImage?.jpegData(compressionQuality: 0.8) {
                try jpegData.write(to: fileName, options: [.atomicWrite, .completeFileProtection])
            }
        } catch {
            print("Unable to save image")
        }
     }

    func addMemory() {
//        if let id = id{ // Ak mame id poznamku iba editujeme
//            let note = notes.filter({$0.id == id}).map({return $0}) // Ziskame konkretnu poznamku
//            if(note.count != 0) {
//                note[0].content = text
//                note[0].name = name
//                note[0].date = Date()
//            }
//        } else{
//        let newMemory = Memory(context: dataController.context)
//        newMemory.id = UUID()
//        newMemory.date = self.date
//        newMemory.place = self.placeText
//        newMemory.text = self.memoryText
//        newMemory.folder = self.folder
//        dataController.save()
    
    
//        savesImage(Name: newMemory.id!.uuidString, inputImage: inputImage)
    }
    
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
    
}
