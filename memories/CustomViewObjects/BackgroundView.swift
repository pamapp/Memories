//
//  BackgroundView.swift
//  memories
//
//  Created by Alina Potapova on 12.02.2022.
//

import SwiftUI

struct BackgroundView: View {
    private enum Strings {
        static let polyAlarm = "POLYALARM"
        static let poly = "POLY"
        static let alarm = "ALARM "
    }
    
    var body: some View {
        ZStack {
//            LinearGradient(gradient: Gradient(colors: [.topLeadingColor, .bottomTrailingColor]), startPoint: .topLeading, endPoint: .bottomTrailing)
//                .edgesIgnoringSafeArea(.all)
//            
            Color.black
                .opacity(0.5)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
