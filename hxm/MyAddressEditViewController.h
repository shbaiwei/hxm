//
//  MyAddressEditViewController.h
//  hxm
//
//  Created by spring on 15/6/1.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZAreaPickerView.h"
@interface MyAddressEditViewController : UIViewController<UITextFieldDelegate,HZAreaPickerDelegate>
@property (nonatomic,strong) NSDictionary *address_info;
@property (retain, nonatomic) IBOutlet UITextField *areaText;
@property (strong, nonatomic) NSString *areaValue;
@property (strong, nonatomic) HZAreaPickerView *locatePicker;

-(void)cancelLocatePicker;
@end
