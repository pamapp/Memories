//
//  MemoryView.swift
//  memories
//
//  Created by Alina Potapova on 09.07.2021.
//

import SwiftUI

struct MemoryView: View {
    
//    @EnvironmentObject var alarmData: MemoryData
//    var memory: Memory
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .frame(width: 330, height: 110)
                .foregroundColor(.white)
                .overlay (
                    HStack {
                        Image("")
                            .frame(width: 50, height: 50)
                        VStack(alignment: .leading, spacing: 20) {
                            Text("23.06.2021")
                                .font(.system(size: 20, weight: .medium, design: .serif))
                                .foregroundColor(.black)
                            Text("Санкт-Петербург")
                                .font(.system(size: 20, weight: .medium, design: .serif))
                                .foregroundColor(.black)
                        }
                    }
                )
        }
    }
}

struct MemoryView_Previews: PreviewProvider {
    static var previews: some View {
        MemoryView()
    }
}
