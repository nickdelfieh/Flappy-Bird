//
//  gameover.swift
//  Flappy Bird
//
//  Created by nick delfieh on 31/12/2025.
//

//thanks to chatgpt.com for making the code
import SpriteKit

class gameover: SKScene {
    
    private var startButton: SKSpriteNode!
    private var bestScoreLabel: SKLabelNode!
    private var gameOverLabel: SKLabelNode! // NEW
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupButtons()
        setupGameOverLabel() // add this
        updateBestScore() // refresh the score whenever scene appears
    }
    
    // MARK: - Background
    func setupBackground() {
        let bg = SKSpriteNode(imageNamed: "background")
        bg.position = CGPoint(x: size.width / 2, y: size.height / 2)
        bg.size = size
        bg.zPosition = -10
        bg.name = "background"
        addChild(bg)
    }
    
    // MARK: - Buttons
    func setupButtons() {
        // START BUTTON
        startButton = SKSpriteNode(imageNamed: "try_button")
        startButton.name = "start"
        startButton.size = CGSize(width: 152, height: 100)
        startButton.position = CGPoint(x: size.width / 2, y: size.height * 0.45)
        startButton.zPosition = 10
        addChild(startButton)
        
        // BEST SCORE LABEL (white, bigger, above the button)
        bestScoreLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
        bestScoreLabel.fontSize = 30
        bestScoreLabel.fontColor = .white
        bestScoreLabel.position = CGPoint(x: 0, y: startButton.size.height / 2 + 20)
        bestScoreLabel.zPosition = 11
        startButton.addChild(bestScoreLabel)
    }
    
    // MARK: - Game Over Label
    func setupGameOverLabel() {
        gameOverLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.fontSize = 50
        gameOverLabel.fontColor = .white
        gameOverLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.7)
        gameOverLabel.zPosition = 12
        addChild(gameOverLabel)
    }
    
    // MARK: - Update Best Score
    func updateBestScore() {
        let bestScore = UserDefaults.standard.integer(forKey: "bestScore")
        bestScoreLabel.text = "Best: \(bestScore)"
    }
    
    // MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let nodes = nodes(at: location)
        for node in nodes {
            if node.name == "start" {
                startGame()
                return
            }
            
            if node.name == "leaderboard" {
                
                return
            }
        }
    }
    
    // MARK: - Actions
    func startGame() {
        let gameScene = GameScene(size: size)
        gameScene.scaleMode = .aspectFill
        view?.presentScene(gameScene, transition: .fade(withDuration: 0.3))
    }
}
