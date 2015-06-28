//
//  MyContactWayViewController.h
//  
//
//  Created by spring on 15/5/28.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface MyContactWayViewController : UIViewController
<UITextFieldDelegate,
MBProgressHUDDelegate,
UIPickerViewDataSource,
UIPickerViewDelegate,
UIGestureRecognizerDelegate>
{
    
    MBProgressHUD *hud;
}


@property (retain, nonatomic) UITextField *areaText;
@property (strong, nonatomic) NSString *areaValue;
@property (nonatomic, strong) NSDictionary *userinfo;

@end
