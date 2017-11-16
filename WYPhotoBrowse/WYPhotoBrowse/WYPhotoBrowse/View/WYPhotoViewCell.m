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
#import <Photos/Photos.h>

@interface WYPhotoViewCell ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

/** UIScrollView */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 小菊花 */
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
        [self.scrollView addSubview:self.photoImageView];
        self.scrollView.frame = self.contentView.bounds;
        self.photoImageView.frame = self.scrollView.bounds;
        self.miniScale = 1.0;
        self.maxScale = 2.0;
        self.scrollView.zoomScale = self.miniScale;
        self.scrollView.maximumZoomScale = self.maxScale;
        [self addGesHandles];
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
    
    CGFloat Rw = MAX(1, _photoImageView.image.size.width /  _scrollView.frame.size.width);
    CGFloat Rh = MAX(1, _photoImageView.image.size.height / _scrollView.frame.size.height);
    _scrollView.contentOffset = CGPointZero;
    _scrollView.contentSize = self.bounds.size;
    _scrollView.minimumZoomScale = 1;
    _scrollView.maximumZoomScale = MAX(MAX(Rw, Rh), self.maxScale);
    if (_scrollView.maximumZoomScale == self.miniScale) {
        _scrollView.maximumZoomScale = self.maxScale;
    }
    self.miniScale = _scrollView.minimumZoomScale;
    self.maxScale = _scrollView.maximumZoomScale;
}

#pragma mark - scrollViewDelegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return self.photoImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    CGFloat Ws = _scrollView.frame.size.width - _scrollView.contentInset.left - _scrollView.contentInset.right;
    CGFloat Hs = _scrollView.frame.size.height - _scrollView.contentInset.top - _scrollView.contentInset.bottom;
    CGFloat W = self.photoImageView.frame.size.width;
    CGFloat H = self.photoImageView.frame.size.height;
    CGRect rct = self.photoImageView.frame;
    rct.origin.x = MAX((NSInteger)(Ws-W)/2, 0);
    rct.origin.y = MAX((NSInteger)(Hs-H)/2, 0);
    self.photoImageView.frame = rct;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
}

/** 请求相册里面的大图 */
- (void)requestImageFromModel:(WYPhotoBrowseModel *)model successBlock:(void (^)(UIImage * result))block {
    
    if (!model.photoPHAsset) {
        block(nil);
    } else {
        PHImageRequestOptions * options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        options.deliveryMode  = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        [[PHImageManager defaultManager] requestImageDataForAsset:model.photoPHAsset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                UIImage *image = [UIImage imageWithData:imageData];
                block(image);
            });
        }];
    }
}

#pragma mark - private method
- (void)setZoomScaleWithImage:(UIImage *)image {
    
    self.scrollView.zoomScale = self.miniScale;
    CGSize size = image.size;
    CGFloat ratio = MAX(size.width / self.scrollView.frame.size.width,size.height / self.scrollView.frame.size.height);
    if(ratio < 1) {
        self.photoImageView.frame = CGRectMake(0, 0, size.width, size.height);
        self.photoImageView.center = CGPointMake(CGRectGetWidth(self.scrollView.frame)/2.0,CGRectGetHeight(self.scrollView.frame)/2.0);
    }else {
        self.photoImageView.frame = CGRectMake(0, 0,CGRectGetWidth(self.scrollView.frame),CGRectGetHeight(self.scrollView.frame));
    }
    [self resetMMZoomScale];
    self.scrollView.zoomScale = self.miniScale;
}

#pragma mark- setters and getters
- (void)setModel:(WYPhotoBrowseModel *)model {
    
    _model = model;
    self.scrollView.zoomScale = self.miniScale;
    [self.indicatorView removeFromSuperview];
    self.indicatorView = nil;
    [self.indicatorView showIndicatorView];
    __weak typeof(self)weakSelf = self;
    if (model.photoPHAsset) {
        [self requestImageFromModel:model successBlock:^(UIImage *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.indicatorView stopIndicatorWithSucess: ((result == nil)? NO : YES)];
                weakSelf.photoImageView.image = result;
                [weakSelf setZoomScaleWithImage:weakSelf.photoImageView.image];
            });
        }];
    }else {
        // 加载网络图片
        [self setHightImageWithURL:model.photoHightImageUrlStr thumbImage:nil];
    }
}

/**
 * @brief 设置大图
 */
- (void)setHightImageWithURL:(NSString *)url thumbImage:(UIImage *)thumbImage {
    
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:thumbImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        // 隐藏菊花
        //        [self hideActivityAdicator];
        [self.indicatorView stopIndicatorWithSucess: !(!image && error)];
        if (!image && error) {
            return;
        }
        [self setZoomScaleWithImage:image];
    }];
}

- (UIImageView *)photoImageView {
    
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] init];
        _photoImageView.contentMode = UIViewContentModeScaleAspectFit;
        _photoImageView.backgroundColor = [UIColor clearColor];
    }
    return _photoImageView;
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

