//
//  GameView.h
//  Sheep
//
//  Created by Dmitry Alexandrovsky on 26.08.14.
//  Copyright (c) 2014 Dmitry Alexandrovsky. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameView : SKView <UIGestureRecognizerDelegate , SKPhysicsContactDelegate>
@property (nonatomic, strong) UISwipeGestureRecognizer* swipe;

-(void) animal:(SKPhysicsBody*)animal didContactFence:(SKPhysicsBody*) fence;
-(void) animal:(SKPhysicsBody*)animal didContactGoal:(SKPhysicsBody*) goal;
@end
