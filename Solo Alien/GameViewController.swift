//
//  GameViewController.swift
//  Solo Alien
//
//  Created by Apple on 23/02/2019.
//  Copyright © 2019 qoboqo. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene(size: CGSize(width: 1536, height: 2048))
            // configure the view
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
        
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
        skView.presentScene(scene)

        
    }

    override var shouldAutorotate: Bool {
        return true
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
