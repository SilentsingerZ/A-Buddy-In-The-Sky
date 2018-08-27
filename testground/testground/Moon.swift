//
//  Moon.swift
//  testground
//
//  Created by 张勇昊 on 5/4/17.
//  Copyright © 2017 YonghaoZhang. All rights reserved.
//

import SpriteKit

class Moon: SKSpriteNode{
    
    
    // MARK: - Init
    init() {
        
        let MoonSize = CGSize(width: 600, height: 650)
        let Moontexture = SKTexture(imageNamed: "super-moon.png")
        
        super.init(texture: Moontexture, color: UIColor.black, size: MoonSize)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    func setup() {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody!.isDynamic = false
        physicsBody!.categoryBitMask = PhysicsCategory.Moon
        physicsBody!.collisionBitMask = PhysicsCategory.Ground
        physicsBody!.contactTestBitMask = PhysicsCategory.Projectile

    }
}
