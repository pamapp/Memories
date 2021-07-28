//
//  ImagePicker.swift
//  memories
//
//  Created by Alina Potapova on 27.07.2021.
//
//
//import SwiftUI
//import Foundation
//
//struct ImagePicker: UIViewControllerRepresentable {
//    @Environment(\.presentationMode) var presentationMode
//    @Binding var image: UIImage?
//
//    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        return picker
//    } 
//
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
//
//    }
//}
//
//class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//    let parent: ImagePicker
//
//    init(_ parent: ImagePicker) {
//        self.parent = parent
//    }
//}
