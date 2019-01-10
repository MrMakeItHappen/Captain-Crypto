import UIKit

final class CryptoTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        cell.textLabel?.font = UIFont(name: "Futured", size: 22.0)
        cell.textLabel?.text = coin.symbol
        
        let cryptoImage : UIImageView = {
            let imgView = UIImageView(image: coin.image)
            imgView.contentMode = .scaleAspectFit
            imgView.clipsToBounds = true
            imgView.frame = CGRect(x: 10.0, y: cell.center.y / 1.5, width: 50.0, height: 50.0)
            return imgView
        }()
        
        cell.addSubview(cryptoImage)
        
        cell.contentView.backgroundColor = UIColor.clear

        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 0, y: 8, width: self.view.frame.size.width, height: 70.0))

        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 2.0
        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        whiteRoundedView.layer.shadowOpacity = 0.2

        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubviewToBack(whiteRoundedView)
        
        return cell
    }

}
