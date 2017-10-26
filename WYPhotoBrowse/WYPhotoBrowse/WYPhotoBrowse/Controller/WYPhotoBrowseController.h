//
//  WYPhotoBrowseController.h
//  WYPhotoBrowse
//
//  Created by liyongfang on 2017/10/17.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPhotoBrowseModel.h"

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
- (void)ClickwyPhotoBrowseRightBtnWitheWYPhotoBrowseType:(eWYPhotoBrowseType *)BrowseType;
- (void)deletePhotoSucessfull;

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

@end
