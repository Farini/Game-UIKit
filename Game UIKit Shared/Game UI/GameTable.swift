//  GameTable.swift
//  Game UIKit: Created by Farini on 3/21/19.
//  Copyright © 2019 Farini. All rights reserved.

import SpriteKit

protocol GameTableDelegate{
    func didSelect(cell:SKNTableCell, at row:Int, sender:GameTable)
}

class GameTable:SKNode{
    
    public enum GameTableSelectionMode{
        case SelectOne;
        case SelectMany;
        case NoSelection;
        case ButtonAction;
    }
    var selectionMode:GameTableSelectionMode?
    
    var tableAnchor:SKNode
    var background:SKSpriteNode
    var cropNode:SKCropNode
    var head:SKSpriteNode
    
    var titleNode:SKLabelNode?
    var titleString:String?{
        didSet{
            self.titleNode?.text = titleString
        }
    }
    
    var backgroundColor:SKColor = SKColor.black.withAlphaComponent(0.75)
    var titleColor:SKColor = SKColor.lightGray
    
    var cells:[SKNTableCell] = []
    var lastSelectedCell:SKNTableCell?
    
    var isTouching:Bool = false
    // var isMoving:Bool = false
    // var touchedNode:SKNode?
    var touchDelta:CGFloat = 0
    
    var delegate:GameTableDelegate?
    
    // MARK: - Table Update
    func updateTable(with cells:[SKNTableCell], clear:Bool){
        // Clear
        if clear{
            for cell in tableAnchor.children{
                if cell is SKNTableCell{
                    cell.removeFromParent()
                }
            }
            self.cells = []
        }
        
        // Calculate next point (height)
        var accumHeight:CGFloat = 0.0
        let spacing:CGFloat = 1.0
        
        // Calculate X: Cell are usually created from the left-alignment
        let pointX = -(self.head.calculateAccumulatedFrame().size.width / 2)
        
        for cell in tableAnchor.children{
            let cellHeight:CGFloat = cell.calculateAccumulatedFrame().size.height
            accumHeight += cellHeight + spacing
        }
        
        var nextPoint:CGPoint = CGPoint(x: pointX, y: -accumHeight)
        
        // Inser New Cells
        for newCell in cells{
            newCell.position = nextPoint
            tableAnchor.addChild(newCell)
            self.cells.append(newCell)
            
            let newCellHeight:CGFloat = newCell.calculateAccumulatedFrame().size.height
            let nextHeight = nextPoint.y - newCellHeight
            nextPoint = CGPoint(x: nextPoint.x, y: nextHeight)
        }
    }
    
    // MARK: - Control
    #if os(iOS) || os(tvOS)
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !isTouching{
            
            for touch in touches{
                
                if !self.background.contains(touch.location(in:self)){
                    return
                }
                
                let anchorLocation = touch.location(in: tableAnchor)
                
                touchDelta = anchorLocation.y
                
                var touchedCell:SKNTableCell?
                for cell in cells{
                    if cell.contains(anchorLocation){
                        touchedCell = cell
                    }
                }
                self.lastSelectedCell = touchedCell
                
                self.isTouching = true
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches{
            
            let newHeight = touch.location(in: tableAnchor).y
            let oldHeight = touchDelta
            
            touchDelta = newHeight
            
            let heightChange = oldHeight - newHeight
            // Should we insert a minimal height change to deselect cell?
            
            let anchorY = tableAnchor.position.y
            
            let contentHeight = tableAnchor.calculateAccumulatedFrame().size.height
            
            let tblHeight = background.calculateAccumulatedFrame().size.height
            
            let heightLimit = contentHeight - tblHeight
            
            if tableAnchor.position.y < 0 && heightChange > 0{
                return
            }
            
            if heightChange < 0 && (anchorY > heightLimit){
                return
            }
            
            if heightChange != 0{
                tableAnchor.position.y -= heightChange
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches{
            
            if isTouching{
                
                if !self.background.contains(touch.location(in:self)){
                    return
                }
                
                let locationInAnchor = touch.location(in: self.tableAnchor)
                
                for cidx in 0...cells.count - 1{
                    let thisCell = cells[cidx]
                    if thisCell.contains(locationInAnchor){//(touchLocation){
                        let represented = String.init(describing: thisCell.representedObject)
                        print("Touch End Cell: \(represented)")
                        // touchedCell = thisCell
                        if thisCell == self.lastSelectedCell{
                            print("Matched Previously selected. call delegate")
                            // Did select
                            self.delegate?.didSelect(cell: thisCell, at: cidx, sender: self)
                        }
                    }
                }
                
                isTouching = false
            }
        }
    }
    
    #endif
    
    // New Init method
    // What do we want from Init?
    // Size ?
    // Delegate Method?
    // Datasource Method?
    // head:SKSpriteNode was mandatory. Will be deprecated
    
    init(size:CGSize){
        
        // Background Rectangle
        let rectangle = SKSpriteNode(color: SKColor.black.withAlphaComponent(0.75), size: size)
        rectangle.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        rectangle.position = CGPoint.zero
        self.background = rectangle
        
        // Header -> Deprecating
        let theNewHead = SKSpriteNode()
        self.head = theNewHead
        
        // Contour frame
        let contour = SKShapeNode(rectOf: size)
        contour.strokeColor = GameColors.silver
        contour.fillColor = SKColor.clear
        contour.lineWidth = 0.5
        let contourPosition = CGPoint(x: 0.0, y: -(size.height / 2.0))
        contour.position = contourPosition
        
        // Anchor
        let anchor:SKNode = SKNode()
        anchor.position = CGPoint.zero
        self.tableAnchor = anchor
        
        // Crop Node
        let cropper = SKCropNode()
        let copyOfRectangle = rectangle.copy() as! SKSpriteNode
        copyOfRectangle.position.y = 0
        cropper.maskNode = copyOfRectangle
        cropper.position = CGPoint.zero
        
        self.cropNode = cropper
        
        super.init()
        
        addChild(background)
        // addChild(head)
        addChild(cropNode)
        addChild(contour)
        
        // Adjust the position of table anchor
        cropNode.addChild(tableAnchor)
        
        self.isUserInteractionEnabled = true
    }
    
    
    
    
    // We are deprecating old initializers
    
    // MARK - Initializers
    /** Initializes a table with a HeadSize, total height and Title */
    init(with headSize:CGSize, height:CGFloat, entitled:String?) {
        
        if let theTitle = entitled{
            self.titleString = theTitle
        }
        
        // Head
        let headColor = GameColors.iron
        let head:SKSpriteNode = SKSpriteNode(color: headColor, size: headSize)
        head.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        self.head = head
        
        // Body
        let bodyPoint:CGPoint = CGPoint(x: 0.0, y: -headSize.height)
        let bodySize:CGSize = CGSize(width: headSize.width, height: height - headSize.height)
        
        // Background Rectangle
        let rectangle = SKSpriteNode(color: SKColor.black.withAlphaComponent(0.75), size: bodySize)
        rectangle.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        rectangle.position = bodyPoint
        self.background = rectangle
        
        // Contour
        let tableSize = CGSize(width: headSize.width, height: height)
        let contour = SKShapeNode(rectOf: tableSize)
        contour.strokeColor = GameColors.silver
        contour.fillColor = SKColor.clear
        contour.lineWidth = 0.5
        let contourPosition = CGPoint(x: 0.0, y: -(tableSize.height / 2))
        contour.position = contourPosition
        
        // Anchor
        let anchor:SKNode = SKNode()
        anchor.position = CGPoint.zero
        self.tableAnchor = anchor
        
        // Crop Node
        let cropper = SKCropNode()
        let copyOfRectangle = rectangle.copy() as! SKSpriteNode
        copyOfRectangle.position.y = 0
        cropper.maskNode = copyOfRectangle
        cropper.position = bodyPoint
        
        self.cropNode = cropper
        
        super.init()
        
        addChild(background)
        addChild(head)
        addChild(cropNode)
        addChild(contour)
        
        // Adjust the position of table anchor
        cropNode.addChild(tableAnchor)
        
        self.isUserInteractionEnabled = true
    }
    
    init(title:String, size:CGSize){
        
        let totalWidth = size.width
        let totalHeight = size.height
        let margin:CGFloat = 4.0
        
        self.titleString = title
        
        // Title Label
        let titleLabel:SKLabelNode = SKLabelNode(fontNamed: "Arial")
        titleLabel.fontSize = 18.0
        titleLabel.fontColor = GameColors.silver
        titleLabel.horizontalAlignmentMode = .center
        titleLabel.verticalAlignmentMode = .top
        titleLabel.text = title
        titleLabel.position = CGPoint(x: 0.0, y: -margin)
        titleLabel.zPosition = 2
        let titleHeight = titleLabel.calculateAccumulatedFrame().size.height
        
        // Head
        let headerSize:CGSize = CGSize(width: totalWidth, height: (titleHeight + (2.0 * margin)))
        let headColor = GameColors.iron
        let head:SKSpriteNode = SKSpriteNode(color: headColor, size: headerSize)
        head.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        head.position = CGPoint.zero
        head.zPosition = 1
        self.head = head
        
        // Body
        let bodyPoint:CGPoint = CGPoint(x: 0.0, y: -headerSize.height)
        let bodySize:CGSize = CGSize(width: totalWidth, height: totalHeight - headerSize.height)
        
        // Background Rectangle
        let rectangle = SKSpriteNode(color: SKColor.black.withAlphaComponent(0.75), size: bodySize)
        rectangle.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        rectangle.position = bodyPoint
        rectangle.zPosition = 0
        self.background = rectangle
        
        // Contour
        let contour = SKShapeNode(rectOf: bodySize)
        contour.strokeColor = GameColors.silver
        contour.fillColor = SKColor.clear
        contour.lineWidth = 0.5
        contour.zPosition = 3
        let contourY = -(bodySize.height / 2) - headerSize.height
        let contourPosition = CGPoint(x: 0.0, y: contourY)
        contour.position = contourPosition
        
        // Anchor
        let anchor:SKNode = SKNode()
        anchor.position = CGPoint.zero
        self.tableAnchor = anchor
        
        // Crop Node
        let cropper = SKCropNode()
        let copyOfRectangle = rectangle.copy() as! SKSpriteNode
        copyOfRectangle.position = CGPoint.zero
        cropper.maskNode = copyOfRectangle
        cropper.position = bodyPoint
        cropper.zPosition = 2
        
        self.cropNode = cropper
        
        super.init()
        
        addChild(background)
        addChild(titleLabel)
        addChild(head)
        addChild(cropNode)
        addChild(contour)
        
        // Adjust the position of table anchor
        cropNode.addChild(tableAnchor)
        
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
