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

/** 交互式转场frame */
@property (nonatomic, assign) CGRect  transitionBeforeImageFrame;
/** 交互式转场后图片frame */
@property (nonatomic, assign) CGRect transitionAfterImgFrame;
/** 交互式转场图片 */
@property (nonatomic, strong) UIImage *transitionImage;
/** 交互式转场横滑手势 */
@property (nonatomic, strong) UIPanGestureRecognizer *gestureRecognizer;
/** 渐进效果 */
@property (nonatomic, assign) BOOL isFadToShow;
/**
 * @brief image在屏幕中心的位置
 */
- (CGRect)imageScreenWithImageFrame:(CGRect)imageFrame;
@end
