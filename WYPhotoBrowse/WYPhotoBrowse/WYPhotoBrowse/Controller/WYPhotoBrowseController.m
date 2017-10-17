//
//  WYPhotoBrowseController.m
//  WYPhotoBrowse
//
//  Created by liyongfang on 2017/10/17.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#import "WYPhotoBrowseController.h"
#import "WYPhotoViewCell.h"

static NSString *kPhotoCellIdentifier = @"photoCellIdentifier";
@interface WYPhotoBrowseController () <UICollectionViewDelegate,UICollectionViewDataSource>

/** collectionView */
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation WYPhotoBrowseController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
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
    cell.model = self.dataArray[indexPath.row];
    return cell;
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

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
