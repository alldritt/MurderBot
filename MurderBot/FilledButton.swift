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

    let title: String
    let action: () -> Void

    var body: some View {
        Button(title) {
            action()
        }
        .buttonStyle(.borderedProminent)
        .frame(maxWidth: .infinity)
    }
}

