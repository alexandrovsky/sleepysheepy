//
//  GameScene.m
//  Sheep
//
//  Created by Dmitry Alexandrovsky on 26.08.14.
//  Copyright (c) 2014 Dmitry Alexandrovsky. All rights reserved.
//

#import "GameScene.h"



@interface GameScene ()
@property (nonatomic, strong) SKSpriteNode* floor;
@property (nonatomic, strong) SKLabelNode* scoreNode;


@end

@implementation GameScene


-(instancetype)initWithSize:(CGSize)size{
    self = [super initWithSize:size];
    if (self) {
        
        
        
        
        self.level = 1;
        self.speed = 1;
        self.backgroundColor = [SKColor colorWithRed:0.4f green:0.6f blue:0.8f alpha:1.0f];
        self.physicsWorld.gravity = CGVectorMake(0.0f, -4.8f);
//        self.scaleMode = SKSceneScaleModeAspectFill;
        
        self.floor = [self createFloor];
        [self addChild:self.floor];
        
        self.fence = [self createFence];
        [self addChild:self.fence];
        
        self.sheep  = [self createSheep];
        [self addChild:self.sheep];
        
        self.scoreNode = [self createScore];
        [self addChild:self.scoreNode];
        
    }
    return self;
}


- (SKSpriteNode*)createFloor {
    SKSpriteNode *floor = [SKSpriteNode spriteNodeWithColor:[SKColor brownColor] size:(CGSize){self.frame.size.width+40, 80}];
    [floor setAnchorPoint:(CGPoint){0, 0}];
    [floor setName:@"floor"];
    [floor setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:floor.frame]];
    floor.physicsBody.dynamic = NO;
    floor.physicsBody.categoryBitMask = kFloorCategory;
    floor.physicsBody.contactTestBitMask = kSheepCategory;
    floor.physicsBody.collisionBitMask = 0;
    floor.position = CGPointMake(-40, 0);
    return floor;
}


- (SKSpriteNode*)createFence {
    SKSpriteNode *fence = [SKSpriteNode spriteNodeWithColor:[SKColor yellowColor] size:(CGSize){20, 60}];
    [fence setAnchorPoint:(CGPoint){0, 0}];
    [fence setName:@"fence"];
    [fence setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:fence.frame]];
    fence.physicsBody.dynamic = NO;
    fence.physicsBody.categoryBitMask = kFenceCategory;
    fence.physicsBody.contactTestBitMask = kSheepCategory;
    fence.physicsBody.collisionBitMask = kFloorCategory;
    fence.position = CGPointMake(self.frame.size.width/2, self.floor.size.height);
    return fence;
}



-(SKSpriteNode*) createSheep{
    SKSpriteNode *sheep = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:(CGSize){60, 80}];
    [sheep setAnchorPoint:(CGPoint){0.5f, 0.5f}];
    [sheep setName:@"sheep"];
    [sheep setPhysicsBody:[SKPhysicsBody bodyWithRectangleOfSize:sheep.size]];
    sheep.physicsBody.dynamic = YES;
    sheep.physicsBody.categoryBitMask = kSheepCategory;
    sheep.physicsBody.contactTestBitMask = kFenceCategory;
    sheep.physicsBody.collisionBitMask = kFloorCategory | kFenceCategory;
    sheep.physicsBody.affectedByGravity = YES;
    sheep.position = CGPointMake(20, self.floor.size.height + 20);
    
    SKAction* actionMove = [SKAction moveToX:self.frame.size.width duration:5.0f/self.speed];
    SKAction* actionMoveDone = [SKAction removeFromParent];
    [sheep runAction:[SKAction sequence:@[actionMove, actionMoveDone]] completion:^{
        [self incrementScore];
        self.sheep = [self createSheep];
        [self addChild:self.sheep];
    }];
    
    return sheep;
}

-(SKLabelNode*)createScore{
    SKLabelNode* score = [[SKLabelNode alloc] initWithFontNamed:@"Arial"];
    score.fontSize = 36;
    score.fontColor = [SKColor grayColor];
    score.text = [NSString stringWithFormat:@"%d", self.score];
    score.position = CGPointMake(self.frame.size.width*0.8, self.frame.size.height*0.8);
    return score;
}

-(void) incrementScore{
    self.score += kScoreIncrement * self.level;
    self.scoreNode.text = [NSString stringWithFormat:@"%d", self.score];
    
//    if (self.score > self.level * 10) {
//        self.level++;
//        self.speed+= 0.2f;
//    }
}



@end
