//
//  Data.swift
//  Coin Prices
//
//  Created by Ethan MacDonald on 7/21/22.
//

import Foundation

struct Coins: Codable, Identifiable, Equatable, Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Coins, rhs: Coins) -> Bool {
        return lhs.id == rhs.id && lhs.id == rhs.id
    }
    
    let id, symbol, name: String
    let image: String
    let currentPrice: Double
    let marketCap, marketCapRank: Int
    let fullyDilutedValuation: Int?
    let totalVolume, high24H, low24H, priceChange24H: Double
    let priceChangePercentage24H, marketCapChange24H, marketCapChangePercentage24H, circulatingSupply: Double
    let totalSupply, maxSupply: Double?
    let ath, athChangePercentage: Double
    let athDate: String
    let atl, atlChangePercentage: Double
    let atlDate: String
    let roi: Roi?
    let lastUpdated: String
    var sparklineIn7D: [SparklineIn7D]

    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case roi
        case lastUpdated = "last_updated"
        case sparklineIn7D = "sparkline_in_7d"
    }
}


struct Roi: Codable {
    let times: Double
    let currency: Currency
    let percentage: Double
}

enum Currency: String, Codable {
    case btc = "btc"
    case eth = "eth"
    case usd = "usd"
}

class SparklineIn7D: Codable, Hashable, Equatable {
    let price: [Double]

    init(price: [Double]) {
        self.price = price
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(price)
    }
    
    static func == (lhs: SparklineIn7D, rhs: SparklineIn7D) -> Bool {
        return lhs.price == rhs.price && lhs.price == rhs.price
    }
}

typealias TaskEntry = [Coins]
