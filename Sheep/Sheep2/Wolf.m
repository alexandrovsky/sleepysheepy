//
//  Wolf.m
//  Sheep2
//
//  Created by Dmitry Alexandrovsky on 16.09.14.
//  Copyright (c) 2014 Dmitry Alexandrovsky. All rights reserved.
//

#import "Wolf.h"

@implementation Wolf
-(instancetype)initWithSize:(CGSize) size andStartingPosition:(CGPoint)start{
    self = [super initWithName:@"wolf" withColor:[SKColor blackColor] withSize:size andStartingPosition:start];
    
    return self;
}
@end
