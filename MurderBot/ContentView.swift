//
//  ContentView.swift
//  MurderBot
//
//  Created by Mark Alldritt on 2021-01-31.
//

import SwiftUI
import CardStack
import ActivityIndicatorView


struct CardOverlay: View {
    //  CardOverlay displays the 'title', in this case the Plot seed value, of the card.
    
    var text: String
    
    var body: some View {
        ZStack {
            Text(text)
                .font(.body)
                .padding(EdgeInsets(top: 5, leading: 7, bottom: 5, trailing: 9))
                .foregroundColor(.black)
        }
        .background(RoundCorneredRectangle(tl: 8, tr: 0, bl: 0, br: 12)
                        .fill(Color.white.opacity(0.65)))
    }
}


struct CardView: View {
    //  An individual card displaying a plot appearing in the CardStack.  CardView has two modes:
    //
    //  - loading while waiting for the Plot.Fetch to receive a plot
    //  - displaying a loaded plot
    //
    
    @Environment(\.openURL) var openURL
    @ObservedObject var plotFetch: Plot.Fetch
    @State var showActivity = true

    private let cardColors = [#colorLiteral(red: 0.7265671492, green: 0.7860677242, blue: 0.7937102318, alpha: 1), #colorLiteral(red: 0.8190054893, green: 0.8204569221, blue: 0.7675603628, alpha: 1), #colorLiteral(red: 0.7900114655, green: 0.8009047508, blue: 0.7654793262, alpha: 1), #colorLiteral(red: 0.9045919776, green: 0.9105549455, blue: 0.8752011657, alpha: 1), #colorLiteral(red: 0.5154729486, green: 0.5264404416, blue: 0.486608386, alpha: 1), #colorLiteral(red: 0.7469534278, green: 0.8222278953, blue: 0.8033685088, alpha: 1), #colorLiteral(red: 0.9165374637, green: 0.9220481515, blue: 0.9042716622, alpha: 1), #colorLiteral(red: 0.8401653171, green: 0.855901897, blue: 0.8247912526, alpha: 1), #colorLiteral(red: 0.8039962649, green: 0.8246852756, blue: 0.7934988141, alpha: 1), #colorLiteral(red: 0.8850758672, green: 0.8908110261, blue: 0.8642533422, alpha: 1)]
    private let cardHeightScale = CGFloat(1.65)
    private let cardCornerRadius = CGFloat(12)
    private let cardShadowRadius = CGFloat(4)

    private func calcCardSize(_ size: CGSize) -> CGSize {
        let h = floor(size.width * cardHeightScale)
        
        if h > size.height {
            let w = floor(size.height / cardHeightScale)
            
            return CGSize(width: w,
                          height: size.height)
        }
        else {
            return CGSize(width: size.width,
                          height: h)
        }
    }

    var body: some View {
        GeometryReader { geo in
            let cardSize = calcCardSize(geo.size)
            let cardColor = cardColors.randomElement()!

            if let plot = plotFetch.plot { // Do we have a plot yet?
                // ...yes
                VStack {
                    VStack {
                        Text(plot.plot)
                            .font(.body).bold()
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                            .padding()
                    }
                    .frame(width: cardSize.width,
                           height: cardSize.height,
                           alignment: .center)
                    
                }
                .background(Color(cardColor))
                .cornerRadius(cardCornerRadius)
                .shadow(radius: cardShadowRadius)
                .overlay(CardOverlay(text: String(plot.seed)),
                         alignment: .bottomTrailing)
                .gesture(LongPressGesture(minimumDuration: 1) // Long Press views plot on https://midsomerplots.net
                    .onEnded { _ in
                        openURL(URL(string: "https://midsomerplots.net/#\(plot.seed)")!)
                    })
            }
            else {
                // ...no
                VStack {
                    VStack() {
                        let textColor = Color(UIColor.gray)
                        
                        HStack(alignment: .center) {
                            ActivityIndicatorView(isVisible: $showActivity, type: .scalingDots)
                                .frame(width: 20, height: 20)
                                .foregroundColor(textColor)
                            Text("Loading \(plotFetch.seed)...")
                                .font(.caption)
                                .foregroundColor(textColor)
                        }
                    }
                    .frame(width: cardSize.width,
                           height: cardSize.height,
                           alignment: .bottom)
                }
                .background(Color(cardColor))
                .cornerRadius(cardCornerRadius)
                .shadow(radius: cardShadowRadius)
            }
        }
    }
}


struct ContentView: View {
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
