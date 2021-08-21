////
////  MemoryEditView.swift
////  memories
////
////  Created by Alina Potapova on 14.08.2021.
////
//
//import SwiftUI
//
//struct MemoryEditView: View {
//    
//    @Environment(\.presentationMode) var isPresented
//    @EnvironmentObject private var dataController: DataController
////
////    @FetchRequest(entity: Memory.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Memory.date, ascending: false),]) var memories: FetchedResults<Memory>
////
//    @State private var date: Date
//    @State private var placeText: String
//    @State private var memoryText: String
//
//    @State var isShowPicker: Bool = false
//    @State var showDatePicker: Bool = false
//    
//    @State private var inputImage: UIImage?
//    @State private var image: Image?
//    
//    @Binding private var memory: Memory?
//    
//    init() {
//        UITextView.appearance().backgroundColor = .clear
//    }
//    
//    init(memory: Binding<Memory?>) {
//        self._memory = memory
//        self._date = State(initialValue: memory.wrappedValue?.safeDateContent ?? Date())
//        self._placeText = State(initialValue: memory.wrappedValue?.safeTextContent ?? "somewhere")
//        self._memoryText = State(initialValue: memory.wrappedValue?.safePlaceContent ?? "something")
//    }
//    
//    var dateFormat: String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd.MM.yyyy, EE"
//        return formatter.string(from: self.date)
//    }
//    
//    var body: some View {
//        ZStack {
//            VStack {
//                List {
//                    Section(header: Text("MEMORY INFO")) {
//                        HStack(alignment: .center) {
//                            Text("Date")
//                            
//                            Spacer()
//                            
//                            Button {
//                                self.endEditing()
//                                self.showDatePicker.toggle()
//                            } label: {
//                                Text(dateFormat)
//                                    .font(.system(size: 18, design: .serif))
//                                    .foregroundColor(.secondary)
//                            }
//                        }
//                        
//                        HStack() {
//                            Text("Place")
//                            
//                            Spacer()
//                            
//                            TextField("Somewhere", text: $placeText)
//                                .multilineTextAlignment(.trailing)
//                                .foregroundColor(.secondary)
//                                .font(.system(size: 18, design: .serif))
//                         
//                        }
//                        
//                        HStack(alignment: .center) {
//                            Text("Image")
//                            
//                            Spacer()
//                            
//                            Button {
//                                self.endEditing()
//                                self.isShowPicker.toggle()
//                                
//                            } label: {
//                                image?
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(height: 50)
//                                    .cornerRadius(10)
//                            }.sheet(isPresented: $isShowPicker, onDismiss: loadImage) {
//                                ImagePicker(image: self.$inputImage)
//                            }
//                        }.padding(.top, 5).padding(.bottom, 5)
//                    }
//                    
//                    Section(header: Text("MEMORY")) {
//                        TextEditor(text: $memoryText)
//                            .foregroundColor(.white)
//                            .frame(height: UIScreen.main.bounds.height / 6.5)
//                    }
//                }
//                .listStyle(.grouped)
//                .padding(.top, 10)
//                .hasScrollEnabled(false)
//
//                Spacer()
//            }
//            .navigationBarTitle(Text("New Memory"), displayMode: .inline)
//            .navigationBarItems(trailing:
//                Button(action: {
//                    self.saveMemoryEdit()
//                    self.isPresented.wrappedValue.dismiss()
//                }, label: {
//                    Text("Save")
//                        .foregroundColor(.blue)
//                })
//            )
//            
//            if self.showDatePicker {
//                ZStack {
//                    Color.black
//                    
//                    VStack() {
//                        DatePicker("Prompt Text", selection: $date)
//                            .accentColor(.blue)
//                            .background(
//                                RoundedRectangle(cornerRadius: 10)
//                                    .fill(Color.blue)
//                                    .opacity(0.1)
//                            )
//                            .datePickerStyle(GraphicalDatePickerStyle())
//                            .frame(width: 300, height: 400)
//                        
//                        Button {
//                            self.showDatePicker.toggle()
//                        } label: {
//                            RoundedRectangle(cornerRadius: 5)
//                                .foregroundColor(.blue)
//                                .frame(width: 70, height: 30)
//                                .overlay(
//                                    Text("Save")
//                                        .foregroundColor(.white)
//                                )
//                        }
//
//                    }
//                }
//            }
//        }
//    }
//
////    func loadImage() {
////        guard let inputImage = inputImage else { return }
////        image = Image(uiImage: inputImage)
////    }
////
//    func loadImage() {
//        guard let inputImage = inputImage else { return }
//        image = Image(uiImage: inputImage)
//
//
//    }
//    
////    func savesImage(Name: String, inputImage: UIImage?) {
////        let fileName = helper.getDocumentsDirectory().appendingPathComponent(Name)
////        do {
////            if let jpegData = inputImage?.jpegData(compressionQuality: 0.8) {
////                try jpegData.write(to: fileName, options: [.atomicWrite, .completeFileProtection])
////            }
////        } catch {
////            print("Unable to save image")
////        }
////     }
//    
//    func saveMemoryEdit() {
//        if let memory = memory {
//            if date != memory.safeDateContent ||
//                placeText != memory.safePlaceContent ||
//                memoryText != memory.safeTextContent {
//                memory.date = date
//                memory.place = placeText
//                memory.text = memoryText
//            }
//        }
//        
//        dataController.save()
//    }
//    
//    private func endEditing() {
//        UIApplication.shared.endEditing()
//    }
//    
//}
