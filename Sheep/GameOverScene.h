//
//  GameOverScene.h
//  SleepySheepy
//
//  Created by Dmitry Alexandrovsky on 28.08.14.
//  Copyright (c) 2014 Dmitry Alexandrovsky. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#define kReplayName @"replay"

@interface GameOverScene : SKScene
@property (nonatomic, strong) SKLabelNode* score;
@property (nonatomic, strong) SKLabelNode* gameOver;
@property (nonatomic, strong) SKSpriteNode* replay;

-(instancetype)initWithScore:(NSInteger) score andSize:(CGSize)size;

@end
