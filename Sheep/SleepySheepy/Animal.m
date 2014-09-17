//
//  Animal.m
//  Sheep2
//
//  Created by Dmitry Alexandrovsky on 16.09.14.
//  Copyright (c) 2014 Dmitry Alexandrovsky. All rights reserved.
//

#import "Animal.h"
#import "GameOptions.h"



@implementation Animal


-(instancetype)initWithName:(NSString*)name withColor:(UIColor*)color withSize:(CGSize) size andStartingPosition:(CGPoint)start{
    self = [super initWithColor:color size:size];
    if (self) {
        self.zPosition = 100;
        self.name = name;
        self.physicsBody.allowsRotation = NO;
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
        self.physicsBody.categoryBitMask = CollisionCategoryAnimal;
        self.physicsBody.contactTestBitMask = CollisionCategoryFence;
        self.physicsBody.collisionBitMask = CollisionCategoryFence | CollisionCategoryGround;
        
        [self spawnAtPosition:start];
    }
    return self;
    
}

-(void)spawnAtPosition:(CGPoint)pos{
//    NSLog(@"spawn: %@ pos: %@",self.name, NSStringFromCGPoint(pos));
    self.position = pos;
    self.state = AnimalStateRunning;
    self.isJumping = NO;
}


-(void)update:(NSTimeInterval)deltaTime{
//    NSLog(@"%@ update",self.name);
    switch (self.state) {
        case AnimalStateRunning:
            if (!self.isJumping) {
                self.position = CGPointMake(self.position.x + self.speed * deltaTime,
                                                  self.position.y);
            }
            break;
        case AnimalStateHitFence:
            break;
        case AnimalStateHitGoal:
        default:
            break;
    }
}

-(void) touchedFenceWithFinishBlock:(void(^)(void))finishBlock{
    [self removeAllActions];
    // run animations...
    self.state = AnimalStateHitFence;
    self.isJumping = NO;
    
    if (finishBlock) {
        finishBlock();
    }
}
-(void) touchedGroundWithFinishBlock:(void(^)(void))finishBlock{
    self.isJumping = NO;
    if (finishBlock) {
        finishBlock();
    }
}
-(void) touchedEndpointWithFinishBlock:(void(^)(void))finishBlock{
    [self removeAllActions];
    self.state = AnimalStateHitFence;
    self.isJumping = NO;
    
    
    if (finishBlock) {
        finishBlock();
    }
    
}


-(void) jumpWithImpulse:(CGVector)impulse{
    if (!self.isJumping) {
        self.isJumping = YES;
        [self.physicsBody applyImpulse:impulse];
    }
    
}

@end
