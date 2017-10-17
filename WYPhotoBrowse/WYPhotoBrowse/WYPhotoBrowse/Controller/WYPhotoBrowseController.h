//
//  WYPhotoBrowseController.h
//  WYPhotoBrowse
//
//  Created by liyongfang on 2017/10/17.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPhotoBrowseModel.h"

@interface WYPhotoBrowseController : UIViewController

/** 当前的currentIndex */
@property (nonatomic, assign) NSInteger currentIndex;

/** 照片数组 */
@property (nonatomic, strong) NSMutableArray *dataArray;
@end
