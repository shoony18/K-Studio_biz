//
//  AppDelegate.swift
//  track_online
//
//  Created by 刈田修平 on 2019/08/31.
//  Copyright © 2019年 刈田修平. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import AVFoundation
import AVKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?
    
        override init() {
            super.init()
            FirebaseApp.configure()
        }

        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            // Override point for customization after application launch.
            // Use Firebase library to configure APIs
    //        FirebaseApp.configure()
            if Auth.auth().currentUser == nil {
                self.window = UIWindow(frame: UIScreen.main.bounds)
                //　Storyboardを指定
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                // Viewcontrollerを指定
                let initialViewController = storyboard.instantiateViewController(withIdentifier:"loginView")
                // rootViewControllerに入れる
                self.window?.rootViewController = initialViewController
                // 表示
                self.window?.makeKeyAndVisible()
            }else{
                self.window = UIWindow(frame: UIScreen.main.bounds)
                //　Storyboardを指定
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                // Viewcontrollerを指定
                let initialViewController = storyboard.instantiateViewController(withIdentifier:"mainView")
                // rootViewControllerに入れる
                self.window?.rootViewController = initialViewController
                // 表示
                self.window?.makeKeyAndVisible()
            }

            return true
        }
    
//    func changeNavigationBarColor() {
        // 全てのNavigation Barの色を変更する
        // Navigation Bar の背景色の変更
//        UINavigationBar.appearance().barTintColor = trackColor.primary
        // Navigation Bar の文字色の変更
//        UINavigationBar.appearance().tintColor = trackColor.secondary
        // Navigation Bar のタイトルの文字色の変更
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: trackColor.background]
//    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
extension UIView {

    /// 枠線の色
    @IBInspectable var borderColor: UIColor? {
        get {
            return layer.borderColor.map { UIColor(cgColor: $0) }
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    /// 枠線のWidth
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    /// 角丸の大きさ
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

  /// 影の色
  @IBInspectable var shadowColor: UIColor? {
    get {
      return layer.shadowColor.map { UIColor(cgColor: $0) }
    }
    set {
      layer.shadowColor = newValue?.cgColor
      layer.masksToBounds = false
    }
  }

  /// 影の透明度
  @IBInspectable var shadowAlpha: Float {
    get {
      return layer.shadowOpacity
    }
    set {
      layer.shadowOpacity = newValue
    }
  }

  /// 影のオフセット
  @IBInspectable var shadowOffset: CGSize {
    get {
     return layer.shadowOffset
    }
    set {
      layer.shadowOffset = newValue
    }
  }

  /// 影のぼかし量
  @IBInspectable var shadowRadius: CGFloat {
    get {
     return layer.shadowRadius
    }
    set {
      layer.shadowRadius = newValue
    }
  }

}


