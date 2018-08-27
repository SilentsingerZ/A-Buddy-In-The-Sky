//
//  GameScene.swift
//  testground
//
//  Created by 张勇昊 on 4/9/17.
//  Copyright © 2017 YonghaoZhang. All rights reserved.
//
//  TODO:
//  1. add coin blocks
//  2. add score and coin text label
//  3. add "perfect" things
//  4. 

//  TODO2:
//  add pause button that link to help scene seperate with game scene
//  create help menu scene
//  make few pictures to show how to play the game

//  TODO3:
//  add a upgrade button that link to upgrade scene seperate with game scene
//  create upgrade menu scene
//  let player can do some upgrade to the mage (score multiplation index, increase acceleration, increase maximum of initial acceleration from 1 to 5, increase mage tower height, increase projectile launch ability,



import SpriteKit
import GameplayKit
import CoreMotion

// setting astronaut position and all imformation about slingshot including max dragged ditance, slingshot strength and so on
struct Settings {
    struct Metrics {
        static let projectileRadius = CGFloat(10)
        static let projectileRestPosition = CGPoint(x: 130, y: 150)
        static let projectileTouchThreshold = CGFloat(10)
        static let projectileSnapLimit = CGFloat(10)
        static let forceMultiplier = CGFloat(1.0)
        static let rLimit = CGFloat(50) //max drag distance set to 50
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    // setting and initializing all element of game
    let projectile: Projectile
    let slingshot: Slingshot
    let moon: Moon
    var projectileIsDragged = false
    var touchCurrentPoint: CGPoint!
    var touchStartingPoint: CGPoint!
    var hud:SKNode!
    var xAcceleration:CGFloat = 0.0
    let motionManager = CMMotionManager()
    var hasGone = false
    let cameraNode: SKCameraNode
    var landscapes = [Landscape]()
    var touching: Bool = false
    let scoreLabel: SKLabelNode!
    let energyLabel: SKLabelNode!
    var currentMaxX: Int!
    
    
    //var energyCollected: Int = 3 {
    //    didSet {
    //        energyLabel.text = "\(energyCollected)"
    //    }
    //}

    
    
    // MARK: - Init
    override init(size: CGSize){
        // initializing element from other swift files
        cameraNode = SKCameraNode()
        scoreLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        energyLabel = SKLabelNode(fontNamed: "AmericanTypewriter-Bold")
        currentMaxX = 4
        GameHandler.sharedInstance.score = 0
        GameHandler.sharedInstance.energy = 3
        projectile = Projectile()
        moon = Moon()
        slingshot = Slingshot()
        super.init(size: size)
        // setup function
        setup()
    }
    // check if error appeared
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    // setup function is to setting initialized elements including position in three dimensions, label fonts and so on
    func setup() {
        //set game world
        physicsWorld.gravity = CGVector(dx: 0, dy: -1.5)
        physicsWorld.contactDelegate = self
        //control by gravity, set motion manager including sensitivity, and reaction time interval
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(
            to: OperationQueue.main,
            withHandler: { (data: CMAccelerometerData?, error: Error?) in
                if let accelerometerData = data {
                    let acceleration = accelerometerData.acceleration
                    self.xAcceleration = (CGFloat(acceleration.y) * 0.75 + (self.xAcceleration * 0.25))
                }
        })
        //add score label in the camera
        
        
        //score
        scoreLabel.zPosition = 999 //most top in the z axis
        scoreLabel.position.x = size.width / -2 + 10
        scoreLabel.position.y = size.height / 2 - 10
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = SKColor.white
        scoreLabel.text = "0"
        cameraNode.addChild(scoreLabel)
        
        //energy
        
        energyLabel.zPosition = 999 //most top in the z axis
        energyLabel.position.x = size.width / -2 + 10
        energyLabel.position.y = size.height / 2 - 35
        energyLabel.horizontalAlignmentMode = .left
        energyLabel.verticalAlignmentMode = .top
        energyLabel.fontSize = 30
        energyLabel.fontColor = SKColor.yellow
        energyLabel.text = "3"
        cameraNode.addChild(energyLabel)
 
        //slingshot
        addChild(slingshot)
        slingshot.position.x = 130
        slingshot.position.y = 100
        slingshot.zPosition = 1
        //moon
        addChild(moon)
        moon.position.x = size.width
        moon.position.y = size.height + 200
        moon.zPosition = 1
        //camera
        addChild(cameraNode)
        camera = cameraNode
        cameraNode.position.x = size.width / 2
        cameraNode.position.y = size.height / 2
        //projectile
        addChild(projectile)
        projectile.position = Settings.Metrics.projectileRestPosition
        projectile.zPosition = 99
        hud = SKNode()
        addChild(hud)

        //repeat background
        for i in 0 ..< 2 {
            let landscape = Landscape(size: size)
            landscape.position.x = CGFloat(i) * size.width
            landscapes.append(landscape)
            addChild(landscape)
        }
        
    }
    
    override func didMove(to view: SKView) {
    }
    
    // function that calculate applied force on astronaut according to slingshot move distance
    func fingerDistanceFromProjectileRestPosition(_ projectileRestPosition: CGPoint, fingerPosition: CGPoint) -> CGFloat {
        return sqrt(pow(projectileRestPosition.x - fingerPosition.x,2) + pow(projectileRestPosition.y - fingerPosition.y,2))
    }
    // set the limit of slingshot dragging
    func projectilePositionForFingerPosition(_ fingerPosition: CGPoint, projectileRestPosition:CGPoint, circleRadius rLimit:CGFloat) -> CGPoint {
        let φ = atan2(fingerPosition.x - projectileRestPosition.x, fingerPosition.y - projectileRestPosition.y)
        let cX = sin(φ) * rLimit
        let cY = cos(φ) * rLimit
        return CGPoint(x: cX + projectileRestPosition.x, y: cY + projectileRestPosition.y)
    }
    
    
    // MARK: - TouchesBegan
    // override function work when user first touch the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        func shouldStartDragging(_ touchLocation:CGPoint, threshold: CGFloat) -> Bool {
            let distance = fingerDistanceFromProjectileRestPosition(
                Settings.Metrics.projectileRestPosition,
                fingerPosition: touchLocation
            )
            return distance < Settings.Metrics.projectileRadius + threshold
        }
        
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            if !projectileIsDragged && shouldStartDragging(touchLocation, threshold: Settings.Metrics.projectileTouchThreshold)  {
                touchStartingPoint = touchLocation
                touchCurrentPoint = touchLocation
                projectileIsDragged = true
            }
        }
        
        touching = true
        if GameHandler.sharedInstance.energy > 0 {
            if projectile.position.x > 160{
                projectile.physicsBody?.velocity = CGVector(dx: (projectile.physicsBody?.velocity.dx)!-700*sin(projectile.zRotation), dy: (projectile.physicsBody?.velocity.dy)!+700*cos(projectile.zRotation))
                //projectile.physicsBody?.velocity = CGVector(dx: 200, dy: 200)
                self.run(SKAction.playSoundFileNamed("dead.wav", waitForCompletion: false))
                makeSpark(projectile.position)
                GameHandler.sharedInstance.energy -= 1
            }
        }
        
        
        
        /*
         for touch in touches {
            let location = touch.location(in: sceneCamera)
            if location.x < 0 {
                // This touch was on the left side of the screen
                touchDown = true
                // Start emitting particles
                jetpackEmitter.numParticlesToEmit = 0 // Emit endless particles
                } else {
                    // This touch was on the right side of the screen
                    fireBullet()
         
         }
         }
        */
        
        
    }
    
    
    // MARK: - TouchesMove
    // override function work when user move finger on the screen
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if projectileIsDragged {
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                let distance = fingerDistanceFromProjectileRestPosition(touchLocation, fingerPosition: touchStartingPoint)
                if distance < Settings.Metrics.rLimit  {
                    touchCurrentPoint = touchLocation
                } else {
                    touchCurrentPoint = projectilePositionForFingerPosition(
                        touchLocation,
                        projectileRestPosition: touchStartingPoint,
                        circleRadius: Settings.Metrics.rLimit
                    )
                }
            }
            projectile.position = touchCurrentPoint
            makeslingshot(projectile.position)
        }
    }
 
    
    // MARK: - TouchesEnd
    // override function work when user stop touching the screen
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if projectileIsDragged {
            projectileIsDragged = false
            let distance = fingerDistanceFromProjectileRestPosition(touchCurrentPoint, fingerPosition: touchStartingPoint)
            if distance > Settings.Metrics.projectileSnapLimit {
                let vectorX = touchStartingPoint.x - touchCurrentPoint.x
                let vectorY = touchStartingPoint.y - touchCurrentPoint.y
                projectile.physicsBody?.applyImpulse(
                    CGVector(
                        dx: vectorX * Settings.Metrics.forceMultiplier,
                        dy: vectorY * Settings.Metrics.forceMultiplier
                    )
                )
                projectile.physicsBody?.affectedByGravity = true
            } else {
                projectile.physicsBody = nil
                projectile.position = Settings.Metrics.projectileRestPosition
            }
            
        }
        touching = false
        /*
        // Check all touches
        for touch in touches {
            let location = touch.location(in: sceneCamera)
            if location.x < 0 {
                // This touch was on the left side of the screen
                touchDown = false
                // Stop emitting particles
                jetpackEmitter.numParticlesToEmit = 1 // Emit maximum of 1 particle
                } else {
                    // This touch was on the right side of the screen
         
         }
         }
        */
        
        
        
    }
    
    
    // MARK: - DIDSIMULATE
    // override function work when game simulated the slingshot action and then start the gravity motion manager which can let player control player's angle position
    override func didSimulatePhysics() {
        
        if projectile.position.x >= 300 && projectile.position.y >= 65 {
        projectile.physicsBody?.angularVelocity = (projectile.physicsBody?.angularVelocity)!/1.15 - xAcceleration*2
        projectile.physicsBody?.velocity = CGVector(dx: projectile.physicsBody!.velocity.dx + xAcceleration, dy: projectile.physicsBody!.velocity.dy)
            if  projectile.position.y <= 80{
                if projectile.zRotation <= CGFloat(M_PI/13) && projectile.zRotation >= CGFloat(-M_PI/13) {
                    projectile.physicsBody?.velocity = CGVector(dx: projectile.physicsBody!.velocity.dx+50, dy: 300)
                    self.run(SKAction.playSoundFileNamed("kick.wav", waitForCompletion: false))
                } else if projectile.zRotation <= CGFloat(M_PI/13 + M_PI) && projectile.zRotation >= CGFloat(M_PI - M_PI/13) {
                    self.run(SKAction.playSoundFileNamed("dead.wav", waitForCompletion: false))
                    endGame()
                }
            }
        }
        for node in physicsObjectsToRemove {
            node.removeFromParent()
        }
    }
    
    
    // MARK: - Update
    // Updating condition of game
    var lastUpdateTime: CFTimeInterval = 0
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if Int(projectile.position.x/50) > currentMaxX {
            GameHandler.sharedInstance.score += Int(projectile.position.x/50) - currentMaxX
            currentMaxX = Int(projectile.position.x/50)
            //GameHandler.sharedInstance.energy = GameHandler.sharedInstance.score
            scoreLabel.text = "\(GameHandler.sharedInstance.score)"
            energyLabel.text = "\(GameHandler.sharedInstance.energy)"
        }
        // set cameroNode position move with astronaut and a relative motion of moon
        if projectile.position.x >= (size.width / 2) {
            if let projectileVelocity = projectile.physicsBody?.velocity {
                if projectileVelocity.dx >= 0 {
                    cameraNode.position.x = projectile.position.x
                }
            }
            
            moon.position.x = cameraNode.position.x + size.width/2 - cameraNode.position.x/100
        }
        // set cameroNode position move with astronaut
        if projectile.position.y >= (size.height / 2) {
            cameraNode.position.y = projectile.position.y
        } else {
            cameraNode.position.y = size.height / 2
        }
        // check if player is dead
        if projectile.position.x >= 200 || projectile.position.y >= 200 || touching == false{
            if let projectileVelocity = projectile.physicsBody?.velocity {
                if (projectileVelocity.dx <= 10 && projectileVelocity.dy <= 10 && projectile.position.y <= 80) ||
                    (cameraNode.position.x-projectile.position.x >= size.width*2/3){
                    endGame()
                }
            }
        }
        
        if projectile.position.y >= 2050 {
            projectile.physicsBody?.velocity = CGVector(dx: projectile.physicsBody!.velocity.dx, dy: -50)
        }
        scrollLandscapes()
        
        /*
        if touching {
            //if coinsCollected > 0 {
            if projectile.position.x > 160 {
                let emitVector = CGVector(dx: -60*sin(projectile.zRotation), dy: 60*cos(projectile.zRotation))
                
                // Push the player up
                projectile.physicsBody?.applyForce(emitVector)
                //coinsCollected -= 1
                }
            //}
        }
        */
    }
    //function that scroll repetive background
    func scrollLandscapes(){
        for landscape in landscapes{
            let dx = landscape.position.x - cameraNode.position.x
            if dx < -(landscape.size.width + size.width / 2) {
                landscape.position.x += landscape.size.width * 2
                // reconfigure landscape
                landscape.resetLandscape()
            }
        }
    }
    //function that goto EndGame.swift scene
    func endGame(){
        GameHandler.sharedInstance.saveGameStats()
        let transtion = SKTransition.fade(withDuration: 1)
        let endGameScene = EndGame(size: self.size)
        self.view?.presentScene(endGameScene, transition: transtion)
    }
    
    // Makes a particle effect at the position of a coin that is picked up.
    
    func makeCoinPoof(_ point: CGPoint) {
        if let poof = SKEmitterNode(fileNamed: "CoinPoof") {
            addChild(poof)
            poof.position = point
            let wait = SKAction.wait(forDuration: 1)
            let remove = SKAction.removeFromParent()
            let seq = SKAction.sequence([wait, remove])
            poof.run(seq)
        }
    }
    
    func makeExplosion(_ point: CGPoint) {
        if let explosion = SKEmitterNode(fileNamed: "EnemyDestroyed") {
            addChild(explosion)
            explosion.position = point
            let wait = SKAction.wait(forDuration: 1)
            let removeExplosion = SKAction.removeFromParent()
            explosion.run(SKAction.sequence([wait, removeExplosion]))
        }
    }
    
    func makeSpark(_ point: CGPoint) {
        if let spark = SKEmitterNode(fileNamed: "Spark") {
            addChild(spark)
            spark.position = point
            let wait = SKAction.wait(forDuration: 1)
            let removeSpark = SKAction.removeFromParent()
            spark.run(SKAction.sequence([wait, removeSpark]))
        }
    }
    
    func makeslingshot(_ point: CGPoint) {
        if let poof = SKEmitterNode(fileNamed: "Explosion") {
            addChild(poof)
            poof.position = point
            let wait = SKAction.wait(forDuration: 1)
            let remove = SKAction.removeFromParent()
            let seq = SKAction.sequence([wait, remove])
            poof.run(seq)
        }
    }
    
    var physicsObjectsToRemove = [SKNode]()
    
    // MARK: - Physics Delegate
    // function of setting collision and contact of required elements
    func didBegin(_ contact: SKPhysicsContact) {
        
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        // set reaction of white flower
        if collision == PhysicsCategory.Coin | PhysicsCategory.Projectile {
            projectile.physicsBody?.velocity = CGVector(dx: projectile.physicsBody!.velocity.dx+300, dy: 200)
            projectile.physicsBody?.angularVelocity += -40
            
            let poofPoint = self.convert(contact.bodyA.node!.position,
                                         from: contact.bodyA.node!.parent!)
            
            if contact.bodyA.node!.name == "Coin" {
                makeCoinPoof(poofPoint)
                physicsObjectsToRemove.append(contact.bodyA.node!)
                
            } else {
                makeCoinPoof(poofPoint)
                physicsObjectsToRemove.append(contact.bodyB.node!)
                
            }
            self.run(SKAction.playSoundFileNamed("stick_grow_loop.wav", waitForCompletion: false))
            
        }
        // set reaction of yellow flower
        else if collision == PhysicsCategory.Coin2 | PhysicsCategory.Projectile {
            projectile.physicsBody?.velocity = CGVector(dx: projectile.physicsBody!.velocity.dx+400, dy: 300)
            projectile.physicsBody?.angularVelocity += -50
            
            let poofPoint = self.convert(contact.bodyA.node!.position,
                                         from: contact.bodyA.node!.parent!)
            
            if contact.bodyA.node!.name == "Coin2" {
                makeCoinPoof(poofPoint)
                physicsObjectsToRemove.append(contact.bodyA.node!)
                
            } else {
                makeCoinPoof(poofPoint)
                physicsObjectsToRemove.append(contact.bodyB.node!)
                
            }
            self.run(SKAction.playSoundFileNamed("stick_grow_loop.wav", waitForCompletion: false))
        }
        // set reaction of keystone
        else if collision == PhysicsCategory.Coin3 | PhysicsCategory.Projectile {
            projectile.physicsBody?.velocity = CGVector(dx: projectile.physicsBody!.velocity.dx+500, dy: 400)
            projectile.physicsBody?.angularVelocity += -60
            
            if GameHandler.sharedInstance.energy < 3 {
                GameHandler.sharedInstance.energy += 1
            }
            
            
            let poofPoint = self.convert(contact.bodyA.node!.position,
                                         from: contact.bodyA.node!.parent!)
            
            if contact.bodyA.node!.name == "Coin3" {
                makeExplosion(poofPoint)
                physicsObjectsToRemove.append(contact.bodyA.node!)
                
            } else {
                makeExplosion(poofPoint)
                physicsObjectsToRemove.append(contact.bodyB.node!)
            }
            
            self.run(SKAction.playSoundFileNamed("touch_mid.wav", waitForCompletion: false))
        }
        // set reaction of flatform and cloud
        else if collision == PhysicsCategory.Deadly | PhysicsCategory.Projectile {
            projectile.physicsBody?.velocity = CGVector(dx: projectile.physicsBody!.velocity.dx, dy: 400)
            //projectile.physicsBody?.angularVelocity += 20
            
            /*
            let poofPoint = self.convert(contact.bodyA.node!.position,
                                         from: contact.bodyA.node!.parent!)

            if contact.bodyA.node!.name == "Deadly" {
                makeCoinPoof(poofPoint)
                physicsObjectsToRemove.append(contact.bodyA.node!)
                
            } else {
                makeCoinPoof(poofPoint)
                physicsObjectsToRemove.append(contact.bodyB.node!)
            }
            */
            self.run(SKAction.playSoundFileNamed("fall.wav", waitForCompletion: false))
        }
            
        else if collision == PhysicsCategory.cloud | PhysicsCategory.Projectile {
            projectile.physicsBody?.velocity = CGVector(dx: projectile.physicsBody!.velocity.dx, dy: 200)
            //projectile.physicsBody?.angularVelocity += 20
            

            self.run(SKAction.playSoundFileNamed("victory.wav", waitForCompletion: false))
        }

        
        else {
            projectile.physicsBody?.velocity = CGVector(dx: projectile.physicsBody!.velocity.dx, dy: projectile.physicsBody!.velocity.dy)
        }
        
    }
}

    

