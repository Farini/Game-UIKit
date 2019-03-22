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
        
        let texture = SKTexture(imageNamed: "profile")
        let sprite = SKSpriteNode(texture: texture, size: CGSize(width: 128, height: 128))
        sprite.anchorPoint = AnchorPoints.middle
        
        addMiddleContent(node: sprite)
        
        let widthUsed = 0.6 * self.viewWidth
        let fontSize:CGFloat = 14.0
        
        let textNode = SKNode()
        textNode.createMultilineLabel(message: "The goals of the Open Font License (OFL) are to stimulate worldwide development of collaborative font projects, to support the font creation efforts of academic and linguistic communities, and to provide a free and open framework in which fonts may be shared and improved in partnership with others.", maxWidth: widthUsed, fontSize: fontSize, aligned: .center)
        
        self.addMiddleContent(node: textNode)
        
        let button = GameButton(titled: "Awesome Button") {
            print("Put button code in here :)")
        }
        posY -= button.calculateAccumulatedFrame().height
        addMiddleContent(node: button)
        
        
        let slider = GameSlider(width: widthUsed, min: 1.0, max: 100.0, starting: 99.0)
        slider.delegate = self
        addMiddleContent(node: slider)
        
        
    }
    
    func sliderDidChange(sender: GameSlider) {
        print("Slider Value: \(sender.current)")
        print("Slider uses a delegate that calls back a function.")
    }
    
    override init(view:SKView, title:String){
        super.init(view: view, title: "Preview")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
