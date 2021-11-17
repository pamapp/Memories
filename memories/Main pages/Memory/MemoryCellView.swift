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
    
    var timeFormat: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy, EE"
        return formatter.string(from: memory.date ?? Date())
    }
    
    var folder: Folder
    
    @ObservedObject var viewModel: MemoriesView.MemoryModel
    
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .frame(width: 330, height: 90, alignment: .leading)
            .foregroundColor(Color(UIColor.separator))
            .onAppear {
                self.loadImage()
            }
            .overlay (
                HStack() {
                Spacer()
                ZStack{
                    image?
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 65, height: 65)
                        .clipped()
                        .cornerRadius(7)
                    if memory.isFavorite {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .offset(x: -31.5, y: 31.5)
                    }
                }
                Spacer()
            
                VStack(alignment: .leading, spacing: 10) {
                    Text("\(timeFormat)")
                        .font(.system(size: 20, weight: .bold, design: .serif))
                        .foregroundColor(.white)
                    Text("\(memory.safePlace)")
                        .font(.system(size: 20, weight: .medium, design: .serif))
                        .foregroundColor(.white)
                }.frame(width: 180, height: 65, alignment: .leading)
            
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                }
            )
            .addButtonActions(leadingButtons: [], trailingButton: [.fav, .delete], onClick: { button in
                if button == CellButtons.delete {
                    withAnimation {
                        self.viewModel.removeMemory(memory: memory)
                    }
                } else if button == CellButtons.fav {
                    withAnimation {
                        self.viewModel.changeFavStatus(memory: memory)
                        print(memory.isFavorite)
                    }
                }
            })
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
