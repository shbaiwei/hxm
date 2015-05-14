//
//  BWCommon.m
//  pinpintong
//
//  Created by Bruce He on 15-4-4.
//  Copyright (c) 2015年 shanghai baiwei network technology. All rights reserved.
//

#import "BWCommon.h"
#import "AFNetworkTool.h"

@implementation BWCommon

+(float) getSystemVersion{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}


+(NSString *) getBaseInfo:(id) key{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"baseinfo" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString * value;
    
    value = [data objectForKey:key];
    
    return value;
}

+(id) getUserInfo:(NSString *)key
{
    NSUserDefaults *udata = [NSUserDefaults standardUserDefaults];
    
    return [udata objectForKey:key];
}

+(void) logout{
    NSUserDefaults *udata = [NSUserDefaults standardUserDefaults];
    
    [udata removeObjectForKey:@"username"];
    [udata removeObjectForKey:@"uid"];
    [udata synchronize];
}

+(BOOL) isLoggedIn{
    
    return [self getUserInfo:@"username"] != nil;
}

//实际还是从NSUserDefaults中获取
+(id) getDataInfo:(NSString *)key
{
    return [self getUserInfo:key];
}

+(void) setRegionData{
    //如果地区不存在 则重新加载
    if ([self getDataInfo:@"regions"] != nil) {
        return;
    }
    
    NSString *api_url = [self getBaseInfo:@"api_url"];
    
    NSString *url =  [api_url stringByAppendingString:@"getAllRegion"];
    
    [AFNetworkTool JSONDataWithUrl:url success:^(id json) {
        
        
        NSString *result = [json objectForKey:@"result"];
        
        if([result  isEqual:@"ok"])
        {
            NSArray *regions = [json objectForKey:@"data"];
            
            NSUserDefaults *udata = [NSUserDefaults standardUserDefaults];
            [udata setObject:regions forKey:@"regions"];
            [udata synchronize];
        }
    } fail:^{
        
        NSLog(@"请求失败");
    }];
    
    
}


/**
 *  计算文本的宽高
 *
 *  @param str     需要计算的文本
 *  @param font    文本显示的字体
 *  @param maxSize 文本显示的范围
 *
 *  @return 文本占用的真实宽高
 */
+ (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

@end