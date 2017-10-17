//
//  WYPhotoBrowseModel.h
//  WYPhotoBrowse
//
//  Created by liyongfang on 2017/10/17.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYPhotoBrowseModel : NSObject

// imageUrl
@property (nonatomic, copy) NSString *photoUrl;

// 图片image
@property (nonatomic, copy) NSString *photoImage;

/**
 *   获取图片_c地址 75%.
 *
 *  @return 图片_c地址
 */
- (NSString *)makeCImageLargeUrl;

@end
