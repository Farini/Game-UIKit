//  GameConstants.swift
//  Game UIKit: Created by Farini on 3/21/19.
//  Copyright © 2019 Farini. All rights reserved.

import SpriteKit

// MARK: - Colors and Textures

public struct GameColors{
    static let iron =       SKColor(named: "ColorIron")!
    static let silver =     SKColor(named: "ColorSilver")!
    static let orange =     SKColor.orange
    static let background = SKColor(named: "ColorBackground")!
    static let transBlack = SKColor.black.withAlphaComponent(0.75)
}

public struct GameTextures{
    
    static let closeIcon =      SKTexture(imageNamed: "CloseIcon")
    
    static let homeIcon =       SKTexture(imageNamed: "HomeIcon")
    
    static let timeBoost =      SKTexture(imageNamed: "TimeBoostIcon")
    static let infoIcon =       SKTexture(imageNamed: "InfoIcon")
    static let shopIcon =       SKTexture(imageNamed: "ShopIcon3")
    static let warningIcon =    SKTexture(imageNamed: "Warning")
    static let refreshIcon =    SKTexture(imageNamed: "RefreshIcon")
    static let tradeIcon =      SKTexture(imageNamed: "TradeIcon")
    static let diceaseIcon =    SKTexture(imageNamed: "Dicease")
    static let factoryIcon =    SKTexture(imageNamed: "FactoryIcon")
    static let quarantineIcon = SKTexture(imageNamed: "Quarantine")
    
    static let addIcon =    SKTexture(imageNamed: "AddIcon")
    static let removeIcon = SKTexture(imageNamed: "DeleteIcon")
    static let starEmpty =  SKTexture(imageNamed: "StarEmptyIcon")
    static let starFull =   SKTexture(imageNamed: "StarFullIcon")
    
    static let vehicleIcon = SKTexture(imageNamed: "VehicleIcon")
    
    static let cryptokey =  SKTexture(imageNamed: "Cryptokey")
    static let crystal =    SKTexture(imageNamed: "Crystal")
    static let energy =     SKTexture(imageNamed: "Energy")
    static let food =       SKTexture(imageNamed: "Food")
    static let fuel =       SKTexture(imageNamed: "Fuel")
    static let materials =  SKTexture(imageNamed: "Materials")
    static let sknLogo =    SKTexture(imageNamed: "SkyNation Logo")
    static let staff =      SKTexture(imageNamed: "Staff")
    static let techTree =   SKTexture(imageNamed: "TechTree")
    static let token =      SKTexture(imageNamed: "Token")
    static let robot =      SKTexture(imageNamed: "Head")
    static let circuit =    SKTexture(imageNamed: "CircuitComponent")
    
}

// MARK: - Shaders

public struct GameShaders{
    
    static func cautionStripes(colored:SKColor?) -> SKShader{
        
        var shaderName:String = "CautionStripes.fsh"
        
        if let color = colored{
            let uniform1 = SKUniform(name: "u_stripe_color", color: color)
            let uniform2 = SKUniform(name: "u_empty_color", color: SKColor.clear)
            shaderName = "CautionStripesColored.fsh"
            
            let shader = SKShader(fileNamed: shaderName)
            shader.uniforms = [uniform1, uniform2]
            return shader
        }else{
            let cautionStripes = SKShader(fileNamed: "CautionStripes.fsh")
            return cautionStripes
        }
    }
    
    static func hexagonShader() -> SKShader{
        let shaderName = "HexagonShader.fsh"
        let shader = SKShader(fileNamed: shaderName)
        return shader
    }
    
    static func interlacedShader(height:CGFloat) -> SKShader{
        // Uniform: u_width, the width of the interlacing lines. Ranges of 1 to 4 work best; try starting with 1.
        // Uniform: u_color, the SKColor to use for interlacing lines. Try starting with black.
        // Uniform: u_strength, how much to blend interlaced lines with u_color. Specify 0 (not at all) up to 1 (fully).
        let horizontalUniform = SKUniform(name: "u_width", float: Float(height))
        let colorUniform = SKUniform(name: "u_color", color: SKColor.black)
        let strenghUniform = SKUniform(name: "u_strength", float: 0.5)
        let shader = SKShader(fileNamed: "InterlaceShader.fsh")
        shader.uniforms = [horizontalUniform, colorUniform, strenghUniform]
        return shader
    }
    
    static func findAllShaders() -> [SKShader]{
        let stripes = GameShaders.cautionStripes(colored: nil)
        let hexagon = GameShaders.hexagonShader()
        return [stripes, hexagon]
    }
}

// MARK: - Text

public struct GameFontNames{
    
    // Import Fonts, if you'd like to use them
    // Every Font must be added to info.plist for iOS Games
    // To get the Font name, show font path on finder - right click - get info - under "Full name"
    
    static let arial:String = "Arial"
    static let inconsolata:String = "Inconsolata Regular"
    static let inconsolataBold:String = "Inconsolata Bold"
    static let cantarell:String = "Cantarell Regular"
    static let squarish:String = "Squarish Sans CT"
    static let ocra:String = "OCR A"
    static let dosis:String = "Dosis Medium"
    
}

public struct GameLabels{
    
    /** Creates a Top-Left-aligned small label colored silver */
    static func smallTextLabel() -> SKLabelNode{
        let fontName = GameFontNames.inconsolata
        let theLabel = SKLabelNode(fontNamed: fontName)
        theLabel.fontSize = 14.0
        theLabel.fontColor = GameColors.silver
        theLabel.horizontalAlignmentMode = .left
        theLabel.verticalAlignmentMode = .top
        return theLabel
    }
    
    /** Creates a Top-Left-aligned heading label colored silver */
    static func headingLabel() -> SKLabelNode{
        let fontName = GameFontNames.inconsolataBold
        let theLabel = SKLabelNode(fontNamed: fontName)
        theLabel.fontSize = 20.0
        theLabel.fontColor = GameColors.silver
        theLabel.horizontalAlignmentMode = .left
        theLabel.verticalAlignmentMode = .top
        return theLabel
    }
    
    static func tableHeaderLabel() -> SKLabelNode{
        let fontName = GameFontNames.inconsolata
        let theLabel = SKLabelNode(fontNamed: fontName)
        theLabel.fontSize = 26.0
        theLabel.fontColor = GameColors.silver
        theLabel.horizontalAlignmentMode = .center
        theLabel.verticalAlignmentMode = .top
        return theLabel
    }
}

// MARK: - Other
public struct GameMargins{
    
    /** Default margin */
    static let regular:CGFloat = 4.0
    static let small:CGFloat = 2.0
    static let big:CGFloat = 6.0
}

/** Most used Anchor Points in SpriteKit */
public struct AnchorPoints{
    
    static let topLeft:CGPoint = CGPoint(x: 0.0, y: 1.0)
    static let lowLeft:CGPoint = CGPoint(x: 0.0, y: 0.0)
    
    static let middle:CGPoint = CGPoint(x: 0.5, y: 0.5)
    
    static let topRight:CGPoint = CGPoint(x: 1.0, y: 1.0)
    static let lowRight:CGPoint = CGPoint(x: 1.0, y: 0.0)
    
}

/** Add notifications names here for better access */
extension NSNotification.Name{
    // Sounds
    static let playBackgroundSound = "PlayBackgroundSound"
    static let stopBackgroundSound = "StopBackgroundSound"
}
