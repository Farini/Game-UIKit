//  GameTableCell.swift
//  Game UIKit: Created by Farini on 3/21/19.
//  Copyright © 2019 Farini. All rights reserved.

import SpriteKit

class SKNTableCell:SKNode{
    
    var representedObject:Any
    
    init(repObject:Any){
        self.representedObject = repObject
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LabelCell:SKNTableCell{
    
    var labelCell:SKLabelNode?
    var labelColor:SKColor?{
        didSet{
            self.labelCell?.fontColor = labelColor
        }
    }
    
    // Selection Circle
    var selectionCircle:SKShapeNode?
    func setSelected(value:Bool){
        if let _ = self.selectionCircle{
            if value{
                self.selectionCircle!.lineWidth = 3.0
                self.selectionCircle!.strokeColor = GameColors.silver
            }else{
                self.selectionCircle!.lineWidth = 0.5
                self.selectionCircle!.strokeColor = GameColors.iron
            }
        }
    }
    
    // Button
    var button:GameButton?
    //var button:SKNButton?
    
    // MARK: - Initializers
    
    /** Detail is aligned right and it can be a string, or a button */
    convenience init(iconsoText:String, width:CGFloat, detail:Any){
        
        // Main Label
        let mainLabel = SKLabelNode(fontNamed: GameFontNames.inconsolata)
        let fontSize:CGFloat = 26.0
        mainLabel.fontSize = fontSize
        mainLabel.text = iconsoText
        mainLabel.horizontalAlignmentMode = .left
        mainLabel.verticalAlignmentMode = .top
        mainLabel.fontColor = GameColors.silver
        let leftAlign = -(width / 2.0) + GameMargins.regular
        mainLabel.position = CGPoint(x:leftAlign, y:0.0)
        
        // Main Initializers
        self.init(repObject:iconsoText)
        
        self.labelCell = mainLabel
        self.addChild(mainLabel)
        
        // Check what is detail
        
        // String Detail
        if let detailString = detail as? String{
            let detailLabel = SKLabelNode(fontNamed: GameFontNames.inconsolata)
            detailLabel.fontSize = CGFloat(fontSize * 0.8)
            detailLabel.fontColor = SKColor.orange
            detailLabel.text = detailString
            detailLabel.horizontalAlignmentMode = .right
            detailLabel.verticalAlignmentMode = .top
            let posX = width - 2.0
            detailLabel.position = CGPoint(x: posX, y: 0.0)
            self.addChild(detailLabel)
        }
        
        // Button Detail
        if let detailButton = detail as? GameButton{
            let posX = width - (detailButton.calculateAccumulatedFrame().size.width / 2) - 2.0
            let posY = -(self.calculateAccumulatedFrame().size.height / 2)
            detailButton.position = CGPoint(x: posX, y: posY)
            self.button = detailButton
            self.addChild(detailButton)
        }
    }
    
    convenience init(text:String){
        
        let someLabel = SKLabelNode(fontNamed: "Arial")
        someLabel.text = text
        someLabel.fontSize = 28.0
        someLabel.horizontalAlignmentMode = .left
        someLabel.verticalAlignmentMode = .top
        someLabel.fontColor = SKColor.white
        
        self.init(repObject: text)
        
        self.labelCell = someLabel
        
        self.addChild(someLabel)
    }
    
    convenience init(text:String, selectable:Bool, repObject:Any){
        
        let someLabel = SKLabelNode(fontNamed: "Arial")
        someLabel.text = text
        someLabel.fontSize = 28.0
        someLabel.horizontalAlignmentMode = .left
        someLabel.verticalAlignmentMode = .top
        someLabel.fontColor = SKColor.white
        
        var circle:SKShapeNode?
        if selectable{
            let cRadius = someLabel.calculateAccumulatedFrame().size.height / 2
            circle = SKShapeNode(circleOfRadius: cRadius)
            circle!.fillColor = GameColors.iron
            circle!.strokeColor = GameColors.silver
            circle!.lineWidth = 0.5
            // self.selectionCircle = circle
        }
        
        self.init(repObject: repObject)
        
        if let circle = circle{
            self.selectionCircle = circle
        }
        
        self.labelCell = someLabel
        
        self.addChild(someLabel)
    }
    
}

/** Recoding Table Cell */
class TableCell:SKNode{
    
    var representedObject:Any
    var width:CGFloat
    
    var selectedShape:SKShapeNode?
    
    
    // MARK: - Initializer
    init(width:CGFloat, repObj:Any){
        self.representedObject = repObj
        self.width = width
        
        super.init()
    }
    
    func drawSelectionShape(selected:Bool, round:CGFloat?){
        
        let cellHeight = self.calculateAccumulatedFrame().size.height - 2.0
        let cellWidth = self.width - 2.0
        
        var shape:SKShapeNode?
        if let roundedCorner = round{
            shape = SKShapeNode(rectOf: CGSize(width: cellWidth, height: cellHeight), cornerRadius: roundedCorner)
        }else{
            shape = SKShapeNode(rectOf: CGSize(width: cellWidth, height: cellHeight))
        }
        
        shape!.position = CGPoint(x:self.width / 2.0, y:-(cellHeight / 2.0) + 1.0)
        self.selectedShape = shape!
        self.addChild(shape!)
        
        if selected == true{
            self.selectedShape?.strokeColor = GameColors.silver
            self.selectedShape?.lineWidth = 1.0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


