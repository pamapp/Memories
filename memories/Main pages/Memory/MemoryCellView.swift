//
//  MemoryCellView.swift
//  memories
//
//  Created by Alina Potapova on 09.07.2021.
//

import SwiftUI

struct MemoryCellView: View {
    @State private var showingMemoryView = false
    @State private var inputImage: UIImage?
    @State private var image: Image? = Image("test_photo")
    
    var memory: Memory
    
    @ObservedObject var viewModel: MemoriesView.MemoryModel
    
    var width: Double
    var height: Double
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .frame(width: width / 2.4, height: height / 3.95)
            .foregroundColor(self.viewModel.getMemoryColor(memory: memory))
            .opacity(0.5)
            .onAppear {
                self.loadImage()
            }
            .overlay(
                VStack {
                    image?
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: width / 2.4, height: height / 9.3)
                        .clipped()
                        .cornerRadius(15)
                    
                    Spacer()
                    
                    VStack {
                        HStack(spacing: 1) {
                            Image(systemName: "mappin")
                                .font(.system(size: 10))
                                .foregroundColor(.gray)
                            Text("\(memory.safePlace)")
                                .font(.montserrat(11))
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .padding(.horizontal, 10)
                        
                        HStack {
                            Text("\(memory.safeText)")
                                .font(.montserrat(12))
                                .lineSpacing(4)
                                .foregroundColor(.white)
                                .frame(height: height / 17)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        
                        
                        HStack {
                            Text("\(timeFormat)")
                                .font(.system(size: 11))
                                .foregroundColor(.gray)
                            Spacer()
                            Text("\(memory.safeTitle)")
                                .font(.system(size: 11))
                                .foregroundColor(.gray)
                                .fontWeight(.bold)
                        }
                        .padding(.horizontal, 10)
                        .padding(.bottom, 8)
                        
                    }
                }
            )
            
        }
    
    var timeFormat: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        return formatter.string(from: memory.date ?? Date())
    }
    
    func loadImage() {
        if memory.id == nil {
            print("nil")
        }
        else {
            let data = helper.loadImage(imageIdName: memory.id!.uuidString)
            guard  let loadedData = data else {
                return
            }
            self.inputImage =  UIImage(data: loadedData)
            self.image = Image(uiImage: inputImage!)
        }
    }
}

