//
//  GameOver.swift
//  spaceWars
//
//  Created by Shayona Basu on 7/7/16.
//  Copyright (c) 2016 Shayona Basu. All rights reserved.
//

import SpriteKit
import Foundation




class MainMenuScene: SKScene, SKPhysicsContactDelegate {

    let floatingCandy = SKSpriteNode(imageNamed: "playerShip")

    override func didMove(to view: SKView) {
        
        let skView = self.view as SKView!
        
        /* Show debug */
        skView?.showsPhysics = false
        skView?.showsDrawCount = false
        skView?.showsFPS = false
        
         let background = SKSpriteNode(imageNamed: "background")
         background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.setScale(4)
         background.zPosition = 1
         self.addChild(background)
        
        //gameName1
        let gameName1 = SKLabelNode(fontNamed: "WakeUpBro" )
        gameName1.text = "Canderoids"
        gameName1.fontSize = 200
        gameName1.fontColor = SKColor.white
        gameName1.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.75)
        gameName1.zPosition = 1
        self.addChild(gameName1)
        
        //play button
        let playButton = SKSpriteNode(imageNamed: "playButton")
        playButton.setScale(0.5)
        playButton.name = "Play"
        playButton.position = CGPoint(x: self.size.width/2, y: self.size.height*0.35)
        playButton.zPosition = 200
        self.addChild(playButton)
        
      //  start game
        let startGame = SKLabelNode(fontNamed: "LongShot")
        startGame.text = "Start Game"
        startGame.fontSize = 140
        startGame.fontColor = SKColor.white
        startGame.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.2)
        startGame.zPosition = 1
        startGame.name = "startButton"
        self.addChild(startGame)
        
        //animation candy
        floatingCandy.setScale(1.2)
        floatingCandy.position = CGPoint(x: self.size.width/2, y: self.size.height*0.65)
        floatingCandy.zPosition = 200
        floatingCandy.alpha = 0
        self.addChild(floatingCandy)
        
        let fadeIn = SKAction.fadeIn(withDuration: 0.1)
        let goDown = SKAction.moveTo(y: self.size.height*0.66, duration: 1)
        let goUp = SKAction.moveTo(y: self.size.height*0.50, duration: 1.2)
        let float = SKAction.sequence([goDown, goUp])
        let floating = SKAction.repeatForever(float)
        let animate = SKAction.sequence([fadeIn, floating])
        floatingCandy.run(animate)
        
   
        
        //help
        let helpButton = SKSpriteNode(imageNamed: "helpButton")
  //      helpButton.size = CGSizeMake(150, 150)
        helpButton.size = CGSize(width: 150,height: 150)
        helpButton.position = CGPoint(x: self.size.width*0.8, y: self.size.height/7)
        helpButton.zPosition = 200
        helpButton.name = "helpButton"
        self.addChild(helpButton)
        
        //about (credits scene)
        let aboutButton = SKSpriteNode(imageNamed: "about")
 //       aboutButton.size = CGSizeMake(150, 150)
        aboutButton.size = CGSize(width: 150,height: 150)
        aboutButton.position = CGPoint(x: self.size.width*0.2, y: self.size.height/7)
        aboutButton.zPosition = 2
        aboutButton.name = "About"
        self.addChild(aboutButton)
    }

    
    func changeScene() {
        
        //carying accross the same size
        let sceneToMoveTo = MenuScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.doorsOpenVertical(withDuration: 0.4)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }

  
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch:AnyObject in touches {
            
   //         let pointOfTouch = touch.location(self)
            let pointOfTouch = touch.location(in: self)
            let nodeItapped = atPoint(pointOfTouch)
            if nodeItapped.name == "Play" {
                
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.crossFade(withDuration: 0.4)
                self.view!.presentScene(sceneToMoveTo, transition : myTransition)
                
            }
            
           if nodeItapped.name == "startButton" {
                
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.crossFade(withDuration: 0.4)
                self.view!.presentScene(sceneToMoveTo, transition : myTransition)
                
            }
            
            if nodeItapped.name == "helpButton" {
                
                changeScene()
                
            }
            
            if nodeItapped.name == "About" {
                
                
                let sceneToMoveTo = AboutScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.doorsOpenVertical(withDuration: 0.4)
                self.view!.presentScene(sceneToMoveTo, transition : myTransition)
                
                
            }
           
                
                
                
            }
            
        
    }
    
    
}
