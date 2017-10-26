//
//  WYPhotoBrowseDrivenInteractive.m
//  WYPhotoBrowse
//
//  Created by liyongfang on 2017/10/25.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#import "WYPhotoBrowseDrivenInteractive.h"

@interface WYPhotoBrowseDrivenInteractive()

/** 转场上下文 */
@property (nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;
/** 交互式转场bgView */
@property(nonatomic, strong) UIView *bgView;
/** fromView */
@property(nonatomic, strong) UIView *fromView;
/** 背景view */
@property(nonatomic, strong) UIView *blackBgView;

@end
@implementation WYPhotoBrowseDrivenInteractive

{
    BOOL _isFirst;
}
- (instancetype)initWithGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer {
    self = [super init];
    if (self) {
        _isFirst = YES;
        _gestureRecognizer = gestureRecognizer;
        [_gestureRecognizer addTarget:self action:@selector(gestureRecognizeDidUpdate:)];
    }
    return self;
}

- (CGFloat)percentForGesture:(UIPanGestureRecognizer *)gesture {
    
    CGPoint translation = [gesture translationInView:gesture.view];
    CGFloat scale = 1 - fabs(translation.y / [UIScreen mainScreen].bounds.size.height);
    scale = scale < 0.6 ? 0.6 : scale;
    return scale;
}

/**
 * @brief 手势方法
 */
- (void)gestureRecognizeDidUpdate:(UIPanGestureRecognizer *)gestureRecognizer {
    
    CGFloat scrale = [self percentForGesture:gestureRecognizer];
    NSLog(@"interactive %f",scrale);
    
    //    if (_isFirst) {
    [self beginInterPercent];
    //        _isFirst = NO;
    //    }
    switch (gestureRecognizer.state) {
            
        case UIGestureRecognizerStateBegan:

            break;
        case UIGestureRecognizerStateChanged:
            [self updateInteractiveTransition:[self percentForGesture:gestureRecognizer]];
            [self updateInterPercent:[self percentForGesture:gestureRecognizer]];
            break;
        case UIGestureRecognizerStateEnded:
            
            if (scrale > 0.8f) {
                [self cancelInteractiveTransition];
                [self interPercentCancel];
            }else {
                [self finishInteractiveTransition];
                [self interPercentFinish:scrale];
            }
            break;
        default:
            [self cancelInteractiveTransition];
            [self interPercentCancel];
            break;
    }
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    self.transitionContext = transitionContext;
}


/**
 * @brief 手势开始
 */
- (void)beginInterPercent {
    
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    //转场过渡的容器view
    UIView *containerView = [transitionContext containerView];
    //ToVC
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toViewController.view;
    [containerView addSubview:toView];
    
    //有渐变的黑色背景
    _blackBgView = [[UIView alloc] initWithFrame:containerView.bounds];
    _blackBgView.backgroundColor = [UIColor blackColor];
    [containerView addSubview:_blackBgView];
    //FromVC
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = fromViewController.view;
    fromView.backgroundColor = [UIColor clearColor];
    [containerView addSubview:fromView];
}

/**
 * @brief 手势更新
 */
- (void)updateInterPercent:(CGFloat)scale {
    
    _blackBgView.alpha = scale;
    NSLog(@"scale = %.2f",scale);
}

/**
 * @brief 手势取消
 */
- (void)interPercentCancel {

    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    //转场过渡的容器view
    UIView *containerView = [transitionContext containerView];
    //FromVC
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = fromViewController.view;
    fromView.backgroundColor = [UIColor blackColor];
    [containerView addSubview:fromView];
    [_blackBgView removeFromSuperview];
    _blackBgView = nil;
    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
}

/**
 * @brief 手势完成
 */
- (void)interPercentFinish:(CGFloat)scale {
    
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    //转场过渡的容器view
    UIView *containerView = [transitionContext containerView];
    //ToVC
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toViewController.view;
    [containerView addSubview:toView];
    
    //有渐变的黑色背景
    UIView *bgView = [[UIView alloc] initWithFrame:containerView.bounds];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = scale;
    [containerView addSubview:bgView];
    
    //过渡的图片
    UIImageView *transitionImgView = [[UIImageView alloc] initWithImage:self.currenttransitionImage];
    transitionImgView.clipsToBounds = YES;
    transitionImgView.contentMode = UIViewContentModeScaleAspectFit;
    transitionImgView.frame = self.afterImageViewFrame;
    [containerView addSubview:transitionImgView];
    CGRect offsetFrame = CGRectZero;
    if (scale > 0.8) {
        offsetFrame = self.beforeImageViewFrame;
    }else {
        // 手势结束后，判断手势y值与转场前的frame做对比,大于则小时在底部，小于则消失在底部
        if ((transitionImgView.frame.origin.y > self.beforeImageViewFrame.origin.y) > 0) {
            offsetFrame = CGRectMake(self.afterImageViewFrame.origin.x, [UIScreen mainScreen].bounds.size.height, self.afterImageViewFrame.size.width,self.afterImageViewFrame.size.height);
        }else {
            offsetFrame = CGRectMake(self.afterImageViewFrame.origin.x, -self.afterImageViewFrame.size.height, self.afterImageViewFrame.size.width,self.afterImageViewFrame.size.height);
        }
    }
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
        
        transitionImgView.frame = offsetFrame;
        bgView.alpha = 0;
        
    }completion:^(BOOL finished) {
        
        NSLog(@"panGesture animation finished");
        
        [_blackBgView removeFromSuperview];
        _blackBgView = nil;
        [bgView removeFromSuperview];
        [transitionImgView removeFromSuperview];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (void)setGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer {
    
    _gestureRecognizer = gestureRecognizer;
     [_gestureRecognizer addTarget:self action:@selector(gestureRecognizeDidUpdate:)];

}

- (void)dealloc {
    
    [self.gestureRecognizer removeTarget:self action:@selector(gestureRecognizeDidUpdate:)];
}


@end
