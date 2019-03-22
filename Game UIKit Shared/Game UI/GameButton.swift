//  GameButton.swift
//  Game UIKit: Created by Farini on 3/21/19.
//  Copyright © 2019 Farini. All rights reserved.

import SpriteKit

/** A Button you can init with a title */
class GameButton:SKNode{
    
    // State/Color      Text            Gradient        Back            Stroke      Shader
    // Enabled          Semi-bright     ---             Transblack      Silver      Hexagon
    // Pressed          Bright          ---             (MID)           Bright      Hexagon
    // Disabled         Iron            ---             Transblack      Iron        Hexagon
    
    // Title Label (Top Layer)
    var title:String
    var label:SKLabelNode = SKLabelNode()
    var labelFontName:String = GameFontNames.arial
    var labelFontSize:CGFloat = 22.0
    
    var labelColor:SKColor = GameColors.silver
    var labelColorPressed:SKColor = SKColor.white
    var labelColorDisabled:SKColor = GameColors.iron
    
    var widthMargin:CGFloat = 14.0
    var heightMargin:CGFloat = 6.0
    
    // Shape
    var shouldRoundCorner:Bool = true
    var shouldRenderShader:Bool = true
    
    // Foreground Layer (Under title) - Gradient (Semi-Transparent), and Stroke
    var topShape:SKShapeNode = SKShapeNode()
    let topShapeColor:SKColor = SKColor.white   // Needs a color to blend.
    var topStrokeWidth:CGFloat = 2.0
    var topStrokeColor:SKColor = GameColors.silver              // Enabled State
    var topStrokeColorPressing:SKColor = GameColors.orange
    var topStrokeColorDisabled:SKColor = GameColors.transBlack
    
    // Background Layer
    var bottomShape:SKShapeNode = SKShapeNode()         // Has the Shader
    var bottomColor:SKColor = GameColors.transBlack     // Needs a color to blend
    var bottomColorPressing:SKColor = GameColors.transBlack
    var bottomColorDisabled:SKColor = GameColors.iron
    var bottomShader:SKShader?
    
    // Others
    enum ButtonState{
        case enabled; case pressed; case disabled;
    }
    var buttonState:ButtonState = ButtonState.enabled
    var buttonAction: () -> ()
    var representedObject:Any?
    
    // MARK: - Initializers
    init(titled:String, buttonAction:@escaping ()-> ()) {
        
        self.title = titled
        self.label = SKLabelNode(text: titled)
        self.buttonAction = buttonAction
        
        super.init()
        
        isUserInteractionEnabled = true
        
        update()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    /** Redraws The Button Node */
    func update(){
        
        self.clearAllChildren() // Extension to clear all children from nodes.
        
        let theLabel = SKLabelNode(text: self.title)
        theLabel.fontName = labelFontName
        theLabel.fontSize = labelFontSize
        theLabel.horizontalAlignmentMode = .center
        theLabel.verticalAlignmentMode = .center
        theLabel.zPosition = 3
        theLabel.fontColor = self.labelColor
        
        self.label = theLabel
        
        // Update margins
        // let labelSize:CGSize = theLabel.calculateAccumulatedFrame().size
        let buttonSize:CGSize = theLabel.calculateFrameWithMargins(height: heightMargin, width: widthMargin).size
        
        // Shape
        let corner:CGFloat = shouldRoundCorner ? 0.0:(buttonSize.height / 4.0)
        let sampleShape:SKShapeNode = SKShapeNode(rectOf: buttonSize, cornerRadius: corner)
        
        // Foreground Layer (Under title)
        let foregroundShape:SKShapeNode = sampleShape.copy() as! SKShapeNode
        // gradient
        let topColor = SKColor(displayP3Red: 0.05, green: 0.05, blue: 0.1, alpha: 0.75)
        let lowColor = SKColor(displayP3Red: 0.2, green: 0.2, blue: 0.2, alpha: 0.75)
        let gradientTexture = SKTexture(size: buttonSize, startColor: topColor, endColor: lowColor, direction: .up)
        // shape
        foregroundShape.fillColor = SKColor.white
        foregroundShape.fillTexture = gradientTexture
        foregroundShape.strokeColor = topStrokeColor
        foregroundShape.lineWidth = topStrokeWidth
        foregroundShape.zPosition = 2
        self.topShape = foregroundShape
        
        // Background Layer
        let backgroundShape:SKShapeNode = sampleShape.copy() as! SKShapeNode
        backgroundShape.fillColor = bottomColor // Needs a color to blend
        if shouldRenderShader == true{
            if bottomShader == nil{
                backgroundShape.fillShader = GameShaders.hexagonShader()
            }else{
                backgroundShape.fillShader = bottomShader!
            }
        }
        backgroundShape.zPosition = 1
        self.bottomShape = backgroundShape
        
        self.addChild(backgroundShape)
        self.addChild(foregroundShape)
        self.addChild(theLabel)
        
        if self.buttonState == .disabled{
            self.updateState(newState: .disabled)
        }
        
    }
    
    /** Updates The Button State*/
    func updateState(newState:ButtonState){
        
        if newState == .disabled{
            // Draw Disabled State
            print("Disabling Button")
            self.buttonState = .disabled
            self.label.fontColor = labelColorDisabled
            self.topShape.strokeColor = topStrokeColorDisabled
            self.bottomShape.fillColor = bottomColorDisabled
            return
        }
        
        if self.buttonState == .disabled{
            
            if newState == .enabled{
                print("Enabling Button")
                self.buttonState = newState
                self.update()
                return
            }
            
            if newState == .pressed{
                print("Button is Disabled. Won't run action.")
                return
            }
        }
        
        // Was Enabled and pressed
        if self.buttonState == .enabled && newState == .pressed{
            
            // Draw Pressed State
            self.label.fontColor = labelColorPressed
            self.topShape.strokeColor = topStrokeColorPressing
            self.bottomShape.fillColor = bottomColorPressing
            
            // Performing
            let waiter = SKAction.wait(forDuration: 0.15)
            let runner = SKAction.run {
                self.buttonAction()
                self.update()
            }
            
            let sequence = SKAction.sequence([waiter, runner])
            self.run(sequence)
        }
    }
    
    // MARK: - Control
    func pushedButton(){
        self.updateState(newState: .pressed)
    }
    
    // MARK: - iOS Touch
    #if os(iOS) || os(tvOS)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if topShape.contains(location){
                self.pushedButton()
            }
        }
    }
    #endif
    
    // MARK: - Mac Click
    #if os(OSX)
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        if topShape.contains(location){
            self.pushedButton()
        }
    }
    #endif
    
}

/** A Button you can Init with an Image */
class SKNImageButton:SKNode{
    
    // Required
    var roundCornerSize:CGFloat = 0.0
    
    var baseColor:SKColor = GameColors.transBlack
    var baseSprite:SKSpriteNode                // The very bottom
    var baseMargin:CGFloat = 1.0
    
    var texturedBackground:SKSpriteNode        // Background - Top of base
    var texturedBackgroundColor:SKColor = GameColors.iron
    var textureMargin:CGFloat = 1.0
    
    var rim:SKShapeNode?                        // The rim (line) over textured background
    var rimSize:CGFloat = 1.0
    var rimColorUnselect:SKColor = SKColor.clear
    
    var rimColorSelected:SKColor = SKColor.orange
    var rimColorFocus:SKColor = SKColor.orange
    // var rimShader:SKShader?
    
    var title:String?
    var label:SKLabelNode?
    var labelFontName:String = "Arial"
    var labelFontSize:CGFloat = 22.0
    var labelWidthMargin:CGFloat = 3.0
    
    var labelColor:SKColor = GameColors.silver
    var labelDisabledColor:SKColor = GameColors.iron
    
    // Optional
    
    var action: () -> ()
    
    var startedTouching:Bool = false
    var focusShape:SKShapeNode?
    
    init(texture:SKTexture, size:CGSize, buttonAction:@escaping () -> ()){
        
        // base
        let background = SKSpriteNode(color: GameColors.transBlack, size: size)
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.baseSprite = background
        
        // rim
        let rimSize = CGSize(width: size.width - 1, height: size.height - 1)
        let shapeNode = SKShapeNode(rectOf: rimSize)
        shapeNode.lineWidth = 1.0
        self.rimColorUnselect = GameColors.iron
        shapeNode.strokeColor = rimColorUnselect
        self.rim = shapeNode
        
        background.addChild(shapeNode)
        
        // texture
        // This will be the size of the actual image
        let smallerSize:CGSize = CGSize(width: size.width - 2, height: size.height - 2)
        let buttonTexture = SKSpriteNode(texture: texture, size: smallerSize)
        self.texturedBackground = buttonTexture
        background.addChild(buttonTexture)
        
        self.action = buttonAction
        
        super.init()
        
        addChild(background)
        
        self.isUserInteractionEnabled = true
    }
    
    init(image:String?, labelText:String?, size:CGSize?, buttonAction:@escaping ()-> ()){
        
        var imageSprite:SKSpriteNode?
        if let bImage = image{
            imageSprite = SKSpriteNode(texture: SKTexture(imageNamed: bImage))
        }else{
            if let someSize = size{
                imageSprite = SKSpriteNode(color: GameColors.iron, size: someSize)
            }
        }
        
        guard let imgSprite = imageSprite else{
            fatalError("can create button")
        }
        
        self.texturedBackground = imgSprite
        let textSize = imgSprite.calculateFrameWithMargins(height: 4.0, width: 4.0).size
        let back = SKSpriteNode(color: GameColors.background, size: textSize)
        baseSprite = back
        
        if let someText = labelText{
            self.title = someText
            
            let theLabel = SKLabelNode(text: someText)
            theLabel.fontName = labelFontName
            theLabel.fontSize = labelFontSize
            theLabel.horizontalAlignmentMode = .center
            theLabel.verticalAlignmentMode = .center
            theLabel.zPosition = 2
            
            self.label = theLabel
        }
        
        self.action = buttonAction
        
        super.init()
        
        addChild(baseSprite)
        addChild(texturedBackground)
        // addChild(rim)
        
        self.isUserInteractionEnabled = true
    }
    
    // MARK: - Initializers
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func focus(){
        if let rim = self.rim{
            rim.strokeColor = self.rimColorSelected
            rim.glowWidth = self.rimSize + 3.0
        }
        #if os(iOS)
        let waiter = SKAction.wait(forDuration: 0.3)
        let runner = SKAction.run {
            self.unfocus()
        }
        self.run(SKAction.sequence([waiter, runner]))
        #endif
    }
    
    func unfocus(){
        if let rim = self.rim{
            rim.strokeColor = self.rimColorUnselect
            rim.glowWidth = 0.0
        }
    }
    
    // MARK: - Touch
    #if os(iOS) || os(tvOS)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if baseSprite.contains(location) {
                self.tapAction()
            }
        }
    }
    
    func tapAction(){
        if self.startedTouching == false{
            startedTouching = true
            self.focus()
            
            // Wait
            let waiter = SKAction.wait(forDuration: 0.1)
            let runner = SKAction.run {
                self.action()
                self.startedTouching = false
            }
            
            let buttonAction = SKAction.sequence([waiter, runner])
            self.run(buttonAction)
        }
    }
    #endif
}
