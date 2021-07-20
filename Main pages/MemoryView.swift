//
//  MemoryView.swift
//  memories
//
//  Created by Alina Potapova on 20.07.2021.
//

import SwiftUI

struct MemoryView: View {
    
    @Environment(\.presentationMode) var isPresented
    
    var memory: Memory
    
    var deleteAction: (Memory) -> Void
    
    var body: some View {
        NavigationView {
        ZStack {
            Color.init(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 60) {
                Text("\(dayString(date: memory.date))")
                    .font(.system(size: 25, design: .serif))

                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 330, height: 330, alignment: .center)
                    .foregroundColor(.white)
                    .overlay(
                            Text(memory.text)
                                .font(.system(size: 25, design: .serif))
                                .foregroundColor(.black)
                                .padding(.leading, 10)
                                .padding(.trailing, 10)
                    )
                
                Button (action: {
                    self.delete()
                }, label: {
                    RoundedRectangle(cornerRadius: 15.0)
                        .frame(width: 300, height: 110, alignment: .center)
                        .foregroundColor(.red)
                        .overlay(
                            Text("DELETE")
                                .font(.system(size: 25, weight: .bold, design: .serif))
                                .foregroundColor(.white)
                    )
                })
                
                Spacer()
                
            }
            }
        }
    }
    
    var dayFormat: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }
    
    func dayString(date: Date) -> String {
         let time = dayFormat.string(from: date)
         return time
    }
    
    private func delete() {
        deleteAction(memory)
        self.isPresented.wrappedValue.dismiss()
    }
}
