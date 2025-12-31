//
//  MenuScene.swift
//  Flappy Bird
//
//  Created by nick delfieh on 31/12/2025.
//

//thanks to chatgpt.com for making the code
import SpriteKit
import GameKit

class MenuScene: SKScene {

    private var startButton: SKSpriteNode!
    private var bestScoreLabel: SKLabelNode!

    override func didMove(to view: SKView) {
        setupBackground()
        setupButtons()
        authenticateGameCenter()
        updateBestScore() // refresh the score whenever MenuScene appears
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
        startButton = SKSpriteNode(imageNamed: "start_button")
        startButton.name = "start"
        startButton.size = CGSize(width: 220, height: 80)
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
                showLeaderboard()
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

    // MARK: - Game Center
    func authenticateGameCenter() {
        GKLocalPlayer.local.authenticateHandler = { vc, error in
            if let vc = vc {
                self.view?.window?.rootViewController?.present(vc, animated: true)
            }
        }
    }

    func showLeaderboard() {
        guard GKLocalPlayer.local.isAuthenticated else { return }

        let vc = GKGameCenterViewController()
        vc.gameCenterDelegate = self
        vc.viewState = .leaderboards
        vc.leaderboardIdentifier = "best_score"
        view?.window?.rootViewController?.present(vc, animated: true)
    }
}

extension MenuScene: GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true)
    }
}
