//
//  ViewController.h
//  Sheep
//
//  Created by Dmitry Alexandrovsky on 26.08.14.
//  Copyright (c) 2014 Dmitry Alexandrovsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>


@class GameView;
@interface ViewController : UIViewController
@property (nonatomic, strong) GameView* gameView;
@end
