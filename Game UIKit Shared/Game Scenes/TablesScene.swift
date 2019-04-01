//
//  TablesScene.swift
//  Game UIKit
//
//  Created by Farini on 4/1/19.
//  Copyright © 2019 Farini. All rights reserved.
//

import SpriteKit

class TablesScene: ContentScene{
    
    override func didMove(to view: SKView) {
        
        let table1Width = 0.4 * view.bounds.width
        let tableHeight = 0.6 * view.bounds.height
        
        let table = GameTable(size: CGSize(width: table1Width, height: tableHeight))
        
        var cells:[SKNTableCell] = []

        for idx in 0...10{
            let cell = LabelCell(iconsoText: "Test \(idx)", width: table1Width, detail: idx)
            cells.append(cell)
        }
        
        table.updateTable(with: cells, clear: true)
        
        self.addMiddleContent(node: table)
        
    }
    
    override init(view: SKView, title: String) {
        super.init(view: view, title: title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
