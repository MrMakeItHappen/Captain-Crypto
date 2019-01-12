import UIKit
import SwiftChart

private let chartHeight: CGFloat = 300.0
private let imageSize: CGFloat = 100.0
private let padding: CGFloat = 10.0
private let priceLabelHeight: CGFloat = 25.0

final class CoinDetailViewController: UIViewController, CoinDataDelegate {
    
    var coin: CryptoCoin?
    private var chart = Chart()
    private var priceLabel = UILabel()
    private var cryptoOwnedLabel = UILabel()
    private var cryptoNetWorthLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        CoinData.shared.delegate = self
        edgesForExtendedLayout = []
        view.backgroundColor = .white
        title = coin?.symbol
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(editTapped))
        
        guard let coin = coin else { return }
        
        chart.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: chartHeight)
        chart.xLabels = [0, 5, 10, 15, 20, 25, 30]
        chart.xLabelsFormatter = { String(Int(round($1))) + "d" }
        chart.yLabelsFormatter = { CoinData.shared.convertDoubleToMoneyString(double: $1) }
        view.addSubview(chart)
        
        let imageView = UIImageView(frame: CGRect(x: view.frame.size.width / 2 - imageSize / 2, y: chartHeight + padding, width: imageSize, height: imageSize))
        imageView.image = coin.image
        view.addSubview(imageView)
        
        priceLabel = UILabel(frame: CGRect(x: 0, y: chartHeight + imageSize + padding, width: view.frame.size.width, height: priceLabelHeight))
        priceLabel.font = UIFont(name: "Avenir Next", size: 18.0)
        priceLabel.textAlignment = .center
        view.addSubview(priceLabel)
        
        cryptoOwnedLabel.frame = CGRect(x: 0, y: chartHeight + imageSize + priceLabelHeight + 30, width: view.frame.size.width, height: priceLabelHeight)
        cryptoOwnedLabel.textAlignment = .center
        cryptoOwnedLabel.font = UIFont(name: "AvenirNext-Medium", size: 22.0)
        view.addSubview(cryptoOwnedLabel)
        
        cryptoNetWorthLabel.frame = CGRect(x: 0, y: chartHeight + imageSize + priceLabelHeight + 60, width: view.frame.size.width, height: priceLabelHeight)
        cryptoNetWorthLabel.textAlignment = .center
        cryptoNetWorthLabel.font = UIFont(name: "AvenirNext-Medium", size: 22.0)
        view.addSubview(cryptoNetWorthLabel)
        
        coin.fetchHistoricalData()
        pricesUpdated()
    }
    
    func historicalPricesUpdated() {
        if let coin = coin {
            let series = ChartSeries(coin.historicalData)
            series.area = true
            series.color = #colorLiteral(red: 0.5568627451, green: 0.8745098039, blue: 0.9764705882, alpha: 1)
            chart.add(series)
        }
    }
    
    private func pricesUpdated() {
        guard let coin = coin else { return }
        priceLabel.text = coin.priceAsString()
        cryptoOwnedLabel.text = "You Own: \(coin.amountOwned) \(coin.symbol)"
        cryptoNetWorthLabel.text = coin.amountAsAString()
    }
    
    @objc private func editTapped() {
        guard let coin = coin else { return }
        
        let alert = UIAlertController(title: "How much \(coin.symbol) do you own?", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Ex. 9.54313"
            textField.keyboardType = .decimalPad
            
            if self.coin?.amountOwned != 0.0 {
                textField.text = String(coin.amountOwned)
            }
        }
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action) in
            if let text = alert.textFields?[0].text {
                if let amount = Double(text) {
                    self.coin?.amountOwned = amount
                    UserDefaults.standard.set(amount, forKey: coin.symbol + "amount")
                    self.pricesUpdated()
                }
            }
        }))
        
        self.present(alert, animated: true)
    }
}
