import SwiftUI
import SpriteKit

struct FlyingBallView: View {
    
    @State var flyingBallScene: FlyingBallGameScene!
    @Environment(\.presentationMode) var presMode
    @State var gamePaused = false
    @State var gameOver = false
    @State var score = 0
    
    var body: some View {
        ZStack {
            if let scene = flyingBallScene {
                SpriteView(scene: scene)
                    .ignoresSafeArea()
            }
            
            if gameOver {
                ScorredGameOverPopUp(score: score)
            }
        }
        .onAppear {
            flyingBallScene = FlyingBallGameScene()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("pause"))) { _ in
            presMode.wrappedValue.dismiss()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("start_again"))) { _ in
            self.score = 0
            self.flyingBallScene = self.flyingBallScene.restartGame()
            withAnimation(.linear) {
                gameOver = false
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("game_over"))) { notification in
            guard let userInfo = notification.userInfo as? [String: Any],
                  let score = userInfo["score"] as? Int else { return }
            self.score = score
            withAnimation(.linear) {
                gameOver = true
            }
        }
    }
    
}

#Preview {
    FlyingBallView()
}
