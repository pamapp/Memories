//
//  TestView.swift
//  memories
//
//  Created by Alina Potapova on 21.04.2022.
//

import SwiftUI

struct TestView: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
            ZStack {
                Color.mainBackgroundColor
                    .ignoresSafeArea()
            
                VStack {
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach(0..<5) { folder in
                                    RoundedRectangle(cornerRadius: 15)
                                    .frame(width: UIScreen.main.bounds.width / 2.3, height: UIScreen.main.bounds.height / 4.7)
                                        .foregroundColor(.cellColor)
                                        .overlay(
                                            VStack {
                                                Image("test_photo")                        .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: UIScreen.main.bounds.width / 2.3, height: UIScreen.main.bounds.height / 10)
                                                    .clipped()
                                                    .cornerRadius(15)
                                                
                                                Spacer()
                                                
                                                VStack(alignment: .leading) {
                                                    HStack(spacing: 1) {
                                                        Image(systemName: "mappin")
                                                            .font(.system(size: 7))
                                                            .foregroundColor(.gray)
                                                        Text("Pushkin")
                                                            .font(.montserrat(8))
                                                            .foregroundColor(.gray)
                                                    }
                                                    .padding(.horizontal, 6)
                                                    
                                                    HStack {
                                                        Text("Сделай завтра новый вид воспоминаний")
                                                            .font(.montserrat(9))
                                                            .lineSpacing(3)
                                                            .foregroundColor(.white)
                                                            .frame(height: UIScreen.main.bounds.height / 20)
                                                    }.padding(.horizontal, 8)
                                                    
                                                    
                                                    HStack {
                                                        Text("July 1")
                                                            .font(.system(size: 8))
                                                            .foregroundColor(.gray)
                                                        Spacer()
                                                        Text("Jyly Borsh")
                        //                                    .font(.montserrat(8))
                                                            .font(.system(size: 8))
                                                            .foregroundColor(.gray)
                                                            .fontWeight(.bold)
                                                    }
                                                    .padding(.horizontal, 10)
                                                    .padding(.bottom, 8)
                                                    
                                                }
                                            }
                                        )
                                        .padding(.horizontal, 20)
                                    
                            }
                        }
                    }
                }
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
