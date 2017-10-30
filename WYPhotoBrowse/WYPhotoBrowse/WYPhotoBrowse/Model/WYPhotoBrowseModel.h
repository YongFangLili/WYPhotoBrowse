//
//  WYPhotoBrowseModel.h
//  WYPhotoBrowse
//
//  Created by liyongfang on 2017/10/17.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYPhotoBrowseModel : NSObject

/** 图片imageUrl */
@property (nonatomic, copy) NSString *photoUrl;
/** 图片imageUrl */
@property (nonatomic, copy) NSString *photoImage;
/** 图片描述 */
@property (nonatomic, copy) NSString *photoDes;
/** 图片标题 */
@property (nonatomic, copy) NSString *potoesTitle;


/**
 *   获取图片_c地址 75%.
 *
 *  @return 图片_c地址
 */
- (NSString *)makeCImageLargeUrl;

@end
