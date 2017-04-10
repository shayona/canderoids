//
//  loadingScreen.swift
//  spaceWars
//
//  Created by Shayona Basu on 10/8/16.
//  Copyright © 2016 Shayona Basu. All rights reserved.
//

import Foundation
import SpriteKit




class loadingScreen: SKScene {
    
    
    var spawnTimer: CFTimeInterval = 0
    let fixedDelta: CFTimeInterval = 1.0/60.0 /* 60 FPS*/
    
    override func didMove(to view: SKView) {
        let skView = self.view as SKView!

        
        
        /* Show debug */
        skView?.showsPhysics = false
        skView?.showsDrawCount = false
        skView?.showsFPS = false
        
        //background
        let background = SKSpriteNode(imageNamed: "loadingScreen")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.setScale(4)
        background.zPosition = 1
        self.addChild(background)
        
        //bubble bee productions
        let gameBy = SKLabelNode(fontNamed: "WakeUpBro" )
        gameBy.text = "       Bee Productions       "
        gameBy.fontSize = 140
      //  gameBy.fontColor = UIColor(red: 123, green: 231, blue: 158, alpha: 1.0)
        gameBy.fontColor = UIColor.white
        gameBy.position = CGPoint(x: self.size.width/2, y: self.size.height*0.3)
        gameBy.zPosition = 1
        self.addChild(gameBy)
        
        
        
    }
    
    let cyanColour = UIColor(red: 191/255, green: 1, blue: 191/255, alpha: 1)

    
    
    func changeScene() {
        
        //carying accross the same size
        let sceneToMoveTo = MainMenuScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(with: SKColor.black, duration: 3)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
     
    spawnTimer += fixedDelta
        
    if spawnTimer >= 2.0{
        
        changeScene()
        
        
        
        }
    
        
    }
 
}
