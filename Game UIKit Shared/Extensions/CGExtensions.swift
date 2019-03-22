//  CGExtensions.swift
//  Game UIKit: Created by Farini on 3/21/19.
//  Copyright © 2019 Farini. All rights reserved.

import CoreGraphics

extension CGSize{
    
    /** Makes a Square Size*/
    init(square side:CGFloat){
        self.init(width: side, height: side)
    }
}

extension CGPoint{
    static func topMiddle() -> CGPoint{
        return CGPoint(x:0.5, y:1.0)
    }
}
