//
//  WYPhotoBrowseDrivenInteractive.h
//  WYPhotoBrowse
//
//  Created by liyongfang on 2017/10/25.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WYPhotoBrowseDrivenInteractive : UIPercentDrivenInteractiveTransition

/**
 * @brief 初始化交互式转场
 * @parame gestureRecognizer 手势
 */
- (instancetype)initWithGestureRecognizer:(UIPanGestureRecognizer*)gestureRecognizer;

/** 转场前的图片frame */
@property (nonatomic, assign) CGRect     beforeImageViewFrame;
/** 当前图片的frame */
@property (nonatomic, assign) CGRect     currentImageViewFrame;
/** 当前转场的图片 */
@property (nonatomic, strong) UIImage    *currenttransitionImage;

@end
