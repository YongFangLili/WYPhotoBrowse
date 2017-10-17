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
    NSArray *urlArray = [NSArray arrayWithObjects:image1,image2,image3,image4,image5, nil];
    for (int i = 1 ; i <= 5; i ++) {
        WYPhotoBrowseModel *model = [[WYPhotoBrowseModel alloc] init];
        model.photoUrl = urlArray[i-1];
        [browseVC.dataArray addObject:model];
    }
    [self.navigationController pushViewController:browseVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
