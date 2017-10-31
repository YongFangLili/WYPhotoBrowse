//
//  WYPhotoBrowseTransitionPush.h
//  WYPhotoBrowse
//
//  Created by liyongfang on 2017/10/25.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WYPhotoBrowseTransitionPush : NSObject<UIViewControllerAnimatedTransitioning>

/** 转场image */
@property (nonatomic, strong) UIImage *transitionImage;

/** push转场前的图片Frame */
@property (nonatomic, assign) CGRect transitionBeforeImgFrame;

/** push转场后的图片frame */
@property (nonatomic, assign) CGRect transitionAfterImgFrame;

/** 转场图片的URL */
@property (nonatomic, copy) NSString *transitionImageUrl;

/** 渐进效果 */
@property (nonatomic, assign) BOOL isFadToShow;


@end
