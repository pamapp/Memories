//
//  MemoriesView.swift
//  memories
//
//  Created by Alina Potapova on 09.07.2021.
//

import SwiftUI

struct MemoriesView: View {
    var body: some View {
        ZStack {
            Color.init(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 50) {
                Text("Memories")
                    .titleStyle()
//                Spacer()
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .center, spacing: 40) {
//                        for memory in 0...3 {
                            MemoryView()
                            MemoryView()
                            MemoryView()
//                        }
                    }
                }
            }
            
        }
    }
}

struct MemoriesView_Previews: PreviewProvider {
    static var previews: some View {
        MemoriesView()
    }
}
