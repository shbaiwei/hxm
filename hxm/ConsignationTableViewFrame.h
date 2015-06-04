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

@property (nonatomic,assign) CGRect inLabelF;

@property (nonatomic,assign) CGRect inValueF;

@property (nonatomic,assign) CGRect packLabelF;

@property (nonatomic,assign) CGRect packValueF;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) NSDictionary *data;

@end