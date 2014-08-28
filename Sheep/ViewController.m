//
//  ViewController.m
//  Sheep
//
//  Created by Dmitry Alexandrovsky on 26.08.14.
//  Copyright (c) 2014 Dmitry Alexandrovsky. All rights reserved.
//

#import "ViewController.h"
#import "GameView.h"
#import "GameScene.h"

@interface ViewController ()
@property (nonatomic, strong) GameView* gameView;
@property (nonatomic, strong) GameScene* gameScene;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.gameView = [[GameView alloc]initWithFrame: CGRectMake(0.0f,
                                                               0.0f,
                                                               self.view.bounds.size.height,
                                                               self.view.bounds.size.width)];
    [self.view addSubview:self.gameView];
    self.gameScene = [[GameScene alloc]initWithSize:self.gameView.bounds.size];
    [self.gameView presentScene:self.gameScene];
    
    self.gameScene.physicsWorld.contactDelegate = self;
    
	// Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    
    if ([animal.node.name isEqualToString:kSheepName] ) {
        [self.gameScene decrementScore];
    }else if([animal.node.name isEqualToString:kWolfName] ) {
        [self.gameScene incrementScore];
    }
    
    [self.gameScene invalidateAnimal];

}

-(void) animal:(SKPhysicsBody*)animal didContactGoal:(SKPhysicsBody*) goal{
    
    if ([animal.node.name isEqualToString:kSheepName] ) {
        [self.gameScene incrementScore];
    }else if([animal.node.name isEqualToString:kWolfName] ) {
        [self.gameScene decrementScore];
    }
    
    [self.gameScene invalidateAnimal];
}

-(void)didEndContact:(SKPhysicsContact *)contact{
}


@end
