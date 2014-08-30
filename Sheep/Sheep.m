//
//  Sheep.m
//  SleepySheepy
//
//  Created by Dmitry Alexandrovsky on 30.08.14.
//  Copyright (c) 2014 Dmitry Alexandrovsky. All rights reserved.
//

#import "Sheep.h"

@implementation Sheep
-(instancetype)init{
    self = [super init];
    if (self) {
        self.name = kSheepName;
        self.actionSound = [SKAction playSoundFileNamed:@"baalamb1.wav" waitForCompletion:NO];
    }
    return self;
}
@end
