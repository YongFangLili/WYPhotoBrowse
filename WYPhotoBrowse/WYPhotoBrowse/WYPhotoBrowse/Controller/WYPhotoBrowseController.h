//
//  WYPhotoBrowseController.h
//  WYPhotoBrowse
//
//  Created by liyongfang on 2017/10/17.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPhotoBrowseModel.h"
#import "WYPhotoBrowseTransition.h"

@class WYPhotoBrowseController;
typedef NS_ENUM(NSUInteger, eWYPhotoBrowseRightButtonType) {
    
    // 默认
    eWYPhotoBrowseDefault = 0,
    // 删除
    eWYPhotoBrowseDelete = 1,
    // 保存
    eWYPhotoBrowseSave = 2,
};

typedef NS_ENUM(NSUInteger, eWYPhotoBrowseInteractiveType) {
    
    // 通过关闭按钮关闭页面
    eWYPhotoBrowseInteractiveCloseByButtonType = 1,
    // 通过手势点击进行关闭
    eWYPhotoBrowseInteractiveCloseByGestureClickType = 2,
};

@protocol WYPhotoBrowseControllerDelegate <NSObject>
@optional
/**
 * @brief loadView
 */
- (void)wyPhotoBrowseControllerLoadView;
/**
 * @brief viewWillAppear
 */
- (void)wyPhotoBrowseControllerViewWillAppear;
/**
 * @brief viewWillDisAppear
 */
- (void)wyPhotoBrowseControllerViewWillDissAppear;
/**
 * @brief 点击右侧按钮
 */
- (void)wyPhotoBrowseClickRightWithWYPhotoBrowseVC:(WYPhotoBrowseController *)browseVC;

@end

@interface WYPhotoBrowseController : UIViewController
/** 照片数组 */
@property (nonatomic, strong) NSMutableArray <WYPhotoBrowseModel *>*dataArray;
/** 当前的currentIndex */
@property (nonatomic, assign) NSInteger currentIndex;
/** 点击数组类型*/
@property (nonatomic, assign) eWYPhotoBrowseRightButtonType rightButtonType;
/** 关闭的交互类型 */
@property (nonatomic, assign) eWYPhotoBrowseInteractiveType interactiveType;
/** 代理 */
@property (nonatomic, weak) id<WYPhotoBrowseControllerDelegate>delegate;
/** 转场动画 */
@property (nonatomic, strong) WYPhotoBrowseTransition *animatedTransition;

/**
 * @brief 点击右边时间button成功
 */
- (void)didClickRightButtonSucucess;

@end
