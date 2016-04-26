//
//  AppDelegate.h
//  TestToForte
//
//  Created by Orangesoft  on 4/21/16.
//  Copyright © 2016 iKoGor.by. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "URLDataManager.h"


@class TableViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, URLDataManagerDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) TableViewController *tController;


@end

