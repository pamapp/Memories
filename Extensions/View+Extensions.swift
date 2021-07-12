//
//  View+Extensions.swift
//  memories
//
//  Created by Alina Potapova on 09.07.2021.
//

import SwiftUI

extension View {
    public func titleStyle() -> some View {
        self.modifier(Title())
    }
}
