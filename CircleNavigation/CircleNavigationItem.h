//
//  CircleNavigationItem.h
//  CircleNavigation
//
//  Created by guoshencheng on 11/23/15.
//  Copyright © 2015 guoshencheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "POP.h"

@protocol CircleNavigationItemDelegate;

@interface POPAnimatableProperty (Masonry)

+ (POPAnimatableProperty*) mas_offsetProperty;

@end

@interface CircleNavigationItem : UIView

@property (weak, nonatomic) id<CircleNavigationItemDelegate>delegate;
@property (assign, nonatomic) CGPoint targetPostion;
@property (assign, nonatomic) CGPoint originPostion;

+ (instancetype)create;
- (void)setupWithImage:(UIImage *)image;
- (void)configureConstraintWithWidth:(CGFloat)width height:(CGFloat)height;
- (void)animateToTargetPostion;
- (void)animateToOriginPostion;

@end

@protocol CircleNavigationItemDelegate <NSObject>
@optional
- (void)circleNavigationItemDidClicked:(CircleNavigationItem *)circleNavigationItem;

@end
