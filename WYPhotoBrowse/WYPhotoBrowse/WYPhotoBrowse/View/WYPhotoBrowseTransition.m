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

/** 转场过渡的图片 */
- (void)setTransitionImage:(UIImage *)transitionImage {
    
    self.customPush.transitionImage = transitionImage;
    self.customPop.transitionImage = transitionImage;
}

/** 转场前的图片frame */
- (void)setTransitionBeforeImgFrame:(CGRect)frame {
    
    self.customPop.transitionBeforeImgFrame = frame;
    self.customPush.transitionBeforeImgFrame = frame;
    self.percentIntractive.beforeImageViewFrame = frame;
}

/** 转场后的图片frame */
- (void)setTransitionAfterImgFrame:(CGRect)frame {
    
    self.customPush.transitionAfterImgFrame = frame;
    self.customPop.transitionAfterImgFrame = frame;
}

- (void)setTransitionImageUrl:(NSString *)transitionImgaeUrl {
    
    self.customPush.transitionImageUrl = transitionImgaeUrl;
}

- (void)setIsFadToShow:(BOOL)isFadToShow {
    
    _isFadToShow = isFadToShow;
    self.customPush.isFadToShow = isFadToShow;
}

-(void)setBeforeImageViewFrame:(CGRect)beforeImageViewFrame {
    
    beforeImageViewFrame = [self imageScreenWithImageFrame:beforeImageViewFrame];
    _beforeImageViewFrame = beforeImageViewFrame;
    self.percentIntractive.beforeImageViewFrame = beforeImageViewFrame;
}
- (void)setCurrentImageViewFrame:(CGRect)currentImageViewFrame {
    
    //    currentImageViewFrame = [self imageScreenWithImageFrame:currentImageViewFrame];
    _currentImageViewFrame = currentImageViewFrame;
    self.percentIntractive.currentImageViewFrame = currentImageViewFrame;
}

- (void)setCurrentImage:(UIImage *)currentImage {
    
    _currentImage = currentImage;
    
    self.percentIntractive.currenttransitionImage = currentImage;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    
    //动画执行者和 nav中一样,故此处不再重写，直接调用之前navigation中的创建好的类
    return self.customPush;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    
    //动画执行者和 nav中一样,故此处不再重写，直接调用之前navigation中的创建好的类
    return self.customPop;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator{
    
    if (self.gestureRecognizer){
        return self.percentIntractive;
    }
    else{
        return nil;
    }
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
