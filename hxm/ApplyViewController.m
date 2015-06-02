//
//  ApplyViewController.m
//  hxm
//
//  Created by Bruce on 15-5-19.
//  Copyright (c) 2015年 Bruce. All rights reserved.
//

#import "ApplyViewController.h"
#import "AFNetworkTool.h"
#import "BWCommon.h"

@interface ApplyViewController ()

@end

@implementation ApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self pageLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) pageLayout{
    
    UIColor *bgColor = [BWCommon getBackgroundColor];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    
    UIScrollView *sclView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    sclView.backgroundColor = bgColor;
    sclView.scrollEnabled = YES;
    sclView.contentSize = CGSizeMake(size.width, size.height);
    [self.view addSubview:sclView];
    
    self.view.backgroundColor = bgColor;
    [self.navigationItem setTitle:@"提交审核信息"];
    
    UITextField *real_name = [self createTextField:@"真实姓名："];
    
    [sclView addSubview:real_name];
    
    UITextField *id_card = [self createTextField:@"身份证号："];
    
    [sclView addSubview:id_card];
    
    UITextField *address = [self createTextField:@"送货地址："];
    
    [sclView addSubview:address];
    
    
    NSArray *constraints1= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[real_name(==280)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(real_name)];
    
    NSArray *constraints2= [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-80-[real_name(==50)]-10-[id_card(==50)]-10-[address(==50)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(real_name,id_card,address)];
    
    NSArray *constraints3= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[id_card(==280)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(id_card)];
    
    NSArray *constraints4= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[address(==280)]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(address)];
    
    
    
    [sclView addConstraints:constraints1];
    [sclView addConstraints:constraints2];
    [sclView addConstraints:constraints3];
    [sclView addConstraints:constraints4];
    /*[sclView addConstraints:constraints5];
    [sclView addConstraints:constraints6];*/

    
    
    
    UIButton *btnUpload = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 200, 50)];
    btnUpload.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnUpload setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [btnUpload setTitle:@"上传身份证" forState:UIControlStateNormal];
    
    [sclView addSubview:btnUpload];
    
    [btnUpload addTarget:self action:@selector(uploadTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self setTextFieldCenter:[[NSArray alloc] initWithObjects:real_name,id_card,address,nil]];

}

- (void) setTextFieldCenter:(NSArray *) items{
    
    NSInteger i = 0;
    
    for (i=0; i<[items count]; i++) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:[items objectAtIndex:i] attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    }
    
}

- (UITextField *) createTextField:(NSString *) title{
    
    UITextField * field = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 280, 50)];
    field.borderStyle = UITextBorderStyleRoundedRect;
    [field.layer setCornerRadius:5.0];
    field.clearsOnBeginEditing = YES;
    field.clearButtonMode=UITextFieldViewModeWhileEditing;
    //field.placeholder = title;
    
    UIView *lfView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 70, 30)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 70, 30)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = title;
    
    [lfView addSubview:titleLabel];
    
    field.leftView = lfView;

    field.translatesAutoresizingMaskIntoConstraints = NO;
    field.leftViewMode = UITextFieldViewModeAlways;
    field.rightViewMode=UITextFieldViewModeAlways;
    field.delegate = self;
    
    return field;
}


-(void) uploadTouched:(id)sender{
    
    UIActionSheet *menu=[[UIActionSheet alloc] initWithTitle:@"上传图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"从相册上传", nil];
    menu.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [menu showInView:self.view];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    if(buttonIndex==0){
        [self snapImage];

    }else if(buttonIndex==1){
        [self pickImage];
    }

}

//拍照
- (void) snapImage{
    UIImagePickerController *ipc=[[UIImagePickerController alloc] init];
    ipc.sourceType=UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = self;
    ipc.allowsEditing=NO;
    
   
    [self presentViewController:ipc animated:YES completion:^{
        
        
    }];
    
}
//从相册里找
- (void) pickImage{
    UIImagePickerController *ipc=[[UIImagePickerController alloc] init];
    ipc.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    ipc.allowsEditing=NO;
    
    [self presentViewController:ipc animated:YES completion:^{
    }];

}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *) info{
    
    UIImage *img=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if(picker.sourceType==UIImagePickerControllerSourceTypeCamera){
            //UIImageWriteToSavedPhotosAlbum(img,nil,nil,nil);
    }
    
    int y = (arc4random() % 1001) + 9000;
    
    NSString *fileName = [NSString stringWithFormat:@"%d%@",y,@".jpg"];
    
    [self saveImage:img WithName:fileName];
    
    NSString *fullFileName = [[self documentFolderPath] stringByAppendingPathComponent:fileName];
    
    NSURL *fileUrl = [[NSURL alloc] initFileURLWithPath:fullFileName];
    //NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
    //NSLog(@"%@",fileUrl);
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    
    NSString *api_url = @"http://www.huaji.com:81/member/register/upload_img";

    NSDictionary *postData = @{@"password":@"200314",@"uniqueid":[BWCommon getUserInfo:@"uid"]};
    
    
    [AFNetworkTool postUploadWithUrl:api_url fileUrl:fileUrl parameters:postData success:^(id responseObject) {
        
        NSInteger errNo = [[responseObject objectForKey:@"errno"] integerValue];
        
        NSLog(@"%@",responseObject);
        if (errNo > 0) {
            [alert setMessage:[responseObject objectForKey:@"error"]];
            [alert show];
        }
        else
        {
            NSString *imgurl = [[responseObject objectForKey:@"data"] objectForKey:@"imgurl"];
        }

    } fail:^{
        NSLog(@"请求失败");
    }];
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (NSString *)documentFolderPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImageJPEGRepresentation(tempImage,1);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
