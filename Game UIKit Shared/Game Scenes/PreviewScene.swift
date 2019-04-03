//
//  PreviewScene.swift
//  Game UIKit
//
//  Created by Farini on 3/21/19.
//  Copyright © 2019 Farini. All rights reserved.
//

import SpriteKit

class PreviewScene: ContentScene, GameSliderDelegate {
   
    override func didMove(to view: SKView) {
        
        let contents = self.contentPlaceholder.children
        let disappear = SKAction.moveBy(x: view.bounds.width, y: 0.0, duration: 0.6)
        let fade = SKAction.fadeOut(withDuration: 0.6)
        let group = SKAction.group([disappear, fade])
        for child in contents{
            child.run(group, completion: child.removeFromParent)
        }
        
        // A Texture
        let texture = SKTexture(imageNamed: "profile")
        let sprite = SKSpriteNode(texture: texture, size: CGSize(width: 128, height: 128))
        sprite.anchorPoint = AnchorPoints.middle
        
        addMiddleContent(node: sprite)
        
        // A Multiline Label
        let widthUsed = 0.6 * self.viewWidth
        let fontSize:CGFloat = 14.0
        let textNode = SKNode()
        textNode.createMultilineLabel(message: "The goals of the Open Font License (OFL) are to stimulate worldwide development of collaborative font projects, to support the font creation efforts of academic and linguistic communities, and to provide a free and open framework in which fonts may be shared and improved in partnership with others.", maxWidth: widthUsed, fontSize: fontSize, aligned: .center)
        self.addMiddleContent(node: textNode)
        
        // Button
        let button = GameButton(titled: "Game Button") {
            // print("Put button code in here :)")
            let newScene = TablesScene(view: view, title: "Tables")
            self.view!.presentScene(newScene)
        }
        addMiddleContent(node: button)
        
        // Slider
        let slider = GameSlider(width: widthUsed, min: 1.0, max: 100.0, starting: 90.0, text: "Slider Value")
        slider.delegate = self
        addMiddleContent(node: slider)
    }
    
    func sliderDidChange(sender: GameSlider) {
        print("Slider Value Changed: \(sender.current)")
    }
    
    override init(view:SKView, title:String){
        super.init(view: view, title: "Preview")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
