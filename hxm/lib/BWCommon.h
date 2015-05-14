//
//  BWCommon.h
//  pinpintong
//
//  Created by Bruce He on 15-4-4.
//  Copyright (c) 2015年 shanghai baiwei network technology. All rights reserved.
//

#ifndef pinpintong_BWCommon_h
#define pinpintong_BWCommon_h


#endif

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface BWCommon : NSObject

+(float) getSystemVersion;
+(NSString *) getBaseInfo:(NSString *) key;

+(id) getUserInfo:(NSString *) key;

+(BOOL) isLoggedIn;
+(void) logout;

+ (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize;

+(void) setRegionData;

+(id) getDataInfo:(NSString *) key;

@end
