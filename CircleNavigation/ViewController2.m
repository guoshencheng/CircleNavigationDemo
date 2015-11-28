//
//  ViewController2.m
//  CircleNavigation
//
//  Created by guoshencheng on 11/28/15.
//  Copyright © 2015 guoshencheng. All rights reserved.
//

#import "ViewController2.h"

@interface ViewController2 ()

@end

@implementation ViewController2

+ (instancetype)create {
    return [[ViewController2 alloc] initWithNibName:@"ViewController2" bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toOne:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
