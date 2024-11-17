//
//  ContentViewTVOS.swift
//  MurderBot
//
//  Created by Mark Alldritt on 2023-04-12.
//

import SwiftUI
import SwiftfulLoadingIndicators
import ProgressIndicatorView


struct ContentViewTVOS: View {
    private let seconds = TimeInterval(60)
    private static let timer = Timer.publish(every: 1.0 / 10, on: .main, in: .common).autoconnect()

    @ObservedObject var fetch = Plot.Fetch()
    @State var timeStart: Date?
    @State var progress = CGFloat(0.6)

    var body: some View {
        VStack {
            if let plot = fetch.plot?.plot {
                Spacer()
                VStack {
                    Text(plot)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                    Text("midsomerplots.net")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .padding(2)
                }
                .opacity(timeStart == nil ? 0 : 1)
                .padding(50)
                Spacer()
                Button {
                    withAnimation() {
                        timeStart = nil
                        fetch.regenerate()
                    }
                }
                label: {
                    HStack(spacing: 30) {
                        ProgressIndicatorView(isVisible: .constant(true),
                                              type: .circle(progress: $progress,
                                                            lineWidth: 3.0,
                                                            strokeColor: .primary,
                                                            backgroundColor: .secondary.opacity(0.3)))
                            .frame(width: 26, height: 26)
                        Text("Next Murder Plot")
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                }
            }
            else {
                Spacer()
                LoadingIndicator(animation: .pulseOutline)
                Spacer()
                Button {}
                label: {
                    HStack(spacing: 30) {
                        Color.clear
                            .frame(width: 26, height: 26)
                        Text("Next Murder Plot")
                            .frame(height: 18)
                    }
                }
                .disabled(true)
            }
        }
        .onAppear() {
            print("onAppear")
            timeStart = Date()
            
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear() {
            print("onDisappear")
            UIApplication.shared.isIdleTimerDisabled = false
        }
        .onReceive(Self.timer) { t in
            guard let _ = fetch.plot else { return }
            let secs = Date().timeIntervalSince(timeStart!)
            let progress = secs / seconds
                        
            if progress >= 1 {
                self.progress = -29
                withAnimation {
                    timeStart = nil
                    fetch.regenerate()
                }
            }
            else {
                self.progress = 1.29 * (1 - progress) - 0.29
            }
        }
        .onChange(of: fetch.plot?.plot, perform: { newValue in
            if fetch.plot != nil {
                withAnimation {
                    timeStart = Date()
                }
            }
        })
    }
}
