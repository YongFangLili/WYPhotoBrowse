//
//  WYPhotoBrowseTransition.m
//  WYPhotoBrowse
//
//  Created by liyongfang on 2017/10/25.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#import "WYPhotoBrowseTransition.h"
#import "WYPhotoBrowseTransitionPop.h"
#import "WYPhotoBrowseTransitionPush.h"
#import "WYPhotoBrowseDrivenInteractive.h"

@interface WYPhotoBrowseTransition()

/** push交互 */
@property (nonatomic, strong) WYPhotoBrowseTransitionPush *customPush;
/** pop交互 */
@property (nonatomic, strong) WYPhotoBrowseTransitionPop  *customPop;
/** 手势交互 */
@property (nonatomic, strong) WYPhotoBrowseDrivenInteractive  *percentIntractive;

@end

@implementation WYPhotoBrowseTransition

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    
    //动画执行者和 nav中一样,故此处不再重写，直接调用之前navigation中的创建好的类
    return self.customPush;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    
    //动画执行者和 nav中一样,故此处不再重写，直接调用之前navigation中的创建好的类
    return self.customPop;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    
    if (self.gestureRecognizer){
        return self.percentIntractive;
    }
    else{
        return nil;
    }
}

#pragma mark - getters && setters
- (void)setTransitionImageUrl:(NSString *)transitionImgaeUrl {
    
    self.customPush.transitionImageUrl = transitionImgaeUrl;
}

- (void)setIsFadToShow:(BOOL)isFadToShow {
    
    _isFadToShow = isFadToShow;
    self.customPush.isFadToShow = isFadToShow;
}

- (void)setTransitionBeforeImageFrame:(CGRect)transitionBeforeImageFrame {

    self.customPop.transitionBeforeImgFrame = transitionBeforeImageFrame;
    self.customPush.transitionBeforeImgFrame = transitionBeforeImageFrame;
    
    transitionBeforeImageFrame = [self imageScreenWithImageFrame:transitionBeforeImageFrame];
    _transitionBeforeImageFrame = transitionBeforeImageFrame;
    self.percentIntractive.beforeImageViewFrame = transitionBeforeImageFrame;
}

- (void)setTransitionAfterImgFrame:(CGRect)transitionAfterImgFrame {
    
    _transitionAfterImgFrame = transitionAfterImgFrame;
    self.customPush.transitionAfterImgFrame = transitionAfterImgFrame;
    self.customPop.transitionAfterImgFrame = transitionAfterImgFrame;
    self.percentIntractive.afterImageViewFrame = transitionAfterImgFrame;
}

- (void)setTransitionImage:(UIImage *)transitionImage {
    
    _transitionImage = transitionImage;
    self.percentIntractive.currenttransitionImage = transitionImage;
    self.customPush.transitionImage = transitionImage;
    self.customPop.transitionImage = transitionImage;
}

- (WYPhotoBrowseDrivenInteractive *)percentIntractive{
    
    if (!_percentIntractive) {
        _percentIntractive = [[WYPhotoBrowseDrivenInteractive alloc] initWithGestureRecognizer:self.gestureRecognizer];
    }
    return _percentIntractive;
}

- (WYPhotoBrowseTransitionPop *)customPop{
    
    if (!_customPop) {
        _customPop = [[WYPhotoBrowseTransitionPop alloc] init];
    }
    return _customPop;
}

- (WYPhotoBrowseTransitionPush *)customPush{
    
    if (_customPush == nil) {
        _customPush = [[WYPhotoBrowseTransitionPush alloc]init];
    }
    return _customPush;
}

- (CGRect)imageScreenWithImageFrame:(CGRect)imageFrame {
    
    CGFloat imageScale = imageFrame.size.height / imageFrame.size.width;
    imageScale = isnan(imageScale) ? 0 : imageScale;
    CGFloat screenScale = [UIScreen mainScreen].bounds.size.height / [UIScreen mainScreen].bounds.size.width;
    CGFloat afterHeight = 0;
    CGFloat afterWidth = 0;
    CGFloat afterleft = 0;
    CGFloat afterTop = 0;
    if (imageScale > screenScale) { // 长图
        
        afterHeight = [UIScreen mainScreen].bounds.size.height;
        afterWidth = afterHeight/imageScale;
        afterleft = ([UIScreen mainScreen].bounds.size.width - afterWidth) / 2;
        afterTop = 0;
    }else { // 短图
        afterWidth = [UIScreen mainScreen].bounds.size.width;
        afterHeight = [UIScreen mainScreen].bounds.size.width * imageScale;
        afterleft = 0;
        afterTop = ([UIScreen mainScreen].bounds.size.height - afterHeight) / 2;
    }
    return CGRectMake(afterleft, afterTop, afterWidth, afterHeight);
}


@end
