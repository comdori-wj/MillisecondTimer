//
//  AppDelegate.swift
//  Timer
//
//  Created by WONJI HA on 2021/07/06.
//
/* Reference
 
 http://yoonbumtae.com/?p=4642 로컬 푸시 알림 메시지
 https://fomaios.tistory.com/entry/iOS-%ED%91%B8%EC%89%AC-%EC%95%8C%EB%A6%BC-%ED%83%AD%ED%96%88%EC%9D%84-%EB%95%8C-%ED%8A%B9%EC%A0%95-%ED%8E%98%EC%9D%B4%EC%A7%80%EB%A1%9C-%EC%9D%B4%EB%8F%99%ED%95%98%EA%B8%B0 푸시알림 탭 특정뷰 이동(APN 네트워크 이용시)
 https://velog.io/@yoonjong/Swift-Push-Notification-%EB%88%84%EB%A5%BC-%EB%95%8C-%ED%8A%B9%EC%A0%95-ViewController-%EB%9C%A8%EA%B2%8C-%ED%95%98%EA%B8%B0 푸시알림 특정뷰 이동(새뷰에서)
 https://velog.io/@minji0801/iOS-Swift-%EC%95%B1-%EC%B6%94%EC%A0%81-%EA%B6%8C%ED%95%9C-Alert-%EB%9D%84%EC%9A%B0%EA%B8%B0 앱 추적 권한 요청
 */

import UIKit
import UserNotifications
import AdSupport
import AppTrackingTransparency
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    //    let notiContent = UNMutableNotificationContent()
    let notiCenter = UNUserNotificationCenter.current()
    
    @Published var isAlertOccurred: Bool = false
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("이제 앱 실행 준비할게요")
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        print("앱 실행 준비 끝")
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        requestNotificationAuthorization() // 최초 푸시 알림 권한 요청
        setAppTracking() // 앱 추적 권한 요청
        
        notiCenter.delegate = self // 특정 ViewController에 구현되어 있으면 푸시를 받지 못할 가능성이 있으므로 AppDelegate에서 구현(앱에서 포그라운드 푸시 알림)
        
//        application.registerForRemoteNotifications()
        //        UIApplication.shared.registerForRemoteNotifications()
        
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
        
        return UIInterfaceOrientationMask.portrait // 세로 화면 고정
    }
    
    func requestNotificationAuthorization() // 노티피케이션 최초 허락
    {
        notiCenter.getNotificationSettings { settings in
            
            // 승인되어있지 않은 경우 request
            if settings.authorizationStatus != .authorized {
                self.notiCenter.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
                    
                    // 거부되어있는 경우 alert
                    if settings.authorizationStatus == .denied {
                        // 알림 띄운 뒤 설정 창으로 이동
                        DispatchQueue.main.async {
                            self.isAlertOccurred = true
                        }
                    }
                    
                    if success
                    {
                        print("Push 권한 허용")
                    }
                    else
                    {
                        print("Push 권한 거부")
                    }
                    
                    if let error = error {
                        print("Error : \(error)")
                    }
                    
                })
            }
        }
    }
    
    func setAppTracking(){
        NotificationHandler().askNotificationPermission {
            // 다른 권한 요청 창보다 늦게 띄우기
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if #available(iOS 14, *) {
                    ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                        switch status {
                        case .authorized:        // 허용됨
                            print("Authorized")
                            print("IDFA = \(ASIdentifierManager.shared().advertisingIdentifier)")    // IDFA 접근
                        case .denied:        // 거부됨
                            print("Denied")
                        case .notDetermined:    // 결정되지 않음
                            print("Not Determined")
                        case .restricted:        // 제한됨
                            print("Restricted")
                        @unknown default:        // 알려지지 않음
                            print("Unknown")
                        }
                    })
                }
            }
        }
    }
    
}
    
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // ForeGround 에서 작동
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //        let _ = notification.request.content.userInfo // deep link 처리 시 아래 _ 값 가지고 처리

        //        completionHandler()
        
//        print("willPresent - identifier: \(notification.request.identifier)")
        
        completionHandler([.list, .banner])
    }
    
    // Background 에서 작동
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
//        print("didReceive - identifier: \(response.notification.request.identifier)")
//        print("didReceive - UserInfo: \(response.notification.request.content.userInfo)")
        
//        let _ = response.notification.request.content.userInfo
        
        if response.notification.request.identifier == "Timer done" { // 식별자 판별후 특정뷰 이동
            NotificationCenter.default.post(name: Notification.Name("Timer"), object: nil, userInfo: ["index": 0])
        }
        
        completionHandler()
    }
}
