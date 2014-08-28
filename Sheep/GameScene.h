//
//  GameScene.h
//  Sheep
//
//  Created by Dmitry Alexandrovsky on 26.08.14.
//  Copyright (c) 2014 Dmitry Alexandrovsky. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#define kFloorCategory      1
#define kFenceCategory      2
#define kAnimalCategory     4
#define kGoalCategory       8

#define kSheepName          @"sheep"
#define kWolfName           @"wolf"
#define kFenceName          @"fence"
#define kFloorName          @"floor"
#define kGoalName           @"goal"
#define kLifeName           @"life"

#define kScoreIncrement     10
#define kWolfProbability    5
#define kInitLifes          3
@interface GameScene : SKScene

@property (nonatomic, strong) SKSpriteNode* fence;
@property (atomic, strong) SKSpriteNode* animal;
@property (nonatomic, strong) SKSpriteNode* goal;

@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) NSUInteger level;
@property (nonatomic, assign) CGFloat speed;



- (SKSpriteNode*) createAnimal;

-(void) incrementScore;
-(void) decrementScore;
-(void) invalidateAnimal;

@end
