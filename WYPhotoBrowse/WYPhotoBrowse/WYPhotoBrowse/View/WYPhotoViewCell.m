//
//  WYPhotoViewCell.m
//  WYPhotoBrowse
//
//  Created by liyongfang on 2017/10/17.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#import "WYPhotoViewCell.h"
#import <UIImageView+WebCache.h>
#import <SDWebImage/UIView+WebCache.h>
#import "WYPhotoBrowseAcitivityIndicatorView.h"

@interface WYPhotoViewCell ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

/** UIScrollView */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 小菊花 */
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) WYPhotoBrowseAcitivityIndicatorView *indicatorView;
/** 最小缩放 */
@property (nonatomic, assign) CGFloat miniScale;
/** 最大缩放 */
@property (nonatomic, assign) CGFloat maxScale;
@end

@implementation WYPhotoViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self.contentView addSubview:self.scrollView];
        [self.scrollView addSubview:self.imageView];
        self.scrollView.frame = self.bounds;
        self.imageView.frame = self.scrollView.bounds;
        self.miniScale = 1.0;
        self.maxScale = 3.0;
        [self addGesHandles];
        self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
//        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
//        //设置小菊花的frame
//        self.activityIndicator.frame= CGRectMake(100, 100, 50, 50);
//        //设置小菊花颜色
//        self.activityIndicator.color = [UIColor whiteColor];
//        //设置背景颜色
//        self.activityIndicator.backgroundColor = [UIColor clearColor];
//        self.activityIndicator.center = self.contentView.center;
//        self.activityIndicator.hidesWhenStopped = NO;
    }
    return self;
}

/**
 * @brief 添加手势
 */
- (void)addGesHandles {
    
    // 添加手势 单个手指双击
    UITapGestureRecognizer *doubleTapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapOne.numberOfTouchesRequired = 1;
    doubleTapOne.numberOfTapsRequired = 2;
    doubleTapOne.delegate = self;
    [self.scrollView addGestureRecognizer:doubleTapOne];
    // 点击手势  单击
    UITapGestureRecognizer *singleTapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTapOne.numberOfTouchesRequired = 1;
    singleTapOne.numberOfTapsRequired = 1;
    singleTapOne.delegate = self;
    [self.scrollView addGestureRecognizer:singleTapOne];
    // 解决单个手指单击和双击冲突问题
    [singleTapOne requireGestureRecognizerToFail:doubleTapOne];
}

#pragma mark - Click Method
- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer {
    
    // 双击放大成两倍 再双击还原为原来的倍数
    if (self.scrollView.zoomScale != self.miniScale) {
        
        [self.scrollView setZoomScale:self.miniScale animated:YES];
    }else {
        [self.scrollView setZoomScale:self.maxScale animated:YES];
    }
    
}

/**
 * @brief 单击手势
 */
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    
    // 单个手指单击，设置隐藏与显示
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickSingleGesture)]) {
        [self.delegate clickSingleGesture];
    }
}

/**
 *  设置minimumZoomScale 和 maximumZoomScale.
 */
- (void)resetMMZoomScale {
    
    CGFloat Rw = MAX(1, _imageView.image.size.width /  _scrollView.frame.size.width);
    CGFloat Rh = MAX(1, _imageView.image.size.height / _scrollView.frame.size.height);
    _scrollView.contentOffset = CGPointZero;
    _scrollView.contentSize = self.bounds.size;
    _scrollView.minimumZoomScale = 1;
    _scrollView.maximumZoomScale = MAX(MAX(Rw, Rh), 1);
    if (_scrollView.maximumZoomScale == self.miniScale) {
        _scrollView.maximumZoomScale = self.maxScale;
    }
    self.miniScale = _scrollView.minimumZoomScale;
    self.maxScale = _scrollView.maximumZoomScale;
}

#pragma mark - scrollViewDelegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    CGFloat Ws = _scrollView.frame.size.width - _scrollView.contentInset.left - _scrollView.contentInset.right;
    CGFloat Hs = _scrollView.frame.size.height - _scrollView.contentInset.top - _scrollView.contentInset.bottom;
    CGFloat W = self.imageView.frame.size.width;
    CGFloat H = self.imageView.frame.size.height;
    CGRect rct = self.imageView.frame;
    rct.origin.x = MAX((NSInteger)(Ws-W)/2, 0);
    rct.origin.y = MAX((NSInteger)(Hs-H)/2, 0);
    self.imageView.frame = rct;
}

/**
 * @brief 显示菊花
 */
- (void)showActivityAdicator {
    
    self.activityIndicator.hidesWhenStopped = NO;
    [self.activityIndicator startAnimating];
}
/**
 * @brief 隐藏菊花
 */
- (void)hideActivityAdicator {
    
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidesWhenStopped = YES;
}

#pragma mark- setters and getters
- (void)setModel:(WYPhotoBrowseModel *)model {
    
    _model = model;
    [self resetMMZoomScale];
//    [self showActivityAdicator];
    [self.indicatorView removeFromSuperview];
    self.indicatorView = nil;
    [self.indicatorView showIndicatorView];
    // 以缩略图作为默认进来的图片
    [self setHightImageWithURL:model.photoHightImageUrlStr thumbImage:nil];
//    __weak typeof(self) weakSelf = self;
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.photoThumbnailUrlStr] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        [weakSelf setHightImageWithURL:model.photoHightImageUrlStr thumbImage:image];
//    }];
}

- (void)setHightImageWithURL:(NSString *)url thumbImage:(UIImage *)thumbImage {
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:thumbImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        // 隐藏菊花
//        [self hideActivityAdicator];
        [self.indicatorView stopIndicatorWithSucess: !(!image && error)];
        if (!image && error) {
//            if (self.delegate && [self.delegate respondsToSelector:@selector(wyPhotoBrowseCellLoadImageFaliured)]) {
//                [self.delegate wyPhotoBrowseCellLoadImageFaliured];
//            }
            return;
        }
        self.scrollView.zoomScale = self.miniScale;
        CGSize size = image.size;
        CGFloat ratio = MAX(size.width / _scrollView.frame.size.width,size.height / _scrollView.frame.size.height);
        if(ratio < 1) {
            self.imageView.frame = CGRectMake(0, 0, size.width, size.height);
            self.imageView.center = CGPointMake(CGRectGetWidth(self.scrollView.frame)/2.0,CGRectGetHeight(self.scrollView.frame)/2.0);
        }else {
            self.imageView.frame = CGRectMake(0, 0,CGRectGetWidth(self.scrollView.frame),CGRectGetHeight(self.scrollView.frame));
        }
        [self resetMMZoomScale];
        self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
    }];
}

- (UIImageView *)imageView {
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.backgroundColor = [UIColor clearColor];
    }
    return _imageView;
}

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.minimumZoomScale = self.miniScale;
        _scrollView.maximumZoomScale = self.maxScale;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = YES;
    }
    return _scrollView;
}

- (WYPhotoBrowseAcitivityIndicatorView *)indicatorView {

    if (!_indicatorView) {
        _indicatorView = [[WYPhotoBrowseAcitivityIndicatorView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:_indicatorView];
    }
    return _indicatorView;
}
@end
