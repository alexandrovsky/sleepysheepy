//
//  GameScene.h
//  Sheep
//
//  Created by Dmitry Alexandrovsky on 26.08.14.
//  Copyright (c) 2014 Dmitry Alexandrovsky. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#define kFloorCategory 1
#define kFenceCategory 2
#define kSheepCategory 4


#define kScoreIncrement 10


@interface GameScene : SKScene

@property (nonatomic, strong) SKSpriteNode* fence;
@property (nonatomic, strong) SKSpriteNode* sheep;

@property (nonatomic, assign) NSUInteger score;
@property (nonatomic, assign) NSUInteger level;
@property (nonatomic, assign) CGFloat speed;

- (SKSpriteNode*) createFloor;
- (SKSpriteNode*) createFence;
- (SKSpriteNode*) createSheep;

@end
