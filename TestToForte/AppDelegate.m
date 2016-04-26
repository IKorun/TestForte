//
//  AppDelegate.m
//  TestToForte
//
//  Created by Orangesoft  on 4/21/16.
//  Copyright © 2016 iKoGor.by. All rights reserved.
//

#import "AppDelegate.h"
#import "TableViewController.h"
#import "URLDataManager.h"

@interface AppDelegate ()

{
    URLDataManager *_urlManager;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.tController = [[TableViewController alloc] init];
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.tController];
    
    self.navController.navigationBar.topItem.title = @"Downloads";
    
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    
    _urlManager = [[URLDataManager alloc] initWithURL:[NSURL URLWithString:@"https://devimages.apple.com.edgekey.net/wwdc-services/ftzj8e4h/6rsxhod7fvdtnjnmgsun/videos.json"]];
    
    return YES;
}


- (void)handleDictionary:(NSDictionary *)dictionary
{
    self.tController.sourceArray = [dictionary objectForKey:@"sessions"];
}


@end
