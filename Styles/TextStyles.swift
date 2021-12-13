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
            .font(.system(size: 25, weight: .bold, design: .serif))
            .padding()
    }
}

struct MemoryText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 25, weight: .bold, design: .serif))
            .foregroundColor(.black)
            .accentColor(.black)
            .multilineTextAlignment(.center)
            .autocapitalization(.allCharacters)
    }
}

struct InfoLineText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 18))
    }
}

