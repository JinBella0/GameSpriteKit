//
//  GameViewController.swift
//  Game1
//
//  Created by 이진경 on 10/14/24.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // GameScene을 코드로 직접 로드
            let scene = GameScene(size: view.bounds.size)
            // 화면에 맞게 자동으로 크기를 조정
            scene.scaleMode = .resizeFill
            
            // 장면을 표시
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
