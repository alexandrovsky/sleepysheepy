//
//  Animal.h
//  SleepySheepy
//
//  Created by Dmitry Alexandrovsky on 30.08.14.
//  Copyright (c) 2014 Dmitry Alexandrovsky. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Animal : SKSpriteNode
@property (nonatomic, strong) SKAction* actionMove;
@property (nonatomic, strong) SKAction* actionInvalidate;
@property (nonatomic, strong) SKAction* actionSound;
//@property (nonatomic, strong) SKAction* actionFinishSuccessful;
//@property (nonatomic, strong) SKAction* actionFinishFail;
@property (nonatomic, readonly, getter = getPoints) NSInteger points;
@property (nonatomic, assign, getter = isValid) BOOL valid;

-(void) move;
//-(void) invalidate;
-(void) finishSuccessful:(void (^)(void))successBlock;
-(void) finishFail:(void (^)(void))failBlock;
@end
