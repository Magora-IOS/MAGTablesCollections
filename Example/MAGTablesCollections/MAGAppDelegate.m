//
//  MAGAppDelegate.m
//  MAGTablesCollections
//
//  Created by Denis Matveev on 08/30/2016.
//  Copyright (c) 2016 Denis Matveev. All rights reserved.
//

#import "MAGAppDelegate.h"
#import "MainViewController.h"

@implementation MAGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UINavigationBar appearance] setTranslucent:NO];
    [self display];
    return YES;
}

- (void)display {
    MainViewController *vc = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    nc.view.frame = self.window.bounds;
    vc.view.frame = nc.view.bounds;
    self.window.rootViewController = nc;
    [self.window makeKeyAndVisible];
}

@end
