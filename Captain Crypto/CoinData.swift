import UIKit

final class CoinData {
    static let shared = CoinData()
    var cryptoCoins = [CryptoCoin]()
    
    
    private init() {
        let symbols = ["ADA", "BCH", "BTC", "DASH", "EOS", "ETH", "LTC", "NEO", "XLM", "XRP"]
        
        for symbol in symbols {
            let cryptoCoin = CryptoCoin(symbol: symbol)
            cryptoCoins.append(cryptoCoin)
        }
    }
}

final class CryptoCoin {
    var symbol = ""
    var image = UIImage()
    var price = 0.0
    var amountOwned = 0.0
    var historicalData = [Double]()
    
    init(symbol: String) {
        self.symbol = symbol
        guard let image = UIImage(named: symbol) else { return }
        self.image = image
    }
}
