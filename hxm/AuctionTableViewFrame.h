//
//  AuctionTableViewFrame.m
//  hxm
//
//  Created by Bruce He on 15/6/25.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface AuctionTableViewFrame : NSObject

@property (nonatomic, assign) CGRect borderViewF;

@property (nonatomic,assign) CGRect aucNoLabelF;
@property (nonatomic,assign) CGRect aucNoValueF;

@property (nonatomic,assign) CGRect statusLabelF;



@property (nonatomic,assign) CGRect channelRowF;

@property (nonatomic,assign) CGRect catRowF;

@property (nonatomic,assign) CGRect cat2RowF;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) NSDictionary *data;

@end