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
/**
 * @brief 图片加载失败
 */
- (void)wyPhotoBrowseCellLoadImageFaliured;

@end

@interface WYPhotoViewCell : UICollectionViewCell
/** 模型 */
@property (nonatomic, strong) WYPhotoBrowseModel *model;
/** 图片 */
@property (nonatomic, strong) UIImageView *photoImageView;
/** 代理 */
@property (nonatomic, weak)id<WYPhotoViewCellDelegate>delegate;

@end
