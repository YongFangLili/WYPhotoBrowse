//
//  WYPhotoBrowseAcitivityIndicatorView.m
//  WYPhotoBrowse
//
//  Created by liyongfang on 2017/10/31.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#import "WYPhotoBrowseAcitivityIndicatorView.h"


@interface WYPhotoBrowseAcitivityIndicatorView()

// 转动小菊花
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

// 加载失败图片
@property (nonatomic, strong) UIImageView *faliureImageView;

// labelText
@property (nonatomic, strong) UILabel *lableView;

@end


@implementation WYPhotoBrowseAcitivityIndicatorView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.activityIndicator];
        [self addSubview:self.lableView];
        self.activityIndicator.frame = CGRectMake(self.center.x - 30 / 2 , self.center.y - 30 / 2 - 10, 30, 30);
        self.lableView.frame = CGRectMake(0, CGRectGetMaxY(self.activityIndicator.frame) + 5,self.bounds.size.width, 16);
    }
    return self;
}

/**
 * @brief 显示View
 */
- (void)showIndicatorView {
    
    self.activityIndicator.frame = CGRectMake(self.center.x - 30 / 2 ,self.center.y - 30 / 2 -10, 30, 30);
    self.lableView.frame = CGRectMake(0, CGRectGetMaxY(self.activityIndicator.frame) + 20,self.bounds.size.width, 16);
    self.activityIndicator.hidesWhenStopped = NO;
    [self.activityIndicator startAnimating];
}

/**
 * @brief 影藏View
 */
- (void)stopIndicatorWithSucess:(BOOL)isSucecess {
    
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidesWhenStopped = YES;
    if (isSucecess) {
        [self removeFromSuperview];
    }else {
        self.faliureImageView.hidden = NO;
        [self addSubview:self.faliureImageView];
        self.faliureImageView.frame = CGRectMake(self.center.x - 103 / 2, self.center.y - 88 / 2 - 10, 103, 88);
        self.lableView.frame = CGRectMake(0, CGRectGetMaxY(self.faliureImageView.frame) + 20,self.bounds.size.width, 16);
        self.lableView.text = @"图片加载失败, 请稍后重试";
    }
}

#pragma mark - lazy
- (UIActivityIndicatorView *)activityIndicator {
    
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
        //设置小菊花的frame
        _activityIndicator.frame= CGRectMake(self.center.x - 30 / 2 , self.bounds.size.height / 2- 30 / 2 - 10, 30, 30);
        //设置小菊花颜色
        _activityIndicator.color = [UIColor whiteColor];
        //设置背景颜色
        _activityIndicator.backgroundColor = [UIColor clearColor];
        _activityIndicator.hidesWhenStopped = NO;
    }
    return _activityIndicator;
}

- (UILabel *)lableView {
    
    if (!_lableView) {
        _lableView = [[UILabel alloc] init];
        _lableView.textColor = [UIColor whiteColor];
        _lableView.font = [UIFont systemFontOfSize:15];
        _lableView.textAlignment = NSTextAlignmentCenter;
        _lableView.text = @"加载中，请稍后";
    }
    return _lableView;
}

- (UIImageView *)faliureImageView {
    
    if (!_faliureImageView) {
        _faliureImageView = [[UIImageView alloc] init];
        _faliureImageView.hidden = YES;
        _faliureImageView.backgroundColor = [UIColor clearColor];
        _faliureImageView.contentMode = UIViewContentModeScaleAspectFit;
        _faliureImageView.image = [UIImage imageNamed:@"WYPhotoBrowse_loadfail"];
    }
    return _faliureImageView;
}
@end
