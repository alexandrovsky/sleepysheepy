//
//  Animal.h
//  Sheep2
//
//  Created by Dmitry Alexandrovsky on 16.09.14.
//  Copyright (c) 2014 Dmitry Alexandrovsky. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_OPTIONS(NSUInteger, AnimalState) {
    AnimalStateRunning      = 1 << 0,
    AnimalStateHitFence     = 1 << 1,
    AnimalStateHitGoal      = 1 << 2,
};


@interface Animal : SKSpriteNode
@property (nonatomic,assign) AnimalState state;
@property (nonatomic,assign) BOOL isJumping;
@property (nonatomic,assign) CGFloat speed;
@property (nonatomic,assign) CGFloat jumpHeight;

-(instancetype)initWithName:(NSString*)name withColor:(UIColor*)color withSize:(CGSize) size andStartingPosition:(CGPoint)start;

-(void)spawnAtPosition:(CGPoint)pos;
-(void)update:(NSTimeInterval)deltaTime;


-(void) touchedFenceWithFinishBlock:(void(^)(void))finishBlock;
-(void) touchedGroundWithFinishBlock:(void(^)(void))finishBlock;
-(void) touchedEndpointWithFinishBlock:(void(^)(void))finishBlock;

-(void) jumpWithImpulse:(CGVector)impulse;


@end
