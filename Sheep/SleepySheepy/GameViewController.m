//
//  GameViewController.m
//  Sheep2
//
//  Created by Dmitry Alexandrovsky on 15.09.14.
//  Copyright (c) 2014 Dmitry Alexandrovsky. All rights reserved.
//

#import "GameViewController.h"
#import "GameOverViewController.h"


@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@implementation GameViewController

- (void)viewDidLoad{
    [super viewDidLoad];

    // Configure the view.
    self.skView.showsFPS = YES;
    self.skView.showsNodeCount = YES;
    self.skView.showsPhysics = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    self.skView.ignoresSiblingOrder = YES;
    
    [self setupScene];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    GameScene* game = (GameScene*)(self.skView.scene);
    [game reset];
}

- (BOOL)shouldAutorotate{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)pauseButtonPressed:(id)sender forEvent:(UIEvent *)event {
    self.skView.scene.paused = !self.skView.scene.paused;
}


-(void)setupScene{
    GameScene *scene = [GameScene unarchiveFromFile:@"GameScene"];
    scene.gameDelegate = self;
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [self.skView presentScene:scene]; // transition:[SKTransition doorsOpenHorizontalWithDuration:0.5f]];
}

-(void)closeSceneWithGameStats:(NSDictionary *)stats{
    if ([stats[@"GameCloseOption"] isEqualToString:GameCloseOptionFinish]) {
        [self performSegueWithIdentifier:@"GoToGameOverSegue" sender:self];
        [self setupScene];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"GoToGameOverSegue"]) {
        GameOverViewController* govc = segue.destinationViewController;
        GameScene* game =(GameScene*)self.skView.scene;
        govc.score = game.score;
    }
    
}

@end
