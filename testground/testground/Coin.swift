//
//  Coin.swift
//  testground
//
//  Created by 张勇昊 on 4/9/17.
//  Copyright © 2017 YonghaoZhang. All rights reserved.
//

import SpriteKit

class Coin: SKSpriteNode {
    
    // MARK: - Init
    init() {
        
        let coinSize = CGSize(width: 25, height: 25)
        
        let cointexture = SKTexture(imageNamed: "flower1")
        
        super.init(texture: cointexture, color: UIColor.yellow, size: coinSize)
    
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    func setup() {
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody!.isDynamic = false
        physicsBody!.categoryBitMask = PhysicsCategory.Coin
        physicsBody!.collisionBitMask = PhysicsCategory.Ground
        physicsBody!.contactTestBitMask = PhysicsCategory.Projectile
    }

}
