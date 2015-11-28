//
//  CircleNavigationItem.m
//  CircleNavigation
//
//  Created by guoshencheng on 11/23/15.
//  Copyright © 2015 guoshencheng. All rights reserved.
//

#import "CircleNavigationItem.h"

@interface CircleNavigationItem()

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UIView *labelViewContainerView;
@property (weak, nonatomic) IBOutlet UIButton *itemButton;
@property (weak, nonatomic) IBOutlet UIView *labelView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelViewLeftConstraint;

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
    CircleNavigationItem *circleNavigationItem = [[[NSBundle mainBundle] loadNibNamed:@"CircleNavigationItem" owner:nil options:nil] lastObject];
    circleNavigationItem.translatesAutoresizingMaskIntoConstraints = NO;
    return circleNavigationItem;
}

- (void)setupWithImage:(UIImage *)image highLightImage:(UIImage *)highLightImage title:(NSString *)title {
    self.itemImageView.backgroundColor = [UIColor clearColor];
    [self.itemButton setImage:image forState:UIControlStateNormal];
    self.label.text = title;
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
    self.labelViewLeftConstraint.constant = -80;
    [self layoutIfNeeded];
    self.layer.cornerRadius = self.frame.size.height / 2;
    self.labelViewContainerView.layer.cornerRadius = self.frame.size.height / 2;
    self.itemButton.transform = CGAffineTransformMakeRotation(M_PI_2 - self.angle);
    self.transform = CGAffineTransformMakeRotation(self.angle - M_PI_2);
    self.labelView.layer.cornerRadius = self.labelView.frame.size.height / 2;
}

- (void)animateToTargetPostionDelay:(CGFloat)delay {
    self.hidden = NO;
    POPBasicAnimation *alphaAnimation = [self alphaAnimationWithDelay:delay fromAlpah:0 toAlpha:1];
    alphaAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        [self springAnimatePopLabelView];
    };
    [self pop_addAnimation:alphaAnimation forKey:@"alpha"];
    POPSpringAnimation *animationX = [self defalutOffsetSpringAnimationWithDelay:delay];
    animationX.toValue = @(self.targetPostion.x);
    [self.leftConstraint pop_addAnimation:animationX forKey:@"centerX"];
    POPSpringAnimation *animationY = [self defalutOffsetSpringAnimationWithDelay:delay];
    animationY.toValue = @(-self.targetPostion.y);
    [self.bottomConstraint pop_addAnimation:animationY forKey:@"centerY"];
}

- (void)animateToOriginPostionDelay:(CGFloat)delay {
    self.labelViewLeftConstraint.constant = 20;
    [self baseAnimatePopLabelViewWithBlock:^(POPAnimation *anim, BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            __weak typeof(self) weakSelf = self;
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                self.leftConstraint = make.left.equalTo(@(weakSelf.originPostion.x));
                self.bottomConstraint = make.bottom.equalTo(@(-weakSelf.originPostion.y));
            }];
            self.alpha = 0;
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.hidden = YES;
        }];
    }];
}

#pragma mark - LiveCycle

#pragma mark - PrivateMethod

- (POPSpringAnimation *)defalutOffsetSpringAnimationWithDelay:(CGFloat)delay {
    POPSpringAnimation *animation = [POPSpringAnimation new];
    animation.property = [POPMutableAnimatableProperty mas_offsetProperty];
    animation.springBounciness = 15.0f;
    animation.springSpeed = 40.0f;
    animation.beginTime = CACurrentMediaTime() + delay;
    return animation;
}

- (void)baseAnimatePopLabelViewWithBlock:(void (^)(POPAnimation *anim, BOOL finished))block{
    POPBasicAnimation *layoutAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    layoutAnimation.duration = 0.1;
    layoutAnimation.toValue = @(-80);
    layoutAnimation.completionBlock = block;
    [self.labelViewLeftConstraint pop_addAnimation:layoutAnimation forKey:@"leftConstraint"];
}

- (void)springAnimatePopLabelView {
    POPSpringAnimation *layoutAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    layoutAnimation.springSpeed = 30.0f;
    layoutAnimation.springBounciness = 5.0f;
    layoutAnimation.toValue = @(20);
    [self.labelViewLeftConstraint pop_addAnimation:layoutAnimation forKey:@"leftConstraint"];
}

- (POPBasicAnimation *)alphaAnimationWithDelay:(CGFloat)delay fromAlpah:(CGFloat)fromAlpha toAlpha:(CGFloat)toAlpha {
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    animation.fromValue = @(fromAlpha);
    animation.toValue = @(toAlpha);
    animation.duration = 0.4;
    animation.beginTime = CACurrentMediaTime() + delay;
    return animation;
}

- (IBAction)didClickItem:(id)sender {
    if ([self.delegate respondsToSelector:@selector(circleNavigationItemDidClicked:)]) {
        [self.delegate circleNavigationItemDidClicked:self];
    }
    
}

@end
