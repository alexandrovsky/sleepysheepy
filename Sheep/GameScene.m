//
//  GameScene.m
//  Sheep
//
//  Created by Dmitry Alexandrovsky on 26.08.14.
//  Copyright (c) 2014 Dmitry Alexandrovsky. All rights reserved.
//

#import "GameScene.h"
#import "GameOverScene.h"
#import "Sheep.h"
#import "Wolf.h"

@interface GameScene ()
@property (nonatomic, strong) SKSpriteNode* floor;
@property (nonatomic, strong) SKLabelNode* scoreNode;
@property (nonatomic, strong) SKLabelNode* levelNode;
@property (nonatomic, assign) CFTimeInterval lastUpdate;
@property (nonatomic, strong) NSMutableArray* lifeNodes;
@property (nonatomic, assign) BOOL incrementFlag;

@end

@implementation GameScene


-(instancetype)initWithSize:(CGSize)size{
    self = [super initWithSize:size];
    if (self) {
        
        
        self.level = 1;
        self.speed = kInitSpeed;

        self.backgroundColor = [SKColor colorWithRed:0.4f green:0.6f blue:0.8f alpha:1.0f];
        self.physicsWorld.gravity = CGVectorMake(0.0f, -9.8f);
//        self.scaleMode = SKSceneScaleModeAspectFill;
        
        self.floor = [self createFloor];
        [self addChild:self.floor];
        
        self.fences = [self createFencesWithCount:0];
        [self.fences enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self addChild:(SKNode*)obj];
        }];
        
        
        self.scoreNode = [self createScore];
        [self addChild:self.scoreNode];
        
        
        self.levelNode = [self createLevel];
        [self addChild:self.levelNode];
        
        self.goal = [self createGoal];
        [self addChild:self.goal];
        
        [self createLives];

        
    }
    return self;
}



- (SKSpriteNode*)createFloor {
    SKSpriteNode *floor = [SKSpriteNode spriteNodeWithColor:[SKColor brownColor] size:(CGSize){self.frame.size.width+40, 80}];
    [floor setAnchorPoint:(CGPoint){0, 0}];
    [floor setName:kFloorName];
    [floor setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:floor.frame]];
    floor.physicsBody.dynamic = NO;
    floor.physicsBody.categoryBitMask = kFloorCategory;
    floor.physicsBody.contactTestBitMask = kAnimalCategory;
    floor.physicsBody.collisionBitMask = 0;
    floor.position = CGPointMake(-40, 0);
    return floor;
}

-(NSMutableArray*)createFencesWithCount:(NSInteger)count{
    NSInteger oldCount = 0;
    if (self.fences) {
        oldCount = self.fences.count;
        [self.fences enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [(SKNode*)obj removeFromParent];
        }];
    }

    NSMutableArray* fences = [NSMutableArray array];
    if (count == 0) {
        SKSpriteNode* fence = [self createFence];
        fence.position = CGPointMake(self.frame.size.width/2, self.floor.size.height);
        [fences addObject:fence];
    }else{
        float xstart = self.floor.size.width*0.3f;
        float xstep = self.floor.size.width*0.6f / count;
        for (int i = 0; i < count; i++) {
            SKSpriteNode* fence = [self createFence];
            fence.position = CGPointMake(xstart+xstep*i, self.floor.size.height);
            [fences addObject:fence];
        }
    }
    
    
    return fences;
}

- (SKSpriteNode*)createFence {
    SKSpriteNode *fence = [SKSpriteNode spriteNodeWithColor:[SKColor yellowColor] size:(CGSize){20, 60}];
    [fence setAnchorPoint:(CGPoint){0, 0}];
    [fence setName:kFenceName];
    [fence setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:fence.frame]];
    fence.physicsBody.dynamic = NO;
    fence.physicsBody.categoryBitMask = kFenceCategory;
    fence.physicsBody.contactTestBitMask = kAnimalCategory;
    fence.physicsBody.collisionBitMask = kFloorCategory;
    
    return fence;
}

-(Animal*)createAnimal{

    if (self.animal) {
        [self.animal removeFromParent];

        self.animal = nil;
    }
    uint32_t rnd = arc4random_uniform(kWolfProbability);
    if ((rnd % kWolfProbability) == 0){
        self.animal = [self createWolf];
    }else{
        self.animal =  [self createSheep];
    }

    
    [self addChild:self.animal];
    
    self.animal.actionMove = [SKAction moveToX:self.frame.size.width duration:5.0f/self.speed];
    self.animal.position = CGPointMake(20, self.floor.size.height + 20);
    [self.animal move];
    
    
    
    return self.animal;
}

-(Sheep*) createSheep{
    Sheep* sheep = [[Sheep alloc] init];
    return sheep;
}

-(Wolf*) createWolf{
    Wolf* wolf = [[Wolf alloc] init];
    return wolf;
}

-(SKSpriteNode*) createGoal{
    SKSpriteNode* goal = [SKSpriteNode spriteNodeWithColor:[SKColor blueColor] size:CGSizeMake(40, 80)];
    [goal setAnchorPoint:CGPointMake(0.5f, 0.0f)];
    [goal setName:kGoalName];
    [goal setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:goal.frame]];
    goal.physicsBody.dynamic = NO;
    goal.physicsBody.categoryBitMask = kGoalCategory;
    goal.physicsBody.contactTestBitMask = kAnimalCategory;
    goal.physicsBody.collisionBitMask = kAnimalCategory | kFloorCategory;
    goal.physicsBody.affectedByGravity = NO;
    goal.position = CGPointMake(self.floor.size.width -goal.frame.size.width , self.floor.size.height);
    
    return goal;
}

-(void) createLives{
    self.lifeNodes = [NSMutableArray array];
    float ypos = self.floor.size.height/2;
    float xoffset = 60;
    for (int i = 0; i < kInitLifes; i++) {
        SKSpriteNode* life = [self createLife];
        life.position = CGPointMake(self.frame.size.width - (xoffset * i) -xoffset, ypos);
        [self addChild:life];
        [self.lifeNodes addObject:life];
    }
}

-(void) loseLife{
    if (self.lifeNodes.count > 0) {
        SKNode* life  = [self.lifeNodes lastObject];
        [life removeFromParent];
        [self.lifeNodes removeLastObject];
    }
    
    if (self.lifeNodes.count == 0) {
        GameOverScene* gos =[[GameOverScene alloc] initWithScore:self.score andSize:self.size];
        self.physicsWorld.speed = 0.0f;
        [self.view presentScene:gos];
    }
}

-(SKSpriteNode*) createLife{
    SKSpriteNode* life = [SKSpriteNode spriteNodeWithColor:[SKColor blueColor] size:CGSizeMake(40, 40)];
    life.anchorPoint = CGPointMake(0.5f, 0.5f);
    [life setName:kLifeName];
    
    return life;
}

-(SKLabelNode*)createScore{
    SKLabelNode* score = [[SKLabelNode alloc] initWithFontNamed:@"Arial"];
    score.fontSize = 36;
    score.fontColor = [SKColor grayColor];
    score.text = [NSString stringWithFormat:@"Score: %lu", (unsigned long)self.score];
    score.position = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.8);
    return score;
}

-(SKLabelNode*)createLevel{
    SKLabelNode* score = [[SKLabelNode alloc] initWithFontNamed:@"Arial"];
    score.fontSize = 36;
    score.fontColor = [SKColor grayColor];
    score.text = [NSString stringWithFormat:@"Level: %lu", (unsigned long)self.level];
    score.position = CGPointMake(self.frame.size.width*0.8, self.frame.size.height*0.8);
    return score;
}

-(void) incrementScore{
    if (!self.incrementFlag) {
        self.score += [self.animal getPoints] * self.level;
        self.scoreNode.text = [NSString stringWithFormat:@"Score: %lu", (unsigned long)self.score];
        
        if (self.score > self.level * 10) {
            ++self.level;
            self.levelNode.text = [NSString stringWithFormat:@"Level: %lu", (unsigned long)self.level];
            self.speed+= 0.125f;
//            if (self.level % 5 == 0) {
//                self.fences = [self createFencesWithCount:self.fences.count+1];
//                [self.fences enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                    [self addChild:(SKNode*)obj];
//                }];
//                self.speed = kInitSpeed;
//            }
        }
        self.incrementFlag = YES;
        [self runAction:self.animal.actionSound];
    }
}

-(void)decrementScore{
    if (!self.incrementFlag) {
        [self loseLife];
        self.level = 1;
        self.speed = 1.0f;
        self.scoreNode.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.score];
        self.incrementFlag = YES;
    }
}



-(void)update:(NSTimeInterval)currentTime{


    if (![self.animal isValid]) {
        self.animal = [self createAnimal];
        
        self.lastUpdate = currentTime;
        self.incrementFlag = NO;
    }
}

@end
