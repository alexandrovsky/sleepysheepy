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
    
    SKPhysicsBody* sheep = nil;
    SKPhysicsBody* fence = nil;
    
    if (contact.bodyA.categoryBitMask == kSheepCategory) {
        sheep = contact.bodyA;
        if (contact.bodyB.categoryBitMask == kFenceCategory) {
            fence = contact.bodyB;
        }
        
    }else if (contact.bodyB.categoryBitMask == kSheepCategory) {
        sheep = contact.bodyB;
        if (contact.bodyA.categoryBitMask == kFenceCategory) {
            fence = contact.bodyA;
        }
    }
    
    if (sheep && fence){
        [sheep.node removeAllActions];
        [sheep.node removeFromParent];
        
        [self.gameScene.sheep removeFromParent];
        self.gameScene.sheep = [self.gameScene createSheep];
        [self.gameScene addChild:self.gameScene.sheep];
    }
}

-(void)didEndContact:(SKPhysicsContact *)contact{
}


@end
