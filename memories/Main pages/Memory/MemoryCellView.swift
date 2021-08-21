//
//  MemoryView.swift
//  memories
//
//  Created by Alina Potapova on 09.07.2021.
//

import SwiftUI

struct MemoryCellView: View {
    
    @State private var showingMemoryView = false
    
    @State private var inputImage: UIImage?
    @State private var image: Image? = Image("test_photo")
    
    @State var memory: Memory
    
    var body: some View {
        NavigationLink(destination: MemoryView(memory: memory), label: {
                RoundedRectangle(cornerRadius: 15)
                .frame(width: 330, height: 90, alignment: .leading)
                .foregroundColor(Color(UIColor.separator))
                
                    .overlay (
                        HStack() {
                            Spacer()
                        
                        image?
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 65, height: 65)
                            .clipped()
                            .cornerRadius(7)
                        
                        Spacer()
                        
                            VStack(alignment: .leading, spacing: 10) {
                                Text("\(timeFormat)")
                                    .font(.system(size: 20, weight: .bold, design: .serif))
                                    .foregroundColor(.white)
                                Text("\(memory.place!)")
                                    .font(.system(size: 20, weight: .medium, design: .serif))
                                    .foregroundColor(.white)
                            }.frame(width: 180, height: 65, alignment: .leading)
                        
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                                .padding(.leading, 20)
                                .padding(.trailing, 20)
                        }
                    )
        })
        .onAppear {
            self.loadImage()
        }
    }
    
    var timeFormat: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy, EE"
        return formatter.string(from: memory.date!)
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
