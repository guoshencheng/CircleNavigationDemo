//
//  ViewController.m
//  CircleNavigation
//
//  Created by guoshencheng on 11/23/15.
//  Copyright © 2015 guoshencheng. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"

@implementation ViewController

+ (instancetype)create {
    return [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CircleNavigation *circle = [CircleNavigation create];
    circle.delegate = self;
    [self.view addSubview:circle];
    [circle setupWithIcon:[UIImage imageNamed:@"circlebar"] hightLightImage:[UIImage imageNamed:@"circlebar_high_light"] itemImages:[self itemArray] highLightImages:[self highLightItemArray] radius:120 iconSize:CGSizeMake(52, 57) itemSize:CGSizeMake(51, 51) offsetLeft:20 offsetBottom:20];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
