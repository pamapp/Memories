//
//  cell_test.swift
//  memories
//
//  Created by macbook on 14.10.2022.
//

import SwiftUI

struct cell_test: View {
    var width = UIScreen.main.bounds.width
    var height = UIScreen.main.bounds.height
    @State private var image: Image? = Image("test_photo")
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .frame(width: width / 2.4, height: height / 3.95)
            .foregroundColor(.cellColor)
            .opacity(0.5)
//            .onAppear {
//                self.loadImage()
//            }
            .overlay(
                VStack {
                    image?
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: width / 2.4, height: height / 9.2)
                        .clipped()
                        .cornerRadius(15)
                    
                    Spacer()
                    
                    VStack {
                        HStack(spacing: 1) {
                            Image(systemName: "mappin")
                                .font(.system(size: 10))
                                .foregroundColor(.memoryGray)
                            Text("Saint-Petersburg")
//                                .frame(width: width / 3)
                                .font(.montserrat(10))
                                .foregroundColor(.memoryGray)
                                .multilineTextAlignment(.leading)
                                .truncationMode(.tail)
                            Spacer()
                        }
                        .padding(.horizontal, 10)

                        HStack {
                            Text("Some memory text Some memory text Some memory text Some memory text Some memory text Some memory textb")
                                .font(.montserrat(10))
                                .lineSpacing(4)
                                .foregroundColor(.white)
                                .frame(height: height / 17)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        .padding(.horizontal, 10)
                        .padding(.bottom, 6)
                        
                        
                        HStack {
                            Text("Октябрь 14")
                                .font(.montserrat(10))
                                .foregroundColor(.memoryGray)
                            Spacer()
                            Text("Test Title")
                                .font(.montserrat(10))
                                .foregroundColor(.memoryGray)
                                .fontWeight(.bold)
                        }
                        .padding(.horizontal, 10)
                        .padding(.bottom, 10)
                        
                    }
                }
            )
            
        }
    
//    var timeFormat: String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MMMM d"
//        return formatter.string(from: memory.date ?? Date())
//    }
    
//    func loadImage() {
//        if memory.id == nil {
//            print("nil")
//        }
//        else {
//            let data = helper.loadImage(imageIdName: memory.id!.uuidString)
//            guard  let loadedData = data else {
//                return
//            }
//            self.inputImage =  UIImage(data: loadedData)
//            self.image = Image(uiImage: inputImage!)
//        }
//    }
}

struct cell_test_Previews: PreviewProvider {
    static var previews: some View {
        cell_test()
    }
}
