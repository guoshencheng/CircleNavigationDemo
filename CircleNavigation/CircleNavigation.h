//
//  CircleNavigation.h
//  CircleNavigation
//
//  Created by guoshencheng on 11/23/15.
//  Copyright © 2015 guoshencheng. All rights reserved.
//

#import "CircleNavigationItem.h"

@protocol CircleNavigationDelegate;

@interface CircleNavigation : UIView<CircleNavigationItemDelegate>

@property (assign, nonatomic) BOOL isPackUp;
@property (weak, nonatomic) id<CircleNavigationDelegate> delegate;

+ (instancetype)create;
- (void)setupWithIcon:(UIImage *)image itemImages:(NSArray *)images radius:(CGFloat)radius iconSize:(CGSize)size itemSize:(CGSize)itemSize;

@end

@protocol CircleNavigationDelegate <NSObject>
@optional
- (void)circleNavigation:(CircleNavigation *)circleNavigation didClickItemAtIndex:(NSInteger)index;

@end