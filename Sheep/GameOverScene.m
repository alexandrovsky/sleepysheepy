//
//  GameOverScene.m
//  SleepySheepy
//
//  Created by Dmitry Alexandrovsky on 28.08.14.
//  Copyright (c) 2014 Dmitry Alexandrovsky. All rights reserved.
//

#import "GameOverScene.h"
#import "GameScene.h"
@implementation GameOverScene

-(instancetype)initWithScore:(NSInteger) score andSize:(CGSize)size{
    self = [self initWithSize:size];
    if (self) {
        self.score = [self createScore:score];
        [self addChild:self.score];
    }
    
    return  self;
}
-(instancetype)initWithSize:(CGSize)size{
    self = [super initWithSize:size];
    if (self) {
        self.replay = [self createReplayButton];
        [self addChild:self.replay];
    }
    return  self;
}

-(SKSpriteNode*) createReplayButton{
    SKSpriteNode* replay = [SKSpriteNode spriteNodeWithColor:[SKColor blueColor] size:CGSizeMake(100, 60)];
    replay.name = kReplayName;
    replay.anchorPoint = CGPointMake(0.5f, 0.5f);
    replay.position = CGPointMake(self.size.width/2, self.size.height/2);
    return  replay;
}

-(SKLabelNode*)createScore:(NSInteger) scoreValue{
    SKLabelNode* score = [[SKLabelNode alloc] initWithFontNamed:@"Arial"];
    score.text = [NSString stringWithFormat: @"Score: %ld",(long)scoreValue];
    score.position = CGPointMake(self.size.width/2, self.size.height * 0.8f);
    return  score;
}


@end
