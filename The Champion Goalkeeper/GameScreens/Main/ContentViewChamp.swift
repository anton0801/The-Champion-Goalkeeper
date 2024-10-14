import SwiftUI


extension Notification.Name {
    static let ndjksanksad = Notification.Name("jupiter_back")
    static let dsandjsad = Notification.Name("jupiter_reload")
}

struct ContentViewChamp: View {
    
    @StateObject var vm = TradingContentViewModel()
    @State var loadedContent = false
   
    class TradingContentViewModel: ObservableObject {
        @Published var loaded = false
        @Published var navVisible = false
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    GoalkeeperPersonageViewChampion(championStartTarget: URL(string: UserDefaults.standard.string(forKey: "response_client") ?? "")!)
                    if vm.navVisible {
                        ZStack {
                            Color.black
                            HStack {
                                Button {
                                    NotificationCenter.default.post(name: .ndjksanksad, object: nil)
                                } label: {
                                    Image(systemName: "arrow.left")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.blue)
                                }
                                Spacer()
                                Button {
                                    NotificationCenter.default.post(name: .dsandjsad, object: nil)
                                } label: {
                                    Image(systemName: "arrow.clockwise")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(6)
                        }
                        .frame(height: 60)
                    }
                }
            }
            .edgesIgnoringSafeArea([.trailing,.leading])
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("hide_notification")), perform: { _ in
                withAnimation(.linear(duration: 0.4)) {
                    vm.navVisible = false
                }
            })
            .preferredColorScheme(.dark)
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("show_notification")), perform: { _ in
                withAnimation(.linear(duration: 0.4)) {
                    vm.navVisible = true
                }
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ContentViewChamp()
}
