import SwiftUI
import WebKit

struct ContentView: View {
    
    @State var settingsViseble = false
    
    @State var soundState = UserDefaults.standard.integer(forKey: "sound_state")
    @State var vibroState = UserDefaults.standard.integer(forKey: "vibro_state")
    
    @State var sheetVisible = false
    @State var commingSoonAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Image("champion_goalkeeper_icon")
                        .resizable()
                        .frame(width: 350, height: 350)
                        .offset(x: 0, y: -20)
                    Spacer()
                }
                
                VStack {
                    HStack {
                        Spacer()
                        VStack {
                            NavigationLink(destination: GameChooserView()
                                .navigationBarBackButtonHidden()) {
                                Image("play")
                                    .resizable()
                                    .frame(width: 240, height: 85)
                            }
                            Button {
                                withAnimation(.easeIn) {
                                    settingsViseble = true
                                }
                            } label: {
                                Image("settings")
                                    .resizable()
                                    .frame(width: 180, height: 70)
                            }
//                            NavigationLink(destination: EmptyView()) {
//                                Image("daily_reward")
//                                    .resizable()
//                                    .frame(width: 180, height: 70)
//                            }
                            Button {
                                sheetVisible.toggle()
                            } label: {
                                Image("privacy_policy")
                                    .resizable()
                                    .frame(width: 180, height: 70)
                            }
                            Button {
                                commingSoonAlert = true
                            } label: {
                                Image("shop")
                                    .resizable()
                                    .frame(width: 180, height: 70)
                            }
                        }
                    }
                }
                
                if settingsViseble {
                    VStack {
                        Image("settings_title")
                            .resizable()
                            .frame(width: 300, height: 80)
                            .zIndex(5)
                        VStack {
                            Text("sound")
                                .font(.custom("Benzin-Bold", size: 32))
                                .foregroundColor(.white)
                            Button {
                                withAnimation(.linear) {
                                    if soundState == 0 {
                                        soundState = 1
                                    } else {
                                        soundState = 0
                                    }
                                }
                            } label: {
                                if soundState == 1 {
                                    Image("on")
                                        .resizable()
                                        .frame(width: 150, height: 50)
                                } else {
                                    Image("off")
                                        .resizable()
                                        .frame(width: 150, height: 50)
                                }
                            }
                            Text("vibro")
                                .font(.custom("Benzin-Bold", size: 32))
                                .foregroundColor(.white)
                            Button {
                                withAnimation(.linear) {
                                    if vibroState == 0 {
                                        vibroState = 1
                                    } else {
                                        vibroState = 0
                                    }
                                }
                            } label: {
                                if vibroState == 1 {
                                    Image("on")
                                        .resizable()
                                        .frame(width: 150, height: 50)
                                } else {
                                    Image("off")
                                        .resizable()
                                        .frame(width: 150, height: 50)
                                }
                            }
                        }
                        .onChange(of: soundState) { newValue in
                            UserDefaults.standard.set(newValue, forKey: "sound_state")
                        }
                        .onChange(of: vibroState) { newValue in
                            UserDefaults.standard.set(newValue, forKey: "vibro_state")
                        }
                        .background(
                            Image("settings_pop_up_bg")
                                .resizable()
                                .frame(width: 200, height: 250)
                        )
                        
                        Button {
                            withAnimation(.easeOut(duration: 0.4)) {
                                settingsViseble = false
                            }
                        } label: {
                            Image("back_btn")
                                .resizable()
                                .frame(width: 100, height: 40)
                        }
                        .padding(.top, 24)
                    }
                    .background(
                        Rectangle()
                            .fill(.black.opacity(0.4))
                            .frame(minWidth: UIScreen.main.bounds.width,
                                   minHeight: UIScreen.main.bounds.height)
                            .ignoresSafeArea()
                    )
                }
            }
            .background(
                Image("main_background")
                    .resizable()
                    .frame(minWidth: UIScreen.main.bounds.width,
                           minHeight: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            )
            .sheet(isPresented: $sheetVisible) {
                PrivacyPolicyView(urlString: "https://champfootball.site/privacy.html")
            }
            .alert(isPresented: $commingSoonAlert) {
                Alert(title: Text("Comming soon!"),
                      message: Text("The store will be available soon, for now play games and collect balls for which you can buy new skins in the store."))
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct PrivacyPolicyView: UIViewRepresentable {
    let urlString: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}

#Preview {
    ContentView()
}
