//
//  WYPhotoViewCell.h
//  WYPhotoBrowse
//
//  Created by liyongfang on 2017/10/17.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPhotoBrowseModel.h"

@protocol WYPhotoViewCellDelegate <NSObject>

/**
 * @brief 单击手势点击
 */
- (void)clickSingleGesture;

@end

@interface WYPhotoViewCell : UICollectionViewCell
/** 模型 */
@property (nonatomic, strong) WYPhotoBrowseModel *model;

/** 代理 */
@property (nonatomic, weak)id<WYPhotoViewCellDelegate>delegate;

@end
