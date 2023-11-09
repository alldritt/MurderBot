//
//  ContentView.swift
//  MurderBot
//
//  Created by Mark Alldritt on 2021-01-31.
//

import SwiftUI
import CardStack


struct ContentViewiOS: View {
    @Environment(\.openURL) var openURL
    @State var fetches = [Plot.Fetch(),  // seed the CardStack with some plots...
                          Plot.Fetch(),
                          Plot.Fetch(),
                          Plot.Fetch(),
                          Plot.Fetch(),
                          Plot.Fetch(),
                          Plot.Fetch()]

    var body: some View {
        VStack {
            CardStack(
                direction: EightDirections.direction,
                data: fetches,
                onSwipe: { plot, direction in
                    fetches.append(Plot.Fetch())
                },
                content: { plot, direction, isOnTop in
                    CardView(plotFetch: plot)
                }
            )
            .padding(10)
            FilledButton(title: "@midsomerplots") {
                openURL(URL(string: "https://twitter.com/midsomerplots")!)
            }
        }
    }
}


struct ContentViewiOS_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewiOS()
    }
}
