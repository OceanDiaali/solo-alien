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
    // global declaration of game player
    let player = SKSpriteNode(imageNamed: "alien")
    
    // global declaration of energy ring sound
    let energyRingSound = SKAction.playSoundFileNamed("drip.wav", waitForCompletion: false)
    
    override func didMove(to view: SKView) {
        // configure game background
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = 0
        self.addChild(background)
        
        // text display for score
        let scoreLabel: SKLabelNode!
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 72
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: self.size.width / 2, y: 1820)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
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
        
        
    } // did Move to
    
    func fireEnergyRing() {
        let energy = SKSpriteNode(imageNamed: "energy-ring")
        energy.setScale(0.2)
        energy.position = player.position
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
        
        // Determine where to spawn the flame along the X axis
        let actualX = random(min: spark.size.width / 2, max: size.width - spark.size.width / 2)
        
        // Position the flame slightly off-screen along the top edge,
        // and along a random position along the X axis as calculated above
        spark.position = CGPoint(x: actualX, y: size.height + spark.size.height / 2)
        
        // Add the flame to the scene
        addChild(spark)
        
        // Determine speed of the flame
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        // Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -spark.size.height / 2),
                                       duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        spark.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    
} // class Game scene
