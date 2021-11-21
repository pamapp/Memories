//
//  ButtonStyle.swift
//  memories
//
//  Created by Alina Potapova on 18.11.2021.
//

import SwiftUI

struct MemoryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color.black)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .scaleEffect(configuration.isPressed ? 1.02 : 1)
            .foregroundColor(configuration.isPressed ? Color.gray: Color(UIColor.separator))
    }
}


struct FolderButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
//            .background(Color.black)
//            .clipShape(RoundedRectangle(cornerRadius: 30))
            .scaleEffect(configuration.isPressed ? 1.02 : 1)
            .foregroundColor(configuration.isPressed ? Color.gray: Color(UIColor.separator))
    }
}
