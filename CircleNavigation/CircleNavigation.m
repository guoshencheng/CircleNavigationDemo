//
//  CircleNavigation.m
//  CircleNavigation
//
//  Created by guoshencheng on 11/23/15.
//  Copyright © 2015 guoshencheng. All rights reserved.
//

#import "CircleNavigation.h"

@interface CircleNavigation()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *circleButtonHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *circleButtonWidthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *circleButton;
@property (assign, nonatomic) CGFloat radius;
@property (assign, nonatomic) CGSize iconSize;
@property (assign, nonatomic) CGSize itemSize;
@property (assign, nonatomic) CGFloat offsetLeft;
@property (assign, nonatomic) CGFloat offsetBottom;
@property (strong, nonatomic) NSArray *highLightItemImages;
@property (strong, nonatomic) NSArray *itemImages;
@property (strong, nonatomic) NSArray *items;

@end

@implementation CircleNavigation

#pragma mark - PublicMethod

+ (instancetype)create {
    CircleNavigation *circleNavigation = [[[NSBundle mainBundle] loadNibNamed:@"CircleNavigation" owner:nil options:nil] lastObject];
    circleNavigation.translatesAutoresizingMaskIntoConstraints = NO;
    return circleNavigation;
}

- (void)clear {
    if (!self.items) {
        for (CircleNavigationItem *item in self.items) {
            [item removeFromSuperview];
        }
        self.items = nil;
    }
}

- (void)setupWithIcon:(UIImage *)image hightLightImage:(UIImage *)highLightImage itemImages:(NSArray *)images highLightImages:(NSArray *)highLightImages radius:(CGFloat)radius iconSize:(CGSize)size itemSize:(CGSize)itemSize offsetLeft:(CGFloat)offsetLeft offsetBottom:(CGFloat)offsetBottom {
    [self clear];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(offsetLeft));
        make.bottom.equalTo(@(-offsetBottom));
        make.width.equalTo(@(size.width));
        make.height.equalTo(@(size.height));
    }];
    self.offsetLeft = offsetLeft;
    self.offsetBottom = offsetBottom;
    self.circleButtonWidthConstraint.constant = size.width;
    self.circleButtonHeightConstraint.constant = size.height;
    [self layoutIfNeeded];
    self.itemSize = itemSize;
    self.iconSize = size;
    [self.circleButton setImage:image forState:UIControlStateNormal];
    [self.circleButton setImage:highLightImage forState:UIControlStateHighlighted];
    self.itemImages = images;
    self.highLightItemImages = highLightImages;
    self.radius = radius;
    [self setup];
}

#pragma mark - LiveCycle

- (void)awakeFromNib {
    self.isPackUp = YES;
    self.circleButton.layer.cornerRadius = self.circleButton.frame.size.width / 2;
}

- (void)layoutIfNeeded {
    [super layoutIfNeeded];
    self.circleButton.layer.cornerRadius = self.circleButton.frame.size.width / 2;
}

#pragma mark - PrivateMethod

- (void)setup {
    [self layoutIfNeeded];
    CGFloat averageAngle = M_PI_2 / (self.itemImages.count - 1);
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.itemImages.count; i ++) {
        CircleNavigationItem *item = [self createSigleItemWithAngle:i * averageAngle image:[self.itemImages objectAtIndex:i] highLightImage:[self.highLightItemImages objectAtIndex:i]];
        item.tag = i;
        [array addObject:item];
    }
    self.items = array;
}

- (CircleNavigationItem *)createSigleItemWithAngle:(CGFloat)angle image:(UIImage *)image highLightImage:(UIImage *)hightLightImage {
    CircleNavigationItem *item = [CircleNavigationItem create];
    [item setupWithImage:image highLightImage:hightLightImage];
    item.targetPostion = CGPointMake(self.radius * sin(angle), - self.radius * cos(angle));
    [self insertSubview:item atIndex:0];
    [item configureConstraintWithWidth:self.itemSize.width height:self.itemSize.height];
    item.delegate = self;
    [self layoutIfNeeded];
    return item;
}

- (IBAction)didClickNavigationIcon:(id)sender {
    if (self.isPackUp) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(-self.radius + self.iconSize.width / 2 - self.itemSize.width / 2 + self.offsetLeft));
            make.bottom.equalTo(@(self.radius - self.iconSize.height / 2 + self.itemSize.height / 2 - self.offsetBottom));
            make.width.equalTo(@(self.radius * 2 + self.itemSize.width));
            make.height.equalTo(@(self.radius * 2 + self.itemSize.height));
        }];
        [self layoutIfNeeded];
        for (CircleNavigationItem *item in self.items) {
            [item animateToTargetPostionDelay:0];
        }
        self.isPackUp = NO;
    } else {
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
}

#pragma mark - CircleNavigationItemDelegate

- (void)circleNavigationItemDidClicked:(CircleNavigationItem *)circleNavigationItem {
    if ([self.delegate respondsToSelector:@selector(circleNavigation:didClickItemAtIndex:)]) {
        [self.delegate circleNavigation:self didClickItemAtIndex:circleNavigationItem.tag];
    }
}

@end
