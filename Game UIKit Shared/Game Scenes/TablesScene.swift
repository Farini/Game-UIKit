//
//  TablesScene.swift
//  Game UIKit
//
//  Created by Farini on 4/1/19.
//  Copyright © 2019 Farini. All rights reserved.
//

import SpriteKit

class TablesScene: ContentScene, GameTableDelegate{
    
    
    func didSelect(cell: SKNTableCell, at row: Int, sender: GameTable) {
        print("Cell delegate call back")
        let label = GameLabels.tableHeaderLabel()
        label.fontSize = 55.0
        label.text = "CELL \(row)"
        self.addChild(label)
        let grow = SKAction.scale(by: 2.0, duration: 0.6)
        let fade = SKAction.fadeOut(withDuration: 1.2)
        let move = SKAction.moveBy(x: 0, y: -20, duration: 0.6)
        let rotate = SKAction.scaleY(to: -1, duration: 0.6)
        let firstGroup = SKAction.group([grow, move])
        let secondGroup = SKAction.group([fade, rotate])
        let sequel = SKAction.sequence([firstGroup, secondGroup])
        label.run(sequel, completion:{
            self.view?.presentScene(self.previousScene!)
        })
    }
    
    override func didMove(to view: SKView) {
        
        let table1Width = 0.4 * view.bounds.width
        let tableHeight = 0.6 * view.bounds.height
        
        let table = GameTable(size: CGSize(width: table1Width, height: tableHeight))
        table.delegate = self
        
        var cells:[SKNTableCell] = []

        for idx in 0...10{
            let cell = LabelCell(iconsoText: "Test \(idx)", width: table1Width, detail: idx)
            cells.append(cell)
        }
        
        table.updateTable(with: cells, clear: true)
        // table.delegate = self
        
        self.addMiddleContent(node: table)
        
    }
    
    override init(view: SKView, title: String) {
        super.init(view: view, title: title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
