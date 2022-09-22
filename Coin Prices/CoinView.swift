//
//  CoinView.swift
//  Coin Prices
//
//  Created by Ethan MacDonald on 7/22/22.
//

import SwiftUI

struct CoinView: View {
    let id: String
    init (id: String){
        self.id = id
    }
    @State var results = CoinDetails()

    var body: some View {
        List(results, id: \.id) { item in
            VStack {
                AsyncImage(url: URL(string: item.image.large)) { image in
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
                    Spacer()
                    Text(item.welcomeDescription.en)
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .textCase(.uppercase)
                        .foregroundColor(Color.secondary)
                }
                Spacer()
            }
            .listRowSeparatorTint(Color(.systemGray5))
        }
        .onAppear(perform: loadData)
        .refreshable {
            do {
                loadData()
            }
        }
        
    }
    
    func loadData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(id)?localization=false&tickers=false&community_data=false&developer_data=false&sparkline=true") else {
            fatalError("Missing URL")
        }
        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode(CoinDetails.self, from: data) {
                    DispatchQueue.main.async {
                        self.results = response
                    }
                    return
                }
            }
        }.resume()
    }
}

struct CoinView_Previews: PreviewProvider {
    static var previews: some View {
        CoinView(id: "btc")
    }
}
