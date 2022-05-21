//
//  TextStyles.swift
//  memories
//
//  Created by Alina Potapova on 09.07.2021.
//

import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.black)
            .font(.montserrat(25))
            .padding()
    }
}

struct MemoryText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.montserrat(25))
            .foregroundColor(.black)
            .accentColor(.black)
            .multilineTextAlignment(.center)
            .autocapitalization(.allCharacters)
    }
}

struct InfoLineText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.montserrat(18))
    }
}

struct ListFootnoteText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.montserrat(14))
            .foregroundColor(.secondary)
            .padding(.leading, 20)
    }
}
