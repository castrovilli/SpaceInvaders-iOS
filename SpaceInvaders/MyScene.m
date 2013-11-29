//
//  MyScene.m
//  SpaceInvaders
//
//  Created by M on 11/26/13.
//  Copyright (c) 2013 M. All rights reserved.
//

#import "MyScene.h"
#import "Upgrade.h"

@implementation MyScene
{
    //Game Objects
    SpaceShip *_spaceShip;
    float _score;
    NSArray  *upgrades;
    BOOL automaticShooting;
}
-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        
        //there is no gravity in space...
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        /* Setup your scene here */
        automaticShooting=YES;
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        _gameRunning=YES;
        _layerEnemiesNode=[SKNode new];
        [self addChild:_layerEnemiesNode];
        _layerPlayerNode = [SKNode new];
        [self addChild:_layerPlayerNode];
        _layerSpaceShipBulletsNode = [SKNode new];
        [self addChild:_layerSpaceShipBulletsNode];
       
        _spaceShip = [[SpaceShip alloc] initWithPosition:CGPointMake((self.size.width / 2), 120)];
        //spaceShip.position here will return the correct position;
        [_layerPlayerNode addChild:_spaceShip];
        
        [self level1];
     
        upgrades = [NSArray arrayWithObjects:[NSNumber numberWithInt:UpgradeAutomaticShooting], nil];
        [self evaluateUpdates];
        
    }
    return self;
}

-(void) level1
{
    //Setup the enemies from top
    SKAction *spawnEnemiesAction1 = [SKAction performSelector:@selector(addXRuserEnemy) onTarget:self];
    SKAction *waitAction1 = [SKAction waitForDuration:1 withRange:3];
    SKAction *firstWave = [SKAction repeatAction:[SKAction sequence:@[spawnEnemiesAction1, waitAction1]] count:20];
    
    SKAction *waitActionBetweenWaves = [SKAction waitForDuration:2];
    
    //Setup up the enemies from left
    SKAction *spawnEnemiesAction2 = [SKAction performSelector:@selector(addXRuserEnemyArc) onTarget:self];
    SKAction *waitAction2 = [SKAction waitForDuration:1 withRange:3];
    SKAction *secondWave =[SKAction repeatAction:[SKAction sequence:@[spawnEnemiesAction2, waitAction2]] count:15];
    
    //Setup the enemies from top and left
    SKAction *thirdWave =[SKAction repeatAction:[SKAction sequence:@[spawnEnemiesAction1, waitAction1,spawnEnemiesAction2, waitAction2]] count:10];
    
    [self runAction:[SKAction sequence:@[firstWave ,waitActionBetweenWaves, secondWave,waitActionBetweenWaves, thirdWave]]];
}

-(void) evaluateUpdates
{
    //do something with upgrades
}

-(void) addRandomEnemy
{
    [_layerEnemiesNode addChild:[EnemyFactory CreateRandomEnemy]];
}

-(void) addXRuserEnemy
{
    [_layerEnemiesNode addChild:[EnemyFactory CreateEnemies:EnemyTypeXRuser AndTheMovement:EnemyMovementNormal]];
}

-(void) addXRuserEnemyArc
{
    [_layerEnemiesNode addChild:[EnemyFactory CreateEnemies:EnemyTypeXRuser AndTheMovement:EnemyMovementArc]];
}

-(void) addXTroyerEnemy
{
    [_layerEnemiesNode addChild:[EnemyFactory CreateEnemies:EnemyTypeXTroyer AndTheMovement:EnemyMovementNormal]];
}

-(void) addXStarEnemy
{
    [_layerEnemiesNode addChild:[EnemyFactory CreateEnemies:EnemyTypeXStar AndTheMovement:EnemyMovementNormal]];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    CGPoint p=_spaceShip.position;
    p.y+=10;

    SpaceShipBullet *bullet = [[SpaceShipBullet alloc]initWithPosition:p];
    [bullet runAction:[self normalBulletAction]];
    [_layerSpaceShipBulletsNode addChild:bullet];
}


-(SKAction *) normalBulletAction
{
    //Move the bullet down the screen and remove it when it is of screen
    SKAction *moveAction = [SKAction moveToY:1000 duration:8];//TODO set appropiate numbers (duration and moveTo handle ultamately the speed.. .. used for the upgrade for ex)
    SKAction *removeBullet= [SKAction removeFromParent];
    SKAction *bulletSequence = [SKAction sequence:@[moveAction, removeBullet]];
    return bulletSequence;
}


- (void)didBeginContact:(SKPhysicsContact *)contact {
    
    if(_gameRunning) {
        
        SKNode *contactNode1 = contact.bodyA.node;
        SKNode *contactNode2 = contact.bodyB.node;
        if([contactNode1 isKindOfClass:[GameObject class]]) {
            [(GameObject *)contactNode1 collidedWith:contact.bodyB contact:contact];
        }
        if([contactNode2 isKindOfClass:[GameObject class]]) {
            [(GameObject *)contactNode2 collidedWith:contact.bodyA contact:contact];
        }
    }
}

- (void)didEndContact:(SKPhysicsContact *)contact
{    
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
