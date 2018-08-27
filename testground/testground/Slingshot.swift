//
//  Player.swift
//  testground
//
//  Created by 张勇昊 on 4/9/17.
//  Copyright © 2017 YonghaoZhang. All rights reserved.
//

import SpriteKit

class Slingshot: SKSpriteNode{
    
    
    // MARK: - Init
    init() {
        let Slingshottexture = SKTexture(imageNamed: "slingshot")
        let SlingshotSize = CGSize(width: 60, height: 110)
        
        super.init(texture: Slingshottexture, color: UIColor.black, size: SlingshotSize)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    func setup() {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody!.isDynamic = false
        physicsBody!.categoryBitMask = PhysicsCategory.Slingshot
        physicsBody!.collisionBitMask = PhysicsCategory.Ground
        physicsBody!.contactTestBitMask = PhysicsCategory.Coin | PhysicsCategory.Deadly | PhysicsCategory.Projectile
    }
}
