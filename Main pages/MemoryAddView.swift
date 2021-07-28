//
//  MemoryAddView.swift
//  memories
//
//  Created by Alina Potapova on 16.07.2021.
//


//TextEditor(text: $memoryText)
//    .foregroundColor(.black)
//    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.5)

import SwiftUI

struct MemoryAddView: View {
    
    @EnvironmentObject var memoryData: MemoryData

    @State var memoryText: String = ""
    @State var placeText: String = ""
    
    @State var isShowPicker: Bool = false
    @State var image: Image? = Image("placeholder")
    
    private enum Strings {
        static let linePlaceHolder = "|"
    }
    
    var body: some View {
            VStack {
                ZStack {
                    VStack {
                        ZStack {
//                            RoundedRectangle(cornerRadius: 10)
//                                .stroke(Color.secondary, lineWidth: 1)
//                                .frame(width: 75, height: 75)
//                                .overlay(
                                    Image(systemName: "photo")
                                        .resizable()
                                        .font(.headline)
                                        .foregroundColor(.secondary)
                                        .scaledToFit()
                                        .frame(height: 75)
//                                )
                            
                            image?
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                        }.padding(.top, 15)
                        
                        
                        Button(action: {
                            withAnimation {
                                self.isShowPicker.toggle()
                            }
                        }) {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 2)
                                .frame(width: 120, height: 35)
                                .overlay(
                                    Text("Select image")
                                        .foregroundColor(.blue)
                                )
                        }.padding(12)
                        
                    }.ignoresSafeArea(.keyboard)
                    
                }.sheet(isPresented: $isShowPicker) {
                    ImagePicker(image: self.$image)
                }
                
                Divider()
                
                VStack(alignment: .leading) {
                    ZStack {
                        TextField("...", text: $memoryText)
//                          .padding(30)
                            .lineLimit(0)

                    }
                }
                
                Spacer()
            }
            .navigationBarTitle(Text("New Memory"), displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    self.addMemory()
                }, label: {
                    Text("Save")
                        .foregroundColor(.blue)
                })
            )
    }
    
    private func addMemory() {
        if memoryText != ""{
            let newMemory = Memory(
                id: UUID().uuidString,
                date: Date(),
                text: memoryText,
                image: ImageTest(withImage: image.asUIImage()),
                place: "Saint-Petesburg")
            memoryData.add(newMemory)
        }
    }
}


struct ImagePicker: UIViewControllerRepresentable {

    @Environment(\.presentationMode)
    var presentationMode

    @Binding var image: Image?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        @Binding var presentationMode: PresentationMode
        @Binding var image: Image?

        init(presentationMode: Binding<PresentationMode>, image: Binding<Image?>) {
            _presentationMode = presentationMode
            _image = image
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            image = Image(uiImage: uiImage)
            presentationMode.dismiss()

        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.dismiss()
        }

    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentationMode: presentationMode, image: $image)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

}
