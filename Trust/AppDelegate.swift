// Copyright DApps Platform Inc. All rights reserved.

import UIKit
import Branch
import RealmSwift
import Localize_Swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    var window: UIWindow?
    var coordinator: AppCoordinator!
    //This is separate coordinator for the protection of the sensitive information.
    lazy var protectionCoordinator: ProtectionCoordinator = {
        return ProtectionCoordinator()
    }()
    let urlNavigatorCoordinator = URLNavigatorCoordinator()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        updateUI()
        if !UIApplication.shared.isProtectedDataAvailable {
            fatalError()
        }
//        protectionCoordinator.didFinishLaunchingWithOptions()
        urlNavigatorCoordinator.branch.didFinishLaunchingWithOptions(launchOptions: launchOptions)

        return true
    }

    @objc func updateUI() {

        let sharedMigration = SharedMigrationInitializer()
        sharedMigration.perform()
        let realm = try! Realm(configuration: sharedMigration.config)
        let walletStorage = WalletStorage(realm: realm)
        let keystore = EtherKeystore(storage: walletStorage)

        if  UserDefaults.standard.bool(forKey: "HasLaunchedOnce") {
            //非首次登陆
            coordinator = AppCoordinator(window: window!, keystore: keystore, navigator: urlNavigatorCoordinator)
            self.coordinator.start()
        } else {
            var defaultLanguageCode: String = NSLocale.current.languageCode ?? "en"
            if  !Localize.availableLanguages().contains(defaultLanguageCode) {
                defaultLanguageCode = "en"
            }
            Localize.setCurrentLanguage(defaultLanguageCode)
            window?.rootViewController = MLWelcomeViewController()
            window?.makeKeyAndVisible()
            //首次登陆
            UserDefaults.standard.set(true, forKey: "HasLaunchedOnce")
            UserDefaults.standard.synchronize()
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        coordinator.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken: deviceToken)
    }

    func applicationWillResignActive(_ application: UIApplication) {
//        protectionCoordinator.applicationWillResignActive()
        Lock().setAutoLockTime()
        CookiesStore.save()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
//        protectionCoordinator.applicationDidBecomeActive()
        CookiesStore.load()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
//        protectionCoordinator.applicationDidEnterBackground()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
//        protectionCoordinator.applicationWillEnterForeground()
    }

    func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplicationExtensionPointIdentifier) -> Bool {
        if extensionPointIdentifier == UIApplicationExtensionPointIdentifier.keyboard {
            return false
        }
        return true
    }

//    func application(
//        _ application: UIApplication,
//        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        Branch.getInstance().handlePushNotification(userInfo)
//    }

    // Respond to URI scheme links
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        return urlNavigatorCoordinator.application(app, open: url, options: options)
    }

    // Respond to Universal Links
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        Branch.getInstance().continue(userActivity)
        return true
    }
}
