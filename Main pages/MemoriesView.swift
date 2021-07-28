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
        NavigationView {
            VStack {
                Divider()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .center, spacing: 25) {
                        ForEach(self.memoryData.memories.indexed(), id: \.1.id) { index, _ in
                            MemoryLabelView(memory: self.memoryData.memories[index])
                        }
                    }
                }.padding(.top, 15)

                NavigationLink(destination: MemoryAddView().environmentObject(self.memoryData), label: {
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 900, height: 90, alignment: .center)
                        .overlay(
                            Image(systemName: "cloud.fill")
                                .foregroundColor(.blue)
                                .font(.system(size: 30))
                                .padding(.bottom, 5)
                        )
                })
            }
            .navigationTitle("Memories")
        }
    }
}

struct MemoriesView_Previews: PreviewProvider {
    static var previews: some View {
        MemoriesView()
    }
}
