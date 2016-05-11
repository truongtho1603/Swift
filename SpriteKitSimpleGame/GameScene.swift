//
//  GameScene.swift
//  SpriteKitSimpleGame
//
//  Created by Tho Do on 5/9/16.
//  Copyright (c) 2016 Tho Do. All rights reserved.
//

import SpriteKit

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(a)))
    }
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

class GameScene: SKScene {
    var skResourcePath: String = "SpriteKitSimpleGameResources/sprites.atlas/"
    
    var player = SKSpriteNode(imageNamed: "SpriteKitSimpleGameResources/sprites.atlas/" + "player")
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.whiteColor()
        self.player.position = CGPoint(x: self.size.width * 0.1, y: self.size.height * 0.5)
        self.addChild(player)
        
        // run action
        runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.runBlock(addMonster),
            SKAction.waitForDuration(1.0)
            ])))
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
    }
    
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addMonster() {
        let monster = SKSpriteNode(imageNamed: skResourcePath + "monster")
        let actualY = random(min: monster.size.height / 2, max: size.height - monster.size.height/2)
        monster.position = CGPoint(x: size.width + monster.size.width / 2, y: actualY)
        self.addChild(monster)
        
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        let actionMove = SKAction.moveTo(CGPoint(x: -monster.size.width/2, y: actualY), duration: NSTimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        monster.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        /* Called when a touch begins */
//        
//        //        for touch in touches {
//        //            let location = touch.locationInNode(self)
//        //
//        //            let sprite = SKSpriteNode(imageNamed:"Spaceship")
//        //
//        //            sprite.xScale = 0.5
//        //            sprite.yScale = 0.5
//        //            sprite.position = location
//        //
//        //            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//        //
//        //            sprite.runAction(SKAction.repeatActionForever(action))
//        //
//        //            self.addChild(sprite)
//        //        }
//    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // 1 - Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.locationInNode(self)
        
        // 2 - Set up initial location of projectile
        let projectile = SKSpriteNode(imageNamed: skResourcePath + "projectile")
        projectile.position = player.position
        
        // 3 - Determine offset of location to projectile
        let offset = touchLocation - projectile.position
        
        // 4 - Bail out if you are shooting down or backwards
        if (offset.x < 0) { return }
        
        // 5 - OK to add now - you've double checked position
        addChild(projectile)
        
        // 6 - Get the direction of where to shoot
        let direction = offset.normalized()
        
        // 7 - Make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * 100
        
        // 8 - Add the shoot amount to the current position
        let realDest = shootAmount + projectile.position
        
        // 9 - Create the actions
        let actionMove = SKAction.moveTo(realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
