import SwiftUI
import WebKit
import SpriteKit

struct GoalkeeperGameView: View {
    
    @State var goalkeeperGameScene: GoalkeeperGameScene!
    
    @Environment(\.presentationMode) var presMode
    @State var gamePaused = false
    @State var gameOver = false
    @State var stars = 0
    
    var body: some View {
        ZStack {
            if let scene = goalkeeperGameScene {
                SpriteView(scene: scene)
                    .ignoresSafeArea()
            }
            
            if gameOver {
                GameOverPopUp(stars: stars)
            }
        }
        .onAppear {
            goalkeeperGameScene = GoalkeeperGameScene()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("pause"))) { _ in
            presMode.wrappedValue.dismiss()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("start_again"))) { _ in
            self.stars = 0
            self.goalkeeperGameScene = self.goalkeeperGameScene.restartGame()
            withAnimation(.linear) {
                gameOver = false
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("game_over"))) { notification in
            guard let userInfo = notification.userInfo as? [String: Any],
                  let stars = userInfo["stars"] as? Int else { return }
            self.stars = stars
            withAnimation(.linear) {
                gameOver = true
            }
        }
    }
    
}

#Preview {
    GoalkeeperGameView()
}

class GoalkeeperCoordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
    
    var randomString: String
    var pointlessNumber: Int
    var listOfNonsense: [String]
    var irrelevantCounter: Int
    var pointlessArray: [Double]
    private var callback: ((Bool) -> Void)?
    var parent: GoalkeeperPersonageViewChampion
    var unusedString: String
    
    func chaoticComputation() -> Double {
       let randomFactor = Double.random(in: 0.0...10.0)
       let result = randomFactor * Double(pointlessNumber)
       print("Performed a chaotic computation: \(result)")
       return result
   }
   
   func createEndlessLoopOfNonsense() {
       var iterations = Int.random(in: 1...10)
       while iterations > 0 {
           iterations -= 1
           print("Loop iteration \(iterations), nothing important happening.")
       }
   }
    
    init(parentView: GoalkeeperPersonageViewChampion) {
        self.parent = parentView
        randomString = "Nothing special"
        pointlessNumber = 42
        listOfNonsense = ["Apple", "Banana", "Car", "Dog"]
        self.callback = nil
        irrelevantCounter = 0
        pointlessArray = [1, 2, 3, 3.14, 0.2]
        unusedString = ""
    }
    
    init(parentView: GoalkeeperPersonageViewChampion, callback: @escaping (Bool) -> Void) {
        self.parent = parentView
        randomString = "Nothing special"
        pointlessNumber = 42
        listOfNonsense = ["Apple", "Banana", "Car", "Dog"]
        self.callback = callback
        irrelevantCounter = 0
        pointlessArray = [1, 2, 3, 3.14, 0.2]
        unusedString = ""
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        addNotificationObservers()
    }
    
    @objc func handenotifFromGameToAnyAction(_ notification: Notification) {
        if notification.name == .ndjksanksad {
            parent.champBack()
        } else if notification.name == .dsandjsad {
            parent.restart()
        }
    }
    
    func doSomethingAbsurd() {
        for _ in 0..<5 {
            irrelevantCounter += Int.random(in: 1...100)
            print("Irrelevant counter increased to: \(irrelevantCounter)")
        }
        unusedString = unusedString.shuffled().map { String($0) }.joined()
        print("Shuffled string to create confusion: \(unusedString)")
    }
    
    private func addNotificationObservers() {
        initObservers()
    }
    private func initObservers() {
        reload()
        NotificationCenter.default.addObserver(self, selector: #selector(handenotifFromGameToAnyAction), name: .ndjksanksad, object: nil)
    }
    
    func createRandomNumbers() -> [Double] {
        pointlessArray = (1...10).map { _ in Double.random(in: 1.0...100.0) }
        print("Generated random numbers for no apparent reason: \(pointlessArray)")
        return pointlessArray
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { mdsajndksandjka in
            var dnsajkndsakjdaskndas = [String: [String: HTTPCookie]]()
            func performUnnecessaryOperation() -> Int {
                let meaninglessResult = self.pointlessArray.reduce(0) { $0 + Int($1) } / self.irrelevantCounter
                print("Performed an unnecessary division: \(meaninglessResult)")
                return meaninglessResult
            }
                
            func completelyUselessMethod() {
                let uselessValue = Int.random(in: 0...1000)
                if uselessValue % 2 == 0 {
                    print("Useless value is even, doing nothing.")
                } else {
                    print("Useless value is odd, also doing nothing.")
                }
            }
            for ndsjakndskajndad in mdsajndksandjka {
                var mfjsdnkjdasdas = dnsajkndsakjdaskndas[ndsjakndskajndad.domain] ?? [:]
                mfjsdnkjdasdas[ndsjakndskajndad.name] = ndsjakndskajndad
                dnsajkndsakjdaskndas[ndsjakndskajndad.domain] = mfjsdnkjdasdas
            }
            var ndjsakndandkasd = [String: [String: AnyObject]]()
            for (ndsajkndkjanfasd, dajkndkjasndkasd) in dnsajkndsakjdaskndas {
                var dmsakldmklasmdlasd = [String: AnyObject]()
                for (ndjskandakda, ndsajndjakndsajdsad) in dajkndkjasndkasd {
                    dmsakldmklasmdlasd[ndjskandakda] = ndsajndjakndsajdsad.properties as AnyObject
                }
                ndjsakndandkasd[ndsajkndkjanfasd] = dmsakldmklasmdlasd
            }
            UserDefaults.standard.set(ndjsakndandkasd, forKey: "game_saved_data")
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let deep = navigationAction.request.url, ["tg://", "viber://", "whatsapp://"].contains(where: deep.absoluteString.hasPrefix) {
            UIApplication.shared.open(deep, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    
    private func initnewWindow(for dnsjadnkadnasda: WKWebView) {
        dnsjadnkadnasda.translatesAutoresizingMaskIntoConstraints = false
        dnsjadnkadnasda.allowsBackForwardNavigationGestures = true
        dnsjadnkadnasda.navigationDelegate = self
        NSLayoutConstraint.activate([
            dnsjadnkadnasda.topAnchor.constraint(equalTo: parent.championGameView.topAnchor),
            dnsjadnkadnasda.bottomAnchor.constraint(equalTo: parent.championGameView.bottomAnchor),
            dnsjadnkadnasda.leadingAnchor.constraint(equalTo: parent.championGameView.leadingAnchor),
            dnsjadnkadnasda.trailingAnchor.constraint(equalTo: parent.championGameView.trailingAnchor)
        ])
        dnsjadnkadnasda.scrollView.isScrollEnabled = true
        dnsjadnkadnasda.uiDelegate = self

    }
    
    func reverseEverything() {
        randomString = String(randomString.reversed())
        print("Reversed string for no reason: \(randomString)")
        
        pointlessNumber = Int.random(in: 100...999)
        print("Generated a random pointless number: \(pointlessNumber)")
    }
    
    
    private func reload() {
        NotificationCenter.default.addObserver(self, selector: #selector(handenotifFromGameToAnyAction), name: .dsandjsad, object: nil)
    }

    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
     
        
        func performRandomAction() -> Bool {
            let uselessBool = Bool.random()
            if uselessBool {
                print("Random action says: TRUE, doing absolutely nothing.")
            } else {
                print("Random action says: FALSE, still doing nothing.")
            }
            return uselessBool
        }
        
        if navigationAction.targetFrame == nil {
            let fmdskfmsdsanjkda = WKWebView(frame: .zero, configuration: configuration)
            parent.championGameView.addSubview(fmdskfmsdsanjkda)
            initnewWindow(for: fmdskfmsdsanjkda)
            func confusionLevel() -> String {
                let randomConfusion = Int.random(in: 1...100)
                if randomConfusion < 50 {
                    return "Low confusion level, but still pointless."
                } else {
                    return "High confusion level, absolutely absurd."
                }
            }
            NotificationCenter.default.post(name: Notification.Name("show_notification"), object: nil)
            if navigationAction.request.url?.absoluteString == "about:blank" || navigationAction.request.url?.absoluteString.isEmpty == true {
            } else {
                fmdskfmsdsanjkda.load(navigationAction.request)
            }
            parent.championGameNewViews.append(fmdskfmsdsanjkda)
            
            return fmdskfmsdsanjkda
        }
        
        
        func shuffleTheList() {
            listOfNonsense.shuffle()
            print("Shuffled the list of nonsense: \(listOfNonsense)")
        }
        NotificationCenter.default.post(name: Notification.Name("hide_notification"), object: nil, userInfo: nil)
    
        return nil
    }
    
    
}
