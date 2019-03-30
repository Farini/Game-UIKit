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
    
    // Background
    var background:SKShapeNode = SKShapeNode()
    var backgroundColor = GameColors.transBlack
    var backgroundStrokeColor = GameColors.silver
    var backgroundStrokeWidth:CGFloat = 1.0
    
    // Knob
    var knob:SKShapeNode = SKShapeNode(circleOfRadius: 32.0)
    var knobTextureIdle = GameTextures.knobStatic
    var knobTexturebusy = GameTextures.knobMoving
    var knobSprite:SKSpriteNode?
    var knobHasSprite:Bool = true
    
    var knobColorIdle:SKColor = GameColors.silver
    var knobColorBusy:SKColor = GameColors.orange
    
    var labelPrefix:String = ""
    var label:SKLabelNode?
//    var rightLabel:SKLabelNode?
//    var leftLabel:SKLabelNode?
    
    // UI State
    /** Return whether user began sliding knob */
    var isKnobSliding:Bool = false
    
    // var touchedKnob:Bool = false
    var delegate:GameSliderDelegate?
    
    // Variables
    var minimum:Double
    var maximum:Double
    var current:Double
    
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
        let knobShape = SKShapeNode(circleOfRadius: 16.0)
        
        if knobHasSprite == true{
            let knobSize = CGSize(square: 32.0)
            let sprite = SKSpriteNode(texture: knobTextureIdle, size: knobSize)
            sprite.name = "Idle"
            self.knobSprite = sprite
            knobShape.fillColor = SKColor.clear
            knobShape.strokeColor = SKColor.clear
            knobShape.lineWidth = 1.0
            knobShape.addChild(sprite)
        }else{
            // To set the knob shape
            knobShape.fillColor = knobColorIdle
            knobShape.strokeColor = knobColorIdle
            knobShape.lineWidth = 1.0
        }
        
        // Label
        if let label = self.label{
            let currentValueString = current.doubleDigitString
            label.text = "\(labelPrefix) \(currentValueString)"
            let labelPosY = label.calculateAccumulatedFrame().height + GameMargins.small + (knobShape.calculateAccumulatedFrame().height / 2.0)
            label.position = CGPoint(x: 0.0, y: labelPosY)
            self.addChild(label)
        }

        let xPos = self.knobCurrentPosition()
        knobShape.position = CGPoint(x: xPos, y: 0.0)
        knobShape.zPosition = 5
        self.knob = knobShape
        
        self.addChild(knobShape)
    }
    
    // MARK: - Initializers
    init(width:CGFloat, min:Double, max:Double, starting:Double?){
        
        self.width = width
        
        // Make sure starting value is between min and max
        if let firstValue = starting{
            if firstValue >= min && firstValue <= max{
                self.current = firstValue
            }else{
                self.current = min
            }
        }else{
            self.current = min
        }
        self.minimum = min
        self.maximum = max
        
        super.init()
        
        self.isUserInteractionEnabled = true
        
        self.render()
    }
    
    init(width:CGFloat, min:Double, max:Double, starting:Double?, text:String){
        
        self.width = width
        
        // Make sure starting value is between min and max
        if let firstValue = starting{
            if firstValue >= min && firstValue <= max{
                self.current = firstValue
            }else{
                self.current = min
            }
        }else{
            self.current = min
        }
        self.minimum = min
        self.maximum = max
        
        // Label
        let centerLabel = GameLabels.headingLabel()
        centerLabel.horizontalAlignmentMode = .center
        centerLabel.text = "Test"
        
        self.labelPrefix = text
        
        self.label = centerLabel
        
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
        guard isKnobSliding == false else {
            isKnobSliding = false
            return
        }
        for touch in touches {
            let location = touch.location(in: self)
            if knob.contains(location){
                isKnobSliding = true
            }
        }
        updateSliderImage()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard isKnobSliding == true else{ return }
        
        for touch in touches{
            
            let location = touch.location(in: self)
            var posX:CGFloat = 0.0
            var posAdjusted:Bool = false
            
            // Check max and min boundaries
            if location.x > width / 2{
                posX = width / 2
                posAdjusted = true
            }
            if location.x < -(width / 2){
                posX = -width / 2
                posAdjusted = true
            }
            // Confirm Location
            if !posAdjusted{
                posX = location.x
            }
            
            knob.position.x = posX
            self.current = currentValueForKnob()
            
            // Label
            if let label = self.label{
                let currentValueString = current.doubleDigitString
                label.text = "\(labelPrefix) \(currentValueString)"
                self.addChild(label)
            }
        }
        
        // Label
        if let label = self.label{
            let currentValueString = current.doubleDigitString
            label.text = "\(labelPrefix) \(currentValueString)"
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard isKnobSliding == true else { return }
        
        for touch in touches{
            let location = touch.location(in: self)
            
            var posX:CGFloat = 0.0
            var posAdjusted:Bool = false
            
            if location.x > width / 2{
                posX = width / 2
                posAdjusted = true
            }
            if location.x < -(width / 2){
                posX = -width / 2
                posAdjusted = true
            }
            
            if !posAdjusted{
                posX = location.x
            }
            
            knob.position.x = posX
            
            self.current = currentValueForKnob().doubleDigitRounded
            
            print("Finished Sliding Value: \(current) - Position: \(knob.position.x) ")
            
            isKnobSliding = false
        }
        
        updateSliderImage()
        
        delegate?.sliderDidChange(sender: self)
    }
    #endif
    
    #if os(OSX)
    override func mouseDown(with event: NSEvent) {
        guard isKnobSliding == false else {
            isKnobSliding = false
            return
        }
        
        let location = event.location(in: self)
        if knob.contains(location){
            // touchedKnob = true
            isKnobSliding = true
        }
        updateSliderImage()
    }
    
    override func mouseDragged(with event: NSEvent) {
        
        guard isKnobSliding == true else{
            return
        }
        
        let location = event.location(in: self)
        var posX:CGFloat = 0.0
        var posAdjusted:Bool = false
        
        // Check max and min boundaries
        if location.x > width / 2{
            posX = width / 2
            posAdjusted = true
        }
        if location.x < -(width / 2){
            posX = -width / 2
            posAdjusted = true
        }
        // Confirm Location
        if !posAdjusted{
            posX = location.x
        }
        
        knob.position.x = posX
        
        let valueTranslator = self.currentValueForKnob()
        self.current = valueTranslator
        
        // Label
        if let label = self.label{
            let currentValueString = current.doubleDigitString
            label.text = "\(labelPrefix) \(currentValueString)"
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        
        guard isKnobSliding == true else {
            return
        }
        
        let location = event.location(in: self)
        var posX:CGFloat = 0.0
        var posAdjusted:Bool = false
        
        // Check max and min boundaries
        if location.x > width / 2{
            posX = width / 2
            posAdjusted = true
        }
        if location.x < -(width / 2){
            posX = -width / 2
            posAdjusted = true
        }
        // Confirm Location
        if !posAdjusted{
            posX = location.x
        }
        
        knob.position.x = posX
        
        self.current = currentValueForKnob().doubleDigitRounded
        
        print("Finished Sliding Value: \(current) - Position: \(knob.position.x) ")
            
        isKnobSliding = false
        updateSliderImage()
        
        delegate?.sliderDidChange(sender: self)
    }
    #endif
    
    // Calculations
    func updateSliderImage(){
        
        switch isKnobSliding {
        case true:
            if knobHasSprite{
                if knobSprite?.name == "Idle"{
                    knobSprite!.texture = knobTexturebusy
                    knobSprite!.name = "Busy"
                }
            }else{
                knob.fillColor = knobColorIdle
                knob.strokeColor = knobColorBusy
            }
        case false:
            if knobHasSprite{
                if knobSprite?.name == "Busy"{
                    knobSprite!.texture = knobTextureIdle
                    knobSprite!.name = "Idle"
                }
            }else{
                knob.fillColor = knobColorIdle
                knob.strokeColor = knobColorBusy
            }
        }
        
        // Label
        if let label = self.label{
            let currentValueString = current.doubleDigitString
            label.text = "\(labelPrefix) \(currentValueString)"
        }
    }
    
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

