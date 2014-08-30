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
@property (nonatomic, assign) CFTimeInterval lastUpdate;
@property (nonatomic, strong) NSMutableArray* lifeNodes;
@property (nonatomic, assign) BOOL incrementFlag;

@end

@implementation GameScene


-(instancetype)initWithSize:(CGSize)size{
    self = [super initWithSize:size];
    if (self) {
        
        
        self.level = 1;
        self.speed = 1;

        self.backgroundColor = [SKColor colorWithRed:0.4f green:0.6f blue:0.8f alpha:1.0f];
        self.physicsWorld.gravity = CGVectorMake(0.0f, -4.8f);
//        self.scaleMode = SKSceneScaleModeAspectFill;
        
        self.floor = [self createFloor];
        [self addChild:self.floor];
        
        self.fence = [self createFence];
        [self addChild:self.fence];
        
        self.scoreNode = [self createScore];
        [self addChild:self.scoreNode];
        
        
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


- (SKSpriteNode*)createFence {
    SKSpriteNode *fence = [SKSpriteNode spriteNodeWithColor:[SKColor yellowColor] size:(CGSize){20, 60}];
    [fence setAnchorPoint:(CGPoint){0, 0}];
    [fence setName:kFenceName];
    [fence setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:fence.frame]];
    fence.physicsBody.dynamic = NO;
    fence.physicsBody.categoryBitMask = kFenceCategory;
    fence.physicsBody.contactTestBitMask = kAnimalCategory;
    fence.physicsBody.collisionBitMask = kFloorCategory;
    fence.position = CGPointMake(self.frame.size.width/2, self.floor.size.height);
    return fence;
}

-(Animal*)createAnimal{
    if (self.animal) {
        [self.animal removeFromParent];
        self.animal = nil;
    }
    uint32_t rnd = arc4random_uniform(kWolfProbability);
    if ((rnd % kWolfProbability) == 0) {
        self.animal = [self createWolf];
    }
    
    self.animal = [self createSheep];
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
    float ypos = self.frame.size.height - 60;
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
    score.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.score];
    score.position = CGPointMake(self.frame.size.width*0.8, self.frame.size.height*0.8);
    return score;
}

-(void) incrementScore{
    if (!self.incrementFlag) {
        self.score += kScoreIncrement * self.level;
        self.scoreNode.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.score];
        
        if (self.score > self.level * 10) {
            self.level++;
            self.speed+= 0.2f;
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
-(void) invalidateAnimal{
    [self.animal invalidate];
    self.animal = nil;
}


-(void)update:(NSTimeInterval)currentTime{
    NSTimeInterval deltaT = currentTime - self.lastUpdate;
    if (deltaT > 2 && self.animal == nil) {
        self.animal = [self createAnimal];
        [self addChild:self.animal];
        self.lastUpdate = currentTime;
        self.incrementFlag = NO;
    }
}

@end
