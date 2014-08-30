//
//  GameScene.h
//  Sheep
//
//  Created by Dmitry Alexandrovsky on 26.08.14.
//  Copyright (c) 2014 Dmitry Alexandrovsky. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Animal.h"

@interface GameScene : SKScene


@property (nonatomic, strong) NSMutableArray* fences;
@property (atomic, strong) Animal* animal;
@property (nonatomic, strong) SKSpriteNode* goal;

@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) NSUInteger level;
@property (nonatomic, assign) CGFloat speed;



- (Animal*) createAnimal;

-(void) incrementScore;
-(void) decrementScore;


@end
