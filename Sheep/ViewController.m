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
    
    self.gameScene.physicsWorld.contactDelegate = self.gameView;
    
	// Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
