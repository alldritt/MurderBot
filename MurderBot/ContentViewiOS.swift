//
//  ContentView.swift
//  MurderBot
//
//  Created by Mark Alldritt on 2021-01-31.
//

import SwiftUI
import ZLSwipeableViewSwiftUI


struct ContentViewiOS: View {
    @Environment(\.openURL) var openURL

    var body: some View {
        VStack {
            SwipeableView() {
                CardView(plotFetch: Plot.Fetch())
            }
            .numberOfActiveView(6)
            .padding()
            FilledButton(title: "@midsomerplots") {
                openURL(URL(string: "https://midsomerplots.net")!)
            }
        }
    }
}


struct ContentViewiOS_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewiOS()
    }
}
