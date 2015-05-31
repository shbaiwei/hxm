//
//  MyAfterSaleTableViewFrame.h
//  hxm
//
//  Created by spring on 15/5/30.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MyAfterSaleTableViewFrame : NSObject

//内容区域
//@property (nonatomic, assign) CGRect imageF;

@property (nonatomic, assign) CGRect borderViewF;

@property (nonatomic, assign) CGRect statusViewF;

@property (nonatomic, assign) CGRect timeIconF;

@property (nonatomic, assign) CGRect timeLabelF;

@property (nonatomic, assign) CGRect statusLabelF;

@property (nonatomic, assign) CGRect orderNoF;

@property (nonatomic, assign) CGRect buttonViewF;

@property (nonatomic, assign) CGRect cancelF;

@property (nonatomic, assign) CGRect detailF;

@property (nonatomic,assign) CGRect logisticsF;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) NSDictionary *data;

@end
