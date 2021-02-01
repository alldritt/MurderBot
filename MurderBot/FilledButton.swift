//
//  FilledButton.swift
//  MurderBot
//
//  Created by Mark Alldritt on 2021-01-31.
//
//
//  A SwiftUI Button with a rounded, filled background.
//

import SwiftUI


struct FilledButton: View {
    var buttonWidth: CGFloat {
        #if os(watchOS)
        let w = WKInterfaceDevice.current().screenBounds.size.width
        #elseif os(iOS)
        let w = UIScreen.main.bounds.size.width
        #elseif os(macOS)
        let w = NSScreen.main.bounds.size.width
        #endif

        return w * 0.8 // 80%
    }
    let title: String
    let action: () -> Void

    var body: some View {
        #if os(watchOS)
        Button(title, action: action)
        #else
        Button(action: action) {
            Text(title)
                .font(.headline)
                .frame(width: buttonWidth * 0.8, height: 40)
                .foregroundColor(.white)
                .background(Color.accentColor)
                .cornerRadius(10)
        }
        #endif
    }
}

