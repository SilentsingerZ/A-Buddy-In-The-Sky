//
//  Deadly.swift
//  testground
//
//  Created by 张勇昊 on 4/9/17.
//  Copyright © 2017 YonghaoZhang. All rights reserved.
//

import SpriteKit

class Deadly: SKSpriteNode{
    
    
    // MARK: - Init
    init() {
        
        //let width = CGFloat(arc4random() % 4) * 10 + 40
        //let height = CGFloat(arc4random() % 4) * 10 + 40
        let width = 60
        let height = 25

        let size = CGSize(width: width, height: height)
        let deadlytexture = SKTexture(imageNamed: "Platform")

        
        super.init(texture: deadlytexture, color: UIColor.cyan, size: size)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    func setup() {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody!.isDynamic = true
        physicsBody!.categoryBitMask = PhysicsCategory.Deadly
        physicsBody!.collisionBitMask = PhysicsCategory.Ground
        physicsBody!.contactTestBitMask = PhysicsCategory.Projectile
    }
}

