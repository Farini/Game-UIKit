//  ContentScene.swift
//  Game UIKit: Created by Carlos Farini on 3/7/19.
//  Copyright © 2019 Farini. All rights reserved.

import SpriteKit

class ContentScene: SKScene {
    
    static let margins:CGFloat = GameMargins.regular
    
    // Navigation Bar
    var title:String                // The title of the scene
    var titleLabel:SKLabelNode      // The title Label
    var topBar:SKSpriteNode         // The top bar where the Title label + buttons go
    var backButton:GameButton       // The button to go back to previous scene
    var previousScene:SKScene?      // The scene to load when tap the back button
    
    /** The main empty node that controls the content of the scene */
    var contentPlaceholder:SKNode
    
    // Positions
    var leftPositionX:CGFloat       // A shortcut to find left position of placeholder to add nodes
    var middleX:CGFloat { return 0.0 }  // The middle X position to add nodes to placeholder
    var viewWidth:CGFloat
    
    var posY:CGFloat                // The y position of the last node inserted
    var viewHeight:CGFloat          // The Size of the view (not the contents) in height
    
    // MARK: - Methods
    
    /** Adds the node to the left, and recalculates position Y */
    func addLeftContent(node:SKNode){
        var posX = self.leftPositionX
        var tempY = posY
        
        // For a Spritenode, adjust the position when anchor point is in the middle
        if let sprite = node as? SKSpriteNode{
            // X
            if sprite.anchorPoint.x == 0.5{
                let halfSprite = sprite.calculateAccumulatedFrame().width / 2
                posX += halfSprite
            }
            // Y
            if sprite.anchorPoint.y == 0.5{
                let halfHeight = sprite.calculateAccumulatedFrame().height / 2
                tempY -= halfHeight
            }
        }
        
        node.position = CGPoint(x: posX, y: tempY)
        
        contentPlaceholder.addChild(node)
        posY -= node.calculateAccumulatedFrame().height + GameMargins.regular
    }
    
    /** Adds the node to the center X, and recalculates position Y */
    func addMiddleContent(node:SKNode){
        var tempY = posY
        
        if let sprite = node as? SKSpriteNode{
            let halfHeight = sprite.calculateAccumulatedFrame().height / 2
            tempY -= halfHeight
        }
        
        node.position = CGPoint(x: 0.0, y: tempY)
        contentPlaceholder.addChild(node)
        posY -= node.calculateAccumulatedFrame().height + GameMargins.regular
    }
    
    /** Adds a node with position previously set. */
    func addPositionedContent(node:SKNode){
        contentPlaceholder.addChild(node)
    }
    
    /** If scene needs scrolling, returns how high can contentPlaceholder go, otherwise Zero */
    func setupScrollerAsNeeded(){
        print("Checking Scrolling Size")
        
        let visibleContent = viewHeight - topBar.calculateAccumulatedFrame().height
        let contentHeight = contentPlaceholder.calculateAccumulatedFrame().height
        
        if contentHeight > visibleContent{
            
            print("Will Add Scroller")
            
            let scrollerWidth:CGFloat = min(32.0, 0.05 * self.viewWidth)
            let scrollerHeight:CGFloat = visibleContent
            
            let coverHeight = (scrollerHeight / contentHeight) * scrollerHeight
            
            let scrollerSize = CGSize(width: scrollerWidth, height: scrollerHeight)
            
            let scroller = GameScroller(size: scrollerSize, coverHeight: coverHeight, gameScene: self)
            self.addChild(scroller)
            
        }
    }
    
    // MARK: - Initializers
    init(view:SKView, title:String){
        
        self.title = title
        
        // Previous Scene
        // As another class is calling this initializer, they will have a view, which will have a scene we can go back to
        if let oldScene = view.scene{
            self.previousScene = oldScene
        }
        
        // Positions
        let width = view.bounds.width
        self.viewWidth = width
        let halfWidth = width / 2
        self.leftPositionX = -halfWidth + GameMargins.regular
        self.posY = -GameMargins.regular
        self.viewHeight = view.bounds.size.height
        
        // Top Bar
        let topPosY = view.bounds.size.height / 2
        
        // Title Label
        let titleLabel:SKLabelNode = SKLabelNode(fontNamed: GameFontNames.arial)
        titleLabel.fontSize = 45.0
        titleLabel.horizontalAlignmentMode = .center
        titleLabel.verticalAlignmentMode = .top
        titleLabel.fontColor = SKColor.blue
        titleLabel.text = title
        titleLabel.position = CGPoint(x: 0.0, y: -GameMargins.regular)
        titleLabel.zPosition = 100
        self.titleLabel = titleLabel
        
        // Nav Bar
        let titleExpandedFrame = titleLabel.calculateFrameWithMargins(height: 8.0, width: 20.0)
        let navBarSize = CGSize(width: view.bounds.size.width, height: titleExpandedFrame.height)
        
        let topColor = SKColor(displayP3Red: 0.05, green: 0.05, blue: 0.1, alpha: 1.0)
        let undColor = SKColor(displayP3Red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        
        let navBarTexture = SKTexture(size: navBarSize, startColor: undColor, endColor: topColor, direction: .up)
        
        let navBarSprite = SKSpriteNode(color: SKColor.darkGray, size: navBarSize)
        navBarSprite.texture = navBarTexture
        
        navBarSprite.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        let navBarPositionY = topPosY
        navBarSprite.position = CGPoint(x: 0.0, y: navBarPositionY)
        navBarSprite.zPosition = 99
        navBarSprite.addChild(titleLabel)
        
        // Top Middle Content Placeholder
        let topMidPos = CGPoint(x: 0.0, y: topPosY - navBarSize.height)
        self.contentPlaceholder = SKNode()
        self.contentPlaceholder.position = topMidPos
        
        // Back Button
        let button = GameButton(titled: "Back") {
            
        }
        // Disable the button if there is no previous scene
        if view.scene == nil{
            button.buttonState = .disabled
        }
        let buttonSize = button.calculateAccumulatedFrame().size
        let buttonPosX = (-halfWidth + GameMargins.regular) + (buttonSize.width / 2.0)
        let buttonPosY = -(navBarSprite.calculateAccumulatedFrame().height / 2)
        self.backButton = button
        self.backButton.position = CGPoint(x: buttonPosX, y: buttonPosY)
        
        // Finish Top Bar setup
        navBarSprite.addChild(button)
        
        self.topBar = navBarSprite
        
        // Init
        super.init(size: view.bounds.size)
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        // Adding Children
        addChild(topBar)                // Top bar has titleLabel and back button as children
        addChild(contentPlaceholder)
        
        self.backButton.buttonAction = {
            print("Dismissing")
            self.view?.presentScene(self.previousScene)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class GameScroller:SKNode{
    
    var scrollBar:SKSpriteNode
    var scrollButton:SKShapeNode
    
    var buttonPosY:CGFloat{
        return scrollButton.position.y
    }
    
    var buttonMaxY:CGFloat
    var buttonMinY:CGFloat
    
    var scrollingScene:ContentScene
    
    #if os(iOS)
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches{
            
            let positionY = touch.location(in: self).y
            // var isTouchingButton:Bool = false
            
            let buttonSpace = scrollButton.convert(touch.location(in: self), from: self)
            if scrollButton.contains(buttonSpace){
                // isTouchingButton = true
                let previousY = scrollButton.position.y
                
                if positionY < buttonMaxY && positionY > buttonMinY{
                    scrollButton.position.y = positionY
                    
                    // Space from top
                    let delta = previousY - positionY
                    scrollingScene.contentPlaceholder.position.y += delta
                }
            }
            
            // let ppy = Double(positionY).doubleDigitRounded
            // let pmaxY = Double(buttonMaxY).doubleDigitRounded
            // let pminY = Double(buttonMinY).doubleDigitRounded
            
            // print("\(isTouchingButton): \(ppy) | \(pmaxY) | \(pminY)")
            
        }
        
    }
    #endif
    
    init(size:CGSize, coverHeight:CGFloat, gameScene:ContentScene){
        
        // Scroll Bar
        let background = SKSpriteNode(color: GameColors.transBlack, size: CGSize(width: size.width, height: size.height))
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = 99
        background.position = CGPoint(x: 0.0, y: 0.0)
        self.scrollBar = background
        
        // Height
        let maximumY = (size.height / 2) - (coverHeight / 2)
        let minimumY = -(size.height / 2) + (coverHeight / 2)
        
        self.buttonMaxY = maximumY
        self.buttonMinY = minimumY
        
        // Scroll Button
        let shapeRadius = size.width / 2
        let bShape = SKShapeNode(rectOf: CGSize(width: size.width, height: coverHeight), cornerRadius: shapeRadius)
        bShape.fillColor = GameColors.silver
        
        let buttonY:CGFloat = maximumY
        bShape.position = CGPoint(x: 0.0, y:buttonY)
        bShape.zPosition = 100
        self.scrollButton = bShape
        
        // Scene
        self.scrollingScene = gameScene
        
        super.init()
        
        let posX = (gameScene.viewWidth / 2) - (size.width / 2)
        let posY:CGFloat = 0.0 - (gameScene.topBar.calculateAccumulatedFrame().height / 2)
        
        self.position = CGPoint(x: posX, y: posY)
        
        self.addChild(scrollBar)
        self.addChild(scrollButton)
        
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


