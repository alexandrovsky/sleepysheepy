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

-(void) resetScene;
-(void) closeSceneWithGameStats:(NSDictionary*)stats;
@end

@interface GameScene : SKScene<SKPhysicsContactDelegate>
@property(nonatomic, weak)id<GameSceneDelegate> gameDelegate;
-(void)didBeginContact:(SKPhysicsContact *)contact;
@end
