//  IntroScene.swift
//  Game UIKit
//  Created by Farini on 3/21/19.
//  Copyright © 2019 Farini. All rights reserved.

import SpriteKit

class IntroScene: SKScene {
    
    
    // MARK: - View Cycle
    override func didMove(to view: SKView) {
        // Setup the scene and UI Components
        print("Did move")
        
        // Clear
        self.clearAllChildren()
        
        let node = SKNode()
        
        let label = SKLabelNode(text: "INTRO LABEL")
        node.addChild(label)
        
        self.addChild(node)
        
        self.animateNodeIntro(node: node)
    }
    
    // Anime
    func animateNodeIntro(node:SKNode){
        
        let expandedFrame = node.calculateFrameWithMargins(height: 0.0, width: 45.0).size
        
        let shape = SKShapeNode(circleOfRadius: expandedFrame.width / 2)
        shape.lineWidth = 15.0
        shape.fillColor = SKColor.clear
        shape.strokeColor = GameColors.orange
        
        let gradientShader = SKShader(fileNamed: "MapShapeGradient.fsh")
        let timeUniform = SKUniform(name: "u_totaltime", float: Float(2.0))
        gradientShader.addUniform(timeUniform)
        
        shape.isPaused = false
        shape.strokeShader = gradientShader
        
        node.addChild(shape)
        
        let nodeHeight = node.calculateAccumulatedFrame().height
        
        // Label Actions
        let waiting = SKAction.wait(forDuration: 1.5)
        let move = SKAction.move(by: CGVector(dx: 0.0, dy: nodeHeight), duration: 0.25)
        let fade = SKAction.fadeOut(withDuration: 0.3)
        let group = SKAction.group([move, fade])
        let sequence = SKAction.sequence([waiting, group, waiting])
        
        // Shape Actions
        let rotate = SKAction.rotate(byAngle: 1.0, duration: 0.5)
        let rotateRepeat = SKAction.repeatForever(rotate)
        
        for child in node.children{
            if child is SKLabelNode{
                child.run(sequence) {
                    self.postAnimation()
                }
            }
            if child is SKShapeNode{
                child.run(rotateRepeat)
            }
        }
        
    }
    
    func postAnimation(){
        print("Post animation")
        let newScene = PreviewScene(view: view!, title: "Preview")
        // let newScene = ContentScene(view: self.view!, title: "Content Scene")
        let openDoors = SKTransition.doorsOpenHorizontal(withDuration: 0.45)
        view?.presentScene(newScene, transition: openDoors)
    }
    
    // MARK: - Initializer
    override init(size: CGSize) {
        
        // If there are any variables required (Not UI) should be started here
        super.init(size: size)
        
        self.anchorPoint = AnchorPoints.middle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
