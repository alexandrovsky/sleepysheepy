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

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.

    self.skView.showsFPS = YES;
    self.skView.showsNodeCount = YES;
    self.skView.showsPhysics = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    self.skView.ignoresSiblingOrder = YES;
    
    [self resetScene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)pauseButtonPressed:(id)sender forEvent:(UIEvent *)event {
    
    self.skView.scene.paused = !self.skView.scene.paused;
    
//    [self.skView.scene removeFromParent];
//    [self.skView presentScene:nil];
//    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)resetScene{
    // Create and configure the scene.
    GameScene *scene = [GameScene unarchiveFromFile:@"GameScene"];
    scene.gameDelegate = self;
    scene.scaleMode = SKSceneScaleModeAspectFill;
    // Present the scene.
    [self.skView presentScene:scene transition:[SKTransition fadeWithDuration:0.5f]];
}
-(void)closeSceneWithGameStats:(NSDictionary *)stats{
    if ([stats[@"GameCloseOption"] isEqualToString:GameCloseOptionFinish]) {
        [self dismissViewControllerAnimated:YES completion:^{
            NSLog(@"dismissed");
        }];
//        GameOverViewController* govc = [[GameOverViewController alloc] initWithNibName:@"Main" bundle:[NSBundle mainBundle]];
//        [self presentViewController:govc animated:YES completion:^{
//            NSLog(@"govc presented");
//        }];
    }
    
}

@end
