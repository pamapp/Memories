//
//  MemoryAddView.swift
//  memories
//
//  Created by Alina Potapova on 16.07.2021.
//

import SwiftUI

struct MemoryAddView: View {
    @Environment(\.presentationMode) var isPresented
    
    @EnvironmentObject var memoryData: MemoryData

    @State var memoryText: String = ""
    @State var placeText: String = ""
    
    var body: some View {
        ZStack {
            VStack {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Memory:")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    VStack {
                        TextField("Print something...", text: $memoryText)
                        Divider()
                    }
                    
                    Text("Place:")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    VStack {
                        TextField("Print place", text: $placeText)
                        Divider()
                    }
                }
                
                HStack(alignment: .center) {
                    Button(action: {
                        self.addMemory()
                    }, label: {
                        Text("Save Memory")
                            .foregroundColor(.blue)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 1)
                            )
                    }).padding(.top)
                }
            }
        }
    }
    
    private func addMemory() {
//        if memoryText != "" && placeText != "" {
            let newMemory = Memory(
                id: UUID().uuidString,
                date: Date(),
                text: memoryText,
                image: "test_photo",
                place: placeText)
            memoryData.add(newMemory)
//        }
        self.isPresented.wrappedValue.dismiss()
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//var date: Date
//var image: String
//var place: String
