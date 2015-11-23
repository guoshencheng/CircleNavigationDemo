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

- (void)setupWithIcon:(UIImage *)image itemImages:(NSArray *)images radius:(CGFloat)radius iconSize:(CGSize)size itemSize:(CGSize)itemSize {
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(-120));
        make.bottom.equalTo(@(120));
        make.width.equalTo(@(320));
        make.height.equalTo(@(320));
    }];
    self.circleButtonWidthConstraint.constant = size.width;
    self.circleButtonHeightConstraint.constant = size.height;
    [self layoutIfNeeded];
    self.itemSize = itemSize;
    [self.circleButton setImage:image forState:UIControlStateNormal];
    self.itemImages = images;
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
    CGFloat averageAngle = M_PI_2 / self.itemImages.count;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.itemImages.count; i ++) {
        CircleNavigationItem *item = [self createSigleItemWithAngle:(0.5 + i) * averageAngle image:[self.itemImages objectAtIndex:i]];
        item.tag = i;
        [array addObject:item];
    }
    self.items = array;
}

- (CircleNavigationItem *)createSigleItemWithAngle:(CGFloat)angle image:(UIImage *)image {
    CircleNavigationItem *item = [CircleNavigationItem create];
    [item setupWithImage:image];
    item.targetPostion = CGPointMake(self.radius * sin(angle), - self.radius * cos(angle));
    [self insertSubview:item atIndex:0];
    [item configureConstraintWithWidth:self.itemSize.width height:self.itemSize.height];
    item.delegate = self;
    [self layoutIfNeeded];
    return item;
}

- (IBAction)didClickNavigationIcon:(id)sender {
    if (self.isPackUp) {
        for (CircleNavigationItem *item in self.items) {
            [item animateToTargetPostion];
        }
        self.isPackUp = NO;
    } else {
        for (CircleNavigationItem *item in self.items) {
            [item animateToOriginPostion];
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
