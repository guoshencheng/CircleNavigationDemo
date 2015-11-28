//
//  AppDelegate.h
//  CircleNavigation
//
//  Created by guoshencheng on 11/23/15.
//  Copyright © 2015 guoshencheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CircleNavigation.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, CircleNavigationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;

@end

