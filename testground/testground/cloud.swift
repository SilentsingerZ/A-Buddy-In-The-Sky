//
//  cloud.swift
//  testground
//
//  Created by 张勇昊 on 5/3/17.
//  Copyright © 2017 YonghaoZhang. All rights reserved.
//

import SpriteKit

class cloud: SKSpriteNode{
    
    
    // MARK: - Init
    init() {

        let cloudtexture = SKTexture(imageNamed: "cloud")
        let width = 200
        let height = 100
        let size = CGSize(width: width, height: height)
        
        super.init(texture: cloudtexture, color: UIColor.cyan, size: size)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    func setup() {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody!.isDynamic = false
        physicsBody!.categoryBitMask = PhysicsCategory.cloud
        physicsBody!.collisionBitMask = PhysicsCategory.Ground
        physicsBody!.contactTestBitMask = PhysicsCategory.Projectile
    }
}
