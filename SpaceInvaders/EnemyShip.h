//
//  EnemyShip.h
//  SpaceInvaders
//
//  Created by M on 11/27/13.
//  Copyright (c) 2013 M. All rights reserved.
//

#import "GameObject.h"
#import "define.h"

@interface EnemyShip : GameObject

@property  float probabilityToShoot;
@property  EnemyMovement enemyMovement;

- (float)increaseScoreAmount;

@end
