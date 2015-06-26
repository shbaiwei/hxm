//
//  MyContactWayViewController.h
//  
//
//  Created by spring on 15/5/28.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "HZAreaPickerView.h"

@interface MyContactWayViewController : UIViewController
<UITextFieldDelegate,
HZAreaPickerDelegate,
MBProgressHUDDelegate>

@property (retain, nonatomic) UITextField *areaText;
@property (strong, nonatomic) NSString *areaValue;
@property (strong, nonatomic) HZAreaPickerView *locatePicker;
@property (nonatomic, strong) NSDictionary *userinfo;

-(void)cancelLocatePicker;
@end
