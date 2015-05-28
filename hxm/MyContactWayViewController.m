//
//  MyContactWayViewController.m
//  
//
//  Created by spring on 15/5/28.
//
//

#import "MyContactWayViewController.h"
#import "BWCommon.h"

@interface MyContactWayViewController ()
{
    UITextField *link_man;
    UITextField *link_mobile;
    UITextField *link_phone;
    UITextField *link_email;
    UITextField *link_qq;
    UITextField *link_fax;
    UITextField *link_prov_id;
    UITextField *link_city_id;
    UITextField *link_dist_id;
    UITextField *link_address;
    //CGSize size;
}
@end

@implementation MyContactWayViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self pageLayout];
}

- (void)pageLayout
{
    UIColor *bgColor = [BWCommon getBackgroundColor];
    self.view.backgroundColor = bgColor;
    
   // CGRect rect = [[UIScreen mainScreen] bounds];
   // size = rect.size;
    
    //link_man = [self createTextField:@"姓名："];
    //[self.view addSubview:link_man];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (UITextField *) createTextField:(NSString *) title{
    
    UITextField * field = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, 300, 50)];
    field.borderStyle = UITextBorderStyleRoundedRect;
    [field.layer setCornerRadius:5.0];
    //field.placeholder = title;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 100, 50)];
    label.text = title;
    field.leftView = label;
    field.leftViewMode = UITextFieldViewModeAlways;
    field.translatesAutoresizingMaskIntoConstraints = NO;
    field.delegate = self;
    
    return field;
}

@end
