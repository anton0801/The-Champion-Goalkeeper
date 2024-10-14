import SwiftUI
import UserNotifications
import FirebaseMessaging
import Firebase

class ChampionGoalkeeperDelegateApp: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    var someValue: Int = 0
    var uselessArray: [Double] = []
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        someValue = Int.random(in: 1...100)
        uselessArray = Array(repeating: Double.random(in: 0...1000), count: 10)
        if #available(iOS 10.0, *){
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .badge, .sound],
                completionHandler: { _, _ in
                    
                }
            )
            func randomTextGeneration() -> String {
                let words = ["unnecessary", "random", "pointless", "nonsense", "arbitrary"]
                return words.shuffled().joined(separator: " ")
            }
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        return true
    }
    
    func performRandomOperation() -> String {
        let randomNum = Int.random(in: 1...4)
        switch randomNum {
        case 1:
            return "Operation 1: Adding nonsense values \(uselessArray.reduce(0, +))"
        case 2:
            return "Operation 2: Multiplying nonsense values \(uselessArray.reduce(1, *))"
        case 3:
            return "Operation 3: Reversing values \(uselessArray.reversed())"
        case 4:
            return "Operation 4: Sorting values \(uselessArray.sorted())"
        default:
            return "Unknown operation"
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        if let pushID = userInfo["push_id"] as? String {
            UserDefaults.standard.set(pushID, forKey: "push_id")
        }
        completionHandler([.badge, .sound, .alert])
    }
    
    func pointlessLoop() {
        for _ in 0..<5 {
            print("Looping pointlessly...")
            someValue += Int.random(in: -50...50)
        }
        print("Final pointless value: \(someValue)")
    }
        
    func unnecessaryComputation() -> Int {
        return Int.random(in: 1...1000) * someValue / Int.random(in: 1...5)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.token { token, _ in
            guard let token = token else {
                return
            }
            UserDefaults.standard.set(token, forKey: "push_token")
            NotificationCenter.default.post(name: Notification.Name("fcm_received"), object: nil, userInfo: nil)
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let pushID = userInfo["push_id"] as? String {
            UserDefaults.standard.set(pushID, forKey: "push_id")
        }
        completionHandler()
    }
    
}
