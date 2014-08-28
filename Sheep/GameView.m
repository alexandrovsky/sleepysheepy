//
//  GameView.m
//  Sheep
//
//  Created by Dmitry Alexandrovsky on 26.08.14.
//  Copyright (c) 2014 Dmitry Alexandrovsky. All rights reserved.
//

#import "GameView.h"
#import "GameScene.h"
#import "GameOverScene.h"

@interface GameView ()
@property (nonatomic, weak) SKNode* touchedNode;
@end

@implementation GameView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        self.showsFPS = YES;
        self.showsPhysics = YES;
        self.showsNodeCount = YES;

    }
    return self;
}

-(void)didMoveToWindow{
    self.swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                           action:@selector(handleSwipe:)];
    self.swipe.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:self.swipe];
}

#pragma mark - Handle touch

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self.scene];
    self.touchedNode = [self.scene nodeAtPoint:positionInScene];
    
    if([self.scene isKindOfClass:GameScene.class]){
        if (self.touchedNode.physicsBody.categoryBitMask == kAnimalCategory) {
            NSLog(@"node %@ touched!!!", self.touchedNode.name);
        }
    }else if([self.scene isKindOfClass:GameOverScene.class]){
        if ([self.touchedNode.name isEqualToString:kReplayName] ) {
            [self presentScene:[[GameScene alloc] initWithSize:self.frame.size]];
        }
    }
    
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.touchedNode = nil;
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    self.touchedNode = nil;
}


#pragma mark - UIGestureRecognizerDelegate

-(void)handleSwipe:(UISwipeGestureRecognizer*)recognizer{
    if (self.touchedNode &&  self.touchedNode.physicsBody.categoryBitMask == kAnimalCategory) {
        NSLog(@"node %@ swiped!!!", self.touchedNode.name);
        [self.touchedNode.physicsBody applyImpulse:CGVectorMake(0.0f, 90.0f)];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
