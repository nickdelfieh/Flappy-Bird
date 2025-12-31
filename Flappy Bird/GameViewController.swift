//
//  GameViewController.swift
//  Flappy Bird
//
//  Created by nick delfieh on 31/12/2025.
//

//thanks to chatgpt.com for making the code
import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let skView = self.view as! SKView
        skView.isMultipleTouchEnabled = false
        skView.ignoresSiblingOrder = true

        let scene = MenuScene(size: skView.bounds.size)
        scene.scaleMode = .resizeFill
        scene.isUserInteractionEnabled = true // 🔑 IMPORTANT

        skView.presentScene(scene)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
