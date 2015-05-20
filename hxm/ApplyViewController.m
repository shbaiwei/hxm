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
    
    
    UIButton *btnUpload = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 200, 50)];
    btnUpload.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnUpload setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [btnUpload setTitle:@"上传身份证" forState:UIControlStateNormal];
    
    [sclView addSubview:btnUpload];
    
    [btnUpload addTarget:self action:@selector(uploadTouched:) forControlEvents:UIControlEventTouchUpInside];

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
    ipc.delegate=self;
    ipc.allowsEditing=NO;
    
    [self presentViewController:ipc animated:YES completion:^{
    }];

}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *) info{
    
    UIImage *img=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if(picker.sourceType==UIImagePickerControllerSourceTypeCamera){
            UIImageWriteToSavedPhotosAlbum(img,nil,nil,nil);
    }
    
    
    
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:[info objectForKey:@"UIImagePickerControllerReferenceURL"] withExtension:nil];
    NSLog(@"%@",fileUrl);
    
    /*
    [AFNetworkTool postUploadWithUrl:@"" fileUrl:fileUrl success:^(id responseObject) {
        
    } fail:^{
        
    }];
     */
    
    
   // UIImage *newImg=[self imageWithImageSimple:img scaledToSize:CGSizeMake(300, 300)];
   // [self saveImage:newImg WithName:[NSString stringWithFormat:@"%@%@",[self generateUuidString],@".jpg"]];
   //[self dismissModalViewControllerAnimated:YES];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
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
