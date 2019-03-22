//
//  GameViewController.swift
//  Game UIKit macOS
//
//  Created by Farini on 3/21/19.
//  Copyright © 2019 Farini. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class GameViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Present the scene
        let skView = self.view as! SKView
        
        let scene = IntroScene(size: skView.bounds.size)
        
        skView.presentScene(scene)
        
        skView.ignoresSiblingOrder = true
        
        skView.showsFPS = true
        skView.showsNodeCount = true
    }

}

