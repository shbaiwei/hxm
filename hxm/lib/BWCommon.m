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

+(void) setUserInfo:(NSString *) key value:(NSString *) value{
    
    NSUserDefaults *udata = [NSUserDefaults standardUserDefaults];
    [udata setObject:value forKey:key];
    [udata synchronize];

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
    
    return [self getUserInfo:@"uid"] != nil && [[self getUserInfo:@"status"] isEqualToString:@"normal"];
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

+(UIColor *) getBackgroundColor{
    
    return [UIColor colorWithRed:240/255.0f green:240/255.0f blue:250/255.0f alpha:1];
}

+(UIColor *) getMainColor{
    return [UIColor colorWithRed:116/255.0f green:197/255.0f blue:67/255.0f alpha:1];
}
+(UIColor *) getBorderColor{
    return [UIColor colorWithRed:168/255.0f green:168/255.0f blue:168/255.0f alpha:1];
}

+(void) setTopBorder:(UIView *)view color:(UIColor *)color{

    [view sizeToFit];
    CALayer* layer = [view layer];
    CALayer *topBorder = [CALayer layer];
    topBorder.borderWidth = 1;
    topBorder.frame = CGRectMake(-1, 0, layer.frame.size.width, 1);
    [topBorder setBorderColor:color.CGColor];
    [layer addSublayer:topBorder];

}
+(void) setBottomBorder:(UIView *)view color:(UIColor *)color{
    
    [view sizeToFit];
    
    CALayer* layer = [view layer];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.borderWidth = 1;
    bottomBorder.frame = CGRectMake(-1, layer.frame.size.height, layer.frame.size.width, 1);
    [bottomBorder setBorderColor:color.CGColor];
    [layer addSublayer:bottomBorder];
}

+(NSMutableDictionary *) getTokenData:(NSString *) api
{
    //NSString *api_url = [self getBaseInfo:@"api_url"];
    //NSString *url =  [api_url stringByAppendingString:api];
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    NSString *timestamp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970] ];
    
    NSString *str = [NSString stringWithFormat:@"%@/%@/%@",[api lowercaseString],timestamp,[self getUserInfo:@"user_key"]];

    //init token
    NSString *token = [self md5:str];
    
    NSLog(@"%@",[self getUserInfo:@"user_key"]);
    NSLog(@"%@",timestamp);
    NSLog(@"%@",str);
    NSLog(@"%@",token);
    
    [data setValue:[BWCommon getUserInfo:@"hxm_uid"] forKey:@"user_id"];
    [data setValue:timestamp forKey:@"time"];
    [data setValue:token forKey:@"token"];

    return data;
}

//md5 32位 加密 （小写）
+ (NSString *)md5:(NSString *)str
{
    
    const char *cStr = [str UTF8String];
    
    unsigned char result[16];
    
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    
    return [NSString stringWithFormat:
            
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            
            result[0], result[1], result[2], result[3],
            
            result[4], result[5], result[6], result[7],
            
            result[8], result[9], result[10], result[11],
            
            result[12], result[13], result[14], result[15]
            
            ]; 
    
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