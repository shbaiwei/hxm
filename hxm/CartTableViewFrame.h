//
//  CartTableViewFrame.h
//  hxm
//
//  Created by Bruce He on 15/6/7.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CartTableViewFrame : NSObject

//内容区域
//@property (nonatomic, assign) CGRect imageF;

@property (nonatomic, assign) CGRect borderViewF;

@property (nonatomic, assign) CGRect  headerF;

@property (nonatomic, assign) CGRect nameF;

@property (nonatomic, assign) CGRect quantityF;
@property (nonatomic, assign) CGRect quantity2F;

@property (nonatomic, assign) CGRect subtotalF;


@property (nonatomic, assign) CGRect priceF;


@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) NSDictionary *data;

@end