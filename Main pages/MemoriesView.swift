//
//  MemoriesView.swift
//  memories
//
//  Created by Alina Potapova on 09.07.2021.
//

import SwiftUI

struct MemoriesView: View {
    
    @EnvironmentObject var memoryData: MemoryData
    
    @State private var showingAddMemoryView = false
    
    var body: some View {
        ZStack {
            Color.init(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                Text("Memories")
                    .titleStyle()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .center, spacing: 25) {
                        ForEach(self.memoryData.memories.indexed(), id: \.1.id) { index, _ in
                            MemoryLabelView(memory: self.memoryData.memories[index])
//                                    .onTapGesture {
//                                        MemoryView(memory: self.memoryData.memories[index])
//                                    }
                        }
                    }
                }

                
                Button (action: {
                    self.showingAddMemoryView.toggle()
                }, label: {
                    RoundedRectangle(cornerRadius: 15.0)
                        .stroke(Color.white, lineWidth: 3)
                        .frame(width: 330, height: 110, alignment: .center)
                        .overlay(
                            VStack {
                                Image(systemName: "cloud.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 25))
                                    .padding(.bottom, 5)
                                Text("+ Add Memory")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .bold))
                            }
                    )
                }).sheet(isPresented: self.$showingAddMemoryView, content: {
                        MemoryAddView()
                            .environmentObject(self.memoryData)
                })
                
                
                Spacer()
            }
            
        }
    }
}

struct MemoriesView_Previews: PreviewProvider {
    static var previews: some View {
        MemoriesView()
    }
}
