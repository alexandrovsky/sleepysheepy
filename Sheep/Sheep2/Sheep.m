//
//  Sheep.m
//  Sheep2
//
//  Created by Dmitry Alexandrovsky on 16.09.14.
//  Copyright (c) 2014 Dmitry Alexandrovsky. All rights reserved.
//

#import "Sheep.h"

@implementation Sheep
-(instancetype)initWithSize:(CGSize) size andStartingPosition:(CGPoint)start{
    self = [super initWithName:@"sheep" withColor:[SKColor whiteColor] withSize:size andStartingPosition:start];
    
    return self;
}
@end
