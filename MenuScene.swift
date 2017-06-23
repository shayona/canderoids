//
//  MenuScene.swift
//  Canderoids
//
//  Created by Shayona Basu on 11/8/16.
//  Copyright © 2016 Shayona Basu. All rights reserved.
//

import Foundation
import SpriteKit

class MenuScene: SKScene {

    
    override func didMoveToView(view: SKView) {
        
        let skView = self.view as SKView!
        
        /* Show debug */
        skView.showsPhysics = false
        skView.showsDrawCount = false
        skView.showsFPS = false
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.setScale(4)
        background.zPosition = 1
        self.addChild(background)
        
        
        let menu = SKSpriteNode(imageNamed: "menu")
        menu.setScale(2.2)
        menu.alpha = 1
        menu.position = CGPoint(x: self.size.width/2, y: self.size.height/1.8)
        menu.zPosition = 50
        menu.name = "Menu"
        self.addChild(menu)
        
        
        let backButton = SKSpriteNode(imageNamed: "backarrow")
        backButton.size = CGSizeMake(150, 150)
        backButton.position = CGPoint(x: self.size.width*0.8, y: self.size.height/7)
        backButton.zPosition = 20
        backButton.name = "Back"
        self.addChild(backButton)

        
        
    }
    
    
 
    
    
   
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch:AnyObject in touches {
            
            let pointOfTouch = touch.locationInNode(self)
            let nodeItapped = nodeAtPoint(pointOfTouch)
            
            if nodeItapped.name == "Back" {
                
                let sceneToMoveTo = MainMenuScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.doorsCloseVerticalWithDuration(0.4)
                self.view!.presentScene(sceneToMoveTo, transition : myTransition)
                
            }

}
}
}


    
    
    
