import UIKit
import Alamofire

@objc protocol CoinDataDelegate: class {
    @objc optional func pricesUpdated()
    @objc optional func historicalPricesUpdated()
}

final class CoinData {
    static let shared = CoinData()
    private let localeIdentifier = "en_US"
    var cryptoCoins = [CryptoCoin]()
    weak var delegate: CoinDataDelegate?
    
    private init() {
        let symbols = ["ADA", "BCH", "BTC", "DASH", "EOS", "ETH", "LTC", "NEO", "XLM", "XRP"]
        for symbol in symbols {
            let cryptoCoin = CryptoCoin(symbol: symbol)
            cryptoCoins.append(cryptoCoin)
        }
    }
    
    func netWorthAsAString() -> String {
        var netWorth = 0.0
        for coin in cryptoCoins {
            netWorth += coin.amountOwned * coin.price
        }
        return convertDoubleToMoneyString(double: netWorth)
    }
    
    func fetchPrices() {
        var symbolList = ""
        for coin in cryptoCoins {
            symbolList += coin.symbol
            if coin.symbol != cryptoCoins.last?.symbol {
                symbolList += ","
            }
        }
        
        Alamofire.request("https://min-api.cryptocompare.com/data/pricemulti?fsyms=\(symbolList)&tsyms=USD").responseJSON { (response) in
            if let json = response.result.value as? [String:Any] {
                for coin in self.cryptoCoins {
                    if let coinJSON = json[coin.symbol] as? [String:Double] {
                        if let price = coinJSON["USD"] {
                            coin.price = price
                            UserDefaults.standard.set(price, forKey: coin.symbol)
                        }
                    }
                }
                self.delegate?.pricesUpdated?()
            }
        }
        
    }
    
    func convertDoubleToMoneyString(double: Double) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: localeIdentifier)
        formatter.numberStyle = .currency
        if let formattedPrice = formatter.string(from: NSNumber(floatLiteral: double)) {
            return formattedPrice
        } else {
            return "ERROR"
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
        self.price = UserDefaults.standard.double(forKey: symbol)
        self.amountOwned = UserDefaults.standard.double(forKey: symbol + "amount")
        
        guard let history = UserDefaults.standard.array(forKey: symbol + "history") as? [Double] else { return }
        self.historicalData = history
    }
    
    func priceAsString() -> String {
        if price == 0.0 {
            return "Updating..."
        }
        return CoinData.shared.convertDoubleToMoneyString(double: price)
    }
    
    func amountAsAString() -> String {
        return CoinData.shared.convertDoubleToMoneyString(double: amountOwned * price)
    }
    
    func fetchHistoricalData() {
        Alamofire.request("https://min-api.cryptocompare.com/data/histoday?fsym=\(symbol)&tsym=USD&limit=30").responseJSON { (response) in
            if let json = response.result.value as? [String:Any] {
                if let pricesJSON = json["Data"] as? [[String:Double]] {
                    self.historicalData = []
                    for priceJSON in pricesJSON {
                        if let closingPrice = priceJSON["close"] {
                            self.historicalData.append(closingPrice)
                        }
                    }
                    CoinData.shared.delegate?.historicalPricesUpdated?()
                    UserDefaults.standard.set(self.historicalData, forKey: self.symbol + "history")
                }
            }
        }
    }
}
