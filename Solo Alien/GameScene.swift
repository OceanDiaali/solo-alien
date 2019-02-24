//
//  GameScene.swift
//  Solo Alien
//
//  Created by Apple on 23/02/2019.
//  Copyright © 2019 qoboqo. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    // for collisions physics
    struct PhysicsCategory {
        static let none      : UInt32 = 0
        static let all       : UInt32 = UInt32.max
        static let enemy   : UInt32 = 0b1       // 1
        static let energyring: UInt32 = 0b10      // 2
    }
    
    // game time per play
    var gameTime = 31
    // score display
    var scoreLabel: SKLabelNode!
    
    // player score
    var playerScore: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(playerScore)"
        }
    }
    // global declaration of game player
    let player = SKSpriteNode(imageNamed: "alien")
    
    // global declaration of energy ring sound
    let energyRingSound = SKAction.playSoundFileNamed("lazerzap.wav", waitForCompletion: false)
    
    override func didMove(to view: SKView) {
        // configure game background
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = 0
        self.addChild(background)
        
        // text display for score
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 72
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.position = CGPoint(x: self.size.width / 2, y: 1820)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
        // text display for countdown timer
        let timerLabel: SKLabelNode!
        timerLabel = SKLabelNode(fontNamed: "Chalkduster")
        timerLabel.text = "30"
        timerLabel.fontSize = 72
        //timerLabel.horizontalAlignmentMode = .left
        timerLabel.position = CGPoint(x: 360, y: 1820)
        timerLabel.zPosition = 2
        addChild(timerLabel)
        
        let wait = SKAction.wait(forDuration: 1) //change countdown speed here
        let block = SKAction.run({
            [unowned self] in
            
            if self.gameTime > 0{
                self.gameTime -= 1
                timerLabel.text = "\(self.gameTime)"
            }
        })
        let sequence = SKAction.sequence([wait,block])
        
        run(SKAction.repeatForever(sequence))
    //})
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addFlame),
                SKAction.wait(forDuration: 1.0)
                ])
        ))
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addEnemy),
                SKAction.wait(forDuration: 4.0)
                ])
        ))
        
        
        player.setScale(0.2)
        player.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.06)
        player.zPosition = 1
        self.addChild(player)
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        let backgroundMusic = SKAudioNode(fileNamed: "music.mp3")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        
        
    } // did Move to
    
    func fireEnergyRing() {
        let energy = SKSpriteNode(imageNamed: "energy-ring")
        energy.setScale(0.2)
        energy.position = player.position
        // ====================
        energy.physicsBody = SKPhysicsBody(circleOfRadius: energy.size.width/2)
        energy.physicsBody?.isDynamic = true
        energy.physicsBody?.categoryBitMask = PhysicsCategory.energyring
        energy.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
        energy.physicsBody?.collisionBitMask = PhysicsCategory.none
        energy.physicsBody?.usesPreciseCollisionDetection = true
        // ====================
        energy.zPosition = 2
        self.addChild(energy)
        
        let moveEnergy = SKAction.moveTo(y: self.size.height + energy.size.height,duration: 1)
        let deleteEnergy = SKAction.removeFromParent()
        let energySequence = SKAction.sequence([energyRingSound, moveEnergy, deleteEnergy])
        
        energy.run(energySequence)
    } // fire energy ring
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // tap on screen to fire energy ring
        fireEnergyRing()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            
            player.position.x += amountDragged
        }
    } // touches moved
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addFlame() {
        //create sprite
        let flame = SKSpriteNode(imageNamed: "fire-flame")
        /* for physics
        flame.physicsBody = SKPhysicsBody(rectangleOf: flame.size) // 1
        flame.physicsBody?.isDynamic = true // 2
        flame.physicsBody?.categoryBitMask = PhysicsCategory.flame // 3
        flame.physicsBody?.contactTestBitMask = PhysicsCategory.energyring // 4
        flame.physicsBody?.collisionBitMask = PhysicsCategory.none */
        
        // resize sprite
        flame.setScale(0.3)
        
        // position over player
        flame.zPosition = 3
        
        // Determine where to spawn the flame along the X axis
        let actualX = random(min: flame.size.width / 2, max: size.width - flame.size.width / 2)
        
        // Position the flame slightly off-screen along the top edge,
        // and along a random position along the X axis as calculated above
        flame.position = CGPoint(x: actualX, y: size.height + flame.size.height / 2)
        
        // Add the flame to the scene
        addChild(flame)
        
        // Determine speed of the flame
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        // Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -flame.size.height / 2),
                                       duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        flame.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    // function for spark(enemy) sprite
    func addEnemy() {
        //create sprite
        let spark = SKSpriteNode(imageNamed: "red-spark")
        // resize sprite
        spark.setScale(0.3)
        
        // position over player
        spark.zPosition = 3
        
        // Determine where to spawn the spark along the X axis
        let actualX = random(min: spark.size.width / 2, max: size.width - spark.size.width / 2)
        
        // Position the spark slightly off-screen along the top edge,
        // and along a random position along the X axis as calculated above
        spark.position = CGPoint(x: actualX, y: size.height + spark.size.height / 2)
        // ===================
        spark.physicsBody = SKPhysicsBody(rectangleOf: spark.size) // 1
        spark.physicsBody?.isDynamic = true // 2
        spark.physicsBody?.categoryBitMask = PhysicsCategory.enemy // 3
        spark.physicsBody?.contactTestBitMask = PhysicsCategory.energyring // 4
        spark.physicsBody?.collisionBitMask = PhysicsCategory.none
        // ===================
        
        // Add the enemy to the scene
        addChild(spark)
        
        // Determine speed of the enemy
        let actualDuration = random(min: CGFloat(3.0), max: CGFloat(6.0))
        
        // Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -spark.size.height / 2),
                                       duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        spark.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    func energyDidCollideWithEnemy(energyring: SKSpriteNode, enemy: SKSpriteNode) {
        //print("Hit")
        energyring.removeFromParent()
        enemy.removeFromParent()
    }
    
    
} // class Game scene

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        // 1
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // 2
        if ((firstBody.categoryBitMask & PhysicsCategory.enemy != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.energyring != 0)) {
            if let enemy = firstBody.node as? SKSpriteNode,
                let energyring = secondBody.node as? SKSpriteNode {
                energyDidCollideWithEnemy(energyring: energyring, enemy: enemy)
            }
        }
    }
}
