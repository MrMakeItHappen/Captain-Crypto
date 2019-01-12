import UIKit
import LocalAuthentication

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) && UserDefaults.standard.bool(forKey: "secure") {
            let authVC = AuthViewController()
            window?.rootViewController = authVC
        } else {
            let cryptoTableVC = CryptoTableViewController()
            let navigationVC = UINavigationController(rootViewController: cryptoTableVC)
            window?.rootViewController = navigationVC
        }
        window?.makeKeyAndVisible()
        
        return true
    }
}

