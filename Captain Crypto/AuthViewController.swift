import UIKit
import LocalAuthentication

final class AuthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        presentAuth()
    }
    
    func presentAuth() {
        LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Crypto Data is protected by Biometrics.") { (success, error) in
            if success {
                DispatchQueue.main.async {
                    let cryptoTableVC = CryptoTableViewController()
                    let navigationVC = UINavigationController(rootViewController: cryptoTableVC)
                    self.present(navigationVC, animated: true)
                }
            } else {
                self.presentAuth()
            }
        }
    }
}
