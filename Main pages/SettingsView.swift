//
//  SettingsView.swift
//  memories
//
//  Created by Alina Potapova on 09.07.2021.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        ZStack {
            Color.init(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 50) {
                Text("Settings")
                    .titleStyle()
                Spacer()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
