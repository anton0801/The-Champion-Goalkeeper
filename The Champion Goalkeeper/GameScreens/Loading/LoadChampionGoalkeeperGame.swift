import SwiftUI

struct LoadChampionGoalkeeperGame: View {
    
    @StateObject var loadChampionViewModel = LoadChampionViewModel()
    
    @State var gameLoadedState = true
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                HStack {
                    Text("Load game...")
                        .font(.custom("Benzin-Bold", size: 32))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.7), radius: 2, x: -1)
                        .shadow(color: .black.opacity(0.7), radius: 2, x: 1)
                    ProgressView()
                }
                
                if loadChampionViewModel.loaded {
                    if loadChampionViewModel.metaData != nil {
                        NavigationLink(destination: ContentViewChamp()
                            .navigationBarBackButtonHidden(), isActive: $gameLoadedState) {
                            
                        }
                    } else {
                        NavigationLink(destination: ContentView()
                            .navigationBarBackButtonHidden(), isActive: $gameLoadedState) {
                            
                        }
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("fcm_received")), perform: { _ in
                loadChampionViewModel.pushTokenReceived = true
                loadChampionViewModel.gameLoaded = true
                loadChampionViewModel.operateDataPushToken()
            })
            .onReceive(Timer.publish(every: 5.0, on: .main, in: .common).autoconnect()) { _ in
                if !loadChampionViewModel.pushTokenReceived {
                    if !loadChampionViewModel.gameLoaded {
                        loadChampionViewModel.gameLoaded = true
                        loadChampionViewModel.operateDataPushToken()
                    }
                }
            }
            .background(
                Image("main_background")
                    .resizable()
                    .frame(minWidth: UIScreen.main.bounds.width,
                           minHeight: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    LoadChampionGoalkeeperGame()
}
