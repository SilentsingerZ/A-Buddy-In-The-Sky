//
//  Coin2.swift
//  testground
//
//  Created by 张勇昊 on 5/2/17.
//  Copyright © 2017 YonghaoZhang. All rights reserved.
//

import SpriteKit

class Coin2: SKSpriteNode {
    
    // MARK: - Init
    init() {
        
        let coin2Size = CGSize(width: 25, height: 25)
        
        let coin2texture = SKTexture(imageNamed: "flower2")

        super.init(texture: coin2texture, color: UIColor.orange, size: coin2Size)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    func setup() {
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody!.isDynamic = false
        physicsBody!.categoryBitMask = PhysicsCategory.Coin2
        physicsBody!.collisionBitMask = PhysicsCategory.Ground
        physicsBody!.contactTestBitMask = PhysicsCategory.Projectile
    }
    
}
