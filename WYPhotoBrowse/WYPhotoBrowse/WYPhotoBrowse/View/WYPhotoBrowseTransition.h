//
//  WYPhotoBrowseTransition.h
//  WYPhotoBrowse
//
//  Created by liyongfang on 2017/10/25.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WYPhotoBrowseTransition : NSObject<UIViewControllerTransitioningDelegate>

/** 转场过渡的图片 */
- (void)setTransitionImage:(UIImage *)transitionImage;
/**  转场图片的url */
- (void)setTransitionImageUrl:(NSString *)transitionImgaeUrl;
/** 转场前的图片frame */
- (void)setTransitionBeforeImgFrame:(CGRect)frame;
/** 转场后的图片frame */
- (void)setTransitionAfterImgFrame:(CGRect)frame;

/** 交互式转场frame */
@property (nonatomic, assign) CGRect  beforeImageViewFrame;
/** 交互式转场后图片frame */
@property (nonatomic, assign) CGRect  currentImageViewFrame;
/** 交互式转场图片 */
@property (nonatomic, strong) UIImage  *currentImage;
/** 交互式转场横滑手势 */
@property (nonatomic, strong) UIPanGestureRecognizer *gestureRecognizer;
/** 渐进效果 */
@property (nonatomic, assign) BOOL isFadToShow;


@end
