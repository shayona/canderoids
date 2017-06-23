//
//  GameScene.swift
//  spaceWars
//
//  Created by Shayona Basu on 7/7/16.
//  Copyright (c) 2016 Shayona Basu. All rights reserved.
//

import SpriteKit
import Foundation

var gameScore = 0
let defaultFont = "LongShot"


class GameScene: SKScene, SKPhysicsContactDelegate {

    //LABELS
    var levelNumber = 0
    let scoreLabel = SKLabelNode(fontNamed: defaultFont)
    
    var livesNumber = 5
    let livesLabel = SKLabelNode(fontNamed: defaultFont)
    
    var amountOfBullets = 50
    let bulletsLabel = SKLabelNode(fontNamed: defaultFont )

	let tapToStartLabel = SKLabelNode(fontNamed: defaultFont)
    
    //player connections
    let player = SKSpriteNode(imageNamed: "playerShip")
	
    

    //SFX CONNECTIONS
    let bulletSound = SKAction.playSoundFileNamed("bulletSoundEffect.wav", waitForCompletion: false)
    let explosionSound = SKAction.playSoundFileNamed("texplosion.wav", waitForCompletion: false)
    let whooshSound = SKAction.playSoundFileNamed("whoosh.wav", waitForCompletion: false)
    let regenExplosionSound = SKAction.playSoundFileNamed("regenExplosion.wav", waitForCompletion: false)
    let blopSound = SKAction.playSoundFileNamed("blop.wav", waitForCompletion: false)
	let loseALifeSound = SKAction.playSoundFileNamed("loseALifeSound.wav", waitForCompletion: false)
	let gameOverSound = SKAction.playSoundFileNamed("gameOverSound.wav", waitForCompletion: false)
	
enum gameState {
    
    case preGame // when the game state is before the start of the game'
    case inGame // when the game state is during the game
    case afterGame // when the game state is after the game
    
}
   var currentGameState = gameState.preGame
    
    
    struct PhysicsCategories {
        
        static let None : UInt32 = 0
        static let Player : UInt32 = 0b1 //1 (binary form)
        static let Bullet : UInt32 = 0b10 //2
        static let Enemy : UInt32 = 0b100 //4
        static let Carrot : UInt32 = 0b1000 //8
        static let MunchedCarrot : UInt32 = 0b1001 //9
        static let Tomato : UInt32 = 0b1010 //10
        static let Regen : UInt32 = 0b1100 //12
        static let BulletBox : UInt32 = 0b1110 //14
        
    }
    
    
    
    
    
    //random function
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF) }
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min }
    
    
    
    // makeing game Area compatible with all screens
    let gameArea: CGRect
    
    override init(size: CGSize) {
        
        //making game compatible with every screen possible
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        super.init(size: size)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    
	
    
    override func didMoveToView(view: SKView) {
     
        self.physicsWorld.contactDelegate = self
        
        gameScore = 0 
		
		let skView = self.view as SKView!
		
		/* Show debug */
		skView.showsPhysics = false
		skView.showsDrawCount = false
		skView.showsFPS = false
		
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        //setting player and size
        player.setScale(0.6)
        player.position = CGPoint(x: self.size.width/2, y: 0 - player.size.height)
        player.zPosition = 2
        
        //adding physics
        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy | PhysicsCategories.Regen
        
        self.addChild(player)
        
        //scoreLabel Settings
        scoreLabel.text = "Score: 0 "
        scoreLabel.fontSize = 120
        scoreLabel.fontColor = SKColor.whiteColor()
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        scoreLabel.position = CGPoint(x: self.size.width*0.15 , y: self.size.height + scoreLabel.frame.size.height)
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        //livesLabel Settings
        livesLabel.text = "Lives: 5"
        livesLabel.fontSize = 90
        livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        livesLabel.position = CGPoint(x: self.size.width*0.85, y: self.size.height + livesLabel.frame.size.height)
        livesLabel.zPosition = 100
        self.addChild(livesLabel)
		
		let moveOnToScreenAction = SKAction.moveToY (self.size.height * 0.9, duration: 0.3)
		scoreLabel.runAction(moveOnToScreenAction)
		livesLabel.runAction(moveOnToScreenAction)
		
        //bullets settings
        bulletsLabel.text = "Bullets: 50"
        bulletsLabel.fontSize = 90
        bulletsLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        bulletsLabel.position = CGPoint(x: self.size.width*0.85 , y: self.size.height + bulletsLabel.frame.size.height)
        bulletsLabel.zPosition = 100
        self.addChild(bulletsLabel)
		
		let moveOnToScreenActionBullets = SKAction.moveToY (self.size.height * 0.85, duration: 0.4)
		bulletsLabel.runAction(moveOnToScreenActionBullets)
		
		//pause button
		/*let pauseButton = SKSpriteNode(imageNamed: "pause")
		pauseButton.size = CGSizeMake(150, 150)
		pauseButton.position = CGPoint(x: self.size.width*0.8, y: self.size.height/7)
		pauseButton.zPosition = 20
		pauseButton.name = "Pause"
		self.addChild(pauseButton) */
		

		
		tapToStartLabel.text = "Tap to Begin"
		tapToStartLabel.fontSize = 100
		tapToStartLabel.fontColor = SKColor.whiteColor()
		tapToStartLabel.zPosition = 1
		tapToStartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
		tapToStartLabel.alpha = 0
		self.addChild(tapToStartLabel)
		
		let fadeInAction = SKAction.fadeInWithDuration(0.4)
		tapToStartLabel.runAction(fadeInAction)
		
		


    }
    
    func levelUpText() {
        
        let levelUpLabel = SKLabelNode(fontNamed: defaultFont)
        levelUpLabel.text = "Level Up!"
        levelUpLabel.fontSize = 200
        levelUpLabel.fontColor = SKColor.whiteColor()
        levelUpLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        levelUpLabel.zPosition = 1
		levelUpLabel.alpha = 0
        self.addChild(levelUpLabel)

        //adding animation
        let fadeIn = SKAction.fadeInWithDuration(0.6)
        let fadeOut = SKAction.fadeOutWithDuration(0.6)
        let delete = SKAction.removeFromParent()
        let fadeSequence = SKAction.sequence([fadeIn, fadeOut, delete])
        levelUpLabel.runAction(fadeSequence)

    }
    
    func addALife() {
        
        livesNumber += 1
        livesLabel.text = "Lives : \(livesNumber)"
        
        let scaleUp = SKAction.scaleTo(2, duration: 0.2)
        let scaleDown = SKAction.scaleTo(1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, blopSound ,scaleDown])
        livesLabel.runAction(scaleSequence)
        
    }
	
	func startGame() {
		
		currentGameState = gameState.inGame
		let fadeOutAction = SKAction.fadeOutWithDuration(0.6)
		let deleteAction = SKAction.removeFromParent()
		let deleteSequence = SKAction.sequence([fadeOutAction, deleteAction])
		tapToStartLabel.runAction(deleteSequence)
		
		let moveShipOntoScreenAction = SKAction.moveToY(self.size.height*0.2, duration: 0.5)
		let startLevelAction  = SKAction.runBlock(startNewLevel)
		let startGameSequence = SKAction.sequence([moveShipOntoScreenAction, startLevelAction])
		player.runAction(startGameSequence)
		
		
	}
	
    func loseALife() {
        livesNumber -= 1
        livesLabel.text = "Lives : \(livesNumber)"
        
        
		
        if livesNumber <= 3 {
            
            livesLabel.fontColor = SKColor.redColor()
            let scaleUp1 = SKAction.scaleTo(3, duration: 0.4)
            let scaleDown1 = SKAction.scaleTo(1, duration: 0.3)
            let scaleSequence1 = SKAction.sequence([scaleUp1, scaleDown1])
            livesLabel.runAction(scaleSequence1)
            
        }
		
		if livesNumber >= 3 {
        
        livesLabel.fontColor = SKColor.whiteColor()
        let scaleUp = SKAction.scaleTo(2, duration: 0.2)
        let scaleDown = SKAction.scaleTo(1, duration: 0.2)
        let scaleSequence = SKAction.sequence([ loseALifeSound, scaleUp, scaleDown])
        livesLabel.runAction(scaleSequence)
            
        }
        
        
        if livesNumber == 0 {
            runGameOver()
        }
        //if we loose three lives, done
       
    }
    
 
    
    func loseBullet() {
        amountOfBullets -= 1
    
        bulletsLabel.text = "Bullets: \(amountOfBullets)"
        
        if amountOfBullets >= 11 {
            
            bulletsLabel.fontColor = SKColor.whiteColor()
            let scaleUp = SKAction.scaleTo(1.2, duration: 0.1)
            let scaleDown = SKAction.scaleTo(1.0, duration: 0.2)
            let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
            bulletsLabel.runAction(scaleSequence)
        }
        
        if amountOfBullets <= 10 {
            
            bulletsLabel.fontColor = SKColor.redColor()
            let scaleUp1 = SKAction.scaleTo(1.5, duration: 0.2)
            let scaleDown1 = SKAction.scaleTo(1.0, duration: 0.3)
            let scaleSequence1 = SKAction.sequence([scaleUp1, scaleDown1])
            bulletsLabel.runAction(scaleSequence1)
            
        }
        
        if amountOfBullets == 0 {
            runGameOver()
        }
    }
    
    
    func addScore() {
        
        gameScore += 1
        scoreLabel.text = "Score: \(gameScore)"
        
        //if we reach a certain score then run this code to =start a new level
        if gameScore == 5 || gameScore == 10 || gameScore == 25 || gameScore == 50 || gameScore == 100 {
            startNewLevel()
            levelUpText()
        }
    
    }

    
    func addBullet() {
        
        var bulletsAdded: [Int] = [20, 25, 30, 50]
        let randomAmount = random(min: 0, max: 4)
        if randomAmount <= 1 {
            amountOfBullets += bulletsAdded[0]
        }
        else if randomAmount <= 2 {
            amountOfBullets += bulletsAdded[1]
        }
        else if randomAmount <= 3 {
            amountOfBullets += bulletsAdded[2]
        }
        else if randomAmount <= 4 {
            amountOfBullets += bulletsAdded[3]
        }
        
        
        bulletsLabel.text = "Score: \(amountOfBullets)"
        let scaleUp = SKAction.scaleTo(1.5, duration: 0.1)
        let scaleDown = SKAction.scaleTo(1.0, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, blopSound, scaleDown])
        bulletsLabel.runAction(scaleSequence)

        
    }
    
    func runGameOver() {
        
        currentGameState = gameState.afterGame
        
        self.removeAllActions() //removing enemy spawn
        
        //generate list of all objects currently on screen with this name (bullet)
        self.enumerateChildNodesWithName("Bullet") {
            bullet, stop in
            bullet.removeAllActions()
            
        }
        
        self.enumerateChildNodesWithName("Enemy") {
            enemy, stop in
            enemy.removeAllActions()
        }
        
        self.enumerateChildNodesWithName("Carrot") {
            enemy, stop in
            enemy.removeAllActions()
        }
        
        self.enumerateChildNodesWithName("Regen") {
            regen, stop in
            regen.removeAllActions()
        }
        
        self.enumerateChildNodesWithName("BulletBox" ) {
            bulletBox, stop in
        bulletBox.removeAllActions()
        }
        
        self.enumerateChildNodesWithName("Tomato" ) {
            tomato, stop in
            tomato.removeAllActions()
        }
        
      let changeSceneAction = SKAction.runBlock(changeScene)
        let waitToChangeScene = SKAction.waitForDuration(1)
        let changeSceneSequence = SKAction.sequence([ gameOverSound, waitToChangeScene, changeSceneAction])
        self.runAction(changeSceneSequence)
        
        
        
    }
    
    
    func changeScene() {
        
        //carying accross the same size
        let sceneToMoveTo = GameOverScene(size: self.size)
         sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fadeWithColor(SKColor.blackColor(), duration: 3)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else {
            
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
       if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Enemy {
            // if the player(1) has hit the enemy(4)
            
            if body1.node != nil {
                spawnExplosion(body1.node!.position)
            }
            
            if body2.node != nil {
                spawnExplosion(body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
                    runGameOver()
        }
        
        
        
        if body1.categoryBitMask == PhysicsCategories.Bullet && body2.categoryBitMask == PhysicsCategories.Enemy {
            //if bullet(2) hits enemy(4)
            
            addScore()
            
            if body2.node != nil {
                spawnExplosion(body2.node!.position)
                
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
        }
        
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Tomato {
            // if the player(1) has hit the enemy(4)
            
            if body1.node != nil {
                spawnExplosion(body1.node!.position)
            }
            
            if body2.node != nil {
                spawnExplosion(body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
            runGameOver()
        }
        
        
        if body1.categoryBitMask == PhysicsCategories.Bullet && body2.categoryBitMask == PhysicsCategories.Tomato {
            //if bullet(2) hits enemy(4)
            
            addScore()
            
            if body2.node != nil {
                spawnExplosion(body2.node!.position)
                
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
        }
        
        
        if body1.categoryBitMask == PhysicsCategories.Bullet && body2.categoryBitMask == PhysicsCategories.MunchedCarrot {
            //if bullet(2) hits munched carrot (8)
            addScore()
            
            spawnExplosion(body2.node!.position)
            
            
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
            
        }
        
        if body1.categoryBitMask == PhysicsCategories.Bullet && body2.categoryBitMask == PhysicsCategories.Carrot {
            //if bullet(2) hits carrot (8)
            addScore()
            
            
            let carrotSprite = body2.node as! SKSpriteNode
            carrotSprite.physicsBody!.categoryBitMask = PhysicsCategories.MunchedCarrot
            carrotSprite.texture = SKTexture(imageNamed: "munchedCarrot")
            
            body1.node?.removeFromParent()
            body1.categoryBitMask = 0
            
        }
        
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Carrot {
            // if the player(1) has hit the carrot(4)
            
            spawnExplosion(body1.node!.position)
            
            
            spawnExplosion(body2.node!.position)
            
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
            runGameOver()
        }
        
        
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.MunchedCarrot {
            // if the player(1) has hit the carrot(4)
            
            if body1.node != nil {
                spawnExplosion(body1.node!.position)
            }
            
            if body2.node != nil {
                spawnExplosion(body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
            runGameOver()
        }

        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Regen {
            //if player(2) hits regen(8)
            addALife()
            
            
            if body2.node != nil {
                spawnRegenExplosion(body2.node!.position)
            }
            
            body2.node?.removeFromParent()
            
        }
        
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.BulletBox {
            //if player(2) hits bullet box(10)
            
            addBullet()
            
            if body2.node != nil {
                spawnBoxExplosion(body2.node!.position)
            }
            
            body2.node?.removeFromParent()

            
        }
        
        
    }
    
    
    
    
    
  
    // MARK:  ALL EXPLOSIONS CODE
    
    /* _______________________________INDEX_______________________________
 
        1. SPAWN EXPLOSION 
            - for player x bullet
            - for player x enemy
     
        2.  REGEN EXPLOSION
            - for player x regen
        
        3.  BOX EXPLOSION
            - for player x box
       ___________________________________________________________________
 */
    
    
    func spawnExplosion(spawnPosition: CGPoint) {
        
        
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        
        //adding animation
        let scaleIn = SKAction.scaleTo(3, duration: 0.1)
        let fadeOut = SKAction.fadeOutWithDuration(0.1)
        let delete = SKAction.removeFromParent()
        let explosionSequence = SKAction.sequence([explosionSound, scaleIn, fadeOut, delete])
        explosion.runAction(explosionSequence)
        
    }
    
    func spawnRegenExplosion(spawnPosition: CGPoint) {
        
        let regenExplosion = SKSpriteNode(imageNamed: "regenExplosion")
        regenExplosion.position = spawnPosition
        regenExplosion.zPosition = 3
        regenExplosion.setScale(0)
        self.addChild(regenExplosion)
        
        //adding animation
        let scaleIn = SKAction.scaleTo(3, duration: 0.4)
        let fadeOut = SKAction.fadeOutWithDuration(0.4)
        let delete = SKAction.removeFromParent()
        let explosionSequence = SKAction.sequence([regenExplosionSound, scaleIn, fadeOut, delete])
        regenExplosion.runAction(explosionSequence)
        
    }
    
	func spawnBoxExplosion(position: CGPoint) {
        //adding animation
        
        let box = SKSpriteNode(imageNamed: "bulletBox")
        box.setScale(0.1)
        box.position = position
        box.zPosition = 2
        self.addChild(box)
        
        let smallBox = SKAction.scaleTo(0.05, duration: 0.5)
        let rotateBox = SKAction.rotateByAngle(0.2, duration: 0.1)
        let moveBox = SKAction.moveTo(bulletsLabel.position + CGPointMake(15, 0), duration: 1.5)
        let deleteBox = SKAction.removeFromParent()
        let boxSequence = SKAction.sequence([smallBox, rotateBox, moveBox, deleteBox])
        box.runAction(boxSequence)
        
        
    }

    
    //________________________________END________________________________
    
    
    
    func startNewLevel() {
        
        levelNumber += 1
        
        if self.actionForKey("spawningEnemies") != nil {
            self.removeActionForKey("spawningEnemies")
        }
        
        var levelDuration = NSTimeInterval()
        
        //levels for player
        switch levelNumber {
        case 1: levelDuration = 1.7
        case 2: levelDuration = 1.4
        case 3: levelDuration = 1.1
        case 4: levelDuration = 0.7
        case 5: levelDuration = 0.4
        case 6: levelDuration = 0.2
            
        default:
            levelDuration = 1.0
            print("cannot find level info")
        }
    
        
        //spawning enemies
        let spawn = SKAction.runBlock(spawnEnemy)
        let waitToSpawn = SKAction.waitForDuration(1.5)
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnForever = SKAction.repeatActionForever(spawnSequence)
        self.runAction(spawnForever, withKey: "spawningEnemies" )
        
        //spawning carrot
        let spawnC = SKAction.runBlock(spawnCarrot)
        let waitToSpawnC = SKAction.waitForDuration(18, withRange: 6)
        let spawnSequenceC = SKAction.sequence([waitToSpawnC, spawnC])
        let spawnForeverC = SKAction.repeatActionForever(spawnSequenceC)
        self.runAction(spawnForeverC)
        
        //spawning tomato
        let spawnT = SKAction.runBlock(spawnTomato)
        let waitToSpawnT = SKAction.waitForDuration(30, withRange: 10)
        let spawnSequenceT = SKAction.sequence([waitToSpawnT, spawnT])
        let spawnForeverT = SKAction.repeatActionForever(spawnSequenceT)
        self.runAction(spawnForeverT)
        
        //spawning regen
        let spawnR = SKAction.runBlock(spawnRegen)
        let waitR = SKAction.waitForDuration(30, withRange: 10)
        let spawnRSequence = SKAction.sequence([waitR, spawnR])
        let spawnRForever = SKAction.repeatActionForever(spawnRSequence)
        self.runAction(spawnRForever)
		
		
        
        //spawning bulletBox
        let spawnB = SKAction.runBlock(spawnBulletBox)
        let waitB = SKAction.waitForDuration(20, withRange: 5)
        let spawnBSequence = SKAction.sequence([waitB, spawnB])
        let spawnBForever = SKAction.repeatActionForever(spawnBSequence)
        self.runAction(spawnBForever)
    
        
    }
    
    
    
    
	override func update(currentTime: NSTimeInterval) {
		
		
		
		if amountOfBullets < 10  {
			
			var haveBulletBox = false
			
			for child in self.children {
				
				if child.name == "BulletBox"{
					
					
					haveBulletBox = true
					break
				}
			}
			
			if haveBulletBox == false {
			spawnBulletBox()
			}
		}
	}
	
	
	
	
    // MARK:  ALL SPAWNING CODE
    
    /* _______________________________INDEX_______________________________
     
     1. SPAWN BULLET
     - bullet settings
        - bullet image, size, position
     - bullet physics
     - bullet animation 
        - moving bullet, deleting, loosing amount
     - adding bullet
     
     2.  SPAWN ENEMY
     - enemy settings
         - enemy image, name, position, size
     - enemy physics
     - enemy animation (1)
         - moving enemy, deleting, loosing a life
       - enemy animation (2)
         - rotating enemy
         - pulsing enemy
     - adding screen
     
     3.  SPAWN REGEN
     - settings
        - regen image, size, name, position
     - regen physics
     - regen animation
        - moving regen, deleting
     - regen animation (2)
        - rotating regen, glowing, pulsing
    - adding to screen
     
     4. SPAWN BOX
     - box settings
        - box image, size, name, position
     - box physics
        - moving box, deleting
     - adding to screen
     
      ____________________________________________________________________
     */

    
    
    
    
        func fireBullet() {
        
        currentGameState == gameState.inGame
        
        //bullet settings
        let bullet = SKSpriteNode(imageNamed: "bullet")
		bullet.name = "Bullet" //reference name
        bullet.setScale(0.5)
        bullet.position = player.position
        bullet.zPosition = 1
            
        //adding physics
        bullet.physicsBody = SKPhysicsBody(rectangleOfSize: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = PhysicsCategories.Bullet
        bullet.physicsBody!.collisionBitMask = PhysicsCategories.None
        bullet.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
            
            
        self.addChild(bullet)
        let moveBullet = SKAction.moveToY(self.size.height + bullet.size.height , duration: 0.7)
        let deleteBullet = SKAction.removeFromParent()
        let minusBullet = SKAction.runBlock(loseBullet)
            
            
        let bulletSequence = SKAction.sequence([bulletSound, minusBullet, moveBullet, deleteBullet])
        bullet.runAction(bulletSequence)
        
        
    }

    
	
    
    
    func spawnEnemy() {
        
        let randomXStart = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        let randomXEnd = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))

        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        //enemy settings
        let enemy = SKSpriteNode(imageNamed: "enemyShip")
        enemy.size = CGSizeMake(200, 200)
        enemy.name = "Enemy"
        enemy.position = startPoint
        enemy.zPosition = 2
        
        //adding physics
        enemy.physicsBody = SKPhysicsBody(rectangleOfSize: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
		
		self.addChild(enemy)

		
        //moving enemy
        let moveEnemy = SKAction.moveTo(endPoint, duration: 3)
        let deleteEnemy = SKAction.removeFromParent()
        let loseALifeAction = SKAction.runBlock(loseALife)
        let enemySequence = SKAction.sequence([whooshSound, moveEnemy, deleteEnemy, loseALifeAction])//if it reaches end of screen: lose a life
        if currentGameState == gameState.inGame {
        enemy.runAction(enemySequence)
        }
        
        //making enemy rotate
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amountToRotate = atan2(dy, dx)
        enemy.zRotation = amountToRotate
        
        //making it pulse
        let pulseUp = SKAction.scaleTo(1.2, duration: 0.3)
        let pulseDown = SKAction.scaleTo(1, duration: 0.3)
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        let repeatPulse = SKAction.repeatActionForever(pulse)
        
        enemy.runAction(repeatPulse)
        
        

    }
    
    
    func spawnCarrot() {
        
        
        let randomXStart = random(min: CGRectGetMinX(gameArea) + 2, max: CGRectGetMaxX(gameArea) - 2)
        let randomXEnd = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        
        //enemy settings
        let carrot = SKSpriteNode(imageNamed: "enemy2")
        carrot.size = CGSizeMake(200, 200)
        carrot.name = "Carrot"
        carrot.position = startPoint
        carrot.zPosition = 2
        
        //adding physics
        carrot.physicsBody = SKPhysicsBody(rectangleOfSize: carrot.size)
        carrot.physicsBody!.affectedByGravity = false
        carrot.physicsBody!.categoryBitMask = PhysicsCategories.Carrot
        carrot.physicsBody!.collisionBitMask = PhysicsCategories.None
        carrot.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
        
        //moving enemy
        let moveEnemy = SKAction.moveTo(endPoint, duration: 5)
        let deleteEnemy = SKAction.removeFromParent()
        let loseALifeAction = SKAction.runBlock(loseALife)
        let enemySequence = SKAction.sequence([ moveEnemy, deleteEnemy, loseALifeAction])//if it reaches end of screen: lose a life
        if currentGameState == gameState.inGame {
            carrot.runAction(enemySequence)
        }
        
        //making enemy rotate
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amountToRotate = atan2(dy, dx)
        carrot.zRotation = amountToRotate
        
        self.addChild(carrot)
    }
    
    
    
    func spawnMuchedCarrot(spawnPosition: CGPoint) {
        
        let randomXEnd = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)

        //enemy settings
        let carrot = SKSpriteNode(imageNamed: "munchedCarrot")
        carrot.size = CGSizeMake(200, 200)
        carrot.name = "MunchedCarrot"
        carrot.zPosition = 2
        
        //adding physics
        carrot.physicsBody = SKPhysicsBody(rectangleOfSize: carrot.size)
        carrot.physicsBody!.affectedByGravity = false
        carrot.physicsBody!.categoryBitMask = PhysicsCategories.MunchedCarrot
        carrot.physicsBody!.collisionBitMask = PhysicsCategories.None
        carrot.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
        
        //moving enemy
        let moveEnemy = SKAction.moveTo(endPoint, duration: 5)
        let deleteEnemy = SKAction.removeFromParent()
        let loseALifeAction = SKAction.runBlock(loseALife)
        let enemySequence = SKAction.sequence([ moveEnemy, deleteEnemy, loseALifeAction])//if it reaches end of screen: lose a life
        if currentGameState == gameState.inGame {
            carrot.runAction(enemySequence)
        }
        
            self.addChild(carrot)

    }
    
    
    func spawnTomato() {
        
        
        let randomXStart = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        let randomXEnd = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        //enemy settings
        let tomato = SKSpriteNode(imageNamed: "tomato")
        tomato.size = CGSizeMake(180, 180)
        tomato.name = "Tomato"
        tomato.position = startPoint
        tomato.zPosition = 2
        
        //adding physics
        tomato.physicsBody = SKPhysicsBody(rectangleOfSize: tomato.size)
        tomato.physicsBody!.affectedByGravity = false
        tomato.physicsBody!.categoryBitMask = PhysicsCategories.Tomato
        tomato.physicsBody!.collisionBitMask = PhysicsCategories.None
        tomato.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
		self.addChild(tomato)

        //moving enemy
        let moveEnemy = SKAction.moveTo(endPoint, duration: 3)
        let deleteEnemy = SKAction.removeFromParent()
        let loseALifeAction = SKAction.runBlock(loseALife)
        let enemySequence = SKAction.sequence([whooshSound, moveEnemy, deleteEnemy, loseALifeAction])//if it reaches end of screen: lose a life
        if currentGameState == gameState.inGame {
            tomato.runAction(enemySequence)
        }
        
        //making enemy rotate
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amountToRotate = atan2(dy, dx)
        tomato.zRotation = amountToRotate
        
        //making it pulse
        let pulseUp = SKAction.scaleTo(1.2, duration: 0.3)
        let pulseDown = SKAction.scaleTo(1, duration: 0.3)
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        let repeatPulse = SKAction.repeatActionForever(pulse)
        
        tomato.runAction(repeatPulse)
        
        
 
        
        
        
        
    }

    func spawnRegen() {
        
        let randomXStart = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        let randomXEnd = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        let regen = SKSpriteNode(imageNamed: "regen1")
        regen.size = CGSizeMake(250, 250)
        regen.name = "Regen"
        regen.position = startPoint
        regen.zPosition = 2
        
        //physics
        regen.physicsBody = SKPhysicsBody(rectangleOfSize: regen.size)
        regen.physicsBody?.affectedByGravity = false
        regen.physicsBody!.categoryBitMask = PhysicsCategories.Regen
        regen.physicsBody!.collisionBitMask = PhysicsCategories.None
        regen.physicsBody!.contactTestBitMask = PhysicsCategories.Player
		self.addChild(regen)

		
        let moveRegen = SKAction.moveTo(endPoint, duration: 6)
        let deleteRegen = SKAction.removeFromParent()
        let regenSequence = SKAction.sequence([moveRegen, deleteRegen])
        if currentGameState == gameState.inGame {
            regen.runAction(regenSequence) }
        
        //making it rotate
        let rotate = SKAction.rotateByAngle(0.5, duration: 0.5)
        let rotateRegen = SKAction.repeatActionForever(rotate)
        regen.runAction(rotateRegen)
        
        //making it glow
        let regen1 = SKTexture(imageNamed: "regen1")
        let regen2 = SKTexture(imageNamed: "regen2")
        let regen3 = SKTexture(imageNamed: "regen3")
        let regen4 = SKTexture(imageNamed: "regen4")
        let textures = [regen1,regen2, regen3, regen4, regen3, regen2]
        
        regen.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(textures, timePerFrame: 0.2)))
        
        //making it pulse
        let pulseUp = SKAction.scaleTo(1.3, duration: 1.0)
        let pulseDown = SKAction.scaleTo(1, duration: 1.0)
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        let repeatPulse = SKAction.repeatActionForever(pulse)
        regen.runAction(repeatPulse)
        
		
    }
    
    func spawnBulletBox() {
        
        
        let randomXStart = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        let randomXEnd = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        //settings
		let bulletBox = SKSpriteNode(imageNamed: "bulletBox")

        bulletBox.name = "BulletBox"
        bulletBox.setScale(0.1)
        bulletBox.position = startPoint
        bulletBox.zPosition = 2
        
        //physics
        bulletBox.physicsBody = SKPhysicsBody(rectangleOfSize: bulletBox.size)
        bulletBox.physicsBody?.affectedByGravity = false
        bulletBox.physicsBody!.categoryBitMask = PhysicsCategories.BulletBox
        bulletBox.physicsBody!.collisionBitMask = PhysicsCategories.None
        bulletBox.physicsBody!.contactTestBitMask = PhysicsCategories.Player
		self.addChild(bulletBox)

        //animation
        let moveBox = SKAction.moveTo(endPoint, duration: 2)
        let deleteBox = SKAction.removeFromParent()
        let boxSequence = SKAction.sequence([moveBox, deleteBox])
        bulletBox.runAction(boxSequence)
        

        
    }
    
    
    
    // ________________________________END________________________________
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
	
		
		

		if currentGameState == gameState.preGame {
			startGame()
		}
		
       else if currentGameState == gameState.inGame {
        fireBullet()
            
        }
    
        let pulseUp = SKAction.scaleTo(0.8, duration: 0.2)
        let pulseDown = SKAction.scaleTo(0.6, duration: 0.3)
        let pulse = SKAction.sequence([ pulseUp, pulseDown])
        let repeatPulse = SKAction.repeatAction(pulse, count: 1)
        player.runAction(repeatPulse)
		
		
				}
			
			
			
			
			
			
			
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        //moving the ship 
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.locationInNode(self) //where r we touching in screen
            let previousPointOfTouch = touch.previousLocationInNode(self)
            
            //moving it left and right
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            
            if currentGameState == gameState.inGame {
            player.position.x += amountDragged
            }
            //moving it up and down
            let amountDraged = pointOfTouch.y - previousPointOfTouch.y
            if currentGameState == gameState.inGame {
            player.position.y += amountDraged
                
            }
            
            if player.position.x > CGRectGetMaxX(gameArea) - player.size.width/2  {
                player.position.x = CGRectGetMaxX(gameArea) - player.size.width/2
            }
            
            if player.position.x < CGRectGetMinX(gameArea) + player.size.width/2 {
                player.position.x = CGRectGetMinX(gameArea) + player.size.width/2
            }
            //up
            if player.position.y > CGRectGetMaxY(gameArea) - player.size.height*2{
                player.position.y = CGRectGetMaxY(gameArea) - player.size.height*2
            }
            //down
            if player.position.y < CGRectGetMinY(gameArea) + player.size.height/2{
                player.position.y = CGRectGetMinY(gameArea) + player.size.height/2
            }
        }
    }
    
   
    
}


