//
//  ViewController.m
//  WYPhotoBrowse
//
//  Created by liyongfang on 2017/10/17.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#import "ViewController.h"
#import "WYPhotoBrowseController.h"

static NSString * image1 = @"https://img05.allinmd.cn/public1/M00/0C/6F/wKgBMFnlnPKAbIlYAAh4agFLOQA317_c_t_225_150.JPG";
static NSString * image2 = @"https://img05.allinmd.cn/public1/M00/0C/71/wKgBL1nlnPOAEyVqAAJIU7ZUZkQ572_c_t_225_150.PNG";
static NSString * image3 = @"https://img05.allinmd.cn/public1/M00/0C/71/wKgBL1nlnZuAG2UsAApk3mYuq_Q211_c_t_225_150.JPG";
static NSString * image4 = @"https://img05.allinmd.cn/public1/M00/0C/6F/wKgBMFnlnZyAEb5UAAmqPCn3yZA689_c_t_225_150.JPG";
static NSString * image5 = @"https://img05.allinmd.cn/public1/M00/0C/71/wKgBL1nlnaCAUF6SAAGrH1JzkNk682_c_t_225_150.JPG";
static NSString * image6 = @"https://img05.allinmd.cn/public1/M00/43/4A/oYYBAFho9rSAKuSDAAQlbMiKJY8585_c_t_340_340.JPG";
static NSString * image7 = @"https://img05.allinmd.cn/public1/M00/43/66/ooYBAFho9raACsDJAAXy3F__6lo125_c_t_340_340.JPG";
static NSString * image8 = @"https://img05.allinmd.cn/public1/M00/43/4A/oYYBAFho9rqARWY7AAb2QS-5kyE308_c_t_340_340.JPG";
static NSString * image9 = @"https://img05.allinmd.cn/public1/M00/43/66/ooYBAFho9r6AfKaNAAsgCnaWsJU640_c_t_340_340.JPG";

@interface ViewController ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.button = [[UIButton alloc] init];
    self.button.frame = CGRectMake(self.view.bounds.size.width/ 2 - 50, self.view.bounds.size.height/ 2 - 50, 100, 100);
    self.button.backgroundColor = [UIColor redColor];
    [self.button setTitle:@"预览大图" forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
}


- (void)buttonClick:(UIButton *)button {
    
    WYPhotoBrowseController *browseVC = [[WYPhotoBrowseController alloc] init];
    browseVC.browseType = eWYPhotoBrowseSave;
    browseVC.currentIndex = 0;
    NSArray *urlArray = [NSArray arrayWithObjects:image1,image2,image3,image4,image5,image6,image7,image8,image8, nil];
    for (int i = 1 ; i <= 9; i ++) {
        WYPhotoBrowseModel *model = [[WYPhotoBrowseModel alloc] init];
        model.photoUrl = urlArray[i-1];
        model.photoDes= @"jbjhjnikjnikjnikjnkjnkjnijk汇纳科技你看就妮可妮可妮可能看见你看你看你看你看见你看见你看见你看见你看见你看jbjhjnikjnikjnikjnkjnkjnijk汇纳科技你看就妮可妮可妮可能看见你看你看你看你看见你看见你看见你看见你看见你看jbjhjnikjnikjnikjnkjnkjnijk汇纳科技你看就妮可妮可妮可能看见你看你看你看你看见你看见你看见你看见你看见你看";
        [browseVC.dataArray addObject:model];
    }
    [self presentViewController:browseVC animated:YES completion:nil];
//    [self.navigationController pushViewController:browseVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
