//
//  WYPhotoBrowseTransitionPop.h
//  WYPhotoBrowse
//
//  Created by liyongfang on 2017/10/25.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WYPhotoBrowseTransitionPop : NSObject<UIViewControllerAnimatedTransitioning>

/** 转场所使用的Image */
@property (nonatomic, strong) UIImage *transitionImage;

/** 转场前的Imageframe */
@property (nonatomic, assign) CGRect transitionBeforeImgFrame;  //转场前图片的frame

/** 转场后的imageFrame */
@property (nonatomic, assign) CGRect transitionAfterImgFrame;   //转场后图片的frame

/** 滑动手势 */
@property (nonatomic, strong) UIPanGestureRecognizer *gestureRecognizer;


@end
