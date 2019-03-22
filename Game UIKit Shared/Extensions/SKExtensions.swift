//  SKExtensions.swift
//  Game UIKit: Created by Farini on 3/21/19.
//  Copyright © 2019 Farini. All rights reserved.

import SpriteKit

extension SKUniform {
    
    /** Uniform that uses color, as argument */
    public convenience init(name: String, color: SKColor) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        let colors = vector_float4([Float(r), Float(g), Float(b), Float(a)])
        
        self.init(name: name, vectorFloat4: colors)
    }
    
    /** Uniform that uses CGSize as argument */
    public convenience init(name: String, size: CGSize) {
        let size = vector_float2(Float(size.width), Float(size.height))
        self.init(name: name, vectorFloat2: size)
    }
    
    /** Uniform that uses CGPoint as argument */
    public convenience init(name: String, point: CGPoint) {
        let point = vector_float2(Float(point.x), Float(point.y))
        self.init(name: name, vectorFloat2: point)
    }
}

extension SKTexture {
    
    enum GradientDirection {
        case up
        case left
        case upLeft
        case upRight
    }
    
    /** Creates a Texture with a gradient */
    convenience init(size: CGSize, startColor: SKColor, endColor: SKColor, direction: GradientDirection = .up) {
        let context = CIContext(options: nil)
        let filter = CIFilter(name: "CILinearGradient")!
        let startVector: CIVector
        let endVector: CIVector
        
        filter.setDefaults()
        
        switch direction {
        case .up:
            startVector = CIVector(x: size.width/2, y: 0)
            endVector   = CIVector(x: size.width/2, y: size.height)
        case .left:
            startVector = CIVector(x: size.width, y: size.height/2)
            endVector   = CIVector(x: 0, y: size.height/2)
        case .upLeft:
            startVector = CIVector(x: size.width, y: 0)
            endVector   = CIVector(x: 0, y: size.height)
        case .upRight:
            startVector = CIVector(x: 0, y: 0)
            endVector   = CIVector(x: size.width, y: size.height)
        }
        
        filter.setValue(startVector, forKey: "inputPoint0")
        filter.setValue(endVector, forKey: "inputPoint1")
        filter.setValue(CIColor(color: startColor), forKey: "inputColor0")
        filter.setValue(CIColor(color: endColor), forKey: "inputColor1")
        
        let image = context.createCGImage(filter.outputImage!, from: CGRect(origin: .zero, size: size))
        
        self.init(cgImage: image!)
    }
}

extension SKNode{
    
    /** Calculates Accumulated frame of Node and adds margins defined */
    func calculateFrameWithMargins(height:CGFloat, width:CGFloat) -> CGRect{
        
        let oldFrame = self.calculateAccumulatedFrame()
        
        let originX = oldFrame.origin.x - width
        let originY = oldFrame.origin.y - height
        
        let newWidth = oldFrame.size.width + (2 * width)
        let newHeight = oldFrame.size.height + (2 * height)
        
        return CGRect(x: originX, y: originY, width: newWidth, height: newHeight)
    }
    
    /** Creates several SKLabelNodes (lines) and add to (this) node */
    func createMultilineLabel(message:String, maxWidth:CGFloat, fontSize:CGFloat, aligned:SKLabelHorizontalAlignmentMode){
        
        let mainLabel = SKLabelNode(fontNamed: GameFontNames.inconsolata)
        mainLabel.fontSize = fontSize
        mainLabel.horizontalAlignmentMode = aligned
        mainLabel.verticalAlignmentMode = .top
        mainLabel.color = SKColor.lightGray
        
        let tArray = message.components(separatedBy: " ")
        
        var lastFittingLabel:SKLabelNode = mainLabel.copy() as! SKLabelNode
        lastFittingLabel.text = ""
        
        var builtLabels:[SKLabelNode] = []
        var lblPosY:CGFloat = 0.0
        
        print("word array")
        
        for windex in 0...tArray.count - 1{
            
            let word = tArray[windex]
            
            let trialLabel:SKLabelNode = lastFittingLabel.copy() as! SKLabelNode
            
            if let previousText = trialLabel.text{
                if previousText == "" {
                    trialLabel.text = word
                }else{
                    trialLabel.text!.append(" \(word)")
                }
            }else{
                trialLabel.text = word
            }
            
            let labelWidth = trialLabel.calculateAccumulatedFrame().width
            
            if labelWidth > maxWidth{
                
                // does not fit. Add the last one to the array
                lastFittingLabel.position = CGPoint(x: 0.0, y: lblPosY)
                builtLabels.append(lastFittingLabel.copy() as! SKLabelNode)
                
                // Update height of next Label
                let heightChange = lastFittingLabel.calculateAccumulatedFrame().height + 2.0
                lblPosY -= heightChange
                
                // as this word doesn't fit, we need to add it to the next label
                lastFittingLabel.text = word
                
            }else{
                // does fit. update
                lastFittingLabel = (trialLabel.copy() as! SKLabelNode)
            }
            // Add the last one
            if windex == tArray.count - 1{
                lastFittingLabel.position = CGPoint(x: 0.0, y: lblPosY)
                builtLabels.append(lastFittingLabel)
            }
            
        }
        
        for label in builtLabels{
            self.addChild(label)
        }
    }
    
    /** Removes all children */
    func clearAllChildren(){
        // Clear the children
        if self.children.count > 0{
            for child in children{
                child.removeFromParent()
            }
        }
    }
    
    /** Removes self from parent */
    func clearFromParent(){
        if let _ = self.parent{
            self.removeFromParent()
        }
    }
    
    /** Returns the Vector Direction from this node to the node passed */
    func vectorDirection(to node:SKNode) -> CGVector {
        
        guard let thisScene = self.scene else{
            return CGVector.zero
        }
        
        var nodePosition = node.position
        if node.parent != nil && node.parent != thisScene{
            nodePosition = thisScene.convert(node.position, from: node.parent!)
        }
        
        let convertedPosition = self.convert(nodePosition, to: self)
        
        let theVector:CGVector = CGVector(dx: convertedPosition.x, dy: convertedPosition.y)
        
        let vecAngle = atan2(theVector.dy, theVector.dx)
        
        print("Angle: \(vecAngle)")
        
        return theVector
    }
    
    /** Returns the Angle of this node in relation to the node passed */
    func angle(to node:SKNode) -> CGFloat{
        
        guard let thisScene = self.scene else{
            return 0.0
        }
        
        var nodePosition = node.position
        if node.parent != nil && node.parent != thisScene{
            nodePosition = thisScene.convert(node.position, from: node.parent!)
        }
        
        let convertedPosition = self.convert(nodePosition, to: self)
        
        let theVector:CGVector = CGVector(dx: convertedPosition.x, dy: convertedPosition.y)
        
        let vecAngle = atan2(theVector.dy, theVector.dx)
        
        return vecAngle
    }
    
    /** Performs an action after the time specified */
    func runAfter(time:Double, action:SKAction){
        let waiter:SKAction = SKAction.wait(forDuration: time)
        let runner:SKAction = action
        let sequel:SKAction = SKAction.sequence([waiter, runner])
        self.run(sequel)
    }
}

extension SKTileMapNode{
    
    /** Returns the column and row of a given point in the map */
    func tileAxialCoordinatesAt(position:CGPoint) -> (column:Int, row:Int){
        let theRow = self.tileRowIndex(fromPosition: position)
        let theColumn = self.tileColumnIndex(fromPosition: position)
        return (theColumn, theRow)
    }
    
    func tileGroupAt(position:CGPoint) -> SKTileGroup?{
        let theRow = self.tileRowIndex(fromPosition: position)
        let theColumn = self.tileColumnIndex(fromPosition: position)
        let tGroup = self.tileGroup(atColumn: theColumn, row: theRow)
        return tGroup
    }
    
    // HEXAGONAL MAPS
    // Note: The below functions are useful for Hexagonal Maps
    // See link for more info: https://www.redblobgames.com/grids/hexagons/
    
    /** Hexagonal Map Transforms 2D coordinates to 3D */
    func tileCubeCoordinatesAt(position:CGPoint) -> (x:Int, y:Int, z:Int){
        let axialPosition = tileAxialCoordinatesAt(position: position)
        return (x: axialPosition.column, y: axialPosition.row, z: -axialPosition.column - axialPosition.row)
    }
    
}

extension SKLabelNode{
    
    /** Resets the text so it fits the desired width. May cut part of text */
    func remakeText(desiredWidth:CGFloat){
        
        if let wholeText = self.text{
            
            let tArray = Array(wholeText)
            
            let lastFittingLabel:SKLabelNode = self.copy() as! SKLabelNode
            lastFittingLabel.text = ""
            
            for character in tArray{
                
                let trialLabel = lastFittingLabel.copy() as! SKLabelNode
                trialLabel.text!.append(character)
                
                let newLabelWidth = trialLabel.calculateAccumulatedFrame().width
                
                if newLabelWidth > desiredWidth{
                    break
                }else{
                    lastFittingLabel.text = trialLabel.text
                }
            }
            
            self.text = lastFittingLabel.text
        }
    }
    
    
}

extension SKView{
    
    enum ViewSizeNames{
        case V_5K;      // 5K
        case V_4K;      // A View with 4K
        case V_2K;      // A View with 2K
        case V_1K;      // A View with 1K
        case V_800PX;   // A View with 800 pixels
        case V_600PX;   // A View with 600 pixels
        case tiny;      // A Small view
    }
    
    var viewSizeName:ViewSizeNames{
        get{
            
            let width =  self.bounds.width
            let height = self.bounds.height
            let larger = max(width, height)
            
            switch larger {
            case 100...599:     return ViewSizeNames.tiny
            case 599..<800:     return ViewSizeNames.V_600PX
            case 800..<1000:    return ViewSizeNames.V_800PX
            case 1000..<2000:   return ViewSizeNames.V_1K
            case 2000..<3000:   return ViewSizeNames.V_2K
            case 3000..<4000:   return ViewSizeNames.V_4K
            case 4000..<6000:   return ViewSizeNames.V_5K
                
            default:
                print("Check View Size. This isn't a normal number")
                return ViewSizeNames.tiny
            }
        }
    }
    
}

