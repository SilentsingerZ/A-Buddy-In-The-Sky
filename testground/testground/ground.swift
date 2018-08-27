//
//  ground.swift
//  testground
//
//  Created by 张勇昊 on 4/9/17.
//  Copyright © 2017 Yonghao Zhang All rights reserved.
//

import SpriteKit

class Ground: SKSpriteNode {
    
    // MARK: - Init
    
    init(size: CGSize){
        let groundtexture = SKTexture(imageNamed: "ground123.jpg")
        
        let groundSize = CGSize(width: size.width, height: 50)
        
        super.init(texture: groundtexture, color: UIColor.orange, size: groundSize)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


    // MARK: - Setup
    func setup() {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody!.isDynamic = false
        physicsBody!.categoryBitMask = PhysicsCategory.Ground
        physicsBody!.collisionBitMask = PhysicsCategory.Projectile | PhysicsCategory.Slingshot
        //physicsBody!.collisionBitMask = PhysicsCategory.Player
        physicsBody!.contactTestBitMask = PhysicsCategory.None
    }

}
