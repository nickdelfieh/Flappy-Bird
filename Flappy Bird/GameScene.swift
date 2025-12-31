//
//  GameScene.swift
//  Flappy Bird
//
//  Created by nick delfieh on 31/12/2025.
//

//thanks to chatgpt.com for making the code
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: - Bird
    var bird: SKSpriteNode!
    var birdVelocity: CGFloat = 0
    let gravity: CGFloat = -800
    let flapImpulse: CGFloat = 300
    
    // MARK: - Background
    var background: SKSpriteNode!
    
    // MARK: - Pipes
    var pipeTimer: Timer?
    let pipeGap: CGFloat = 190
    let pipeMoveDuration: TimeInterval = 4
    
    // MARK: - Score
    var score = 0
    var bestScore = 0
    var scoreLabel: SKLabelNode!
    var bestScoreLabel: SKLabelNode!
    
    // MARK: - Game State
    var isGameOver = false
    var isPlayingScoreSound = false
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        setupBackground()
        setupBird()
        setupScoreLabels()
        startPipeTimer()
    }
    
    // MARK: - Setup
    func setupBackground() {
        background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.size = size
        background.zPosition = -1
        addChild(background)
    }
    
    func setupBird() {
        bird = SKSpriteNode(imageNamed: "bird")
        bird.setScale(2.5)
        bird.position = CGPoint(x: size.width * 0.3, y: size.height / 2)
        
        bird.physicsBody = SKPhysicsBody(texture: bird.texture!, size: bird.size)
        bird.physicsBody?.isDynamic = true
        bird.physicsBody?.categoryBitMask = 1
        bird.physicsBody?.contactTestBitMask = 2
        bird.physicsBody?.collisionBitMask = 0
        
        addChild(bird)
    }
    
    func setupScoreLabels() {
        scoreLabel = SKLabelNode(text: "0")
        scoreLabel.fontSize = 50
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 80)
        scoreLabel.zPosition = 10
        addChild(scoreLabel)
        
        bestScore = UserDefaults.standard.integer(forKey: "bestScore")
        bestScoreLabel = SKLabelNode(text: "Best: \(bestScore)")
        bestScoreLabel.fontSize = 30
        bestScoreLabel.fontColor = .yellow
        bestScoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 130)
        bestScoreLabel.zPosition = 10
        addChild(bestScoreLabel)
    }
    
    func startPipeTimer() {
        pipeTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            self.spawnPipePair()
        }
    }
    
    // MARK: - Touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameOver { return }
        
        birdVelocity = flapImpulse
        
        // Wing sound (only if not scoring sound)
        if !isPlayingScoreSound {
            run(SKAction.playSoundFileNamed("sfx_wing", waitForCompletion: false))
        }
    }
    
    // MARK: - Update
    override func update(_ currentTime: TimeInterval) {
        if isGameOver { return }
        
        let dt: CGFloat = 1.0 / 60.0
        
        birdVelocity += gravity * dt
        bird.position.y += birdVelocity * dt
        
        if bird.position.y < 0 || bird.position.y > size.height {
            gameOver()
        }
        
        for node in children {
            if let pipe = node as? SKSpriteNode, pipe.name == "pipe" {
                
                if pipe.position.x < -pipe.size.width {
                    pipe.removeFromParent()
                }
                
                if pipe.anchorPoint.y == 0,
                   pipe.userData == nil,
                   pipe.position.x + pipe.size.width / 2 < bird.position.x {
                    
                    score += 1
                    scoreLabel.text = "\(score)"
                    pipe.userData = ["scored": true]
                    
                    // Score sound
                    isPlayingScoreSound = true
                    run(SKAction.playSoundFileNamed("sfx_point", waitForCompletion: false)) {
                        self.isPlayingScoreSound = false
                    }
                    
                    if score > bestScore {
                        bestScore = score
                        bestScoreLabel.text = "Best: \(bestScore)"
                        UserDefaults.standard.set(bestScore, forKey: "bestScore")
                    }
                }
            }
        }
    }
    
    // MARK: - Pipes
    func spawnPipePair() {
        
        let pipeX = size.width + 50
        
        let minGapY = size.height * 0.25
        let maxGapY = size.height * 0.75
        let gapCenterY = CGFloat.random(in: minGapY...maxGapY)
        
        let bottomHeight = gapCenterY - pipeGap / 2
        let topHeight = size.height - (gapCenterY + pipeGap / 2)
        
        let pipeBottom = SKSpriteNode(imageNamed: "pipeBottom")
        pipeBottom.name = "pipe"
        pipeBottom.anchorPoint = CGPoint(x: 0.5, y: 0)
        pipeBottom.position = CGPoint(x: pipeX, y: 0)
        pipeBottom.size.height = bottomHeight
        
        pipeBottom.physicsBody = SKPhysicsBody(
            rectangleOf: CGSize(width: pipeBottom.size.width, height: bottomHeight),
            center: CGPoint(x: 0, y: bottomHeight / 2)
        )
        pipeBottom.physicsBody?.isDynamic = false
        pipeBottom.physicsBody?.categoryBitMask = 2
        pipeBottom.physicsBody?.contactTestBitMask = 1
        pipeBottom.physicsBody?.collisionBitMask = 0
        addChild(pipeBottom)
        
        let pipeTop = SKSpriteNode(imageNamed: "pipeTop")
        pipeTop.name = "pipe"
        pipeTop.anchorPoint = CGPoint(x: 0.5, y: 1)
        pipeTop.position = CGPoint(x: pipeX, y: size.height)
        pipeTop.size.height = topHeight
        
        pipeTop.physicsBody = SKPhysicsBody(
            rectangleOf: CGSize(width: pipeTop.size.width, height: topHeight),
            center: CGPoint(x: 0, y: -topHeight / 2)
        )
        pipeTop.physicsBody?.isDynamic = false
        pipeTop.physicsBody?.categoryBitMask = 2
        pipeTop.physicsBody?.contactTestBitMask = 1
        pipeTop.physicsBody?.collisionBitMask = 0
        addChild(pipeTop)
        
        let moveLeft = SKAction.moveBy(x: -size.width - 100, y: 0, duration: pipeMoveDuration)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveLeft, remove])
        
        pipeBottom.run(sequence)
        pipeTop.run(sequence)
    }
    
    // MARK: - Collision
    func didBegin(_ contact: SKPhysicsContact) {
        gameOver()
    }
    

    
    // MARK: - Game Over
    func gameOver() {
        let gameOverScene = gameover(size: size)
        gameOverScene.scaleMode = .aspectFill
        view?.presentScene(gameOverScene, transition:.fade(withDuration: 0.5))
    }
}
