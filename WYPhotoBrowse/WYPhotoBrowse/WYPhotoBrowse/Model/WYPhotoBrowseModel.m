//
//  WYPhotoBrowseModel.m
//  WYPhotoBrowse
//
//  Created by liyongfang on 2017/10/17.
//  Copyright © 2017年 liyongfang. All rights reserved.
//

#import "WYPhotoBrowseModel.h"

@implementation WYPhotoBrowseModel


/**
 *   获取图片_c地址 75%.
 *
 *  @return 图片_c地址
 */
//- (NSString *)makeCImageLargeUrl
//{
//    NSString * tString = nil;
//    if (!self.photoUrl || self.photoUrl.length == 0) {
//        
//        return @"";
//    }
//    NSMutableString *tmpStr = [NSMutableString stringWithString:self.photoUrl];
//    
//    NSString *mediaFormat = nil;
//    if(tmpStr.length > 5)
//    {
//        mediaFormat = [tmpStr substringFromIndex:tmpStr.length - 5];
//        NSRange domRange = [mediaFormat rangeOfString:@"."];
//        if(domRange.location != NSNotFound && domRange.length > 0)
//        {
//            mediaFormat = [mediaFormat substringFromIndex:domRange.location + 1];
//        }
//    }
//    
//    NSRange range_c_d = [tmpStr rangeOfString:@"_c_d_sp"];
//    NSRange range_c = [tmpStr rangeOfString:@"_c."];
//    NSRange range_c_t = [tmpStr rangeOfString:@"_c_t_"];
//    
//    if(range_c_d.location != NSNotFound && range_c_d.length)
//    {
//        NSString *str = [tmpStr substringToIndex:range_c_d.location];
//        tString = [NSString stringWithFormat:@"%@_c.%@",str,mediaFormat];
//    }
//    else if (range_c.location != NSNotFound && range_c.length)
//    {
//        NSString *str = [tmpStr substringToIndex:range_c.location];
//        tString = [NSString stringWithFormat:@"%@_c.%@",str,mediaFormat];
//    }
//    else if (range_c_t.location != NSNotFound && range_c_t.length)
//    {
//        NSString *str = [tmpStr substringToIndex:range_c_t.location];
//        tString = [NSString stringWithFormat:@"%@_c.%@",str,mediaFormat];
//    }
//    else {
//        tString = tmpStr;
//    }
//    return tString;
//}

/// 获取大图网址.
- (NSString *)makeCImageLargeUrl {
    
    NSString * tString = self.photoUrl;
    
    if (self.photoUrl && self.photoUrl.length != 0) {
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
