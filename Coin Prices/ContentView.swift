//
//  CoinList.swift
//  Coin Prices
//
//  Created by Ethan MacDonald on 7/21/22.
//

import SwiftUI
import Charts


struct ContentView: View {
    @State var results = TaskEntry()
    @State var showSheetView = false
    @State private var path = NavigationPath()
      
    var body: some View {
        NavigationStack(path: $path) {
            List(results, id: \.id) { item in
                NavigationLink(value: item) {
                    HStack {
                        AsyncImage(url: URL(string: item.image)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24, alignment: .center)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.name)
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(Color.primary)
                            Text(item.symbol)
                                .font(.system(size: 12, weight: .regular, design: .rounded))
                                .textCase(.uppercase)
                                .foregroundColor(Color.secondary)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(item.currentPrice, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(Color.primary)
                            Text("\(String(format: "%.4f%%", item.priceChangePercentage24H))")
                                .font(.system(size: 12, weight: .regular, design: .rounded))
                                .foregroundColor(item.priceChangePercentage24H.isLess(than: 0) ? Color("Pink") : Color("Green"))
                        }
                    }
                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                }
                .alignmentGuide(.listRowSeparatorLeading) { dimensions in
                    dimensions[.leading]
                }
                .listRowSeparatorTint(Color(.systemGray5))
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
            .navigationDestination(for: Coins.self) { item in
//                Chart {
//                    ForEach(chartData, id: \.self) { item in
//                        LineMark(
//                            x: PlottableValue.value("Date", 2),
//                            y: PlottableValue.value("Value", .item),
//                            series: .value("Company", "A")
//                        )
//                        .foregroundStyle(.blue)
//                    }
//                    RuleMark(
//                        y: .value("Threshold", 400)
//                    )
//                    .foregroundStyle(.red)
//                }
//                Path {path in
//                    for index in chartData.indices {
//
//                        let xPosition = UIScreen.main.bounds.width / CGFloat(chartData.count) * CGFloat(index + 1)
//
//                        if index == 0 {
//                            path.move(to: CGPoint(x: 0, y: 0))
//                        }
//                        path.addLine(to: CGPoint(x: xPosition, y: 0))
//                    }
//                }.stroke(Color.blue, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                Text(item.name)
                    .font(.title).bold()
            }
            .onAppear(perform: loadData)
            .refreshable {
                do {
                    loadData()
                }
            }
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
