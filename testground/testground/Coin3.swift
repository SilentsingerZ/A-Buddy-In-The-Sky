//
//  Coin3.swift
//  testground
//
//  Created by 张勇昊 on 5/2/17.
//  Copyright © 2017 YonghaoZhang. All rights reserved.
//

import SpriteKit

class Coin3: SKSpriteNode {
    
    // MARK: - Init
    init() {
        
        let coin3Size = CGSize(width: 20, height: 40)

        let coin3texture = SKTexture(imageNamed: "keystone.png")

        super.init(texture: coin3texture, color: UIColor.purple, size: coin3Size)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    func setup() {
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody!.isDynamic = false
        physicsBody!.categoryBitMask = PhysicsCategory.Coin3
        physicsBody!.collisionBitMask = PhysicsCategory.Ground
        physicsBody!.contactTestBitMask = PhysicsCategory.Projectile
    }
    
}

