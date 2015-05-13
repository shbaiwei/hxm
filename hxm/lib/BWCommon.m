//
//  common.m
//  easyshanghai
//
//  Created by Bruce He on 15-3-16.
//  Copyright (c) 2015年 shanghai baiwei network technology. All rights reserved.
//

#import "BWCommon.h"

@implementation BWCommon

+(float) getSystemVersion{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+(void) fixTabBarItem:(UITabBarItem *) tabBarItem {
    //修复ios7以上 tab选中时的效果
    
    if ([BWCommon getSystemVersion] > 7.0){
        tabBarItem.selectedImage = [tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //tabBarItem.image = [tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
        //[tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255 green:133 blue:0 alpha:1], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    }
}

+(NSString *) getBaseInfo:(id) key{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"base" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString * value;
    
    value = [data objectForKey:key];
    
    return value;
}

+(NSString *) getAPIUrl:(NSString *) action{
    
    NSString * api_url;
    api_url = [BWCommon getBaseInfo:@"api_url"];
    return [NSString stringWithFormat:@"%@%@",api_url,action];
    
}

@end