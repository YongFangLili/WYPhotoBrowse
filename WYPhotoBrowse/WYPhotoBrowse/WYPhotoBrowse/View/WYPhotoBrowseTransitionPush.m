//
//  WYPhotoBrowseTransitionPush.m
//  WYPhotoBrowse
//
//  Created by liyongfang on 2017/10/25.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#import "WYPhotoBrowseTransitionPush.h"
#import <UIImageView+WebCache.h>
#import <SDWebImage/UIView+WebCache.h>

@implementation WYPhotoBrowseTransitionPush

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    return 0.5;
}
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    // 转场动画
    [self transitionAnimateWithIsFade:self.isFadToShow withtransitionContext:transitionContext];
}

- (void)transitionAnimateWithIsFade:(BOOL)isFade withtransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    //转场过渡的容器view
    UIView *containerView = [transitionContext containerView];
    
    //FromVC
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = fromViewController.view;
    [containerView addSubview:fromView];
    
    //ToVC
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toViewController.view;
    [containerView addSubview:toView];
    
    if (isFade) {
        toView.alpha = 0.0;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveLinear animations:^{
            toView.alpha = 1.0;
            
        } completion:^(BOOL finished) {
            
            toView.hidden = NO;
            [fromView removeFromSuperview];
            BOOL wasCancelled = [transitionContext transitionWasCancelled];
            //设置transitionContext通知系统动画执行完毕
            [transitionContext completeTransition:!wasCancelled];
        }];
        
    }else {
        
        toView.hidden = YES;
        //图片背景的空白view (设置和控制器的背景颜色一样，给人一种图片被调走的假象 [可以换种颜色看看效果])
        UIView *imgBgWhiteView = [[UIView alloc] initWithFrame:self.transitionBeforeImgFrame];
        imgBgWhiteView.backgroundColor = [UIColor clearColor];
        [containerView addSubview:imgBgWhiteView];
        
        //有渐变的黑色背景
        UIView *bgView = [[UIView alloc] initWithFrame:containerView.bounds];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0;;
        
        [containerView addSubview:bgView];
        
        //过渡的图片
        UIImageView *transitionImgView = [[UIImageView alloc] init];
        transitionImgView.backgroundColor = [UIColor clearColor];
        transitionImgView.contentMode = UIViewContentModeScaleAspectFit;
        transitionImgView.frame = self.transitionBeforeImgFrame;
        [transitionContext.containerView addSubview:transitionImgView];
        
        if (self.transitionImage) {
            transitionImgView.image = self.transitionImage;
        }
        
        // 如果没有图片加载网络图
        if (self.transitionImageUrl) {
            
            [transitionImgView sd_setShowActivityIndicatorView:YES];
            [transitionImgView sd_setShowActivityIndicatorView:YES];
            [transitionImgView sd_setImageWithURL:[NSURL URLWithString:self.transitionImageUrl] placeholderImage:nil options:SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [transitionImgView sd_setShowActivityIndicatorView:NO];
                if (image) {
                    transitionImgView.image = image;
                }else {
                    transitionImgView.image = [UIImage imageNamed:@"default_image_16_9"];
                }
            }];
        }
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveLinear animations:^{
            
            transitionImgView.frame = self.transitionAfterImgFrame;
            bgView.alpha = 1.0;
            
        } completion:^(BOOL finished) {
            
            toView.hidden = NO;
            [imgBgWhiteView removeFromSuperview];
            [bgView removeFromSuperview];
            [transitionImgView removeFromSuperview];
            [fromView removeFromSuperview];
            BOOL wasCancelled = [transitionContext transitionWasCancelled];
            //设置transitionContext通知系统动画执行完毕
            [transitionContext completeTransition:!wasCancelled];
        }];
    }
}

@end
