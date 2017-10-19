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

@interface WYPhotoViewCell ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

/** 图片 */
@property (nonatomic, strong) UIImageView *imageView;

/** UIScrollView */
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) CGFloat miniScale;

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
        self.maxScale = 2.0;
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
    doubleTapOne.numberOfTouchesRequired = 1; doubleTapOne.numberOfTapsRequired = 2; doubleTapOne.delegate = self;
    [self.scrollView addGestureRecognizer:doubleTapOne];
//    self.currentZoomScale = self.scrollView.zoomScale;
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
        [self.scrollView setZoomScale:2 animated:YES];
    }
    
}

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
    if (_scrollView.maximumZoomScale == 1) {
        _scrollView.maximumZoomScale = 2;
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


#pragma mark- setters and getters
- (void)setModel:(WYPhotoBrowseModel *)model {
    
    _model = model;
    // 设置图片
    [self.imageView sd_setShowActivityIndicatorView:YES];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[model makeCImageLargeUrl]] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [self.imageView sd_setShowActivityIndicatorView:NO];
        
        if(!image) return ;
        
        _scrollView.zoomScale = 1;
        
        CGSize size = image.size;
        CGFloat ratio = MAX(size.width / _scrollView.frame.size.width,
                            size.height / _scrollView.frame.size.height);
        if(ratio < 1)
        {
//            self.imageView.contentMode = UIViewContentModeCenter;
            self.imageView.frame = CGRectMake(0, 0, size.width, size.height);
            self.imageView.center = CGPointMake(CGRectGetWidth(_scrollView.frame)/2.0,
                                                    CGRectGetHeight(_scrollView.frame)/2.0);
//            self.imageView.contentMode = UIViewContentModeCenter;
        }
        else
        {
            self.imageView.frame = CGRectMake(0, 0,
                                                  CGRectGetWidth(_scrollView.frame),
                                                  CGRectGetHeight(_scrollView.frame));
//            self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        }
        
//        self.imageView.frame = CGRectMake(0, 0,
//                                          CGRectGetWidth(self.containerView.frame),
//                                          CGRectGetHeight(self.containerView.frame));
        
        [self resetMMZoomScale];
        _scrollView.zoomScale = _scrollView.minimumZoomScale;
        
//        [self scrollViewDidZoom:_scrollView];
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
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.maximumZoomScale = 2.0;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = YES;
    }
    return _scrollView;
}

@end
