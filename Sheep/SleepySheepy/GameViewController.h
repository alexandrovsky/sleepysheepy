//
//  GameViewController.h
//  Sheep2
//

//  Copyright (c) 2014 Dmitry Alexandrovsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"

@interface GameViewController : UIViewController<GameSceneDelegate>
@property (strong, nonatomic) IBOutlet SKView *skView;



-(void) setupScene;
-(void) closeSceneWithGameStats:(NSDictionary*)stats;
@end
