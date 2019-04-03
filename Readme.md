#  Game UIKit
A series of UI Elements for Game makers made in Swift.

## UI Elements

### Game Button
Game Button was made in a way that you can create the button quickly and add the code that executes when the button is pressed.

```Swift
let button = GameButton(titled: "Game Button") {
    // Button code goes here.
}
```

There are various aspects of the button UI that you can change easily as you would like.

    var labelColor:SKColor = GameColors.silver
    var labelColorPressed:SKColor = SKColor.white
    var labelColorDisabled:SKColor = GameColors.iron
    
```Swift
let button = GameButton(titled: "Game Button") {
    // Button code goes here.
}    
button.labelColor = SKColor.blue // Changes the label color to blue (enabled state)
button.update // Updates the changes made above
```

## GameConstants.swift

As a programmer, it is productive to have some code that can be executed in a few lines, or filenames that are pre-estabilished, so you can visualize them as you are typing.

### GameTextures

This is a struct that stores the textures that you add to your game. Many UI elements are going to be often reused, especially textures. It is easy to load a texture by calling GameTextures.

```Swift
let closeTexture = GameTextures.closeIcon
let closeSprite = SKSpriteNode(texture:closeTexture)
self.addChild(closeSprite)
```

### GameColors

Another struct that stores a very important reusable element. Colors.
On interfaces, a programmer often uses a default color for background, another default color for text, etc. Using GameColors makes that gap easy, even when you forget what color you are using for what element.

```Swift
let menuScene = SKScene(size:CGSize(width:300, height:300))
menuScene.backgroundColor = GameColors.background
```

Under the folder "Artwork", there is a file called "InterfaceAssets.xcassets", where you can add custom colors, and then define them in *GameColors*, and just reuse them with a simple line of code where you see the name of the color.

### GameShaders

Here you can use game shaders without having to worry about what SKUniforms to pass. It still needs som improvements, but you can call those static functions that shows clearly what variables are expected, such as *SKColor*, *Float*, *CGPoint*, *CGSize*, etc. The point is to make coding easy, and this improves the quality of work, while minimizing risks, such as forgetting what *SKUniform* types to pass, and also to visualize what each *SKShader* does.


## Changes

- [X] 3/27/2019: GameSlider use in MacOS: 
- [X] 3/29/2019: Improvements in GameSlier, and added a label.
