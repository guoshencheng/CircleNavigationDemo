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
- (void)setupWithIcon:(UIImage *)image
      hightLightImage:(UIImage *)highLightImage
           itemImages:(NSArray *)images
               titles:(NSArray *)titles
      highLightImages:(NSArray *)hightLightImages
               radius:(CGFloat)radius
             iconSize:(CGSize)size
             itemSize:(CGSize)itemSize offsetLeft:(CGFloat)offsetLeft offsetBottom:(CGFloat)offsetBottom;

@end

@protocol CircleNavigationDelegate <NSObject>
@optional
- (void)circleNavigation:(CircleNavigation *)circleNavigation didClickItemAtIndex:(NSInteger)index;

@end