//
//  AppDelegate.m
//  CircleNavigation
//
//  Created by guoshencheng on 11/23/15.
//  Copyright © 2015 guoshencheng. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:[ViewController create]];
    [self.window setRootViewController:self.navigationController];
    [self.window makeKeyAndVisible];
    CircleNavigation *circle = [CircleNavigation create];
    circle.delegate = self;
    [self.window addSubview:circle];
    [circle setupWithIcon:[UIImage imageNamed:@"circlebar"] hightLightImage:[UIImage imageNamed:@"circlebar_high_light"] itemImages:[self itemArray] titles:[self titles] highLightImages:[self highLightItemArray] radius:120 iconSize:CGSizeMake(52, 57) itemSize:CGSizeMake(51, 51) offsetLeft:20 offsetBottom:20];
    return YES;
}

- (NSArray *)titles {
    return @[@"用户信息", @"搜索", @"编辑信息", @"系统信息"];
}

- (NSArray *)itemArray {
    return @[[UIImage imageNamed:@"home_user_info"], [UIImage imageNamed:@"home_search"], [UIImage imageNamed:@"home_edit_content"], [UIImage imageNamed:@"home_system_message"]];
}

- (NSArray *)highLightItemArray {
    return @[[UIImage imageNamed:@"home_user_info_high_light"], [UIImage imageNamed:@"home_search_high_light"], [UIImage imageNamed:@"home_edit_content_high_light"], [UIImage imageNamed:@"home_system_message_high_light"]];
}

- (void)circleNavigation:(CircleNavigation *)circleNavigation didClickItemAtIndex:(NSInteger)index {
    NSLog(@"%@", @(index));
}

@end
