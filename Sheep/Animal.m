//
//  Animal.m
//  SleepySheepy
//
//  Created by Dmitry Alexandrovsky on 30.08.14.
//  Copyright (c) 2014 Dmitry Alexandrovsky. All rights reserved.
//

#import "Animal.h"

@implementation Animal


-(instancetype)init{
    self = [super initWithColor:[SKColor whiteColor] size:CGSizeMake(60, 80)];
    if (self) {

        self.anchorPoint = CGPointMake(0.5f, 0.5f);
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.dynamic = YES;
        self.physicsBody.categoryBitMask = kAnimalCategory;
        self.physicsBody.contactTestBitMask = kFenceCategory;
        self.physicsBody.collisionBitMask = kFloorCategory | kFenceCategory;
        self.physicsBody.affectedByGravity = YES;
        
        self.valid = YES;
        
        SKAction* invalidBlock =[SKAction runBlock:^{
            self.valid = NO;
        }];
        
        self.actionInvalidate = [SKAction sequence:@[invalidBlock, [SKAction removeFromParent]]];
//        self.actionFinishSuccessful = [SKAction performSelector:@selector(finishSuccessful) onTarget:self];
//        self.actionFinishFail = [SKAction performSelector:@selector(finishFail) onTarget:self];
    }
    return  self;
}


-(void) move{
    [self runAction:[SKAction sequence:@[self.actionMove, self.actionInvalidate]]];
}

-(void) invalidate{
}

-(void) finishSuccessful:(void (^)(void))successBlock{
    [self runAction:[SKAction sequence:@[//self.actionFinishSuccessful,
                                         [SKAction runBlock:successBlock],
                                         self.actionInvalidate]]];
}

-(void) finishFail:(void (^)(void))failBlock{
    [self runAction:[SKAction sequence:@[//self.actionFinishFail,
                                         [SKAction runBlock:failBlock],
                                         self.actionInvalidate]]];
}

-(NSInteger)getPoints{
    return kScoreIncrement;
}
@end
