//
//  CustomTextField.swift
//  memories
//
//  Created by Alina Potapova on 23.07.2021.
//

import SwiftUI

struct CustomTextField: View {
    var curWidth: CGFloat
    var curHeight: CGFloat
    var fieldType: Bool
    var placeholder: Text
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    @Binding var text: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(.white)
                .frame(width: curWidth, height: curHeight, alignment: .leading)
                .overlay(
                    HStack (alignment: .top) {
                    
                        ZStack(alignment: .leading)
                        {
                            if text.isEmpty { placeholder }

                            if !fieldType
                            {
                                TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
                            }
                            
                            ZStack (alignment: .leading)
                            {
                                if fieldType {
                                    TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
                                }
                            }
                        }
                        
                    }.frame(width: curWidth, height: curHeight, alignment: .leading)
                        
                )
        }
    }
}
