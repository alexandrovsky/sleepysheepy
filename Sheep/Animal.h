//
//  Animal.h
//  SleepySheepy
//
//  Created by Dmitry Alexandrovsky on 30.08.14.
//  Copyright (c) 2014 Dmitry Alexandrovsky. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Animal : SKSpriteNode
@property (nonatomic, strong) SKAction* actionMove;
@property (nonatomic, strong) SKAction* actionMoveDone;
@property (nonatomic, strong) SKAction* actionSound;
@property (nonatomic, readonly, getter = getPoints) NSInteger points;
-(void) move;
-(void) invalidate;
@end
