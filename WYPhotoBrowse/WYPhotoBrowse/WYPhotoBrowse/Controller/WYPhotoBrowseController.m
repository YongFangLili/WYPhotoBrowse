//
//  WYPhotoBrowseController.m
//  WYPhotoBrowse
//
//  Created by liyongfang on 2017/10/17.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#import "WYPhotoBrowseController.h"
#import "WYPhotoViewCell.h"
#define kDesphotoViewWidth ([UIScreen mainScreen].bounds.size.width - 15 - 15)
static NSString *kPhotoCellIdentifier = @"photoCellIdentifier";
@interface WYPhotoBrowseController ()
<UICollectionViewDelegate,
UICollectionViewDataSource,
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
 @end

@implementation WYPhotoBrowseController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO; 
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpUI];
    
}

- (void)setUpUI {

    // collectionView
    [self.view addSubview:self.collectionView];
    // topView
    [self.view addSubview:self.topView];
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 18, 46, 46)];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(clickCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:closeBtn];
    // 保存或者是删除
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 10 - 46 , 18, 46, 46)];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    switch (self.browseType) {
        case eWYPhotoBrowseSave:
            [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
            break;
        case eWYPhotoBrowseDelete:
            [rightBtn setTitle:@"删除" forState:UIControlStateNormal];
            break;
        default:
            [rightBtn setTitle:@"" forState:UIControlStateNormal];
            break;
    }
    [self.topView addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    // title
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(closeBtn.frame), 18, self.view.bounds.size.width - 2 *(CGRectGetMaxX(closeBtn.frame)) , 46)];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.numberOfLines = 1;
    titleLable.textColor = [UIColor whiteColor];
    titleLable.text = @"治疗前";
    [self.topView addSubview:titleLable];
    
    // bottomView
    [self.view addSubview:self.bottomView];
  
    [self.bottomView addSubview:self.pageLable];
    [self.bottomView addSubview:self.photoDesView];
    [self updatePageDes];
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
    
    // 更新frame
    // 设置富文本，设置版本更显描述textView
    NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc]initWithString:model.photoDes];
    NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc]init];
    [paragraph setLineSpacing:4];//设置行间距
    [paragraph setParagraphSpacing:5];//设置段落间距
    NSDictionary *attributeDic = @{NSFontAttributeName:[UIFont systemFontOfSize:13],NSParagraphStyleAttributeName:paragraph,NSForegroundColorAttributeName:[UIColor whiteColor] };
    [attributeStr setAttributes:attributeDic range:NSMakeRange(0, attributeStr.length)];
    CGFloat desViewHeight = [model.photoDes boundingRectWithSize:CGSizeMake(kDesphotoViewWidth,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributeDic context:nil].size.height;
    desViewHeight = desViewHeight > (4 * 13 + 4 * 4 + 13 + 13/2) ? (4 * 13 + 4 * 4 + 13 + 13/2) : desViewHeight;
    
    
    self.photoDesView.attributedText = attributeStr;
    
    CGFloat bottomViewHeight = (15 + 30) + desViewHeight;
    self.bottomView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height -  bottomViewHeight, [UIScreen mainScreen].bounds.size.width, bottomViewHeight);
    self.pageLable.frame = CGRectMake(0, bottomViewHeight - 30, [UIScreen mainScreen].bounds.size.width, 30);
    self.photoDesView.frame = CGRectMake(15, 15, kDesphotoViewWidth, desViewHeight);
//    [self textViewCursorIsHidden:1];
}

#pragma mark - click Mehod
- (void)clickCloseBtn:(UIButton *)btn {

    [self. navigationController popViewControllerAnimated:YES];
}

- (void)clickRightBtn:(UIButton *)btn {
    
    switch (self.browseType) {
        case eWYPhotoBrowseSave:
            
            break;
        case eWYPhotoBrowseDelete:
            
            break;
        default:
            break;
    }
}

#pragma mark - collectionDataSource & collectionDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    WYPhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // 获取当前的index
    if ([scrollView isEqual:self.photoDesView]) return;
    NSInteger index = scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
    self.currentIndex = index;
//     [self textViewCursorIsHidden:1];
    // 更新页码与详情
    [self updatePageDes];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    //  更新textView禁止编辑
    return NO;
}

////textView滚动条是否显示
//- (void)textViewCursorIsHidden:(BOOL) isHidden {
//    // && img.autoresizingMask == UIViewAutoresizingNone
//    for(UIView *img in [self.photoDesView subviews]) {
//        if ([img isKindOfClass:[UIImageView class]] ){
//            img.backgroundColor = [UIColor redColor];
//            [img setAlpha:1.0];
//        }
//    }
//}

- (void)clickSingleGesture {
    
    // 隐藏动画
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
        [_collectionView registerClass:[WYPhotoViewCell class] forCellWithReuseIdentifier:kPhotoCellIdentifier];
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (UIView *)topView {
    
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
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
//        _photoDesView.textContainer.lineFragmentPadding = 0;
        _photoDesView.showsHorizontalScrollIndicator = NO;
        _photoDesView.showsVerticalScrollIndicator = YES;
        _photoDesView.alwaysBounceVertical = YES;
        _photoDesView.layoutManager.allowsNonContiguousLayout = NO;
        _photoDesView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
//        _photoDesView.selectable = NO;
    }
    return _photoDesView;
}

- (UILabel *)pageLable {
    
    if (!_pageLable) {
        _pageLable = [[UILabel alloc] init];
        _pageLable.textColor = [UIColor whiteColor];
        _pageLable.textAlignment = NSTextAlignmentRight;
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
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 30, [UIScreen mainScreen].bounds.size.width, 30)];
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

@end
