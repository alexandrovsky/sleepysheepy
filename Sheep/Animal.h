//
//  Animal.h
//  SleepySheepy
//
//  Created by Dmitry Alexandrovsky on 30.08.14.
//  Copyright (c) 2014 Dmitry Alexandrovsky. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>


@protocol FailAnimatable <NSObject>

@property(nonatomic, strong) NSMutableArray* failTextures;
-(void)createFailAnimation;
@end


@protocol Physical <NSObject>
@property (nonatomic,strong)NSMutableArray* joints;
@property (nonatomic,strong)NSMutableArray* bones;
-(void) createPhysics;

@end




@interface Animal : SKSpriteNode
@property (nonatomic, strong) SKAction* actionMove;
@property (nonatomic, strong) SKAction* actionInvalidate;
@property (nonatomic, strong) SKAction* actionSound;
@property (nonatomic, readonly, getter = getPoints) NSInteger points;
@property (nonatomic, assign, getter = isValid) BOOL valid;


-(SKPhysicsBody*) createPhysicsBodyWithSize:(CGSize)size;

-(void) move;
//-(void) invalidate;
-(void) finishSuccessful:(void (^)(void))successBlock;
-(void) finishFail:(void (^)(void))failBlock;
@end
