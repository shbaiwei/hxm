//
//  MyAddressTableViewFrame.h
//  hxm
//
//  Created by spring on 15/5/30.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MyAddressTableViewFrame : NSObject

//内容区域
//@property (nonatomic, assign) CGRect imageF;

@property (nonatomic, assign) CGRect borderViewF;

@property (nonatomic, assign) CGRect statusViewF;

@property (nonatomic, assign) CGRect timeIconF;

@property (nonatomic, assign) CGRect timeLabelF;

@property (nonatomic, assign) CGRect delButtonF;

@property (nonatomic, assign) CGRect editButtonF;

@property (nonatomic, assign) CGRect addressButtonF;

@property (nonatomic, assign) CGRect nameLabelF;

@property (nonatomic, assign) CGRect detailLabelF;

@property (nonatomic, assign) CGRect rigthImageIconF;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) NSDictionary *data;

@end
