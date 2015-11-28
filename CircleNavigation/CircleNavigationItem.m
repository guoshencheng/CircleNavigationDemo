//
//  CircleNavigationItem.m
//  CircleNavigation
//
//  Created by guoshencheng on 11/23/15.
//  Copyright © 2015 guoshencheng. All rights reserved.
//

#import "CircleNavigationItem.h"

@interface CircleNavigationItem()

@property (strong, nonatomic) UIButton *itemButton;
@property (strong, nonatomic) MASConstraint *leftConstraint;
@property (strong, nonatomic) MASConstraint *bottomConstraint;

@end

@implementation POPAnimatableProperty (Masonry)

CGFloat getLayoutConstant(MASConstraint* constraint) {
    return (CGFloat)[[constraint valueForKey:@"layoutConstant"] floatValue];
}

+ (POPAnimatableProperty*) mas_offsetProperty {
    return [POPAnimatableProperty propertyWithName:@"offset" initializer:^(POPMutableAnimatableProperty *prop) {
        prop.readBlock = ^(MASConstraint *constraint, CGFloat values[]) {
            values[0] = getLayoutConstant(constraint);
        };
        
        prop.writeBlock = ^(MASConstraint *constraint, const CGFloat values[]) {
            [constraint setOffset:values[0]];
        };
    }];
}

@end

@implementation CircleNavigationItem

#pragma mark - PublicMethod

+ (instancetype)create {
    CircleNavigationItem *circleNavigationItem = [[CircleNavigationItem alloc] init];
    circleNavigationItem.translatesAutoresizingMaskIntoConstraints = NO;
    return circleNavigationItem;
}

- (instancetype)init {
    if (self = [super init]) {
        self.itemButton = [[UIButton alloc] init];
        [self addSubview:self.itemButton];
        [self.itemButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(0));
            make.right.equalTo(@(0));
            make.top.equalTo(@(0));
            make.bottom.equalTo(@(0));
        }];
    }
    return self;
}

- (void)setupWithImage:(UIImage *)image highLightImage:(UIImage *)highLightImage {
    [self.itemButton setImage:image forState:UIControlStateNormal];
    [self.itemButton setImage:highLightImage forState:UIControlStateHighlighted];
}

- (void)configureConstraintWithWidth:(CGFloat)width height:(CGFloat)height {
    self.hidden = YES;
    __weak typeof(self) weakSelf = self;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        self.leftConstraint = make.left.equalTo(@(weakSelf.originPostion.x));
        self.bottomConstraint = make.bottom.equalTo(@(-weakSelf.originPostion.y));
        make.width.equalTo(@(width));
        make.height.equalTo(@(height));
    }];
}

- (void)animateToTargetPostionDelay:(CGFloat)delay {
    self.hidden = NO;
    POPBasicAnimation *alphaAnimation = [self alphaAnimationWithDelay:delay fromAlpah:0 toAlpha:1];
    [self pop_addAnimation:alphaAnimation forKey:@"alpha"];
    POPSpringAnimation *animationX = [self defalutOffsetSpringAnimationWithDelay:delay];
    animationX.toValue = @(self.targetPostion.x);
    [self.leftConstraint pop_addAnimation:animationX forKey:@"centerX"];
    POPSpringAnimation *animationY = [self defalutOffsetSpringAnimationWithDelay:delay];
    animationY.toValue = @(-self.targetPostion.y);
    [self.bottomConstraint pop_addAnimation:animationY forKey:@"centerY"];
}

- (void)animateToOriginPostionDelay:(CGFloat)delay {
    POPBasicAnimation *alphaAnimation = [self alphaAnimationWithDelay:delay fromAlpah:1 toAlpha:0];
    [self pop_addAnimation:alphaAnimation forKey:@"alpha"];
    [UIView animateWithDuration:0.2 animations:^{
        __weak typeof(self) weakSelf = self;
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            self.leftConstraint = make.left.equalTo(@(weakSelf.originPostion.x));
            self.bottomConstraint = make.bottom.equalTo(@(-weakSelf.originPostion.y));
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark - LiveCycle

#pragma mark - PrivateMethod

- (POPSpringAnimation *)defalutOffsetSpringAnimationWithDelay:(CGFloat)delay {
    POPSpringAnimation *animation = [POPSpringAnimation new];
    animation.property = [POPMutableAnimatableProperty mas_offsetProperty];
    animation.springBounciness = 10;
    animation.springSpeed = 6;
    animation.beginTime = CACurrentMediaTime() + delay;
    return animation;
}

- (POPBasicAnimation *)alphaAnimationWithDelay:(CGFloat)delay fromAlpah:(CGFloat)fromAlpha toAlpha:(CGFloat)toAlpha {
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    animation.fromValue = @(fromAlpha);
    animation.toValue = @(toAlpha);
    animation.duration = 1;
    animation.beginTime = CACurrentMediaTime() + delay;
    return animation;
}

- (IBAction)didClickItem:(id)sender {
    if ([self.delegate respondsToSelector:@selector(circleNavigationItemDidClicked:)]) {
        [self.delegate circleNavigationItemDidClicked:self];
    }
    
}

@end
