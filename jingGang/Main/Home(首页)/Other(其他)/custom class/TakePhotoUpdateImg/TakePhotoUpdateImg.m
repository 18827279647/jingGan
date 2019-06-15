//
//  TakePhotoUpdateImg.m
//  jingGang
//
//  Created by 张康健 on 15/9/14.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "TakePhotoUpdateImg.h"
#import "ALActionSheetView.h"
#import "AFNetworking.h"
#import "H5Base_url.h"
#import "MBProgressHUD.h"
#import "YYImageClipViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "IRequest.h"
#import "YSLoginManager.h"

@interface TakePhotoUpdateImg()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,YYImageClipDelegate,UIActionSheetDelegate> {
    
    UIViewController *_takePhotoVC;
}

@property (nonatomic, copy)GetPhotoBlock getphotoBlock;
@property (nonatomic, copy)UpdateImgBlock updateImgBlock;
@property (strong,nonatomic) UIImagePickerController *picker;


@end

@implementation TakePhotoUpdateImg

-(void)showInVC:(UIViewController *)takePhotoVC getPhoto:(GetPhotoBlock)getPhotoBlock upDateImg:(UpdateImgBlock)updateImgBlock
{
    _takePhotoVC = takePhotoVC;
    _getphotoBlock = getPhotoBlock;
    _updateImgBlock = updateImgBlock;
    
    //弹出选择sheet
    [self _showPhotoSheet];


}

-(void)updateImage:(UIImage *)image getImgurl:(UpdateImgBlock)updateImgBlock {
    
    _updateImgBlock = updateImgBlock;
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    [self _upLoadHeadImgWithImgData:imageData];

}

-(void)_showPhotoSheet{
    
//    ALActionSheetView *actionSheetView = [ALActionSheetView showActionSheetWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照", @"从相册中选择"] handler:^(ALActionSheetView *actionSheetView, NSInteger buttonIndex) {
//        
//        if (buttonIndex == 0) {//拍照
//            [self showPickerWithType:UIImagePickerControllerSourceTypeCamera];
//        }else if (buttonIndex == 1){//从相册中选
//            [self showPickerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
//        }else{//取消
//            
//        }
//    }];
//
//    [actionSheetView show];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选择", nil];
    [actionSheet showInView:[self getCurrentVC].view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self showPickerWithType:UIImagePickerControllerSourceTypeCamera];
    }else if (buttonIndex == 1){
        [self showPickerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

- (void)showPickerWithType:(UIImagePickerControllerSourceType)photoType
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = photoType;
    picker.delegate = self;
    NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
    [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
    picker.mediaTypes = mediaTypes;
    [_takePhotoVC presentViewController:picker animated:YES completion:^{
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }];
    self.picker = picker;
}

#pragma mark - image piker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    return;
    //回调产生的photoblock
//    if (self.getphotoBlock) {
//        self.getphotoBlock(picker,image,editingInfo);
//    }
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
//    [self _upLoadHeadImgWithImgData:imageData];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    YYImageClipViewController *imgCropperVC = [[YYImageClipViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, ScreenWidth,ScreenWidth) limitScaleRatio:3.0];
    imgCropperVC.delegate = self;
    [picker pushViewController:imgCropperVC animated:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    }];
}

- (void)imageCropper:(YYImageClipViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    if (self.getphotoBlock) {
        self.getphotoBlock(self.picker,editedImage,nil);
    }
    
    NSData *imageData = UIImageJPEGRepresentation(editedImage, 0.5);
    [self _upLoadHeadImgWithImgData:imageData];

    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    }];
}

- (void)imageCropperDidCancel:(YYImageClipViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];

    }];
}


#pragma mark - 上传图片 - 生成url
#pragma mark - 上传头像图片
-(void)_upLoadHeadImgWithImgData:(NSData *)imgData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[YSLoginManager queryAccessToken] forHTTPHeaderField:@"auth_token"];
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hub.labelText = @"正在获取图片地址..";
    NSString *uploadImagePath;
    AbstractRequest *request = [[AbstractRequest alloc] init:nil];
    uploadImagePath = request.baseUrl;
    NSString *postImageUrl = [NSString stringWithFormat:@"%@/v1/image",uploadImagePath];
    @weakify(hub);
    [manager POST:postImageUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imgData name:@"file" fileName:@"filename" mimeType:@"image/jpeg"];
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @strongify(hub);
        [hub hide:YES];
        NSArray *imageItems = responseObject[@"items"];
        if (imageItems.count) {
            NSString *newCommentImgUrl =  [[responseObject[@"items"] xf_safeObjectAtIndex:0] objectForKey:@"fileUrl"];
            NSError *error = nil;
            //回调更新图片block
            if (!newCommentImgUrl || [newCommentImgUrl isEqualToString:@""]) {
                error = [NSError errorWithDomain:@"图片上传失败" code:1 userInfo:nil];
            }else {
                error = [NSError errorWithDomain:@"图片上传成功" code:0 userInfo:nil];
            }
            if (self.updateImgBlock) {
                self.updateImgBlock(newCommentImgUrl,error);
            }
        }else {
            NSString *message = responseObject[@"sub_msg"];
            [UIAlertView xf_showWithTitle:@"上传失败！" message:message delay:2.4 onDismiss:NULL];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSError *error2 = [NSError errorWithDomain:error.localizedDescription code:1 userInfo:nil];
        @strongify(hub);
        [hub hide:YES];
        if (self.updateImgBlock) {
            self.updateImgBlock(nil,error2);
        }
    }];
}


//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}



@end
