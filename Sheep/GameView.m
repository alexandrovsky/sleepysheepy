//
//  GameView.m
//  Sheep
//
//  Created by Dmitry Alexandrovsky on 26.08.14.
//  Copyright (c) 2014 Dmitry Alexandrovsky. All rights reserved.
//

#import "GameView.h"
#import "GameScene.h"
#import "GameOverScene.h"
#import "Animal.h"

@interface GameView ()
@property (nonatomic, weak) SKNode* touchedNode;
@end

@implementation GameView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        self.showsFPS = YES;
        self.showsPhysics = YES;
        self.showsNodeCount = YES;

    }
    return self;
}

-(void)didMoveToWindow{
    self.swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                           action:@selector(handleSwipe:)];
    self.swipe.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:self.swipe];
}

#pragma mark - Handle touch

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self.scene];
    self.touchedNode = [self.scene nodeAtPoint:positionInScene];
    
    if([self.scene isKindOfClass:GameScene.class]){
        if (self.touchedNode.physicsBody.categoryBitMask == kAnimalCategory) {
            NSLog(@"node %@ touched!!!", self.touchedNode.name);
        }
    }else if([self.scene isKindOfClass:GameOverScene.class]){
        if ([self.touchedNode.name isEqualToString:kReplayName] ) {
            GameScene* gs = [[GameScene alloc] initWithSize:self.frame.size];
            [self presentScene:gs];
            gs.physicsWorld.contactDelegate = self;
        }
    }
    
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.touchedNode = nil;
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    self.touchedNode = nil;
}


#pragma mark - UIGestureRecognizerDelegate

-(void)handleSwipe:(UISwipeGestureRecognizer*)recognizer{
    if (self.touchedNode &&  self.touchedNode.physicsBody.categoryBitMask == kAnimalCategory) {
        NSLog(@"node %@ swiped!!!", self.touchedNode.name);
        [self.touchedNode.physicsBody applyImpulse:CGVectorMake(0.0f, 150.0f)];
    }
}


#pragma mark -- SKPhysicsContactDelegate
-(void)didBeginContact:(SKPhysicsContact *)contact{
    
    SKPhysicsBody* animal = nil;
    SKPhysicsBody* fence = nil;
    SKPhysicsBody* goal = nil;
    
    uint32_t bitmask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask;
    
    if (bitmask == (kAnimalCategory | kFenceCategory)) {
        if (contact.bodyA.categoryBitMask == kAnimalCategory) {
            animal = contact.bodyA;
            if (contact.bodyB.categoryBitMask == kFenceCategory) {
                fence = contact.bodyB;
            }
        }else if (contact.bodyB.categoryBitMask == kAnimalCategory) {
            animal = contact.bodyB;
            if (contact.bodyA.categoryBitMask == kFenceCategory) {
                fence = contact.bodyA;
            }
        }
        [self animal:animal didContactFence:fence];
    }else if (bitmask == (kAnimalCategory | kGoalCategory)){
        if (contact.bodyA.categoryBitMask == kAnimalCategory) {
            animal = contact.bodyA;
            if (contact.bodyB.categoryBitMask == kGoalCategory) {
                goal = contact.bodyB;
            }
        }else if (contact.bodyB.categoryBitMask == kAnimalCategory) {
            animal = contact.bodyB;
            if (contact.bodyA.categoryBitMask == kGoalCategory) {
                goal = contact.bodyA;
            }
        }
        [self animal:animal didContactGoal:goal];
    }
    
}


-(void) animal:(SKPhysicsBody*)animal didContactFence:(SKPhysicsBody*) fence{
    
    GameScene* gs = (GameScene*)self.scene;
    Animal* a = (Animal*)(animal.node);
    if ([a.name isEqualToString:kSheepName] ) {
        [a finishFail:^{
            if ([gs respondsToSelector:@selector(decrementScore)]) {
                [gs decrementScore];
            }
        }];
        
    }else if([a.name isEqualToString:kWolfName] ) {
        [a finishSuccessful:^{
            if ([gs respondsToSelector:@selector(incrementScore)]) {
                [gs incrementScore];
            }
        }];
    }
}

-(void) animal:(SKPhysicsBody*)animal didContactGoal:(SKPhysicsBody*) goal{
    GameScene* gs = (GameScene*)self.scene;
    Animal* a = (Animal*)(animal.node);
    if ([a.name isEqualToString:kSheepName] ) {
        [a finishSuccessful:^{
            [gs incrementScore];
        }];
        
    }else if([a.name isEqualToString:kWolfName] ) {
        [a finishFail:^{
            [gs decrementScore];
        }];
        
    }
}

-(void)didEndContact:(SKPhysicsContact *)contact{
}

@end
