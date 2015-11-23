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
    [circle setupWithIcon:[UIImage imageNamed:@"RYOptionItem"] itemImages:@[[UIImage imageNamed:@"RYOptionItem"], [UIImage imageNamed:@"RYOptionItem"], [UIImage imageNamed:@"RYOptionItem"], [UIImage imageNamed:@"RYOptionItem"]] radius:100 iconSize:CGSizeMake(32, 32) itemSize:CGSizeMake(32, 32)];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)circleNavigation:(CircleNavigation *)circleNavigation didClickItemAtIndex:(NSInteger)index {
    NSLog(@"%@", @(index));
}

@end
