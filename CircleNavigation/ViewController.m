//
//  ViewController.m
//  CircleNavigation
//
//  Created by guoshencheng on 11/23/15.
//  Copyright © 2015 guoshencheng. All rights reserved.
//

#import "ViewController.h"
#import "ViewController2.h"
#import "Masonry.h"

@implementation ViewController

+ (instancetype)create {
    return [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toTwo:(id)sender {
    [self.navigationController pushViewController:[ViewController2 create] animated:YES];
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
