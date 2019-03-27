//  GameSlider.swift
//  Game UIKit: Created by Farini on 3/21/19.
//  Copyright © 2019 Farini. All rights reserved.

import SpriteKit

protocol GameSliderDelegate {
    func sliderDidChange(sender:GameSlider)
}

class GameSlider: SKNode {
    
    // UI
    var width:CGFloat
    var sliderHeight:CGFloat = 15.0
    // static let heightDefault = 15.0
    
    var background:SKShapeNode = SKShapeNode()
    var backgroundColor = GameColors.transBlack
    var backgroundStrokeColor = GameColors.silver
    var backgroundStrokeWidth:CGFloat = 1.0
    
    var knob:SKShapeNode = SKShapeNode(circleOfRadius: 32.0)
    var knobTextureStatic = GameTextures.knobStatic
    var knobTextureMoving = GameTextures.knobMoving
    var knobSprite:SKSpriteNode?
    
    var knobColor:SKColor = GameColors.silver
    
    var centerLabel:SKLabelNode?
    var rightLabel:SKLabelNode?
    var leftLabel:SKLabelNode?
    
    var currentTint:SKColor?
    
    // Variables
    var minimum:Double
    var maximum:Double
    var current:Double
    
    var touchedKnob:Bool = false
    var delegate:GameSliderDelegate?
    
    // MARK: - Methods
    
    /** Renders the Node */
    func render(){
        
        print("Rendering Slider")
        
        // Clear children
        self.clearAllChildren()
        
        // Background
        let backgroundSize = CGSize(width: width, height: sliderHeight)
        let backShape = SKShapeNode(rectOf: backgroundSize, cornerRadius: sliderHeight / 4.0)
        backShape.fillColor = backgroundColor
        backShape.strokeColor = backgroundStrokeColor
        backShape.lineWidth = backgroundStrokeWidth
        backShape.zPosition = 0
        self.background = backShape
        self.addChild(backShape)
        
        // Knob
        let knobShape = SKShapeNode(circleOfRadius: 4.0)
        let knobSize = CGSize(square: 32.0)
        let sprite = SKSpriteNode(texture: knobTextureStatic, size: knobSize)
        knobShape.addChild(sprite)
//        var knobShape = SKShapeNode(circleOfRadius: 16.0)
//        // An image (SpriteNode) can be set as a knob
//        if let knobImage = knobSprite{
//            knobShape = SKShapeNode(circleOfRadius: 4.0)
//            knobImage.zPosition = 5
//            knobShape.addChild(knobImage)
//        }
        // knobShape.fillColor = knobColor
        // knobShape.strokeColor = GameColors.orange
        // knobShape.lineWidth = 1.0
        
        let xPos = self.knobCurrentPosition()
        knobShape.position = CGPoint(x: xPos, y: 0.0)
        knobShape.zPosition = 5
        self.knob = knobShape
        
        self.addChild(knobShape)
        
    }
    
    // MARK: - Initializers
    init(width:CGFloat, min:Double, max:Double, starting:Double?){
        
        self.width = width
        
        if let firstValue = starting{
            self.current = firstValue
        }else{
            self.current = 0.0
        }
        
        self.minimum = min
        self.maximum = max
        
        super.init()
        
        self.isUserInteractionEnabled = true
        
        self.render()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Control
    
    #if os(iOS) || os(tvOS)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if knob.contains(location){
                touchedKnob = true
                // Touched Knob
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if touchedKnob == false { return }
        
        for touch in touches{
            let location = touch.location(in: self)
            
            var posX:CGFloat = 0.0
            var posAdjusted:Bool = false
            
            if location.x > width / 2{
                posX = width / 2
                posAdjusted = true
                //touchedKnob = false
            }
            if location.x < -(width / 2){
                posX = -width / 2
                posAdjusted = true
                //touchedKnob = false
            }
            
            if !posAdjusted{
                posX = location.x
            }
            
            knob.position.x = posX
            
            let valueTranslator = self.currentValueForKnob()
            self.current = valueTranslator
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if touchedKnob == false { return }
        
        for touch in touches{
            let location = touch.location(in: self)
            
            var posX:CGFloat = 0.0
            var posAdjusted:Bool = false
            
            if location.x > width / 2{
                posX = width / 2
                posAdjusted = true
                //touchedKnob = false
            }
            if location.x < -(width / 2){
                posX = -width / 2
                posAdjusted = true
                //touchedKnob = false
            }
            
            if !posAdjusted{
                posX = location.x
            }
            
            knob.position.x = posX
            
            let valueTranslator = self.currentValueForKnob()
            self.current = valueTranslator
            
            print("Finished Setting Knob")
            print("Value: \(current)")
            print("Position: \(knob.position.x)")
            
            touchedKnob = false
        }
        
        delegate?.sliderDidChange(sender: self)
    }
    #endif
    
    #if os(OSX)
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        if knob.contains(location){
            touchedKnob = true
        }
    }
    
    override func mouseDragged(with event: NSEvent) {
        let location = event.location(in: self)
        
        var posX:CGFloat = 0.0
        var posAdjusted:Bool = false
        
        if location.x > width / 2{
            posX = width / 2
            posAdjusted = true
            //touchedKnob = false
        }
        if location.x < -(width / 2){
            posX = -width / 2
            posAdjusted = true
            //touchedKnob = false
        }
        
        if !posAdjusted{
            posX = location.x
        }
        
        knob.position.x = posX
        
        let valueTranslator = self.currentValueForKnob()
        self.current = valueTranslator
    }
    
    override func mouseUp(with event: NSEvent) {
        if touchedKnob == false { return }
        
        let location = event.location(in: self)
            
        var posX:CGFloat = 0.0
        var posAdjusted:Bool = false
            
        if location.x > width / 2{
            posX = width / 2
            posAdjusted = true
            //touchedKnob = false
        }
        if location.x < -(width / 2){
            posX = -width / 2
            posAdjusted = true
            //touchedKnob = false
        }
            
        if !posAdjusted{
            posX = location.x
        }
            
        knob.position.x = posX
            
        let valueTranslator = self.currentValueForKnob()
        self.current = valueTranslator
            
        print("Finished Setting Knob")
        print("Value: \(current)")
        print("Position: \(knob.position.x)")
            
        touchedKnob = false
        
        delegate?.sliderDidChange(sender: self)
    }
    #endif
    
    // Calculations
    
    /** returns the knob in the correct position, given the current value */
    func knobCurrentPosition() -> CGFloat{
        
        let dx_min = current - minimum
        let totalRange = maximum - minimum
        let rangeFraction:Double = dx_min / totalRange
        
        // if x starts at zero, we would have fraction * width
        let distanceFromZero:CGFloat = CGFloat(rangeFraction) * width
        let halfwidth = width / 2.0
        let xPosition = distanceFromZero - halfwidth
        return xPosition
    }
    
    /** returns the current value, given the knob's position */
    func currentValueForKnob() -> Double{
        
        let relativePosX = knob.position.x + (width / 2.0)
        let fracPosX = relativePosX / width
        let amountOverMinimum = Double(fracPosX) * (maximum - minimum)
        
        var realAmount = minimum + amountOverMinimum
        
        if realAmount < minimum { realAmount = minimum }
        if realAmount > maximum { realAmount = maximum }
        
        return realAmount
        
    }
    
}

