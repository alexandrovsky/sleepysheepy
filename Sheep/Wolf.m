//
//  Wolf.m
//  SleepySheepy
//
//  Created by Dmitry Alexandrovsky on 30.08.14.
//  Copyright (c) 2014 Dmitry Alexandrovsky. All rights reserved.
//

#import "Wolf.h"

@interface Wolf()

@property(nonatomic, strong) NSMutableArray* bloodTextures;

@end


@implementation Wolf

-(instancetype) init{
    self = [super init];
    if (self) {
        self.name = kWolfName;
        self.color = [SKColor blackColor];
        [self createBloodAnimation];
    }
    return self;
}


-(void)createBloodAnimation{
    self.bloodTextures = [NSMutableArray arrayWithCapacity:5];
    for (int i = 1; i <= 5; i++) {
        NSString* textureName = [NSString stringWithFormat:@"blood_c_000%d",i];
        SKTexture* texture = [SKTexture textureWithImageNamed:textureName];
        [self.bloodTextures addObject:texture];
    }
    for (int i = 1; i <= 5; i++) {
        NSString* textureName = [NSString stringWithFormat:@"blood_d_000%d",i];
        SKTexture* texture = [SKTexture textureWithImageNamed:textureName];
        [self.bloodTextures addObject:texture];
    }
}

-(void)finishSuccessful:(void (^)(void))successBlock{
    [super finishSuccessful:successBlock];
}

-(void) finishFail:(void (^)(void))failBlock{
    SKSpriteNode* blood = [SKSpriteNode spriteNodeWithTexture:self.bloodTextures[0]];
    blood.position = self.position;
    [self.parent addChild:blood];
    [blood runAction:[SKAction sequence:@[[SKAction animateWithTextures:self.bloodTextures timePerFrame:0.1f], [SKAction removeFromParent]]]];
    [super finishFail:failBlock];
    
}

-(NSInteger)getPoints{
    return kScoreIncrement;
}

@end
