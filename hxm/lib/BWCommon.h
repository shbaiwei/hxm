//
//  common.h
//  easyshanghai
//
//  Created by Bruce He on 15-3-16.
//  Copyright (c) 2015年 shanghai baiwei network technology. All rights reserved.
//

#ifndef easyshanghai_common_h
#define easyshanghai_common_h


#endif

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface BWCommon : NSObject

+(float) getSystemVersion;
+(void) fixTabBarItem:(UITabBarItem*) tabBarItem;
+(NSString *) getBaseInfo:(NSString *) key;
+(NSString *) getAPIUrl:(NSString *) action;

@end