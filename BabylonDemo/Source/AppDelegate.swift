import UIKit
import World

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let appController = AppController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        Current.baseURL = { DevelopWorld().baseURL }

        window = UIWindow(frame: UIScreen.main.bounds)
        appController.embedRootViewController(in: window!)
        return true
    }

}

