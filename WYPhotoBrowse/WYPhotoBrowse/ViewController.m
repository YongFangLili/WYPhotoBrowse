//
//  ViewController.m
//  WYPhotoBrowse
//
//  Created by liyongfang on 2017/10/17.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#import "ViewController.h"
#import "WYPhotoBrowseController.h"
#import "WYPhotoBrowseTransition.h"
#import <MBProgressHUD.h>

static NSString * image1 = @"https://img05.allinmd.cn/public1/M00/4F/75/oYYBAFl92xCABwXJACznWq4DFrY755_c_t_340_340.jpg";
static NSString * image2 = @"https://img05.allinmd.cn/public1/M00/4F/76/oYYBAFl93J-AT4-NAA4--0rxvV0980_c_t_340_340.jpg";
static NSString * image3 = @"https://img05.allinmd.cn/public1/M00/4F/8F/ooYBAFl92zGAD7hTACXA6Fdztw8567_c_t_340_340.jpg";
static NSString * image4 = @"https://img05.allinmd.cn/public1/M00/1C/1C/ooYBAFeGJTGAZrwzADyPzZ_2nV8941_c_t_340_340.jpg";
//static NSString * image5 = @"https://img05.allinmd.cn/public1/M00/4F/75/oYYBAFl922uACNMiAEuvOTL6SXg856_c_t_340_340.jpg";
static NSString * image5 = @"https://img05.allinmd.cn/public1/M00/14/85/ooYBAFaytAWAEGeKACcmgnGrM4M527_c_d_sp.jpg";
static NSString * image6 = @"https://img05.allinmd.cn/public1/M00/43/4A/oYYBAFho9rSAKuSDAAQlbMiKJY8585_c_t_340_340.JPG";
static NSString * image7 = @"https://img05.allinmd.cn/public1/M00/43/66/ooYBAFho9raACsDJAAXy3F__6lo125_c_t_340_340.JPG";
static NSString * image8 = @"https://img05.allinmd.cn/public1/M00/43/4A/oYYBAFho9rqARWY7AAb2QS-5kyE308_c_t_340_340.JPG";
static NSString * image9 = @"https://img05.allinmd.cn/public1/M00/14/85/ooYBAFaytBaAQycLACnbWGpy9Eo552_c_d_sp.jpg";

@interface ViewController ()<WYPhotoBrowseControllerDelegate>

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
    [self.button setImage:[UIImage imageNamed:@"u0-1"] forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
}


- (void)buttonClick:(UIButton *)button {
    
    WYPhotoBrowseController *browseVC = [[WYPhotoBrowseController alloc] init];
    browseVC.rightButtonType = eWYPhotoBrowseSave;
    browseVC.currentIndex = 0;
    NSArray *urlArray = [NSArray arrayWithObjects:image1,image2,image3,image4,image5,image6,image7,image8,image8, nil];
    for (int i = 1 ; i <= 9; i ++) {
        WYPhotoBrowseModel *model = [[WYPhotoBrowseModel alloc] init];
        model.photoThumbnailUrlStr = urlArray[i-1];
        model.photoHightImageUrlStr = [self makeCImageLargeUrlWiththumbUpUrl:model.photoThumbnailUrlStr];
        model.photoDes= @"jbjhjnikjnikjnikjnkjnkjnijk汇纳科技你看就妮可妮可妮可能看见你看你看你看你看见你看见你看见你看见你看见你看jbjhjnikjnikjnikjnkjnkjnijk汇纳科技你看就妮可妮可妮可能看见你看你看你看你看见你看见你看见你看见你看见你看jbjhjnikjnikjnikjnkjnkjnijk汇纳科技你看就妮可妮可妮可能看见你看你看你看你看见你看见你看见你看见你看见你看";
        if (i == 2 || i == 7) {
            model.photoDes= @"你看见你看见你看见你看";
        }
        model.photoesTitle = @"治疗前";
        [browseVC.dataArray addObject:model];
    }
//    self.transition = [[WYPhotoBrowseTransition alloc] init];
//    self.transition.transitionImage = self.button.imageView.image;
//    self.transition.transitionBeforeImageFrame = self.button.frame;
//    self.transition.transitionAfterImgFrame = [self.transition imageScreenWithImageFrame:self.button.imageView.bounds];
//    self.transition.isFadToShow = YES;
    browseVC.currentIndex = 0;
    browseVC.interactiveType = eWYPhotoBrowseInteractiveCloseByButtonType;
    browseVC.rightButtonType = eWYPhotoBrowseSave;
    browseVC.delegate = self;
//    browseVC.animatedTransition.transitionImage = self.button.imageView.image;
//    browseVC.animatedTransition.transitionBeforeImageFrame = self.button.frame;
//    browseVC.animatedTransition.transitionAfterImgFrame = [browseVC.animatedTransition imageScreenWithImageFrame:self.button.imageView.bounds];
//    browseVC.animatedTransition.isFadToShow = YES;
    [self presentViewController:browseVC animated:YES completion:nil];
}

#pragma mark -WYPhotoBrowseControllerDelegate
- (void)wyPhotoBrowseControllerViewWillAppear {
    
}

- (void)wyPhotoBrowseControllerViewWillDissAppear {
    
}

- (void)wyPhotoBrowseClickRightWithWYPhotoBrowseVC:(WYPhotoBrowseController *)browseVC {
    
    switch (browseVC.rightButtonType) {
        case eWYPhotoBrowseSave:
            // 保存图片的代码
            break;
        case eWYPhotoBrowseDelete:
            // 删除图片的代码
            break;
        default:
            break;
    }
    [browseVC didClickRightButtonSucucess];
}

- (void)wyphotoBrowseDidSavePhotoWithIsSucecess:(BOOL)sucecess {
    
    //
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.mode = MBProgressHUDModeText;
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.bezelView.alpha = 0.5;
    hud.detailsLabel.textColor  = [UIColor whiteColor];
    hud.detailsLabel.font = [UIFont systemFontOfSize:16.0];
    hud.detailsLabel.text = sucecess ? @"保存成功" : @"保存失败";
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:1.0];
}

- (void)wyPhotoBrowseLoadImageFaliured {
    
    // 图片下载失败
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.mode = MBProgressHUDModeText;
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.bezelView.alpha = 0.5;
    hud.detailsLabel.textColor  = [UIColor whiteColor];
    hud.detailsLabel.font = [UIFont systemFontOfSize:16.0];
    hud.detailsLabel.text = @"下载失败";
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:1.0];
}


/// 获取大图网址.
- (NSString *)makeCImageLargeUrlWiththumbUpUrl:(NSString *)url {
    
    NSString * tString = url;
    if (url && url.length != 0) {
        NSMutableString * tmpStr = [NSMutableString stringWithString:tString];
        NSString * mediaFormat = nil;
        if(tmpStr.length > 5) {
            mediaFormat = [tmpStr substringFromIndex:tmpStr.length - 5];
            NSRange domRange = [mediaFormat rangeOfString:@"."];
            if(domRange.location != NSNotFound && domRange.length > 0) {
                mediaFormat = [mediaFormat substringFromIndex:domRange.location + 1];
            }
        }
        NSRange range_c_d = [tmpStr rangeOfString:@"_c_d_sp"];
        NSRange range_c = [tmpStr rangeOfString:@"_c."];
        NSRange range_c_t = [tmpStr rangeOfString:@"_c_t_"];
        NSRange range_c_p = [tmpStr rangeOfString:@"_c_p_"];
        if(range_c_d.location != NSNotFound && range_c_d.length) {
            NSString *str = [tmpStr substringToIndex:range_c_d.location];
            tString = [NSString stringWithFormat:@"%@.%@",str,mediaFormat];
        } else if (range_c.location != NSNotFound && range_c.length) {
            NSString *str = [tmpStr substringToIndex:range_c.location];
            tString = [NSString stringWithFormat:@"%@.%@",str,mediaFormat];
        } else if (range_c_t.location != NSNotFound && range_c_t.length){
            NSString *str = [tmpStr substringToIndex:range_c_t.location];
            tString = [NSString stringWithFormat:@"%@.%@",str,mediaFormat];
        } else if (range_c_p.location != NSNotFound && range_c_p.length){
            NSString *str = [tmpStr substringToIndex:range_c_p.location];
            tString = [NSString stringWithFormat:@"%@.%@",str,mediaFormat];
        } else {
            tString = tmpStr;
        }
        return tString;
    } else {
        return @"";
    }
}

@end
