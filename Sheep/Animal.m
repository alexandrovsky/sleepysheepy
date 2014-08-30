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
//        self.position = CGPointMake(20, self.floor.size.height + 20);
        
//        self.actionMove = [SKAction moveToX:self.frame.size.width duration:5.0f/self.speed];
        self.actionMoveDone = [SKAction removeFromParent];
    }
    return  self;
}


-(void) move{
    [self runAction:[SKAction sequence:@[self.actionMove, self.actionMoveDone]]];
}

-(void) invalidate{
    [self removeFromParent];
}
-(NSInteger)getPoints{
    return kScoreIncrement;
}
@end
