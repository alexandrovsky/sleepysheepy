//
//  GameScene.h
//  Sheep2
//

//  Copyright (c) 2014 Dmitry Alexandrovsky. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

static NSString* const GameCloseOptionFinish = @"GameCloseOptionFinish";
static NSString* const GameCloseOptionPause = @"GameCloseOptionPause";

@protocol GameSceneDelegate <NSObject>

-(void) setupScene;
-(void) closeSceneWithGameStats:(NSDictionary*)stats;
@end

@interface GameScene : SKScene<SKPhysicsContactDelegate>
@property (nonatomic, assign) NSUInteger score;
@property(nonatomic, weak)id<GameSceneDelegate> gameDelegate;
-(void)didBeginContact:(SKPhysicsContact *)contact;
-(void) reset;
@end
