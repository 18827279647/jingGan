//
//  YSHealthyCircleAddImageView.m
//  jingGang
//
//  Created by dengxf on 16/8/4.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSHealthyCircleAddImageView.h"
#import "AFHTTPRequestOperationManager.h"
#import "IRequest.h"
#import "YSLoginManager.h"

@interface YSHealthyCircleAddImageView ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (assign, nonatomic) NSInteger imagesCount;

@property (strong,nonatomic) UIViewController *controller;

/**
 *  当前已选图片 */
@property (strong,nonatomic) UIImage *currentSelectedImage;

/**
 *  已上传成功的图片 */
@property (strong,nonatomic) UIImage *didSuccessUploadImage;

@property (strong,nonatomic) UIImageView *addImageView;

@end

#define MagrinX  15.0f
#define MagrinImageWidth 12
#define SelectedImageHW (ScreenWidth - MagrinX * 2 - MagrinImageWidth * 2) / 3

@implementation YSHealthyCircleAddImageView

- (instancetype)initWithFrame:(CGRect)frame controller:(UIViewController *)controller
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.controller = controller;
        self.imagesCount = 0;
        [self setup];
    }
    return self;
}

- (void)setup {
    UIImageView *addImageView = [[UIImageView alloc] init];
    addImageView.x = MagrinX ;
    addImageView.y = 0;
    addImageView.width = SelectedImageHW;
    addImageView.height = addImageView.width;
    addImageView.userInteractionEnabled = YES;
    addImageView.image = [UIImage imageNamed:@"ys_healthymanage_addimage"];
    [self addSubview:addImageView];
    self.addImageView = addImageView;
    
    @weakify(self);
    [addImageView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        @strongify(self);
        [self modifyHeadByCamera];
    }];
}

/**
 *   使用手机拍照
 */
- (void)modifyHeadByCamera
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //摄像头不可用
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设备没有Camera" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        
        [SVProgressHUD dismiss];
        return;
    }
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType =  UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    [self.controller presentViewController:ipc animated:YES completion:^{
        [SVProgressHUD dismiss];
    }];
}

/**
 *  从相册中选择图片
 */
- (void) modifyHeadByChoose
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        ipc.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    }
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    [self.controller presentViewController:ipc animated:YES completion:^{
        [SVProgressHUD dismiss];
    }];
}


#pragma mark -- UIImagePickerControllerDelegate --
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *image;
    if ([mediaType isEqualToString:@"public.image"])
    {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    [picker dismissViewControllerAnimated:YES completion:^{
            /**
             *   做上传图片的处理
             */
        self.currentSelectedImage = image;
        [self handleUpdatingImage:image];
    }];
}

/**
 *   -- 处理将要上传图片(将图片进行压缩) --
 */
- (void)handleUpdatingImage:(UIImage *)image {
    NSData * imageData = [[NSData alloc]init];
    imageData=UIImageJPEGRepresentation(image, 0.5);
    [self uploadImageWithImageData:imageData];
    [SVProgressHUD showInView:self.controller.view status:@"正在上传" networkIndicator:NO posY:-1 maskType:1];
}

/**
 *  将压缩过后的数据流进行上传
 *
 *  @param imageData 图片二进制流
 */
- (void)uploadImageWithImageData:(NSData *)imageData {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[YSLoginManager queryAccessToken] forHTTPHeaderField:@"auth_token"];
    NSString *uploadImagePath;
    AbstractRequest *request = [[AbstractRequest alloc] init:nil];
    uploadImagePath = request.baseUrl;
    NSString *postImageUrl = [NSString stringWithFormat:@"%@/v1/image",uploadImagePath];
    [manager POST:postImageUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"filename" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        /**
         *  成功上传图片- 拿到上传图片的路径-》newCommentImgUrl
         */
        NSArray *imageItems = responseObject[@"items"];
        if (imageItems.count) {
            NSString *newCommentImgUrl =  [[responseObject[@"items"] xf_safeObjectAtIndex:0] objectForKey:@"fileUrl"];
            
            NSError *error = nil;
            if (!newCommentImgUrl || [newCommentImgUrl isEqualToString:@""]) {
                /**
                 *  上传失败不做处理 */
                self.currentSelectedImage = nil;
                error = [NSError errorWithDomain:@"图片上传失败" code:1 userInfo:nil];
                [SVProgressHUD dismissWithSuccess:@"图片上传失败"];
            }else {
                /**
                 *   */
                self.imagesCount += 1;
                self.didSuccessUploadImage = self.currentSelectedImage;
                [SVProgressHUD dismissWithSuccess:@"上传成功"];
                [self updateImageViews];
            }
        }else {
            NSString *message = responseObject[@"sub_msg"];
            [UIAlertView xf_showWithTitle:@"上传失败！" message:message delay:2.4 onDismiss:NULL];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.currentSelectedImage = nil;
        [SVProgressHUD dismissWithError:@"网络错误，请稍后重试"];
    }];
}


/**
 *  更新图片位置布局 */
- (void)updateImageViews {
    NSInteger imageCount = self.imagesCount;
    UIImageView *selectedImageView = [[UIImageView alloc] initWithImage:self.didSuccessUploadImage];
    NSInteger row = imageCount % 3;
    
    if (imageCount > 1) {
        imageCount -= 1;
    }
    NSInteger col = imageCount / 3;
    
    selectedImageView.width = SelectedImageHW ;
    selectedImageView.height = SelectedImageHW;
    if (row == 0) {
        selectedImageView.x = MagrinX + 2 * SelectedImageHW + 2 * MagrinImageWidth;
    }else if (row == 1) {
        selectedImageView.x = MagrinX;
    }else if (row == 2) {
        selectedImageView.x = MagrinX + 1 * SelectedImageHW + 1 * MagrinImageWidth;
    }
    
    if (col == 0) {
        selectedImageView.y = 0;
    }else if(col == 1) {
        selectedImageView.y = SelectedImageHW + MagrinImageWidth;
    }else if(col == 2) {
        selectedImageView.y = SelectedImageHW * 2 + MagrinImageWidth * 2;
    }
    
    [self addSubview:selectedImageView];
    
    if (imageCount != 8) {
        if (row == 0) {
            /**
             *  往下移 */
            self.addImageView.x = MagrinX;
            self.addImageView.y = MaxY(selectedImageView) + MagrinImageWidth;
            
        }else {
            self.addImageView.x = MaxX(selectedImageView) + MagrinImageWidth;
            self.addImageView.y = selectedImageView.y;
        }
//        self.scrollView.contentSize = CGSizeMake(self.width, MaxY(self.addImageView) + 40);

    }else {
        [self.addImageView setHidden:YES];
    }
    
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

}

@end
