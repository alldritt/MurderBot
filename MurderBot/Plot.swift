//
//  Plot.swift
//  MurderBot
//
//  Created by Mark Alldritt on 2021-02-01.
//

import Foundation


//  https://midsomerplots.net JSON response:
//
//  {
//      "plot": "A local candle maker is found in one of Mrs Lovett’s delicious meat pies. Suspicion falls on Drooping Point’s angry old-age pensioner, deeply concerned that a stash of WWII Nazi washing detergent might threaten the Midsomer space programme.",
//      "seed": 1612151766
//  }
//
//  The Plot struct models a plot.  The Plot.Fetch class queries the https://midsomerplots.net server for a plot.

struct Plot: Codable, Identifiable {
    var id: UInt {
        return seed
    }
    let plot: String
    let seed: UInt
    
    class Fetch: ObservableObject, Hashable, Identifiable {
        private (set) var seed: UInt
        
        var id: UInt { seed }

        //  Conform to Equitable
        static func == (lhs: Fetch, rhs: Fetch) -> Bool {
            return lhs.seed == rhs.seed
        }
        
        //  Conform to Hashable
        func hash(into hasher: inout Hasher) {
            hasher.combine(seed)
        }

        @Published var plot: Plot?
        
        init() {
            seed = UInt.random(in: 0...999999999)
            getPlot()
        }
        
        init(seed: UInt) {
            self.seed = seed
            getPlot()
        }
        
        public func regenerate() {
            seed = UInt.random(in: 0...999999999)
            plot = nil
            getPlot()
        }
        
        private func getPlot() {
            let url = URL(string: "https://midsomerplots.acrossthecloud.net/plot?seed=\(seed)")!
            
            #if true
            Task {
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    let plot = try JSONDecoder().decode(Plot.self, from: data)
                    
                    await MainActor.run {
                        self.plot = plot
                    }
                }
                catch (let e) {
                    print("Exception \(e)")
                }
            }
            #else
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
            #endif
        }
    }
}
