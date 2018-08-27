//
//  Nodes.swift
//  testground
//
//  Created by 张勇昊 on 4/9/17.
//  Copyright © 2017 YonghaoZhang . All rights reserved.
//

import SpriteKit

     class Projectile: SKSpriteNode {

    // MARK: - Init
     init() {

        let projectiletexture = SKTexture(imageNamed: "mage.png")
        
        let projectileSize = CGSize(width: 40, height: 40)
        
        super.init(texture: projectiletexture, color: UIColor.red, size: projectileSize)
 
        setup()
        
}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    func setup() {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody!.friction = 20
        physicsBody!.affectedByGravity = false
        physicsBody!.categoryBitMask = PhysicsCategory.Projectile
        physicsBody!.contactTestBitMask = PhysicsCategory.Coin | PhysicsCategory.Deadly | PhysicsCategory.Coin2 | PhysicsCategory.Coin3 | PhysicsCategory.Moon | PhysicsCategory.Slingshot
        physicsBody!.collisionBitMask = PhysicsCategory.Ground
        }
    
}
