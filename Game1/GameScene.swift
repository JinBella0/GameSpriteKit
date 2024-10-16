import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label: SKLabelNode?
    private var character: SKSpriteNode?
    private var blueberries: [SKSpriteNode] = []
    private var scoreLabel: SKLabelNode?
    private var scoreBackground: SKSpriteNode?
    private var score: Int = 0
    private var blueberriesAvoided: Int = 0
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.white
        
//        self.label = self.childNode(withName: "ㅣ") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // 캐릭터
        self.character = SKSpriteNode(imageNamed: "Character")
        self.character?.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        self.character?.setScale(0.2)
        self.addChild(self.character!)
        
        // 스코어
        scoreBackground = SKSpriteNode(color: SKColor.lightGray, size: CGSize(width: 150, height: 40))
        scoreBackground?.position = CGPoint(x: 100, y: self.size.height - 70)
        scoreBackground?.zPosition = 1
        if let scoreBackground = scoreBackground {
            self.addChild(scoreBackground)
        }
        
    
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel?.position = CGPoint(x: 100, y: self.size.height - 80)
        scoreLabel?.fontSize = 25
        scoreLabel?.fontName = "Helvetica-Bold"
        scoreLabel?.zPosition = 2
        if let scoreLabel = scoreLabel {
            self.addChild(scoreLabel)
        }
        
       
        startDroppingBlueberries()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let touchLocation = t.location(in: self)
            character?.run(SKAction.move(to: touchLocation, duration: 0.5))
        }
        
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let touchLocation = t.location(in: self)
            character?.run(SKAction.move(to: touchLocation, duration: 0.3))
        }
    }
    
    
    func startDroppingBlueberries() {
        let dropAction = SKAction.run { [weak self] in
            self?.createBlueberry()
        }
        let waitAction = SKAction.wait(forDuration: 1.0)
        let sequence = SKAction.sequence([dropAction, waitAction])
        self.run(SKAction.repeatForever(sequence))
    }
    
    func createBlueberry() {
        let blueberry = SKSpriteNode(imageNamed: "Blueberry")
        let randomX = CGFloat.random(in: 0...self.size.width)
        blueberry.position = CGPoint(x: randomX, y: self.size.height)
        self.addChild(blueberry)
        blueberries.append(blueberry)
        
        let moveAction = SKAction.moveTo(y: -blueberry.size.height, duration: 5.0)
        blueberry.run(moveAction) { [weak self] in
            self?.handleBlueberryFell(blueberry)
        }
    }
    
//    override func update(_ currentTime: TimeInterval) {
//        for blueberry in blueberries {
//            if let character = character {
//                // 블베 & 캐릭터 겹칠 때만 게임 종료
//                if blueberry.frame.intersects(character.frame) && blueberry.contains(character.position) {
//                    endGame()
//                    return
                    
                    override func update(_ currentTime: TimeInterval) {
                           for blueberry in blueberries {
                               if blueberry.frame.intersects(character?.frame ?? CGRect.zero) {
                                   // 블베 닿았을 때 게임 종료
                                   endGame()
                                   return
//                               }
//                           }
//                }
            }
        }
        
       
        blueberriesAvoided += 1
        scoreLabel?.text = "Score: \(blueberriesAvoided)"
    }
    
    func handleBlueberryFell(_ blueberry: SKSpriteNode) {
        blueberry.removeFromParent()
        blueberries.removeAll { $0 == blueberry }
    }
    
    func endGame() {
        let endLabel = SKLabelNode(text: "LOSE!")
        endLabel.fontName = "Helvetica-Bold"
        endLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        endLabel.fontSize = 45
        endLabel.fontColor = SKColor.red
        self.addChild(endLabel)
        
        // 최종 스코어 표시
        let finalScoreLabel = SKLabelNode(text: "Final Score: \(blueberriesAvoided)")
        finalScoreLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2 - 50)
        finalScoreLabel.fontSize = 30
        finalScoreLabel.fontColor = SKColor.black
        finalScoreLabel.fontName = "Helvetica-Bold"
        self.addChild(finalScoreLabel)
        
        self.isPaused = true
    }
}
