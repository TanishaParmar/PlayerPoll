//
//  AppDelegate.swift
//  PlayerPoll
//
//  Created by mac on 11/10/21.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import LGSideMenuController
import FBSDKLoginKit
import FBSDKCoreKit
//import GoogleMobileAds
import SwiftGoogleTranslate
import Firebase
import Branch

func appDelegate() -> AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
      // handler for Universal Links
      return Branch.getInstance().continue(userActivity)
//      return true
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        SwiftGoogleTranslate.shared.start(with: "AIzaSyCeUzU8KpLArAbyHB2BqJUWJsVeOtOClIo")
       /* GADMobileAds.sharedInstance().start(completionHandler: nil)
   //     GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ GADSimulatorID ]
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["285c265d9951789bcc244a1b5cc1b35e" ]*/
//        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "2077ef9a63d2b398840261c8221a0c9b" ]
        
//        ApplicationDelegate.shared.application(application,didFinishLaunchingWithOptions: launchOptions)

        
        branchForAdvancedOrLowerVersions(launchOptions: launchOptions)
        
        ApplicationDelegate.shared.application(application,didFinishLaunchingWithOptions: launchOptions)
        IQKeyboardManager.shared.enable = true
        setInitialLanding()
        configureNotification(application: application)
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEvents.activateApp()
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?,annotation: Any) -> Bool {
        return ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func setInitialLanding(){
        let vc = SplashVC.instantiate(fromAppStoryboard: .Landing)
        let nav = UINavigationController(rootViewController: vc)
        nav.hero.isEnabled = true
        nav.isNavigationBarHidden = true
        appDelegate().window?.rootViewController = nav
    }
    
    func setHomeScreen(pollId: String = ""){
        let homeVC = HomeVC.instantiate(fromAppStoryboard: .Home)
        homeVC.pollId = pollId
        let leftVC = SideMenuVC.instantiate(fromAppStoryboard: .Home)
        let sideMenuVC = LGSideMenuController(rootViewController: homeVC, leftViewController: leftVC)
        sideMenuVC.leftViewWidth = UIScreen.main.bounds.width * 0.7
        sideMenuVC.leftViewPresentationStyle = .slideAside
        sideMenuVC.leftViewStatusBarStyle = .default
        sideMenuVC.leftViewStatusBarBackgroundColor = PPColor.identifierBlue
        sideMenuVC.leftViewStatusBarBackgroundAlpha = 1.0
        sideMenuVC.leftViewStatusBarBackgroundBlurEffect = nil
        let rootVC = UINavigationController(rootViewController: sideMenuVC)
        rootVC.isNavigationBarHidden = true
        rootVC.hero.isEnabled = true
        appDelegate().window?.rootViewController = rootVC
    }
    
    func setLogoutScreen(){
        UserDefaults.standard.removeObject(forKey: DefaultKeys.authToken)
        let vc = LoginVC.instantiate(fromAppStoryboard: .Landing)
        let rootVC = UINavigationController(rootViewController: vc)
        rootVC.isNavigationBarHidden = true
        rootVC.hero.isEnabled = true
        appDelegate().window?.rootViewController = rootVC
    }
    
    func branchForAdvancedOrLowerVersions(launchOptions: [UIApplication.LaunchOptionsKey: Any]?){
        if #available(iOS 13.0, *) {
            BranchScene.shared().initSession(launchOptions: launchOptions) { (params, error, scene) in
                if error != nil{
                    print(error?.localizedDescription ?? "")
                    return
                }
                if let dict = params as? [String:Any],let uid: String = dict["OtherID"] as? String {
                    print(uid,"Wow")
                    let env = dict["environment"] as? String ?? ""
                    //&&  AFWrapperClass.returnCurrentUserId() != ""
                    if env == DataManager.returnEnv().rawValue && uid != "" {
                        print("valid redirect")
                        self.checkAndNavigateToProfileDetails(OtherId:uid, type:dict["type"] as? String ?? "" , title: dict["$og_description"] as? String ?? "", id: dict["link"] as? String ?? "")
                    }else{
                        print("invalid redirect")
                    }
                }
            }
            
        }else{
            Branch.getInstance().initSession(launchOptions: launchOptions, andRegisterDeepLinkHandler: {params, error in
                if error != nil{
                    print(error?.localizedDescription ?? "")
                }
                if let dict = params as? [String:Any],let uid: String = dict["OtherID"] as? String {
                    print(uid)
                    let env = dict["environment"] as? String ?? ""
                    if env == DataManager.returnEnv().rawValue && uid != "" {
                        print("valid redirect")
                        self.checkAndNavigateToProfileDetails(OtherId:uid, type:dict["type"] as? String ?? "" , title: dict["$og_description"] as? String ?? "", id: dict["link"] as? String ?? "")
                    }else{
                        print("invalid redirect")
                    }
                }
            })
        }
    }
    
    func checkAndNavigateToProfileDetails(OtherId: String,type:String,title:String,id:String){
        if type == "LiveStream"{
            let rootVc = HomeVC.instantiate(fromAppStoryboard: .Home)
            rootVc.pollId = OtherId
//            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
//            let rootVc = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//            rootVc.postId = OtherId
            let nav = UINavigationController(rootViewController: rootVc)
            nav.isNavigationBarHidden = true
            if #available(iOS 13.0, *){
                if let scene = UIApplication.shared.connectedScenes.first{
                    guard let windowScene = (scene as? UIWindowScene) else { return }
                    print(">>> windowScene: \(windowScene)")
                    let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
                    window.windowScene = windowScene //Make sure to do this
                    window.rootViewController = nav
                    window.makeKeyAndVisible()
                    self.window = window
                }
            } else {
                self.window?.rootViewController = nav
                self.window?.makeKeyAndVisible()
            }
        } else {
            let rootVc = HomeVC.instantiate(fromAppStoryboard: .Home)
            rootVc.pollId = OtherId

//            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
//            let rootVc = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//            rootVc.postId = OtherId
//            rootVc.catID = OtherId
//            rootVc.titleName = title
//            rootVc.linkID = id
            let nav = UINavigationController(rootViewController: rootVc)
            nav.isNavigationBarHidden = true
            if #available(iOS 13.0, *){
                if let scene = UIApplication.shared.connectedScenes.first{
                    guard let windowScene = (scene as? UIWindowScene) else { return }
                    print(">>> windowScene: \(windowScene)")
                    let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
                    window.windowScene = windowScene //Make sure to do this
                    window.rootViewController = nav
                    window.makeKeyAndVisible()
                    self.window = window
                }
            } else {
                self.window?.rootViewController = nav
                self.window?.makeKeyAndVisible()
            }
        }
       
    }
    
    
    
    /*
    func branchForAdvancedOrLowerVersions(launchOptions: [UIApplication.LaunchOptionsKey: Any]?){
        if #available(iOS 13.0, *) {
            BranchScene.shared().initSession(launchOptions: launchOptions) { (params, error, scene) in
                if error != nil{
                    print(error?.localizedDescription ?? "")
                }
                if let dict = params as? [String:Any],let uid: String = dict["OtherID"] as? String {
                    print(uid,"Wow")
                    let env = dict["environment"] as? String ?? ""
                    //&&  AFWrapperClass.returnCurrentUserId() != ""
                    if env == DataManager.returnEnv().rawValue && uid != "" {
                        print("valid redirect")
                        self.checkAndNavigateToProfileDetails(OtherId:uid, type:dict["type"] as? String ?? "" , title: dict["$og_description"] as? String ?? "", id: dict["link"] as? String ?? "")
                    }else{
                        print("invalid redirect")
                    }
                }
            }
        }else{
            Branch.getInstance().initSession(launchOptions: launchOptions, andRegisterDeepLinkHandler: {params, error in
                if error != nil{
                    print(error?.localizedDescription ?? "")
                }
                if let dict = params as? [String:Any],let uid: String = dict["OtherID"] as? String {
                    print(uid)
                    let env = dict["environment"] as? String ?? ""
                    if env == DataManager.returnEnv().rawValue && uid != "" {
                        print("valid redirect")
                        self.checkAndNavigateToProfileDetails(OtherId:uid, type:dict["type"] as? String ?? "" , title: dict["$og_description"] as? String ?? "", id: dict["link"] as? String ?? "")
                    }else{
                        print("invalid redirect")
                    }
                }
            })
        }
    }
    
    
    func checkAndNavigateToProfileDetails(OtherId: String,type:String,title:String,id:String){
        if type == "Post"{
//            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
//            let rootVc = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//            rootVc.postId = OtherId
            let rootVc = HomeVC.instantiate(fromAppStoryboard: .Home)

            let nav = UINavigationController(rootViewController: rootVc)
            nav.isNavigationBarHidden = true
            if #available(iOS 13.0, *){
                if let scene = UIApplication.shared.connectedScenes.first{
                    guard let windowScene = (scene as? UIWindowScene) else { return }
                    print(">>> windowScene: \(windowScene)")
                    let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
                    window.windowScene = windowScene //Make sure to do this
                    window.rootViewController = nav
                    window.makeKeyAndVisible()
                    self.window = window
                }
            } else {
                self.window?.rootViewController = nav
                self.window?.makeKeyAndVisible()
            }
        }else{
//            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
//            let rootVc = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//            rootVc.postId = OtherId
//            rootVc.catID = OtherId
//            rootVc.titleName = title
//            rootVc.linkID = id
            let rootVc = HomeVC.instantiate(fromAppStoryboard: .Home)

            let nav = UINavigationController(rootViewController: rootVc)
            nav.isNavigationBarHidden = true
            if #available(iOS 13.0, *){
                if let scene = UIApplication.shared.connectedScenes.first{
                    guard let windowScene = (scene as? UIWindowScene) else { return }
                    print(">>> windowScene: \(windowScene)")
                    let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
                    window.windowScene = windowScene //Make sure to do this
                    window.rootViewController = nav
                    window.makeKeyAndVisible()
                    self.window = window
                }
            } else {
                self.window?.rootViewController = nav
                self.window?.makeKeyAndVisible()
            }
        }
       
    }*/
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        Branch.getInstance().application(app, open: url, options: options)
        return true
    }
//    func application(
//          _ app: UIApplication,
//          open url: URL,
//          options: [UIApplication.OpenURLOptionsKey : Any] = [:]
//      ) -> Bool {
//          ApplicationDelegate.shared.application(
//              app,
//              open: url,
//              sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//              annotation: options[UIApplication.OpenURLOptionsKey.annotation]
//          )
//      }
//
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "PlayerPoll")
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



//MARK:- Push notifications method(s)
extension AppDelegate: UNUserNotificationCenterDelegate{
   
    func configureNotification(application: UIApplication) {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }else{
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        defer{
            completionHandler()
        }
        if let data = response.notification.request.content.userInfo as? [String:Any], let aps = data["aps"] as? [String:Any], let notifData = aps["data"] as? [String:Any]{
            performPushRedirection(data: notifData)
        }
    }
    
    
    func performPushRedirection(data: [String:Any]){
        let type = data["notification_type"] as? String ?? ""
        if type == "2"{
            //perform chat redirection
            let roomId = data["roomID"] as? String ?? ""
            let profileImage = data["profileImage"] as? String ?? ""
            let otherUserID = data["otherUserID"] as? String ?? ""
            let uName = data["title"] as? String ?? ""
            if otherUserID == Globals.userId{
                return
            }
            let vc = ChatDetailsVC.instantiate(fromAppStoryboard: .Menu)
            vc.otherUser = otherUserID
            vc.profileImage = profileImage
            vc.name = uName
            vc.roomId = roomId
            vc.fromAppDel = true
            let rootVC = UINavigationController(rootViewController: vc)
            rootVC.isNavigationBarHidden = true
            appDelegate().window?.rootViewController = rootVC
        }else if type == "4"{
            let pollId = data["detailsID"] as? String ?? ""
            if !Globals.authToken.isEmpty{
                appDelegate().setHomeScreen(pollId: pollId)
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("device token string", deviceTokenString)
        Globals.defaults.set(deviceTokenString, forKey: DefaultKeys.deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs registration failed: \(error)")
    }
  
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let userDict = userInfo as! [String:Any]
        print("received", userDict)
        if application.applicationState == .inactive {

        } else {
            print("not invoked cause its in foreground")
        }
        completionHandler(.newData)
    }
        
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound,.alert, .badge])
    }
    
    
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        BranchScene.shared().scene(scene, continue: userActivity)
    }
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        BranchScene.shared().scene(scene, openURLContexts: URLContexts)
    }
    
}
