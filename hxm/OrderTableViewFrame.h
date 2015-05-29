//
//  NearbyTableViewFrame.h
//  easyshanghai
//
//  Created by Bruce He on 15-5-21.
//  Copyright (c) 2015年 shanghai baiwei network technology. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OrderTableViewFrame : NSObject

//内容区域
//@property (nonatomic, assign) CGRect imageF;

@property (nonatomic, assign) CGRect borderViewF;
@property (nonatomic, assign) CGRect orderNoF;

@property (nonatomic, assign) CGRect orderFeeF;
@property (nonatomic, assign) CGRect orderFeeTitleF;
@property (nonatomic, assign) CGRect buttonViewF;

@property (nonatomic, assign) CGRect timeF;

@property (nonatomic, assign) CGRect commentF;

@property (nonatomic, assign) CGRect noteF;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) NSDictionary *data;

@end