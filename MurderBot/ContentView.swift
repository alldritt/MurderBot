//
//  ContentView.swift
//  MurderBot
//
//  Created by Mark Alldritt on 2021-01-31.
//

import SwiftUI
import CardStack
import ActivityIndicatorView


//  JSON response:
//
//  {
//      "plot": "A local candle maker is found in one of Mrs Lovett’s delicious meat pies. Suspicion falls on Drooping Point’s angry old-age pensioner, deeply concerned that a stash of WWII Nazi washing detergent might threaten the Midsomer space programme.",
//      "seed": 1612151766
//  }

struct Plot: Codable, Identifiable {
    var id: Int {
        return seed
    }
    let plot: String
    let seed: Int
    
    static let mock: [FetchPlot] = [
        FetchPlot(),
        FetchPlot(),
        FetchPlot(),
        FetchPlot(),
        FetchPlot(),
        FetchPlot(),
        FetchPlot()
    ]
}


let colors = [#colorLiteral(red: 0.7265671492, green: 0.7860677242, blue: 0.7937102318, alpha: 1), #colorLiteral(red: 0.8190054893, green: 0.8204569221, blue: 0.7675603628, alpha: 1), #colorLiteral(red: 0.7900114655, green: 0.8009047508, blue: 0.7654793262, alpha: 1), #colorLiteral(red: 0.9045919776, green: 0.9105549455, blue: 0.8752011657, alpha: 1), #colorLiteral(red: 0.5154729486, green: 0.5264404416, blue: 0.486608386, alpha: 1), #colorLiteral(red: 0.7469534278, green: 0.8222278953, blue: 0.8033685088, alpha: 1), #colorLiteral(red: 0.9165374637, green: 0.9220481515, blue: 0.9042716622, alpha: 1), #colorLiteral(red: 0.8401653171, green: 0.855901897, blue: 0.8247912526, alpha: 1), #colorLiteral(red: 0.8039962649, green: 0.8246852756, blue: 0.7934988141, alpha: 1), #colorLiteral(red: 0.8850758672, green: 0.8908110261, blue: 0.8642533422, alpha: 1)]


class FetchPlot: ObservableObject, Hashable {
    let id = UInt.random(in: 0...999999999)

    static func == (lhs: FetchPlot, rhs: FetchPlot) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    @Published var plot: Plot?
     
    init() {
        let url = URL(string: "https://midsomerplots.acrossthecloud.net/plot?seed=\(id)")!
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            do {
                if let plotData = data {
                    let plot = try JSONDecoder().decode(Plot.self, from: plotData)
                    
                    DispatchQueue.main.async {
                        self.plot = plot
                    }
                } else {
                    print("No data")
                }
            } catch {
                print("Error")
            }
        }.resume()
    }
}


struct RoundedCorners: Shape {
    var tl: CGFloat = 0.0
    var tr: CGFloat = 0.0
    var bl: CGFloat = 0.0
    var br: CGFloat = 0.0

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let w = rect.size.width
        let h = rect.size.height

        // Make sure we do not exceed the size of the rectangle
        let tr = min(min(self.tr, h/2), w/2)
        let tl = min(min(self.tl, h/2), w/2)
        let bl = min(min(self.bl, h/2), w/2)
        let br = min(min(self.br, h/2), w/2)

        path.move(to: CGPoint(x: w / 2.0, y: 0))
        path.addLine(to: CGPoint(x: w - tr, y: 0))
        path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr,
                    startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)

        path.addLine(to: CGPoint(x: w, y: h - br))
        path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br,
                    startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)

        path.addLine(to: CGPoint(x: bl, y: h))
        path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl,
                    startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)

        path.addLine(to: CGPoint(x: 0, y: tl))
        path.addArc(center: CGPoint(x: tl, y: tl), radius: tl,
                    startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)

        return path
    }
}


struct CardOverlay: View {
    var text: String
    
    var body: some View {
        ZStack {
            Text(text)
                .font(.footnote)
                .padding(EdgeInsets(top: 5, leading: 7, bottom: 5, trailing: 9))
                .foregroundColor(.black)
        }
        .background(RoundedCorners(tl: 8, tr: 0, bl: 0, br: 12).fill(Color.white.opacity(0.65)))
    }
}


struct CardView: View {
    @ObservedObject var plotFetch: FetchPlot
    @State var showActivity = true

    let cardHeightScale = CGFloat(1.65)

    func calcCardSize(_ size: CGSize) -> CGSize {
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
            let bgColor = colors.randomElement()!

            if let plot = plotFetch.plot {
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
                .background(Color(bgColor))
                .cornerRadius(12)
                .shadow(radius: 4)
                .overlay(CardOverlay(text: String(plot.seed)),
                         alignment: .bottomTrailing)
            }
            else {
                VStack {
                    VStack() {
                        let textColor = Color(UIColor.gray)
                        
                        HStack(alignment: .center) {
                            ActivityIndicatorView(isVisible: $showActivity, type: .scalingDots)
                                .frame(width: 20, height: 20)
                                .foregroundColor(textColor)
                            Text("Loading...")
                                .font(.caption)
                                .foregroundColor(textColor)
                        }
                    }
                    .frame(width: cardSize.width,
                           height: cardSize.height,
                           alignment: .bottom)
                }
                .background(Color(bgColor))
                .cornerRadius(12)
                .shadow(radius: 4)
            }
        }
    }
}


struct ContentView: View {
    @Environment(\.openURL) var openURL
    @State var fetches = Plot.mock

    var body: some View {
        VStack {
            CardStack(
                direction: EightDirections.direction,
                data: fetches,
                onSwipe: { plot, direction in
                    fetches.append(FetchPlot())
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
