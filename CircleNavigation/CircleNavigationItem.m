//
//  CircleNavigationItem.m
//  CircleNavigation
//
//  Created by guoshencheng on 11/23/15.
//  Copyright © 2015 guoshencheng. All rights reserved.
//

#import "CircleNavigationItem.h"

@interface CircleNavigationItem()

@property (weak, nonatomic) IBOutlet UIButton *itemButton;
@property (strong, nonatomic) MASConstraint *centerXConstraint;
@property (strong, nonatomic) MASConstraint *centerYConstraint;

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
    CircleNavigationItem *circleNavigationItem = [[[NSBundle mainBundle] loadNibNamed:@"CircleNavigationItem" owner:nil options:nil] lastObject];
    circleNavigationItem.translatesAutoresizingMaskIntoConstraints = NO;
    return circleNavigationItem;
}

- (void)setupWithImage:(UIImage *)image {
    [self.itemButton setImage:image forState:UIControlStateNormal];
}

- (void)configureConstraintWithWidth:(CGFloat)width height:(CGFloat)height {
    self.hidden = YES;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        self.centerXConstraint = make.centerX.equalTo(self.superview).offset(0);
        self.centerYConstraint = make.centerY.equalTo(self.superview).offset(0);
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
    [self.centerXConstraint pop_addAnimation:animationX forKey:@"centerX"];
    POPSpringAnimation *animationY = [self defalutOffsetSpringAnimationWithDelay:delay];
    animationY.toValue = @(self.targetPostion.y);
    [self.centerYConstraint pop_addAnimation:animationY forKey:@"centerY"];
}

- (void)animateToOriginPostionDelay:(CGFloat)delay {
    POPBasicAnimation *alphaAnimation = [self alphaAnimationWithDelay:delay fromAlpah:1 toAlpha:0];
    [self pop_addAnimation:alphaAnimation forKey:@"alpha"];
    [UIView animateWithDuration:0.2 animations:^{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            self.centerXConstraint = make.centerX.equalTo(self.superview).offset(0);
            self.centerYConstraint = make.centerY.equalTo(self.superview).offset(0);
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
