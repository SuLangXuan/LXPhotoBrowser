//
//  LXPhotoBrowserTransitionManger.m
//  LXPhotoBrowser
//
//  Created by 轩 on 2017/5/8.
//  Copyright © 2017年 Xuan. All rights reserved.
//

#import "LXPhotoBrowserTransitionManger.h"
#define ANIMATIONTIME 1.0

@interface LXPhotoBrowserTransitionManger ()
///yes 正在转场 no dismiss 退场
@property (nonatomic,assign)BOOL presenting;
/** 最后的位置 */
//@property (nonatomic,assign)CGRect endRect;
@end

@implementation LXPhotoBrowserTransitionManger

#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    self.presenting = YES;
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    self.presenting = NO;
    return self;
}


#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return ANIMATIONTIME;
}


- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    self.presenting ? [self customPresent:transitionContext] : [self customDismiss:transitionContext] ;
}

#pragma mark - pravite
- (void)customPresent:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIView *formView = [transitionContext viewForKey:UITransitionContextToViewKey];
    [transitionContext.containerView addSubview:formView];
    formView.alpha = 0.0;
    transitionContext.containerView.backgroundColor = [UIColor blackColor];
    UIImageView *imgV;
    if ([self.presentDelegate respondsToSelector:@selector(getAnimationImageViewWithIndexPath:)]) {
        imgV = [self.presentDelegate getAnimationImageViewWithIndexPath:self.clickIndexPath];
    }
    if ([self.presentDelegate respondsToSelector:@selector(getStartRectWithIndexPath:)]) {
       imgV.frame = [self.presentDelegate getStartRectWithIndexPath:self.clickIndexPath];
    }
    
    [transitionContext.containerView addSubview:imgV];
    
    [UIView animateWithDuration:ANIMATIONTIME animations:^{
        if ([self.presentDelegate respondsToSelector:@selector(getEndRectWithIndexPath:)]) {
            imgV.frame = [self.presentDelegate getEndRectWithIndexPath:self.clickIndexPath];
        }
    } completion:^(BOOL finished) {
        [imgV removeFromSuperview];
        formView.alpha = 1.0;
        [transitionContext completeTransition:YES];
        transitionContext.containerView.backgroundColor = [UIColor clearColor];
    }];
}

- (void)customDismiss:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIView *toView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    [toView removeFromSuperview];
    UIImageView *imgV = [[UIImageView alloc] initWithImage:self.img];
    if ([self.dismissDelegate respondsToSelector:@selector(getImageViewForDismissView)]) {
        imgV = [self.dismissDelegate getImageViewForDismissView];
    }
    [transitionContext.containerView addSubview:imgV];
    transitionContext.containerView.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:ANIMATIONTIME animations:^{
        if ([self.dismissDelegate respondsToSelector:@selector(getCurrentIndexpathForDismissView)]) {
            NSIndexPath *currentIndexPath = [self.dismissDelegate getCurrentIndexpathForDismissView];
            if ([self.presentDelegate respondsToSelector:@selector(getStartRectWithIndexPath:)]) {
                imgV.frame = [self.presentDelegate getStartRectWithIndexPath:currentIndexPath];
            }
        }
    } completion:^(BOOL finished) {
        [imgV removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}

//- (void)setImg:(UIImage *)img{
//    _img = img;
//    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//    CGFloat h = width *img.size.height /img.size.width;
//    CGFloat y;
//    if (h > [UIScreen mainScreen].bounds.size.height) {
//        y = 0;
//        
//    }else{
//        y = ([UIScreen mainScreen].bounds.size.height - h)*0.5;
//    }
//    self.endRect = CGRectMake(0, y, width, h);
//    
//}

@end
