//
//  MemoryView.swift
//  memories
//
//  Created by Alina Potapova on 09.07.2021.
//

import SwiftUI

struct MemoryLabelView: View {
    
    @EnvironmentObject var memoryData: MemoryData
    
    @State private var showingMemoryView = false
    
    var memory: Memory
    
    var body: some View {
        ZStack {
//            NavigationLink(destination: MemoryView(memory: self.memory).environmentObject(MemoryData()), label: {
//                RoundedRectangle(cornerRadius: 15)
//                    .frame(width: 330, height: 110)
//                    .foregroundColor(.white)
//                    .overlay (
//                        HStack(spacing: 30) {
//                            VStack(alignment: .leading, spacing: 20) {
//                                Text("\(self.memory.timeFormat)")
//                                    .font(.system(size: 20, weight: .bold, design: .serif))
//                                    .foregroundColor(.black)
//                                Text("\(self.memory.place)")
//                                    .font(.system(size: 20, weight: .medium, design: .serif))
//                                    .foregroundColor(.black)
//                            }.padding(.leading, 20)
//
//                            Image("\(self.memory.image)")
//                                .resizable()
//                                .frame(width: 70, height: 70)
//                                .padding(.trailing, 20)
//                        }
//                    )
//                }).frame(width: 330, height: 110)
            
            Button {
                self.showingMemoryView.toggle()
            } label: {
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 330, height: 105)
                    .foregroundColor(.blue)
                    .overlay (
                        HStack(spacing: 30) {
                            VStack(alignment: .leading, spacing: 20) {
                                Text("\(self.memory.timeFormat)")
                                    .font(.system(size: 20, weight: .bold, design: .serif))
                                    .foregroundColor(.white)
                                Text("\(self.memory.place)")
                                    .font(.system(size: 20, weight: .medium, design: .serif))
                                    .foregroundColor(.white)
                            }.padding(.leading, 20)

                            Image("\(self.memory.image)")
                                .resizable()
                                .frame(width: 70, height: 70)
                                .padding(.trailing, 20)
                        }
                    )
            }.sheet(isPresented: self.$showingMemoryView, content: {
                MemoryView(memory: self.memory, deleteAction: memoryData.delete)
                    .environmentObject(self.memoryData)
            })

        }
    }
}
