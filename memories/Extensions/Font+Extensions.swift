//
//  Font+Extensions.swift
//  memories
//
//  Created by Alina Potapova on 19.04.2022.
//

import SwiftUI

extension Font {
    static func montserrat(_ size: CGFloat = 20) -> Font {
        .custom("Montserrat-Regular", size: size)
    }
    static func montserratBold(_ size: CGFloat = 20) -> Font {
        .custom("Montserrat-Bold", size: size)
    }
}
