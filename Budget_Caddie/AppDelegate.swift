//
//  AppDelegate.swift
//  Budget_Caddie
//
//  Created by Sabin on 17/12/24.
//

import UIKit
import CoreData
import AWSS3
import UserNotifications
@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
                center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                    // Enable or disable features based on authorization.
                    if granted {
                        DispatchQueue.main.async {
                            application.registerForRemoteNotifications()
                        }
                    }
                }
        
        // Override point for customization after application launch.
        if UserDefaultsHandler.shared.getUserEmail() == nil || UserDefaultsHandler.shared.getUserEmail() == "" {
            makeLoginAsRootViewController()
        } else {
            makeRootViewController()
        }
        configureAWS()
        return true
    }
    func configureAWS() {
         let credentialProvider = AWSStaticCredentialsProvider(accessKey: "AKIATTSKFQUGSYPQ32A4", secretKey: "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")
        //         let credentialProvider = AWSCognitoCredentialsProvider(regionType: .USWest2, identityPoolId: Constant.awsConfig.kCOGNITO_POOL_ID) //  USEast1
        let configuration = AWSServiceConfiguration(region: .EUNorth1, credentialsProvider: credentialProvider)
                AWSServiceManager.default().defaultServiceConfiguration = configuration
                AWSS3.register(with: configuration!, forKey: "EU-NORTH-1")//(with: configuration!, forKey: Constant.awsConfig.KRegion)
                AWSS3TransferUtility.register(with: configuration!, forKey: "AKIATTSKFQUGSYPQ32A4")
                AWSDDLog.sharedInstance.logLevel = .verbose
    }
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        UserDefaultsHandler.shared.setCurrentDeviceToken(token: token)
    }

    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("❌ Failed to register: \(error)")
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    willPresent notification: UNNotification,
                                    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.sound])
        }
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Budget_Caddie")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func makeRootViewController() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            let story = UIStoryboard(name: "Main", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            vc.view.frame = window.frame
            vc.modalPresentationStyle = .fullScreen
            UIView.transition(with: window, duration: 0.4, options: .transitionCrossDissolve, animations: {
                    window.rootViewController = vc
                }, completion: nil)
            window.makeKeyAndVisible()
        }
    }
    
    func makeLoginAsRootViewController() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            let story = UIStoryboard(name: "Main", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "LoginVCID") as! LoginViewController
            vc.view.frame = window.frame
            UIView.transition(with: window, duration: 0.4, options: .transitionCrossDissolve, animations: {
                    window.rootViewController = vc
                }, completion: nil)
            window.makeKeyAndVisible()
        }
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

