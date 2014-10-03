//
//  AppDelegate.m
//  Sheep2
//
//  Created by Dmitry Alexandrovsky on 15.09.14.
//  Copyright (c) 2014 Dmitry Alexandrovsky. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSError *error = [[NSError alloc] init];
    

    NSURL *url = [[NSBundle mainBundle] URLForResource:@"schlafkindchenschlaf_chor" withExtension:@"mid"];
//    NSURL *bank = [[NSBundle mainBundle] URLForResource:@"Yamaha_XG_Sound_Set" withExtension:@"sf2"];
    NSURL *bank = [[NSBundle mainBundle] URLForResource:@"FreeFont" withExtension:@"sf2"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startMusic:) name:@"startMusic" object:nil];
    
    
    // midi bank file, you can download from http://www.sf2midi.com/
   
    self.midiPlayer = [[AVMIDIPlayer alloc] initWithContentsOfURL:url soundBankURL:bank error:&error];
    if (error) {
        NSLog(@"error = %@", error);
    }else{
        self.midiPlayer.rate = 1.0f;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"startMusic" object:nil];
//        [self.midiPlayer prepareToPlay];
//        [self.midiPlayer play:^{
//            NSLog(@"finished playing midi");
//        }];
    }
    
    return YES;
}

-(void)startMusic:(NSNotification*)notification{
    [self.midiPlayer prepareToPlay];
    self.midiPlayer.currentPosition = 0.0f;
    [self.midiPlayer play:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"startMusic" object:nil];
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
