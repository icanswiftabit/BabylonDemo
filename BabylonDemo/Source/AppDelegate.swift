import UIKit
import World

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    let window = UIWindow()
    let appController = AppFlowController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        Current.baseURL = { DevelopWorld().baseURL }

        appController.embedRootViewController(in: window)
        return true
    }

}

