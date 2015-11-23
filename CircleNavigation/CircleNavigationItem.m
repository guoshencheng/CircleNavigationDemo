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

- (void)animateToTargetPostion {
    self.hidden = NO;
    POPSpringAnimation *animationX = [POPSpringAnimation new];
    animationX.toValue = @(self.targetPostion.x);
    animationX.property = [POPMutableAnimatableProperty mas_offsetProperty];
    animationX.springBounciness = 10;
    animationX.springSpeed = 6;
    [self.centerXConstraint pop_addAnimation:animationX forKey:@"centerX"];
    POPSpringAnimation *animationY = [POPSpringAnimation new];
    animationY.toValue = @(self.targetPostion.y);
    animationY.property = [POPMutableAnimatableProperty mas_offsetProperty];
    animationY.springBounciness = 10;
    animationY.springSpeed = 6;
    [self.centerYConstraint pop_addAnimation:animationY forKey:@"centerY"];
}

- (void)animateToOriginPostion {
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
- (IBAction)didClickItem:(id)sender {
    if ([self.delegate respondsToSelector:@selector(circleNavigationItemDidClicked:)]) {
        [self.delegate circleNavigationItemDidClicked:self];
    }
    
}

@end
