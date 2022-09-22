//
//  CoinList.swift
//  Coin Prices
//
//  Created by Ethan MacDonald on 7/21/22.
//

import SwiftUI

struct ContentView: View {
    @State var results = TaskEntry()
    @State var showSheetView = false
      
    var body: some View {
        NavigationView {
            List(results, id: \.id) { item in
                NavigationLink(destination: CoinView(id: item.id)) {
                    HStack {
                        AsyncImage(url: URL(string: item.image)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24, alignment: .center)
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(Color.primary)
                            Spacer()
                            Text(item.symbol)
                                .font(.system(size: 12, weight: .regular, design: .rounded))
                                .textCase(.uppercase)
                                .foregroundColor(Color.secondary)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text( item.currentPrice, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(Color.primary)
                            Spacer()
                            Text("\(String(format: "%.4f%%", item.priceChangePercentage24H))")
                                .font(.system(size: 12, weight: .regular, design: .rounded))
                                .foregroundColor(item.priceChangePercentage24H.isLess(than: 0) ? Color("Pink") : Color("Green"))
                        }
                    }
                    .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
                }
                .listRowSeparatorTint(Color(.systemGray5))
            }
//            .onAppear(perform: downloadMarkets)
            .onAppear(perform: loadData)
            .refreshable {
                do {
                    loadData()
                }
            }
            .navigationTitle("Prices")
            .navigationBarItems(trailing:
                Button(action: {
                    self.showSheetView.toggle()
                }) {
                    Image(systemName: "info.circle.fill")
                        .font(Font.system(.body))
                        .foregroundColor(Color(.systemGray3))
                }
            )
        }.sheet(isPresented: $showSheetView) {
            SheetView(showSheetView: self.$showSheetView)
        }
    }
    
  
    func loadData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=240&page=1&sparkline=false") else {
            fatalError("Missing URL")
        }
        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode(TaskEntry.self, from: data) {
                    DispatchQueue.main.async {
                        self.results = response
                    }
                    return
                }
            }
        }.resume()
    }
    
//    @Sendable func downloadMarkets() async {
//        do {
//            let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=240&page=1&sparkline=false")!
//            let (data, _) = try await URLSession.shared.data(from: url)
//
//            let decoder = JSONDecoder()
//            decoder.dateDecodingStrategy = .iso8601
//
//            coins = try decoder.decode([TaskEntry].self, from: data)
//        } catch {
//            fatalError("Whoops! That didn't work.")
//        }
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
