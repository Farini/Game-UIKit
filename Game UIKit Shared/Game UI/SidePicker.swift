//  SidePicker.swift
//  Game UIKit: Created by Farini on 3/21/19.
//  Copyright © 2019 Farini. All rights reserved.

import SpriteKit

/** A Sideways picker Container */
class SidePicker: SKNode {
    
    var size:CGSize                     // The Size if the Entire Picker
    
    var cellSprite:SKSpriteNode         // The content of each Item
    var cellCroper:SKCropNode           // The cropper node (Content is cell sprite)
    
    var itemHandler:SKNode = SKNode()   // An emtpy node to use for items navigation
    var selectedItemIndex:Int = 0       // Index of item currently selected
    
    var selectedObject:Any? {
        return items[selectedItemIndex].representedItem
    }
    
    var items:[SidePickerItem]      // Array with Items for This picker
    let margin:CGFloat = 4.0            // The margin between items
    
    func switchNext(){
        let maxIndex = self.items.count - 1
        let nextItemIndex = selectedItemIndex == maxIndex ? 0:selectedItemIndex + 1
        
        // let nextItem = items[nextItemIndex]
        let currentItem = items[selectedItemIndex]
        
        var move:SKAction = SKAction.move(to: CGPoint.zero, duration: 0.25)
        
        if nextItemIndex != 0{
            let deltaWidth = -(currentItem.calculateAccumulatedFrame().width + self.margin)
            move = SKAction.moveBy(x: deltaWidth, y: 0.0, duration: 0.25)
        }
        
        move.timingMode = .easeOut
        
        self.itemHandler.run(move)
        self.selectedItemIndex = nextItemIndex
    }
    
    // MARK: - Init
    init(size:CGSize, items:[SidePickerItem], title:String?) {
        
        self.size = size
        self.items = items
        
        let totalHeight = size.height
        let totalWidth = size.width
        var cellHeight = totalHeight
        
        // Title
        var titleLabel:SKLabelNode?
        if let title = title{
            titleLabel = GameLabels.tableHeaderLabel()
            titleLabel!.fontSize = 22.0
            titleLabel!.text = title
            let labelHeight = titleLabel!.calculateAccumulatedFrame().height
            cellHeight -= (labelHeight + margin)
        }
        
        // Nav Button
        let switcherButton = GameButton(titled: "Next >", buttonAction: {
            //self.switchNext()
        })
        
        let buttonHeight = switcherButton.calculateAccumulatedFrame().height
        let buttonY = -totalHeight + (buttonHeight / 2)
        let buttonWidth = switcherButton.calculateAccumulatedFrame().width
        let buttonX = totalWidth - (buttonWidth / 2)
        switcherButton.position = CGPoint(x: buttonX, y: buttonY)
        
        cellHeight -= (buttonHeight + margin)
        
        let cellWidth = totalWidth
        let cSprite = SKSpriteNode(color: GameColors.transBlack, size: CGSize(width: cellWidth, height: cellHeight))
        cSprite.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        cSprite.position = CGPoint.zero
        self.cellSprite = cSprite
        
        let cellCrop = SKCropNode()
        cellCrop.maskNode = cSprite
        cellCrop.position = CGPoint.zero
        
        if let label = titleLabel{
            cellCrop.position = CGPoint(x: 0.0, y: -label.calculateAccumulatedFrame().height - margin)
        }
        
        self.cellCroper = cellCrop
        
        super.init()
        
        // Add the children
        self.addChild(cellCroper)
        cellCroper.addChild(itemHandler)
        
        // Add the items
        var posX:CGFloat = 0
        for item in items{
            let itemPosition = CGPoint(x: posX, y: 0.0)
            item.position = itemPosition
            itemHandler.addChild(item)
            item.render(size: CGSize(width: cellWidth, height: cellHeight))
            let itemWidth = item.calculateAccumulatedFrame().width + self.margin
            posX += itemWidth
        }
        
        // Button that switches to another item
        switcherButton.buttonAction = {
            self.switchNext()
        }
        self.addChild(switcherButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/** Side Picker Item */
class SidePickerItem:SKNode{
    
    var representedItem:Any?
    var texture:SKTexture
    var subtitle:String
    let innerMargin:CGFloat = 2.0
    
    init(itemName:String, texture:SKTexture, subtitle:String, item:Any?) {
        
        self.representedItem = item
        self.texture = texture
        self.subtitle = subtitle
        
        super.init()
        self.name = itemName
    }
    
    func render(size:CGSize){
        let subtitleWidth = size.width - 2 * innerMargin
        let subtitleNode = SKNode()
        subtitleNode.createMultilineLabel(message: subtitle, maxWidth: subtitleWidth, fontSize: 10.0, aligned: .center)
        let subtitleHeight = subtitleNode.calculateAccumulatedFrame().height
        let remainingHeight = size.height - subtitleHeight - innerMargin
        
        // Assume its a square
        let smallerSide = min(remainingHeight, size.width)
        let spriteSize = CGSize(square: smallerSide)
        let sprite = SKSpriteNode(texture: texture, size: spriteSize)
        sprite.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        self.addChild(sprite)
        
        let posY = -(sprite.calculateAccumulatedFrame().size.height + innerMargin)
        subtitleNode.position = CGPoint(x: 0.0, y: posY)
        self.addChild(subtitleNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
