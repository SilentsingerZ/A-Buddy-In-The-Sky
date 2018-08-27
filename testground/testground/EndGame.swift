//
//  EndGame.swift
//  testground
//
//  Created by 张勇昊 on 4/12/17.
//  Copyright © 2017 YonghaoZhang. All rights reserved.
//


import SpriteKit

class EndGame: SKScene {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        //setting font size and font color of scorelabel, highscorelabel, tryagainlabel, sharelabel
        let scoreLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        scoreLabel.fontSize = 60
        scoreLabel.zPosition = 999
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        scoreLabel.text = "\(GameHandler.sharedInstance.score)"
        addChild(scoreLabel)
        
        let highScoreLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        highScoreLabel.fontSize = 30
        highScoreLabel.zPosition = 999
        highScoreLabel.fontColor = SKColor.red
        highScoreLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height*2/3)
        highScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        highScoreLabel.text = "\(GameHandler.sharedInstance.highScore)"
        addChild(highScoreLabel)
        
        if GameHandler.sharedInstance.score == GameHandler.sharedInstance.highScore{
            self.run(SKAction.playSoundFileNamed("highScore.wav", waitForCompletion: false))
            Victory(scoreLabel.position)
        }
        
        let tryAgainLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        tryAgainLabel.fontSize = 30
        tryAgainLabel.zPosition = 999
        tryAgainLabel.fontColor = SKColor.white
        tryAgainLabel.position = CGPoint(x: self.size.width / 2, y: 50)
        tryAgainLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        tryAgainLabel.text = "Tap To Play Again"
        addChild(tryAgainLabel)
        
        let ShareLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        ShareLabel.fontSize = 10
        scoreLabel.zPosition = 999
        ShareLabel.fontColor = SKColor.white
        ShareLabel.position = CGPoint(x: self.size.width / 2, y: 30)
        ShareLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        ShareLabel.text = "(make a screenshot and share score with your friends!!!)"
        addChild(ShareLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //return to game scene (GameScene.swift)
        let transition = SKTransition.fade(withDuration: 1)
        let gameScene = GameScene(size: self.size)
        self.view?.presentScene(gameScene, transition: transition)
    }
    
    func Victory(_ point: CGPoint) {
        if let poof = SKEmitterNode(fileNamed: "StarExplosion") {
            addChild(poof)
            poof.position = point
            let wait = SKAction.wait(forDuration: 1000)
            let remove = SKAction.removeFromParent()
            let seq = SKAction.sequence([wait, remove])
            poof.run(seq)
        }
    }
    
}
