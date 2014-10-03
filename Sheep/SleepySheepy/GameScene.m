//
//  GameScene.m
//  Sheep2
//
//  Created by Dmitry Alexandrovsky on 15.09.14.
//  Copyright (c) 2014 Dmitry Alexandrovsky. All rights reserved.
//

#import "GameScene.h"
#import "GameOptions.h"
#import "Animal.h"
#import "Sheep.h"
#import "Wolf.h"
#import "FMMParallaxNode.h"

#import "AppDelegate.h"

@interface GameScene()
@property(nonatomic, strong)NSMutableArray* lifes;
@property (nonatomic, strong) Animal* animal;
@property (nonatomic, strong) FMMParallaxNode* parallaxClouds;
@property (nonatomic, strong) SKNode* fence;
@property (nonatomic, strong) SKNode* ground;
@property (nonatomic, strong) SKNode* startingpoint;
@property (nonatomic, strong) SKNode* endingpoint;
@property (nonatomic, strong) SKLabelNode* scoreLabel;
@property (nonatomic, strong) SKLabelNode* speedLabel;
@property (nonatomic, assign) CGFloat speed;

@property (nonatomic, assign) NSUInteger scoreIncrement;
@property (nonatomic, assign) BOOL userTouchedAnimal;
@property (nonatomic, assign) BOOL userDidSwipe;



//@property (nonatomic, assign) SKShapeNode* debugShapeNode;


@property (nonatomic, assign) CFTimeInterval lastFrameTime;

@property(nonatomic, weak) AVMIDIPlayer* backgroundMusic;
@end






@implementation GameScene


-(void)didMoveToView:(SKView *)view {
    [self setupScene];
    UISwipeGestureRecognizer* swipeUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self
                                                                               action:@selector(handleSwipeUp:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    swipeUp.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:swipeUp];
    
    
    UISwipeGestureRecognizer* swipeDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self
                                                                                   action:@selector(handleSwipeDown:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    swipeDown.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:swipeDown];
    
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.backgroundMusic = appDelegate.midiPlayer;
    
    self.lastFrameTime = CACurrentMediaTime();
}


-(void)setupScene{
    self.physicsWorld.contactDelegate = self;
    

    
    self.startingpoint = [self childNodeWithName:@"startingpoint"];
    self.endingpoint = [self childNodeWithName:@"endingpoint"];
    self.endingpoint.hidden = NO;
    self.endingpoint.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.endingpoint.frame.size];
    self.endingpoint.physicsBody.dynamic = NO;
    self.endingpoint.physicsBody.categoryBitMask = CollisionCategoryEndingpoint;
    self.endingpoint.physicsBody.contactTestBitMask = CollisionCategoryAnimal;
    
    

    
    self.fence = [self childNodeWithName:@"fence"];
    self.fence.physicsBody.categoryBitMask = CollisionCategoryFence;
    self.fence.physicsBody.contactTestBitMask = CollisionCategoryAnimal;
    self.fence.physicsBody.collisionBitMask = CollisionCategoryFence | CollisionCategoryGround;
    
    
    self.ground = [self childNodeWithName:@"ground"];
    
    
    self.scoreLabel = (SKLabelNode*)[self childNodeWithName:@"score"];
    self.speedLabel =  (SKLabelNode*)[self childNodeWithName:@"speed"];
    [self createScrollingClouds];
//    [self reset];
}


-(void) reset{
    #warning fixme: load from plist
    self.speed = kInitSpeed;
    self.scoreIncrement = kScoreIncrement;
    self.score = 0;
    [self.lifes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SKNode* life  = (SKNode*)obj;
        [life removeFromParent];
    }];
    
    self.animal = [self createAnimal];
    [self createLifes];
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:1000.0f],
                                         [SKAction runBlock:^{
        self.paused = NO;
    }]]]];
}

-(void)createScrollingClouds{
    NSArray* parallaxCloudsNames = @[@"cloud.png", @"cloud.png"];
    
    CGSize cloudSize = CGSizeMake(200.0, 200.0);

    self.parallaxClouds = [[FMMParallaxNode alloc] initWithBackgrounds:parallaxCloudsNames
                                                                       size:cloudSize
                                                       pointsPerSecondSpeed:50.0f];
    
    self.parallaxClouds.position = CGPointMake(self.frame.size.width+cloudSize.width, self.frame.size.height/2.0);
    
    [self.parallaxClouds randomizeNodesPositions];
    
    
    [self addChild:self.parallaxClouds];
    
}

-(void) createLifes{
    self.lifes = [NSMutableArray arrayWithCapacity:kInitLifes];
    SKNode* lifeRoot = [self childNodeWithName:@"life"];
    for (int i = 0; i < kInitLifes; i++) {
        CGSize size = CGSizeMake(50, 50);
        CGFloat offset = 10;
        SKSpriteNode* life = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:size];
        life.position = CGPointMake((-i*(size.width + offset)),
                                    0.0f);
        [lifeRoot addChild:life];
        [self.lifes addObject:life];
    }

}

-(Animal*)createAnimal{
    Animal* animal;
    NSInteger rnd =  arc4random_uniform(5);
    if (rnd == 0) {
        animal = [[Wolf alloc] initWithSize:CGSizeMake(100, 100)
                        andStartingPosition:self.startingpoint.position];
    }else{
        animal = [[Sheep alloc] initWithSize:CGSizeMake(100, 100)
                        andStartingPosition:self.startingpoint.position];
    }
    
    
    
    animal.speed = self.speed;
    [self addChild:animal];
    
    return animal;
}

-(void)resetAnimal{
    if (self.animal) {
        [self.animal removeFromParent];
    }
    self.animal = [self createAnimal];
}

-(void)loseLife{
    if (self.lifes.count > 0) {
        SKNode* life = self.lifes.lastObject;
        [life removeFromParent];
        [self.lifes removeLastObject];
    }else{
        [self.gameDelegate closeSceneWithGameStats:@{@"score" : @(self.score),
                                                     @"GameCloseOption": GameCloseOptionFinish}];
    }
}

-(void) updateScore{
    self.score += self.scoreIncrement;
    self.speed += kSpeedIncrement;
    if (self.speed > kMaxSpeed) {
        self.speed = kMaxSpeed;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.score];
    self.speedLabel.text = [NSString stringWithFormat:@"Speed: %4.2f", self.speed];
    self.backgroundMusic.rate = self.speed / kInitSpeed;
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self.scene];
    
    
    SKNode* touchedNode = [self.scene nodeAtPoint:positionInScene];
    NSLog(@"touched node: %@",touchedNode.name);
    if ([touchedNode.name isEqualToString:self.animal.name]) {
        self.userTouchedAnimal = YES;
    }
    

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.userTouchedAnimal = NO;
    self.userDidSwipe = YES;
}


-(void)handleSwipeUp:(UISwipeGestureRecognizer *)recognizer {


    //    CGPoint positionInScene = [touch locationInNode:self.scene];

    if(recognizer.state == UIGestureRecognizerStateBegan){
        
    }else if(recognizer.state == UIGestureRecognizerStateEnded){
        self.userDidSwipe = YES;
        if (self.userTouchedAnimal && !self.animal.isJumping){
            [self.animal jumpWithImpulse:CGVectorMake(self.animal.speed/2, 270)];
        }
    }
    NSLog(@"swipe up");
}
-(void)handleSwipeDown:(UISwipeGestureRecognizer *)recognizer {
    
    if(recognizer.state == UIGestureRecognizerStateBegan){
        
    }else if(recognizer.state == UIGestureRecognizerStateEnded){
        self.userDidSwipe = YES;
        if (self.userTouchedAnimal && !self.animal.isJumping){
            [self.animal jumpWithImpulse:CGVectorMake(self.animal.speed/2, -270)];
            self.animal.physicsBody.collisionBitMask = 0;
            self.animal.physicsBody.contactTestBitMask = 0;
            
            if ([self.animal.name isEqualToString:@"sheep"]) {
                [self loseLife];
            }else if ([self.animal.name isEqualToString:@"wolf"]){
            }
            
            
            [self.animal runAction:[SKAction waitForDuration:kAnimalResetTimeout] completion:^{
                [self resetAnimal];
            }];
            
            
        }
    }
    
    
    NSLog(@"swipe down");
    
}



-(void)animalContactsFence{
    CGFloat wait = 1.0f;
    
    if (!self.animal.isJumping) {
        wait = 0.0f;
    }
    
    if ([self.animal.name isEqualToString:@"sheep"]) {
        [self loseLife];
    }else if ([self.animal.name isEqualToString:@"wolf"]){
    }
    
    
    [self.animal touchedFenceWithFinishBlock:^{
        [self.animal runAction:[SKAction waitForDuration:wait*kAnimalResetTimeout]completion:^{
            [self resetAnimal];
        }];
    }];
}


-(void)animalContactsEndpoint{
    CGFloat wait = 1.0f;
    
    if (!self.animal.isJumping) {
        wait = 0.0f;
    }
    
    if ([self.animal.name isEqualToString:@"sheep"]) {
        [self updateScore];
    }else if ([self.animal.name isEqualToString:@"wolf"]){
        [self loseLife];
    }
    
    
    [self.animal  touchedEndpointWithFinishBlock:^{
        [self.animal runAction:[SKAction waitForDuration:wait*kAnimalResetTimeout]completion:^{
            [self resetAnimal];
        }];
    }];
}

-(void)didBeginContact:(SKPhysicsContact *)contact{

    if ([contact.bodyA.node.name isEqualToString:self.animal.name]){
        if([contact.bodyB.node.name isEqualToString:self.fence.name]) {
            [self animalContactsFence];
        }else if([contact.bodyB.node.name isEqualToString:self.ground.name]){
            [self.animal touchedGroundWithFinishBlock:nil];
        }else if([contact.bodyB.node.name isEqualToString:self.endingpoint.name]){
            [self animalContactsEndpoint];
        }
    }
    if ([contact.bodyB.node.name isEqualToString:self.animal.name]){
        if([contact.bodyA.node.name isEqualToString:self.fence.name]) {
            [self animalContactsFence];
        }else if([contact.bodyA.node.name isEqualToString:self.ground.name]) {
            [self.animal touchedGroundWithFinishBlock:nil];
        }else if([contact.bodyA.node.name isEqualToString:self.endingpoint.name]){
            [self animalContactsEndpoint];
        }
    }
//    NSLog(@"contact: node a: %@ node b: %@",contact.bodyA.node.name, contact.bodyB.node.name);
}

-(void)update:(CFTimeInterval)currentTime {
    
    if (self.paused) {
        return;
    }
    
    CFTimeInterval deltaTime = currentTime - self.lastFrameTime;
    
    //update nodes:
    [self.animal update:deltaTime];
    [self.parallaxClouds update:currentTime];
    
    // finaly update the time
    self.lastFrameTime = currentTime;
}





@end
