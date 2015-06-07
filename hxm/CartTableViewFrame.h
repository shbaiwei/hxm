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
@property (nonatomic, assign) CGRect nameF;

@property (nonatomic, assign) CGRect levelF;

@property (nonatomic, assign) CGRect limitF;

@property (nonatomic, assign) CGRect merchantF;

@property (nonatomic, assign) CGRect priceF;

@property (nonatomic, assign) CGRect buyButtonF;
@property (nonatomic, assign) CGRect auctionButtonF;

@property (nonatomic,assign) CGRect cartButtonF;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) NSDictionary *data;

@end