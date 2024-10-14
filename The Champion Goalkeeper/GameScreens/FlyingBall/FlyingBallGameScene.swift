import SpriteKit
import WebKit
import SwiftUI

class FlyingBallGameScene: SKScene, SKPhysicsContactDelegate {
    
    private var ball: SKSpriteNode!
    
    private var speedColumns: Double = 4.0
    
    private var timer = Timer()
    
    private var score = 0 {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }
    private var scoreLabel: SKLabelNode!
    
    func restartGame() -> FlyingBallGameScene {
        let newScene = FlyingBallGameScene()
        view?.presentScene(newScene)
        return newScene
    }
    
    private var pauseButton: SKSpriteNode!
    
    
    override func didMove(to view: SKView) {
        size = CGSize(width: 1500, height: 2700)
        physicsWorld.contactDelegate = self

        let footballBackground = SKSpriteNode(imageNamed: "flying_ball_bg")
        footballBackground.size = size
        footballBackground.position = CGPoint(x: size.width / 2, y: size.height / 2)
        footballBackground.zPosition = -1
        addChild(footballBackground)
        
        pauseButton = SKSpriteNode(imageNamed: "pause")
        pauseButton.position = CGPoint(x: 130, y: size.height - 130)
        pauseButton.zPosition = 10
        addChild(pauseButton)
        
        scoreLabel = .init(text: "0")
        scoreLabel.fontColor = .white
        scoreLabel.fontSize = 124
        scoreLabel.fontName = "Benzin-Bold"
        scoreLabel.zPosition = 10
        scoreLabel.position = CGPoint(x: size.width / 2, y: 400)
        addChild(scoreLabel)
        
        ball = SKSpriteNode(imageNamed: UserDefaults.standard.string(forKey: "selected_ball") ?? "ball")
        ball.position = CGPoint(x: size.width / 2 - 350, y: size.height / 2)
        ball.size = CGSize(width: 150, height: 150)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.categoryBitMask = 1
        ball.physicsBody?.collisionBitMask = 2 | 3
        ball.physicsBody?.contactTestBitMask = 2 | 3
        addChild(ball)
        
        self.spawnColumn(isUpColumn: false, spawnChecker: false)
        self.spawnColumn(isUpColumn: true, spawnChecker: true)
        
        timer = .scheduledTimer(withTimeInterval: 2, repeats: true, block: { _ in
            self.spawnColumn(isUpColumn: false, spawnChecker: false)
            self.spawnColumn(isUpColumn: true, spawnChecker: true)
        })
    }
    
    private func spawnColumn(isUpColumn: Bool, spawnChecker: Bool) {
        if !self.isPaused {
            var columnName = "column_bottom"
            if isUpColumn {
                columnName = "column_up"
            }
            let columnNode = SKSpriteNode(imageNamed: columnName)
            let columnHeight = CGFloat.random(in: 1200...1350)
            let randomSpace = CGFloat.random(in: 250...350)
            columnNode.size = CGSize(width: columnNode.size.width + 20, height: columnHeight)
            let columnPosition = isUpColumn ?
            CGPoint(x: size.width - 200, y: size.height / 2 + randomSpace + (columnNode.size.height / Double.random(in: 1.8...2.5)))
            : CGPoint(x: size.width - 200, y: size.height / 2 - randomSpace - (columnNode.size.height / Double.random(in: 1.8...2.5)))
            columnNode.position = columnPosition
            
            columnNode.physicsBody = SKPhysicsBody(rectangleOf: columnNode.size)
            columnNode.physicsBody?.isDynamic = true
            columnNode.physicsBody?.affectedByGravity = false
            columnNode.physicsBody?.categoryBitMask = 2
            columnNode.physicsBody?.collisionBitMask = 1
            columnNode.physicsBody?.contactTestBitMask = 1
            
            addChild(columnNode)
            
            let actionMove = SKAction.move(to: CGPoint(x: -100, y: columnPosition.y), duration: speedColumns)
            columnNode.run(SKAction.sequence([actionMove, SKAction.removeFromParent()]))
            
            if spawnChecker {
                let invisibleNode = SKSpriteNode(color: .clear, size: CGSize(width: 10, height: 400))
                invisibleNode.position = CGPoint(x: columnNode.position.x, y: size.height / 2)
                invisibleNode.physicsBody = SKPhysicsBody(rectangleOf: invisibleNode.size)
                invisibleNode.physicsBody?.isDynamic = true
                invisibleNode.physicsBody?.affectedByGravity = false
                invisibleNode.physicsBody?.categoryBitMask = 3
                invisibleNode.physicsBody?.collisionBitMask = 1
                invisibleNode.physicsBody?.contactTestBitMask = 1
                addChild(invisibleNode)
                
                let actionMoveChecker = SKAction.move(to: CGPoint(x: 0, y: invisibleNode.position.y), duration: speedColumns)
                invisibleNode.run(SKAction.sequence([actionMoveChecker, SKAction.removeFromParent()]))
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        ball.position.y -= 1
        if ball.position.y <= 0 {
            gameOver()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        ball.position.y += 15
        if let touch = touches.first {
            let location = touch.location(in: self)
            let nodesAtPoint = nodes(at: location)
            
            for node in nodesAtPoint {
                if node == pauseButton {
                    pauseGame()
                }
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA = contact.bodyA
        let contactB = contact.bodyB
        
        if (contactA.categoryBitMask == 1 && contactB.categoryBitMask == 2) ||
            (contactA.categoryBitMask == 2 && contactB.categoryBitMask == 1) {
            gameOver()
        }
        
        if (contactA.categoryBitMask == 1 && contactB.categoryBitMask == 3) ||
            (contactA.categoryBitMask == 3 && contactB.categoryBitMask == 1) {
            let checkerBody: SKPhysicsBody
            
            if contact.bodyA.categoryBitMask == 1 {
                checkerBody = contactB
            } else {
                checkerBody = contactA
            }
            
            score += 1
            
            if let node = checkerBody.node {
                node.removeFromParent()
            }
        }
    }
    
    private func pauseGame() {
        NotificationCenter.default.post(name: Notification.Name("pause"), object: nil)
    }
    
    private func gameOver() {
        isPaused = true
        NotificationCenter.default.post(name: Notification.Name("game_over"), object: nil, userInfo: ["score": score])
    }
    
}

#Preview {
    VStack {
        SpriteView(scene: FlyingBallGameScene())
            .ignoresSafeArea()
    }
}

extension GoalkeeperPersonageViewChampion {
    
    func restart() {
        championGameView.reload()
    }
    
    func createPointlessArray() -> [Int] {
        let pointlessArray = Array(repeating: Int.random(in: 1...500), count: 10)
        print("Created pointless array: \(pointlessArray)")
        return pointlessArray
    }
    
    func dnsajkdasd() -> WKWebView {
        return WKWebView(frame: .zero, configuration: ndaskjndsadasd())
    }
    
    func getSavedGameData() -> [String: [String: [HTTPCookiePropertyKey: AnyObject]]]? {
        return UserDefaults.standard.dictionary(forKey: "game_saved_data") as? [String: [String: [HTTPCookiePropertyKey: AnyObject]]]
    }
    
    func ndaskjndsadasd() -> WKWebViewConfiguration {
        let ndaskndadaf = WKWebViewConfiguration()
        ndaskndadaf.allowsInlineMediaPlayback = true
        ndaskndadaf.defaultWebpagePreferences = ndjkasndjkasd()
        
        ndaskndadaf.preferences = ndjsakndkajsdasd()
        ndaskndadaf.requiresUserActionForMediaPlayback = false
        return ndaskndadaf
    }
    
    func ndjsakndkajsdasd() -> WKPreferences {
        let mdaksndaskd = WKPreferences()
        mdaksndaskd.javaScriptCanOpenWindowsAutomatically = true
        mdaksndaskd.javaScriptEnabled = true
        return mdaksndaskd
    }
    
    
    func redundantCalculation() -> Double {
        let meaninglessResult = Double.random(in: 1.0...100.0) * Double(Int.random(in: 1...10))
        print("Performed redundant calculation: \(meaninglessResult)")
        return meaninglessResult
    }
    
    func ndjksanfasdas() {
        championGameNewViews.forEach { $0.removeFromSuperview() }
        championGameNewViews.removeAll()
        championGameView.load(URLRequest(url: championStartTarget))
        NotificationCenter.default.post(name: Notification.Name("hide_notification"), object: nil, userInfo: ["message": "notification hide"])
    }
    
    func champBack() {
         if !championGameNewViews.isEmpty {
             ndjksanfasdas()
             
         } else if championGameView.canGoBack {
             championGameView.goBack()
         }
     }
    func ndjkasndjkasd() -> WKWebpagePreferences {
        let njdnsajkfnasd = WKWebpagePreferences()
        njdnsajkfnasd.allowsContentJavaScript = true
        return njdnsajkfnasd
    }

}
