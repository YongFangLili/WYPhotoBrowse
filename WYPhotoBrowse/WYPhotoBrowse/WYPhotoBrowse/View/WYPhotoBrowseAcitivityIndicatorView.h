//
//  WYPhotoBrowseAcitivityIndicatorView.h
//  WYPhotoBrowse
//
//  Created by liyongfang on 2017/10/31.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYPhotoBrowseAcitivityIndicatorView : UIView

/**
 * @brief 显示View
 */
- (void)showIndicatorView;

/**
 * @brief 影藏View
 */
- (void)stopIndicatorWithSucess:(BOOL)isSucecess;

@end
