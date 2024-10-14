import SwiftUI

@main
struct The_Champion_GoalkeeperApp: App {
    
    @UIApplicationDelegateAdaptor(ChampionGoalkeeperDelegateApp.self) var championGoalkeeperDelegateApp
    
    var body: some Scene {
        WindowGroup {
            LoadChampionGoalkeeperGame()
        }
    }
    
}
