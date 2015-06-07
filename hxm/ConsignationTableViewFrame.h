//
//  ConsignationTableViewFrame.h
//  hxm
//
//  Created by Bruce on 15-6-2.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface ConsignationTableViewFrame : NSObject

@property (nonatomic, assign) CGRect borderViewF;

@property (nonatomic,assign) CGRect priceLabelF;
@property (nonatomic,assign) CGRect priceValueF;

@property (nonatomic,assign) CGRect statusLabelF;



@property (nonatomic,assign) CGRect inRowF;

@property (nonatomic,assign) CGRect packRowF;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) NSDictionary *data;

@end