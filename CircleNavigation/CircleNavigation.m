//
//  CircleNavigation.m
//  CircleNavigation
//
//  Created by guoshencheng on 11/23/15.
//  Copyright © 2015 guoshencheng. All rights reserved.
//

#import "CircleNavigation.h"

@interface CircleNavigation()

@property (strong, nonatomic) UIWindow *circleNaviWindow;
@property (strong, nonatomic) UIButton *circleButton;
@property (assign, nonatomic) CGFloat radius;
@property (assign, nonatomic) CGSize iconSize;
@property (assign, nonatomic) CGSize itemSize;
@property (assign, nonatomic) CGFloat offsetLeft;
@property (assign, nonatomic) CGFloat offsetBottom;
@property (strong, nonatomic) NSArray *highLightItemImages;
@property (strong, nonatomic) NSArray *itemImages;
@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) UIWindow *actionWindow;

@end

@implementation CircleNavigation

#pragma mark - PublicMethod

+ (instancetype)create {
    CircleNavigation *circleNavigation = [[CircleNavigation alloc] init];
    circleNavigation.translatesAutoresizingMaskIntoConstraints = NO;
    return circleNavigation;
}

- (instancetype)init {
    if (self = [super init]) {
        self.circleButton = [[UIButton alloc] init];
        [self addSubview:self.circleButton];
        [self.circleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(0));
            make.bottom.equalTo(@(0));
            make.width.equalTo(@(20));
            make.height.equalTo(@(20));
        }];
        self.isPackUp = YES;
        self.circleButton.layer.cornerRadius = self.circleButton.frame.size.width / 2;
        [self.circleButton addTarget:self action:@selector(didClickNavigationIcon:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)clear {
    if (!self.items) {
        for (CircleNavigationItem *item in self.items) {
            [item removeFromSuperview];
        }
        self.items = nil;
    }
}

- (void)setupWithIcon:(UIImage *)image hightLightImage:(UIImage *)highLightImage itemImages:(NSArray *)images titles:(NSArray *)titles highLightImages:(NSArray *)highLightImages radius:(CGFloat)radius iconSize:(CGSize)size itemSize:(CGSize)itemSize offsetLeft:(CGFloat)offsetLeft offsetBottom:(CGFloat)offsetBottom {
    [self clear];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(offsetLeft));
        make.bottom.equalTo(@(-offsetBottom));
        make.width.equalTo(@(size.width));
        make.height.equalTo(@(size.height));
    }];
    self.offsetLeft = offsetLeft;
    self.offsetBottom = offsetBottom;
    [self updateCircleButtonWithHeight:size.height width:size.width];
    [self layoutIfNeeded];
    self.itemSize = itemSize;
    self.iconSize = size;
    self.titles = titles;
    [self.circleButton setImage:image forState:UIControlStateNormal];
    [self.circleButton setImage:highLightImage forState:UIControlStateHighlighted];
    self.itemImages = images;
    self.highLightItemImages = highLightImages;
    self.radius = radius;
    [self setup];
}

#pragma mark - LiveCycle

- (void)layoutIfNeeded {
    [super layoutIfNeeded];
    self.circleButton.layer.cornerRadius = self.circleButton.frame.size.width / 2;
}

#pragma mark - PrivateMethod

- (void)updateCircleButtonWithHeight:(CGFloat)height width:(CGFloat)width {
    [self.circleButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width));
        make.height.equalTo(@(height));
    }];
}

- (void)setup {
    [self layoutIfNeeded];
    CGFloat averageAngle = M_PI_2 / (self.itemImages.count - 1);
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.itemImages.count; i ++) {
        CircleNavigationItem *item = [self createSigleItemWithAngle:i * averageAngle image:[self.itemImages objectAtIndex:i] highLightImage:[self.highLightItemImages objectAtIndex:i] title:[self.titles objectAtIndex:i]];
        item.tag = i;
        [array addObject:item];
    }
    self.items = array;
}

- (CircleNavigationItem *)createSigleItemWithAngle:(CGFloat)angle image:(UIImage *)image highLightImage:(UIImage *)hightLightImage title:(NSString *)title{
    CircleNavigationItem *item = [CircleNavigationItem create];
    [item setupWithImage:image highLightImage:hightLightImage title:title];
    CGFloat offsetX = (self.iconSize.width - self.itemSize.width) / 2;
    CGFloat offsetY = (self.iconSize.height - self.itemSize.height) / 2;
    item.targetPostion = CGPointMake(self.radius * sin(angle) + offsetX, self.radius * cos(angle) + offsetY);
    item.originPostion = CGPointMake(offsetX, offsetY);
    item.angle = angle;
    [self insertSubview:item atIndex:0];
    [item configureConstraintWithWidth:self.itemSize.width height:self.itemSize.height];
    item.delegate = self;
    [self layoutIfNeeded];
    return item;
}

- (void)didClickNavigationIcon:(id)sender {
    if (self.isPackUp) {
        [self animateToOpen];
    } else {
        [self animateToPackUp];
    }
}

- (void)animateToPackUp {
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(self.offsetLeft));
        make.bottom.equalTo(@(- self.offsetBottom));
        make.width.equalTo(@(self.iconSize.width));
        make.height.equalTo(@(self.iconSize.height));
    }];
    [self layoutIfNeeded];
    for (CircleNavigationItem *item in self.items) {
        [item animateToOriginPostionDelay:0];
    }
    self.isPackUp = YES;
}

- (void)animateToOpen {
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(self.radius + self.itemSize.width));
        make.height.equalTo(@(self.radius + self.itemSize.height));
    }];
    [self layoutIfNeeded];
    for (CircleNavigationItem *item in self.items) {
        [item animateToTargetPostionDelay:0];
    }
    self.isPackUp = NO;
}

#pragma mark - CircleNavigationItemDelegate

- (void)circleNavigationItemDidClicked:(CircleNavigationItem *)circleNavigationItem {
    [self animateToPackUp];
    if ([self.delegate respondsToSelector:@selector(circleNavigation:didClickItemAtIndex:)]) {
        [self.delegate circleNavigation:self didClickItemAtIndex:circleNavigationItem.tag];
    }
}

@end
