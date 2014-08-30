//
//  Wolf.m
//  SleepySheepy
//
//  Created by Dmitry Alexandrovsky on 30.08.14.
//  Copyright (c) 2014 Dmitry Alexandrovsky. All rights reserved.
//

#import "Wolf.h"

@implementation Wolf

-(instancetype) init{
    self = [super init];
    if (self) {
        self.name = kWolfName;
        self.color = [SKColor blackColor];
    }
    return self;
}

-(NSInteger)getPoints{
    return -kScoreIncrement;
}

@end
