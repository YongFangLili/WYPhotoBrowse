//
//  WYPhotoBrowseModel.h
//  WYPhotoBrowse
//
//  Created by liyongfang on 2017/10/17.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface WYPhotoBrowseModel : NSObject

/** 图片缩略图imageUrl */
@property (nonatomic, copy) NSString *photoThumbnailUrlStr;
/** 图片大图imageUrl */
@property (nonatomic, copy) NSString *photoHightImageUrlStr;
/** 图片描述 */
@property (nonatomic, copy) NSString *photoDes;
/** 图片标题 */
@property (nonatomic, copy) NSString *photoesTitle;
/** 默认图名称 */
@property (nonatomic, copy) NSString *photoesDefaultStr;
/** 图片ID */
@property (nonatomic, copy) NSString *photoID;
/**  PHAsset 从相册取的图片 */
@property (nonatomic, strong) PHAsset * photoPHAsset;


@end
