//
//  GameOver.swift
//  spaceWars
//
//  Created by Shayona Basu on 7/7/16.
//  Copyright (c) 2016 Shayona Basu. All rights reserved.
//


import SpriteKit
import Foundation


class GameOverScene: SKScene {
    
    let restartLabel = SKLabelNode(fontNamed: defaultFont)
    let backToMenu = SKLabelNode(fontNamed: defaultFont)

    
    override func didMoveToView(view: SKView) {
        
        let skView = self.view as SKView!
        
        /* Show debug */
        skView.showsPhysics = false
        skView.showsDrawCount = false
        skView.showsFPS = false
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        background.setScale(4)
        self.addChild(background)
    
        let gameOverLabel = SKLabelNode(fontNamed: defaultFont)
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 200
        gameOverLabel.fontColor = SKColor.whiteColor()
        gameOverLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)
        
        //score label
        let scoreLabel = SKLabelNode(fontNamed: defaultFont)
        scoreLabel.text = "Score: \(gameScore)"
        scoreLabel.fontSize = 125
        scoreLabel.fontColor = SKColor.whiteColor()
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.55)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        //setting up highscore
        let defaults = NSUserDefaults()
        var highScoreNumber = defaults.integerForKey("highScoreSaved")
        
        if gameScore > highScoreNumber {
            highScoreNumber = gameScore
            defaults.setInteger(highScoreNumber, forKey: "highScoreSaved")
        }
        
        //highscore
        let highScoreLabel = SKLabelNode(fontNamed: defaultFont)
        highScoreLabel.text = "High Score: \(highScoreNumber)"
        highScoreLabel.fontSize = 125
        highScoreLabel.fontColor = SKColor.whiteColor()
        highScoreLabel.zPosition = 1
        highScoreLabel.position = CGPoint(x:self.size.width/2, y: self.size.height*0.45)
        self.addChild(highScoreLabel)
        
        //try again label
        restartLabel.text = "Try Again"
        restartLabel.fontSize = 150
        restartLabel.fontColor = SKColor.whiteColor()
        restartLabel.zPosition = 1
        restartLabel.position = CGPoint(x:self.size.width/2, y: self.size.height*0.3)
        self.addChild(restartLabel)
        
        backToMenu.text = "Back to Menu"
        backToMenu.fontSize = 150
        backToMenu.fontColor = SKColor.whiteColor()
        backToMenu.zPosition = 1
        backToMenu.position = CGPoint(x:self.size.width/2, y: self.size.height*0.2)
        self.addChild(backToMenu)

    }

    
    
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch: AnyObject in touches {
            
            let pointOfTouch = touch.locationInNode(self)
            
            if restartLabel.containsPoint(pointOfTouch) {
                let sceneToMoveTo = GameScene(size:self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fadeWithColor(SKColor.blackColor(), duration: 0.2)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
            
            if backToMenu.containsPoint(pointOfTouch) {
                let sceneToMoveTo = MainMenuScene(size:self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fadeWithColor(SKColor.blackColor(), duration: 0.2)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
            
        }
        
        

    
    
    
        
    }
    
    
    
    
    
    
    
    
    
}