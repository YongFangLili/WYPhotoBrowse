//
//  WYPhotoBrowseController.h
//  WYPhotoBrowse
//
//  Created by liyongfang on 2017/10/17.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPhotoBrowseModel.h"
@class WYPhotoBrowseController;
typedef NS_ENUM(NSUInteger, eWYPhotoBrowseType) {
    
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
- (void)wyPhotoBrowseControllerLoadView;
- (void)wyPhotoBrowseControllerViewWillAppear;
- (void)wyPhotoBrowseControllerViewWillDissAppear;
- (void)wyPhotoBrowseClickRightWithWYPhotoBrowseVC:(WYPhotoBrowseController *)browseVC;

@end

@interface WYPhotoBrowseController : UIViewController

/** 当前的currentIndex */
@property (nonatomic, assign) NSInteger currentIndex;

/** 照片数组 */
@property (nonatomic, strong) NSMutableArray *dataArray;

/** 浏览类型 */
@property (nonatomic, assign) eWYPhotoBrowseType browseType;

/** 关闭的交互类型 */
@property (nonatomic, assign) eWYPhotoBrowseInteractiveType InteractiveType;

/** 代理 */
@property (nonatomic, weak) id<WYPhotoBrowseControllerDelegate>delegate;


- (void)didClickRightButtonSucucess;

@end
