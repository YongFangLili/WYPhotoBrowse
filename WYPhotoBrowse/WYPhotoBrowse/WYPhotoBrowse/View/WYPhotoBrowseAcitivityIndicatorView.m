//
//  WYPhotoBrowseAcitivityIndicatorView.m
//  WYPhotoBrowse
//
//  Created by liyongfang on 2017/10/31.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#import "WYPhotoBrowseAcitivityIndicatorView.h"


@interface WYPhotoBrowseAcitivityIndicatorView()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) UILabel *lableView;

@end


@implementation WYPhotoBrowseAcitivityIndicatorView

/**
 * @brief 显示View
 */
- (void)showIndicatorView {
    
     self.activityIndicator hidesWhenStopped = NO;
    [self.activityIndicator startAnimating];
   
}

/**
 * @brief 影藏View
 */
- (void)hideIndicatorView {
    
    [self.activityIndicator stopAnimating];
    self.activityIndicator hidesWhenStopped = YES;
    
}
@end
