//
//  WYPhotoBrowseController.m
//  WYPhotoBrowse
//
//  Created by liyongfang on 2017/10/17.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#import "WYPhotoBrowseController.h"
#import "WYPhotoViewCell.h"
#import "WYPhotoBrowseTransition.h"
#import "WYPhotoBrowseDrivenInteractive.h"
#import "MBProgressHUD.h"

#define kWYDesphotoViewWidth ([UIScreen mainScreen].bounds.size.width - kWYLeftMargin_15 - kWYLeftMargin_15)
#define kWYiPhoneXInch ([UIScreen mainScreen].bounds.size.height == 812.0)
#define kWYNavHeight   (kWYiPhoneXInch ? 88 : 64)
#define kWYTopButtonHeight 46
#define kWYLeftMargin_15 15
#define kWYLeftMargin_10 10
#define kWYTopButtonY (kWYNavHeight - kWYTopButtonHeight)

static NSString *kWYPhotoBrowseCellIdentifier = @"WY_PhotoBrowseCellIdentifier";
@interface WYPhotoBrowseController ()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UIGestureRecognizerDelegate,
UITextViewDelegate,
WYPhotoViewCellDelegate
>

/** collectionView */
@property (nonatomic, strong) UICollectionView *collectionView;
/** 顶部view  关闭按钮  保存  删除  */
@property (nonatomic, strong) UIView *topView;
/** 底部View   详情   页码*/
@property (nonatomic, strong) UIView *bottomView;
/** 图片描述View */
@property (nonatomic, strong) UITextView *photoDesView;
/** pageLable */
@property (nonatomic, strong) UILabel *pageLable;
/** title */
@property (nonatomic, strong) UILabel *titleLable;
/** 图片的中心 */
@property (nonatomic, assign) CGPoint transitionImgViewCenter;
/** topView的中心 */
@property (nonatomic, assign) CGPoint transitionTopViewCenter;
/** 底部view的中心 */
@property (nonatomic, assign) CGPoint transitionBottomViewCenter;
 @end

@implementation WYPhotoBrowseController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO; 
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setUpUI];
    [self addPanGesture];
      self.animatedTransition.isFadToShow = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (self.delegate && [self.delegate respondsToSelector:@selector(wyPhotoBrowseControllerViewWillAppear)]) {
        [self.delegate wyPhotoBrowseControllerViewWillAppear];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if (self.delegate && [self.delegate respondsToSelector:@selector(wyPhotoBrowseControllerViewWillDissAppear)]) {
        [self.delegate wyPhotoBrowseControllerViewWillDissAppear];
    }
}

- (void)setUpUI {

    // collectionView
    [self.view addSubview:self.collectionView];
    // topView
    [self.view addSubview:self.topView];//18
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(kWYLeftMargin_10, kWYTopButtonY, kWYTopButtonHeight, kWYTopButtonHeight)];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(clickCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:closeBtn];
    // 保存或者是删除
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - kWYLeftMargin_10 - kWYTopButtonHeight , kWYTopButtonY, kWYTopButtonHeight, kWYTopButtonHeight)];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
 [rightBtn addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    switch (self.rightButtonType) {
        case eWYPhotoBrowseSave:
            [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
            [self.topView addSubview:rightBtn];
            break;
        case eWYPhotoBrowseDelete:
            [rightBtn setTitle:@"删除" forState:UIControlStateNormal];
            [self.topView addSubview:rightBtn];
            break;
        case eWYPhotoBrowseDefault:
        default:
            break;
    }
    self.titleLable.frame = CGRectMake(CGRectGetMaxX(closeBtn.frame), kWYTopButtonY, self.view.bounds.size.width - 2 *(CGRectGetMaxX(closeBtn.frame)) , kWYTopButtonHeight);
    [self.topView addSubview:self.titleLable];
    // bottomView
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.pageLable];
    [self.bottomView addSubview:self.photoDesView];
    [self updatePageDes];
}

/**
 * @brief 添加手势
 */
- (void)addPanGesture {
    
    // 创建转场手势
    UIPanGestureRecognizer *interactiveTransitionRecognizer;
    interactiveTransitionRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(interactiveTransitionRecognizerAction:)];
    [self.view addGestureRecognizer:interactiveTransitionRecognizer];
}

#pragma mark - click Mehod
- (void)clickCloseBtn:(UIButton *)btn {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickRightBtn:(UIButton *)btn {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(wyPhotoBrowseClickRightWithWYPhotoBrowseVC:)]) {
        [self.delegate wyPhotoBrowseClickRightWithWYPhotoBrowseVC:self];
    }
}

#pragma mark - private method
- (void)updatePageDes {
    
    // 更新page  更新detail
    WYPhotoBrowseModel *model = self.dataArray[self.currentIndex];
    NSString *pageText = [NSString stringWithFormat:@"%zd / %zd",self.currentIndex + 1,self.dataArray.count];
    NSRange xiegangRang = [pageText rangeOfString:@" /"];
    NSRange range = NSMakeRange(0, xiegangRang.location);
    NSMutableAttributedString * pageAttributeStr= [[NSMutableAttributedString alloc]initWithString:pageText];
    [pageAttributeStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:range];
    [pageAttributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(NSMaxRange(xiegangRang), pageText.length-NSMaxRange(xiegangRang))];
    
    self.pageLable.attributedText = pageAttributeStr;
    [self.bottomView addSubview:self.pageLable];
    self.photoDesView.text  = model.photoDes;
    self.titleLable.text = model.photoesTitle;
    
    // 更新frame
    // 设置富文本，设置版本更显描述textView
    CGFloat desViewHeight = 0.0;
    // 处理为nil的情况
    if (!model.photoDes && model.photoDes.length == 0) {
    }else {
        
        NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc]initWithString:model.photoDes];
        NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc]init];
        [paragraph setLineSpacing:4];//设置行间距
        [paragraph setParagraphSpacing:5];//设置段落间距
        NSDictionary *attributeDic = @{NSFontAttributeName:[UIFont systemFontOfSize:13],NSParagraphStyleAttributeName:paragraph,NSForegroundColorAttributeName:[UIColor whiteColor] };
        [attributeStr setAttributes:attributeDic range:NSMakeRange(0, attributeStr.length)];
        desViewHeight = [model.photoDes boundingRectWithSize:CGSizeMake(kWYDesphotoViewWidth,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributeDic context:nil].size.height;
        desViewHeight = desViewHeight > (4 * 13 + 4 * 4 + 13 + 13/2) ? (4 * 13 + 4 * 4 + 13 + 13/2) : desViewHeight;
        self.photoDesView.attributedText = attributeStr;
    }
    CGFloat bottomViewHeight = (kWYLeftMargin_15 + kWYLeftMargin_15 * 2) + desViewHeight;
    self.bottomView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height -  bottomViewHeight, [UIScreen mainScreen].bounds.size.width, bottomViewHeight);
    self.pageLable.frame = CGRectMake(kWYLeftMargin_15, bottomViewHeight - kWYLeftMargin_15 * 2, [UIScreen mainScreen].bounds.size.width - kWYLeftMargin_15 * 2, kWYLeftMargin_15 * 2);
    self.photoDesView.frame = CGRectMake(kWYLeftMargin_15, kWYLeftMargin_15, kWYDesphotoViewWidth, desViewHeight);
    [self.collectionView setContentOffset:CGPointMake(self.currentIndex *([UIScreen mainScreen].bounds.size.width), 0)];
}

/**
 * @brief 点击右侧按钮回调
 */
- (void)didClickRightButtonSucucess {
    
    switch (self.rightButtonType) {
        case eWYPhotoBrowseSave:
            [self savePhoto];
            break;
        case eWYPhotoBrowseDelete:
            [self deletePhotoSucessfull];
            break;
        default:
            break;
    }
}

/**
 * @brief 保存相册
 */
- (void)savePhoto {
    // 保存相册
    WYPhotoViewCell*cell =(WYPhotoViewCell *) [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
    UIImageWriteToSavedPhotosAlbum(cell.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

/**
 * @brief 相册保存成功
 */
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.mode = MBProgressHUDModeText;
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.bezelView.alpha = 0.5;
    hud.detailsLabel.textColor  = [UIColor whiteColor];
    hud.detailsLabel.font = [UIFont systemFontOfSize:16.0];

    if(error != NULL){
        NSLog(@"保存失败");
        hud.detailsLabel.text = @"保存失败";
    }else{
        hud.detailsLabel.text  = @"保存成功";
    }
    [self.view addSubview:hud];
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:1.5];
}
                   
#pragma mark 隐藏弹框
- (void)hideHUDForView:(UIView *)view {
    
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
        [MBProgressHUD hideHUDForView:view animated:YES];
}

- (void)hideHUD {
    
    [self hideHUDForView:nil];
}
- (void)deletePhotoSucessfull {
    
    [self upDateData];
}

/**
 * @brief 删除成功后，移除删除的model
 */
- (void)upDateData {
    
    WYPhotoBrowseModel *model = self.dataArray[self.currentIndex];
    if ([self.dataArray containsObject:model]) {
        [self.dataArray removeObject:model];
    }
    if (self.dataArray.count == 0) {
        // 刷新图集数据
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self dismissViewControllerAnimated:YES completion:nil];
        });
        return;
    }
    if (self.currentIndex >= self.dataArray.count) {
        self.currentIndex = self.dataArray.count -1;
    }
    [self.collectionView reloadData];
    [self updatePageDes];
}

/**
 * @brief 隐藏头部与底部视图
 */
- (void)hideTopAndBottomView {
    
    [UIView animateWithDuration:(0.25) animations:^{
        if (self.topView.frame.origin.y < 0) {
            self.topView.frame = CGRectMake(self.topView.frame.origin.x,0 , self.topView.bounds.size.width, self.topView.bounds.size.height);
            self.bottomView.frame = CGRectMake(self.bottomView.frame.origin.x, [UIScreen mainScreen].bounds.size.height - self.bottomView.bounds.size.height, self.bottomView.bounds.size.width, self.bottomView.bounds.size.height);
        }else {
            self.topView.frame = CGRectMake(self.topView.frame.origin.x,-self.topView.bounds.size.height, self.topView.bounds.size.width, self.topView.bounds.size.height);
            self.bottomView.frame = CGRectMake(self.bottomView.frame.origin.x, [UIScreen mainScreen].bounds.size.height, self.bottomView.bounds.size.width, self.bottomView.bounds.size.height);
        }
    }];
}
/**
 * @brief 图片在整个屏幕的位置
 */
- (CGRect)backScreenImageViewRectWithImage:(UIImage *)image {
    
    if (image) {
        CGFloat imageScale = image.size.height / image.size.width;
        imageScale = isnan(imageScale) ? 0 : imageScale;
        CGFloat screenScale = [UIScreen mainScreen].bounds.size.height / [UIScreen mainScreen].bounds.size.width;
        CGFloat afterHeight = 0;
        CGFloat afterWidth = 0;
        CGFloat afterleft = 0;
        CGFloat afterTop = 0;
        if (imageScale > screenScale) { // 长图
            afterHeight = [UIScreen mainScreen].bounds.size.height;
            afterWidth = afterHeight/imageScale;
            afterleft = ([UIScreen mainScreen].bounds.size.width - afterWidth) / 2;
            afterTop = 0;
        }else { // 短图
            afterWidth = [UIScreen mainScreen].bounds.size.width;
            afterHeight = [UIScreen mainScreen].bounds.size.width * imageScale;
            afterleft = 0;
            afterTop = ([UIScreen mainScreen].bounds.size.height - afterHeight) / 2;
        }
        return CGRectMake(afterleft, afterTop, afterWidth, afterHeight);
    }
    return CGRectZero;
}

#pragma mark - collectionDataSource & collectionDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    WYPhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kWYPhotoBrowseCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // 获取当前的index
    if ([scrollView isEqual:self.photoDesView]) return;
    NSInteger index = scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
    self.currentIndex = index;
    // 更新页码与详情
    [self updatePageDes];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    //  更新textView禁止编辑
    return NO;
}

#pragma mark - cellDelegate 单击手势点击
- (void)clickSingleGesture {
    
    // 隐藏动画 （如果）
    switch (self.interactiveType) {
            // button点击类型  隐藏
        case eWYPhotoBrowseInteractiveCloseByButtonType:
        {
            [self hideTopAndBottomView];
        }
            break;
            // 手势点击关闭
        case eWYPhotoBrowseInteractiveCloseByGestureClickType:
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        default:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
    }
}

/**
 * @brief pan手势滑动（上下滑动image）
 */
- (void)interactiveTransitionRecognizerAction:(UIPanGestureRecognizer *)gestureRecognizer {
    
    // 获取当前的cell
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    WYPhotoViewCell*cell =(WYPhotoViewCell *) [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
    CGFloat scale = 1 - fabs(translation.y / [UIScreen mainScreen].bounds.size.height);
    scale = scale < 0.2 ? 0.2 : scale;
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateBegan:{
            //1. 设置代理
            self.animatedTransition = nil;
            self.animatedTransition.gestureRecognizer = gestureRecognizer;
            self.transitioningDelegate = self.animatedTransition;
            self.transitionImgViewCenter = cell.imageView.center;
            self.transitionBottomViewCenter = self.bottomView.center;
            self.transitionTopViewCenter = self.topView.center;
            //3.dismiss
            [self dismissViewControllerAnimated:YES completion:nil];
            self.animatedTransition.transitionBeforeImageFrame = [self backScreenImageViewRectWithImage:cell.imageView.image];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            
            cell.imageView.center = CGPointMake(cell.imageView.center.x, self.transitionImgViewCenter.y + translation.y);
            if (cell.imageView.center.y >= self.transitionImgViewCenter.y && translation.y >= 0) {
                self.bottomView.center = CGPointMake(self.bottomView.center.x, self.transitionBottomViewCenter.y + translation.y);
                self.topView.center = CGPointMake(self.bottomView.center.x, self.transitionTopViewCenter.y - translation.y);
            }else {
                self.bottomView.center = CGPointMake(self.bottomView.center.x, self.transitionBottomViewCenter.y - translation.y);
                self.topView.center = CGPointMake(self.topView.center.x, self.transitionTopViewCenter.y +translation.y);
            }
        }
            break;
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            if (scale > 0.8f) {
                [UIView animateWithDuration:0.2 animations:^{
                    // 重置位置
                    cell.imageView.center = self.transitionImgViewCenter;
                    cell.imageView.alpha = 1.0;
                    cell.imageView.transform = CGAffineTransformMakeScale(1, 1);
                    self.bottomView.center = self.transitionBottomViewCenter;
                    self.topView.center = self.transitionTopViewCenter;
                } completion:^(BOOL finished) {
                    self.animatedTransition.gestureRecognizer = nil;
                }];
            }
            CGRect originFrame = [self backScreenImageViewRectWithImage:cell.imageView.image];
            self.animatedTransition.transitionImage = cell.imageView.image;
            self.animatedTransition.transitionAfterImgFrame = CGRectMake(originFrame.origin.x ,cell.imageView.center.y - originFrame.size.height / 2,originFrame.size.width, originFrame.size.height);
        }
    }
}

#pragma mark - lazy
- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
        layOut.minimumLineSpacing = 0;
        layOut.minimumInteritemSpacing = 0;
        layOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layOut.itemSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layOut];
        [_collectionView registerClass:[WYPhotoViewCell class] forCellWithReuseIdentifier:kWYPhotoBrowseCellIdentifier];
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}

- (UIView *)topView {
    
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kWYNavHeight)];
        _topView.backgroundColor = [UIColor blackColor];
        _topView.alpha = 0.7;
    }
    return _topView;
}

- (UITextView *)photoDesView {
    
    if (!_photoDesView) {
        _photoDesView = [[UITextView alloc] init];
        _photoDesView.font = [UIFont systemFontOfSize:13];
        _photoDesView.textColor = [UIColor whiteColor];
        _photoDesView.backgroundColor = [UIColor clearColor];
        _photoDesView.delegate = self;
        _photoDesView.textContainerInset = UIEdgeInsetsZero;
        _photoDesView.showsHorizontalScrollIndicator = NO;
        _photoDesView.showsVerticalScrollIndicator = YES;
        _photoDesView.alwaysBounceVertical = YES;
        _photoDesView.layoutManager.allowsNonContiguousLayout = NO;
        _photoDesView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    }
    return _photoDesView;
}

- (UILabel *)pageLable {
    
    if (!_pageLable) {
        _pageLable = [[UILabel alloc] init];
        _pageLable.textColor = [UIColor whiteColor];
        _pageLable.textAlignment = NSTextAlignmentLeft;
    }
    return _pageLable;
}

- (UILabel *)titleLable {
    
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.textColor = [UIColor whiteColor];
        _titleLable.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLable;
}

- (UIView *)bottomView {
    
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - kWYLeftMargin_15 * 2, [UIScreen mainScreen].bounds.size.width, kWYLeftMargin_15 * 2)];
        _bottomView.backgroundColor = [UIColor blackColor];
        _bottomView.alpha = 0.7;
    }
    return _bottomView;
}

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (WYPhotoBrowseTransition *)animatedTransition {
    
    if (!_animatedTransition) {
        _animatedTransition = [[WYPhotoBrowseTransition alloc] init];
        self.transitioningDelegate = _animatedTransition;
    }
    return _animatedTransition;
}
@end
