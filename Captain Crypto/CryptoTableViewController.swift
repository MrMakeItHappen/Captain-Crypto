import UIKit
import LocalAuthentication

private let headerHeight: CGFloat = 100.0
private let netWorthHeight: CGFloat = 45.0

final class CryptoTableViewController: UITableViewController, CoinDataDelegate {
    private var amountLabel = UILabel()
}

extension CryptoTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        CoinData.shared.fetchPrices()
        
        if LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            updateSecureButton()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        CoinData.shared.delegate = self
        self.tableView.reloadData()
        displayNetWorth()
    }
}

extension CryptoTableViewController {
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return createHeaderView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = CoinDetailViewController()
        detailViewController.coin = CoinData.shared.cryptoCoins[indexPath.row]
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoinData.shared.cryptoCoins.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let coin = CoinData.shared.cryptoCoins[indexPath.row]
        
        cell.textLabel?.font = UIFont(name: "AvenirNext-Medium", size: 22.0)
        cell.textLabel?.text = "\(coin.symbol): \(coin.priceAsString())"
        
        let cryptoImage : UIImageView = {
            let imgView = UIImageView(image: coin.image)
            imgView.contentMode = .scaleAspectFit
            imgView.clipsToBounds = true
            imgView.frame = CGRect(x: 10.0, y: cell.center.y / 1.5, width: 50.0, height: 50.0)
            return imgView
        }()
        cell.addSubview(cryptoImage)
        
        let percentChangeLabel = UILabel()
        let positiveChangeColor = #colorLiteral(red: 0.2509803922, green: 0.9764705882, blue: 0.6078431373, alpha: 1)
//        let negativeChangeColor = #colorLiteral(red: 0.8666666667, green: 0.1019607843, blue: 0.1019607843, alpha: 1)
        percentChangeLabel.backgroundColor = positiveChangeColor
        percentChangeLabel.font = UIFont(name: "AvenirNext-Regular", size: 16.0)
        percentChangeLabel.text = "+100%"
        percentChangeLabel.textAlignment = .center
        percentChangeLabel.frame = CGRect(x: view.frame.size.width - 100, y: cell.center.y + 5.5, width: 75.0, height: 25.0)
        cell.addSubview(percentChangeLabel)
 
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 0, y: 8, width: self.view.frame.size.width, height: 70.0))
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 2.0
        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        
        cell.contentView.backgroundColor = UIColor.clear
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubviewToBack(whiteRoundedView)
        
        return cell
    }
}

extension CryptoTableViewController {
    func updateSecureButton() {
        if UserDefaults.standard.bool(forKey: "secure") {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Disable ID", style: .plain, target: self, action: #selector(secureTapped))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Enable ID", style: .plain, target: self, action: #selector(secureTapped))
        }
    }
    
    @objc func secureTapped() {
        if UserDefaults.standard.bool(forKey: "secure") {
            UserDefaults.standard.set(false, forKey: "secure")
        } else {
            UserDefaults.standard.set(true, forKey: "secure")
        }
        updateSecureButton()
    }
    
    private func createHeaderView() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: headerHeight))
        headerView.backgroundColor = .white
        
        let netWorthLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: netWorthHeight))
        netWorthLabel.text = "CRYPTO NET WORTH"
        netWorthLabel.font = UIFont(name: "AvenirNext-Regular", size: 16.0)
        netWorthLabel.textAlignment = .center
        headerView.addSubview(netWorthLabel)
        
        amountLabel.frame = CGRect(x: 0, y: netWorthHeight, width: view.frame.size.width, height: headerHeight - netWorthHeight)
        amountLabel.textAlignment = .center
        amountLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 50.0)
        headerView.addSubview(amountLabel)
        
        displayNetWorth()
        
        return headerView
    }
    
    func pricesUpdated() {
        self.tableView.reloadData()
        displayNetWorth()
    }
    
    private func displayNetWorth() {
        amountLabel.text = CoinData.shared.netWorthAsAString()
    }
}
