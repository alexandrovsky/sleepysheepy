//
//  Wolf.m
//  SleepySheepy
//
//  Created by Dmitry Alexandrovsky on 30.08.14.
//  Copyright (c) 2014 Dmitry Alexandrovsky. All rights reserved.
//

#import "Wolf.h"



@implementation Wolf

@synthesize failTextures;

-(instancetype) init{
    self = [super init];
    if (self) {
        self.name = kWolfName;
        self.color = [SKColor blackColor];
        [self createFailAnimation];
    }
    return self;
}

#pragma mark - FailAnimatable
-(void)createFailAnimation{
    self.failTextures = [NSMutableArray arrayWithCapacity:5];
    for (int i = 1; i <= 5; i++) {
        NSString* textureName = [NSString stringWithFormat:@"blood_c_000%d",i];
        SKTexture* texture = [SKTexture textureWithImageNamed:textureName];
        [self.failTextures addObject:texture];
    }
    for (int i = 1; i <= 5; i++) {
        NSString* textureName = [NSString stringWithFormat:@"blood_d_000%d",i];
        SKTexture* texture = [SKTexture textureWithImageNamed:textureName];
        [self.failTextures addObject:texture];
    }
}

-(void)finishSuccessful:(void (^)(void))successBlock{
    SKSpriteNode* blood = [SKSpriteNode spriteNodeWithTexture:self.failTextures[0]];
    blood.position = self.position;
    [self.parent addChild:blood];
    [blood runAction:[SKAction sequence:@[[SKAction animateWithTextures:self.failTextures timePerFrame:0.1f], [SKAction removeFromParent]]]];
    [super finishSuccessful:successBlock];
}

-(void) finishFail:(void (^)(void))failBlock{
    SKSpriteNode* blood = [SKSpriteNode spriteNodeWithTexture:self.failTextures[0]];
    blood.position = self.position;
    [self.parent addChild:blood];
    [blood runAction:[SKAction sequence:@[[SKAction animateWithTextures:self.failTextures timePerFrame:0.1f], [SKAction removeFromParent]]]];
    [super finishFail:failBlock];
    
}

-(NSInteger)getPoints{
    return kScoreIncrement;
}

@end
