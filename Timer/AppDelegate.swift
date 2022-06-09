//
//  AppDelegate.swift
//  Timer
//
//  Created by WONJI HA on 2021/07/06.
//
/* Reference
 
 https://fomaios.tistory.com/entry/iOS-%ED%91%B8%EC%89%AC-%EC%95%8C%EB%A6%BC-%ED%83%AD%ED%96%88%EC%9D%84-%EB%95%8C-%ED%8A%B9%EC%A0%95-%ED%8E%98%EC%9D%B4%EC%A7%80%EB%A1%9C-%EC%9D%B4%EB%8F%99%ED%95%98%EA%B8%B0 푸시알림 탭 특정뷰 이동(원래 뷰에서)
 https://velog.io/@yoonjong/Swift-Push-Notification-%EB%88%84%EB%A5%BC-%EB%95%8C-%ED%8A%B9%EC%A0%95-ViewController-%EB%9C%A8%EA%B2%8C-%ED%95%98%EA%B8%B0 푸시알림 특정뷰 이동(새뷰에서)
 */

import UIKit
import GoogleMobileAds
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    let userNotifiNotificationCenter = UNUserNotificationCenter.current()


    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("이제 앱 실행 준비할게요")
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("앱 실행 준비 끝")
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
       //UNUserNotificationCenter.current().delegate = self // 특정 ViewController에 구현되어 있으면 푸시를 받지 못할 가능성이 있으므로 AppDelegate에서 구현
       userNotifiNotificationCenter.delegate = self // 특정 ViewController에 구현되어 있으면 푸시를 받지 못할 가능성이 있으므로 AppDelegate에서 구현(앱에서 푸시알림)
        application.registerForRemoteNotifications()
        
        return true
    }
    
    /*
          앱이 종료되기 직전에 호출된다.
       하지만 메모리 확보를 위해 suspended 상태에 있는 앱이 종료될 때나
       background 상태에서 사용자에 의해 종료될 때나
       오류로 인해 앱이 종료될 때는 호출되지 않는다.
         */
    
      func applicationWillTerminate(_ application: UIApplication) {
              print("이제 곧 종료될거에요")
          }

    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
           
           return UIInterfaceOrientationMask.portrait //세로 화면 고정
       }
}
    
    extension AppDelegate : UNUserNotificationCenterDelegate {

        //ForeGround에서 작동 시키는 방법
       func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
                
                completionHandler([.list, .badge, .sound, .banner])

       }
        
        //눌렀을 때, 특정한 활동을 수행 할 수 있도록 하기
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            
            let application = UIApplication.shared
           
            //앱이 켜져있는 상태에서 푸시 알림을 눌렀을 때
            if application.applicationState == .active {
                print("푸시알림을 탭함 : 앱 켜진 상태")
                if response.notification.request.content.subtitle == "타이머 완료" { //푸시 알림 제목에 따라서 특정 뷰로 이동
                    NotificationCenter.default.post(name: Notification.Name("showPage"), object: nil, userInfo: ["index": 0])

                }
            }
                
            //앱이 꺼져있는 상태에서 푸시 알림을 눌렀을 때
            else if application.applicationState == .inactive {
                print("푸시알림 탭함 : 앱 꺼진 상태")
                NotificationCenter.default.post(name: Notification.Name("showPage"), object: nil, userInfo: ["index": 0])
                }
            
//            guard let rVC = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController else {
//                return
//            }
//
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//            if let conVC = storyboard.instantiateViewController(withIdentifier: "MTimer") as? MainTimer { //스택형식으로 뷰가 열림
//               //conVC.modalPresentationStyle = .fullScreen
//                rVC.present(conVC, animated: true, completion: nil)
//
//            }
//
//
//            if let conVC = storyboard.instantiateViewController(withIdentifier: "Main") as? UITabBarController {
//                conVC.modalPresentationStyle = .fullScreen
//                conVC.tabBarController?.selectedIndex = 0
//                rVC.tabBarController?.selectedIndex = 0
//                rVC.present(conVC, animated: true, completion: nil)
//            }


            if response.actionIdentifier == UNNotificationDismissActionIdentifier {
                print("메시지 닫힘")
            }
            else if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
                print("푸시메시지 클릭 함")

                
            }
            
            print("scene얻음")
            


            completionHandler()
            }

    }


    
