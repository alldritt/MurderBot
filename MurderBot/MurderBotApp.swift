//
//  MurderBotApp.swift
//  MurderBot
//
//  Created by Mark Alldritt on 2021-01-31.
//

import SwiftUI

@main
struct MurderBotApp: App {
    var body: some Scene {
        WindowGroup {
            #if os(iOS)
            ContentViewiOS()
            #endif
            #if os(tvOS)
            ContentViewTVOS()
            #endif
        }
    }
}
