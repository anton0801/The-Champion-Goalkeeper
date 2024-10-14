import SpriteKit
import SwiftUI

class OffensiveGameScene: SKScene {

   private var goalkeeper: SKSpriteNode!
   private var ball: SKSpriteNode!
   private var leg: SKSpriteNode!
   
   private var pauseButton: SKSpriteNode!
   
   private var selectedGoalkeeperMove: GoalkeeperDirections? = nil
   private var selectedBallMove: GoalkeeperDirections? = nil
   
   private var topLeftButton: SKSpriteNode!
   private var leftButton: SKSpriteNode!
   private var bottomLeftButton: SKSpriteNode!
   
   private var topRightButton: SKSpriteNode!
   private var rightButton: SKSpriteNode!
   private var bottomRightButton: SKSpriteNode!
   
   private var shootCountRest = 6 {
       didSet {
           if shootCountRest > 0 {
               shoots[shootCountRest].run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.3), SKAction.removeFromParent()]))
           } else {
               gameOver()
           }
       }
   }
   private var shoots: [SKNode] = []
   
   private var starsNode: [SKNode] = []
   private var stars = 0 {
       didSet {
           setUpStars()
       }
   }
   
   private var missedGoals = 0 {
       didSet {
           if missedGoals == 2 {
               stars += 1
           } else if missedGoals == 4 {
               stars += 1
           } else if missedGoals == 6 {
               stars += 1
           }
       }
   }
   
   override func didMove(to view: SKView) {
       size = CGSize(width: 1500, height: 2700)
       
       let footballBackground = SKSpriteNode(imageNamed: "football_bg")
       footballBackground.size = size
       footballBackground.position = CGPoint(x: size.width / 2, y: size.height / 2)
       footballBackground.zPosition = -1
       addChild(footballBackground)
       
       let gates = SKSpriteNode(imageNamed: "gate")
       gates.position = CGPoint(x: size.width / 2, y: size.height / 2 + 250)
       gates.size = CGSize(width: size.width - 150, height: gates.size.height)
       addChild(gates)
       
       goalkeeper = SKSpriteNode(imageNamed: "goalkeeper_pers")
       goalkeeper.position = CGPoint(x: size.width / 2, y: size.height / 2 + 120)
       addChild(goalkeeper)
       
       ball = SKSpriteNode(imageNamed: UserDefaults.standard.string(forKey: "selected_ball") ?? "ball")
       ball.position = CGPoint(x: size.width / 2, y: 700)
       addChild(ball)
       
       leg = SKSpriteNode(imageNamed: "leg")
       leg.position = CGPoint(x: size.width / 2 - 250, y: 400)
       addChild(leg)
       
       pauseButton = SKSpriteNode(imageNamed: "pause")
       pauseButton.position = CGPoint(x: 130, y: size.height - 130)
       addChild(pauseButton)
       
       topLeftButton = SKSpriteNode(imageNamed: "button_left_top_edge")
       topLeftButton.position = CGPoint(x: 190, y: size.height / 2 - 150)
       addChild(topLeftButton)
       
       leftButton = SKSpriteNode(imageNamed: "button_left")
       leftButton.position = CGPoint(x: 190, y: size.height / 2 - 400)
       addChild(leftButton)
       
       bottomLeftButton = SKSpriteNode(imageNamed: "bottom_left_bottom_edge")
       bottomLeftButton.position = CGPoint(x: 190, y: size.height / 2 - 650)
       addChild(bottomLeftButton)
       
       pauseButton = SKSpriteNode(imageNamed: "pause")
       pauseButton.position = CGPoint(x: 130, y: size.height - 130)
       addChild(pauseButton)
       
       topRightButton = SKSpriteNode(imageNamed: "button_top_right_edge")
       topRightButton.position = CGPoint(x: size.width - 190, y: size.height / 2 - 150)
       addChild(topRightButton)
       
       rightButton = SKSpriteNode(imageNamed: "button_right")
       rightButton.position = CGPoint(x: size.width - 190, y: size.height / 2 - 400)
       addChild(rightButton)
       
       bottomRightButton = SKSpriteNode(imageNamed: "button_right_bottom_edge")
       bottomRightButton.position = CGPoint(x: size.width - 190, y: size.height / 2 - 650)
       addChild(bottomRightButton)
       
       setUpStars()
       setUpShootCount()
       
       playBackgroundMusic()
   }
   
   private func setUpStars() {
       for star in starsNode {
           star.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.3), SKAction.removeFromParent()]))
       }
       
       for i in 0..<3 {
           var starName = "star_not_filled"
           if (stars - 1) >= i {
               starName = "star_filled"
           }
           let starNode = SKSpriteNode(imageNamed: starName)
           starNode.position = CGPoint(x: size.width / 2 - 300 + ((starNode.size.width + 25) * CGFloat(i)), y: size.height / 2 + 800)
           addChild(starNode)
           starsNode.append(starNode)
       }
   }
   
   private func setUpShootCount() {
       if shoots.isEmpty {
           for i in 0..<shootCountRest {
               let ballNode = SKSpriteNode(imageNamed: UserDefaults.standard.string(forKey: "selected_ball") ?? "ball")
               ballNode.size = CGSize(width: 80, height: 80)
               ballNode.position = CGPoint(x: size.width - 100, y: size.height - 150 - ((ballNode.size.height + 25) * CGFloat(i)))
               addChild(ballNode)
               shoots.append(ballNode)
           }
       }
   }
   
   func degreesToRadians(degrees: CGFloat) -> CGFloat {
       return degrees * .pi / 180
   }
   
    private func startShoot() {
        let moveLeg = SKAction.move(to: CGPoint(x: size.width / 2 - 200, y: 550), duration: 0.5)
        let rotate = SKAction.rotate(toAngle: degreesToRadians(degrees: 25), duration: 0.5)
        let group = SKAction.group([moveLeg, rotate])
        leg.run(group) {
            self.startBall()
        }
    }
    
    func generateHitChance() -> Int {
        return Int.random(in: 0...100)
    }
    
    func restartGame() -> OffensiveGameScene {
        let newScene = OffensiveGameScene()
        view?.presentScene(newScene)
        return newScene
    }
    
    private var guessProbability = Int.random(in: 10...80)
    
   private func startBall() {
       let directions: [GoalkeeperDirections] = [.topLeft, .left, .bottomLeft, .topRight, .right, .bottomRight]
       if generateHitChance() <= guessProbability {
           selectedGoalkeeperMove = selectedBallMove
      } else {
          selectedGoalkeeperMove = directions.randomElement() ?? .topLeft
      }
       let animDuration = 0.5
       
       playBallShootSound()
       let ballPointMove = getPointMove(selectedBallMove!)
       let goalkeeperMovePoint = getPointMove(selectedGoalkeeperMove!)
       let goalkeeperMoveRotation = getRotationOfDirection(selectedGoalkeeperMove!)
       
       let goalkeeperMove = SKAction.move(to: goalkeeperMovePoint, duration: animDuration)
       let goalkeeperRotation = SKAction.rotate(toAngle: degreesToRadians(degrees: goalkeeperMoveRotation), duration: animDuration)
       
       let moveAction = SKAction.move(to: ballPointMove, duration: animDuration)
       let ballScaleAction = SKAction.scale(to: 0.3, duration: animDuration)
       goalkeeper.run(SKAction.group([goalkeeperMove, goalkeeperRotation]))
       ball.run(SKAction.group([moveAction, ballScaleAction])) {
           self.shootCountRest -= 1
           if self.selectedGoalkeeperMove != self.selectedBallMove {
               self.missedGoals += 1
               let notificationFeedback = UINotificationFeedbackGenerator()
               notificationFeedback.notificationOccurred(.success)
           } else {
               let notificationFeedback = UINotificationFeedbackGenerator()
               notificationFeedback.notificationOccurred(.error)
           }
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
               self.resetGame()
           }
       }
   }
   
   private func resetGame() {
       buttonMoveSelected?.run(SKAction.fadeAlpha(to: 1, duration: 0.3))
       buttonMoveSelected = nil
       ball.position = CGPoint(x: size.width / 2, y: 700)
       ball.xScale = 1
       ball.yScale = 1
       leg.position = CGPoint(x: size.width / 2 - 250, y: 400)
       leg.zRotation = 0
       goalkeeper.position = CGPoint(x: size.width / 2, y: size.height / 2 + 120)
       goalkeeper.zRotation = 0
       selectedBallMove = nil
       selectedGoalkeeperMove = nil
   }
   
   private func getRotationOfDirection(_ direction: GoalkeeperDirections) -> CGFloat {
       switch direction {
       case .topLeft:
           return 45
       case .left:
           return 45
       case .bottomLeft:
           return 45
       case .topRight:
           return -45
       case .right:
           return -45
       case .bottomRight:
           return -45
       }
   }
   
   private func getPointMove(_ direction: GoalkeeperDirections) -> CGPoint {
       switch direction {
       case .topLeft:
           return CGPoint(x: size.width / 2 - 450, y: size.height / 2 + 450)
       case .left:
           return CGPoint(x: size.width / 2 - 450, y: size.height / 2 + 250)
       case .bottomLeft:
           return CGPoint(x: size.width / 2 - 450, y: size.height / 2)
       case .topRight:
           return CGPoint(x: size.width / 2 + 450, y: size.height / 2 + 450)
       case .right:
           return CGPoint(x: size.width / 2 + 450, y: size.height / 2 + 250)
       case .bottomRight:
           return CGPoint(x: size.width / 2 + 450, y: size.height / 2)
       }
   }
   
   private var buttonMoveSelected: SKNode? = nil {
       didSet {
           if buttonMoveSelected != nil {
               startShoot()
           }
       }
   }
   
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       if let touch = touches.first {
           let location = touch.location(in: self)
           let nodesAtPoint = nodes(at: location)
           
           for node in nodesAtPoint {
               if buttonMoveSelected == nil {
                   if node == topLeftButton {
                       selectedBallMove = .topLeft
                       buttonMoveSelected = node
                   } else if node == leftButton {
                       selectedBallMove = .left
                       buttonMoveSelected = node
                   } else if node == bottomLeftButton {
                       selectedBallMove = .bottomLeft
                       buttonMoveSelected = node
                   } else if node == topRightButton {
                       selectedBallMove = .topRight
                       buttonMoveSelected = node
                   } else if node == rightButton {
                       selectedBallMove = .right
                       buttonMoveSelected = node
                   } else if node == bottomRightButton {
                       selectedBallMove = .bottomRight
                       buttonMoveSelected = node
                   }
               }
               
               if node == pauseButton {
                   pauseGame()
               }
           }
           
           if buttonMoveSelected != nil {
               buttonMoveSelected!.run(SKAction.fadeAlpha(to: 0.6, duration: 0.3))
           }
       }
   }
   
   private func gameOver() {
       isPaused = true
       NotificationCenter.default.post(name: Notification.Name("game_over"), object: nil, userInfo: ["stars": stars])
   }
   
   private func pauseGame() {
       isPaused = true
       NotificationCenter.default.post(name: Notification.Name("pause"), object: nil)
   }
   
   private func playBallShootSound() {
       if UserDefaults.standard.integer(forKey: "sound_state") == 1 {
           run(SKAction.playSoundFileNamed("ball_pull", waitForCompletion: false))
       }
   }
   
   private func playBackgroundMusic() {
       if UserDefaults.standard.integer(forKey: "sound_state") == 1 {
           let backMusic = SKAudioNode(fileNamed: "back_music")
           backMusic.autoplayLooped = true
           addChild(backMusic)
           
           let setVolumeAction = SKAction.changeVolume(to: 0.05, duration: 0)
           backMusic.run(setVolumeAction)
       }
   }
       
}

#Preview {
    VStack {
        SpriteView(scene: OffensiveGameScene())
            .ignoresSafeArea()
    }
}
