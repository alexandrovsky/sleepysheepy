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
        self.physicsBody = [self createPhysicsBodyWithSize:self.size];
        
        self.valid = YES;
        
        SKAction* invalidBlock =[SKAction runBlock:^{
            self.valid = NO;
        }];
        
        self.actionInvalidate = [SKAction sequence:@[invalidBlock, [SKAction removeFromParent]]];
    }
    return  self;
}



-(SKPhysicsBody*) createPhysicsBodyWithSize:(CGSize)size{
    SKPhysicsBody* physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    physicsBody.dynamic = YES;
    physicsBody.categoryBitMask = kAnimalCategory;
    physicsBody.contactTestBitMask = kFenceCategory;
    physicsBody.collisionBitMask = kFloorCategory | kFenceCategory;
    physicsBody.affectedByGravity = YES;
    
    return physicsBody;
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
