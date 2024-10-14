import SwiftUI
import SpriteKit

struct OffensiveGameView: View {
    
    @State var offensiveGameScene: OffensiveGameScene!
    
    @Environment(\.presentationMode) var presMode
    @State var gamePaused = false
    @State var gameOver = false
    @State var stars = 0
    
    var body: some View {
        ZStack {
            if let scene = offensiveGameScene {
                SpriteView(scene: scene)
                    .ignoresSafeArea()
            }
            
            if gameOver {
                GameOverPopUp(stars: stars)
            }
        }
        .onAppear {
            offensiveGameScene = OffensiveGameScene()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("pause"))) { _ in
            presMode.wrappedValue.dismiss()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("start_again"))) { _ in
            self.stars = 0
            self.offensiveGameScene = self.offensiveGameScene.restartGame()
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
    OffensiveGameView()
}
