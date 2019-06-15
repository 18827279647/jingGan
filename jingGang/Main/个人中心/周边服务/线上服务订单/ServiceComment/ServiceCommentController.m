//
//  ServiceCommentController.m
//  jingGang
//
//  Created by 张康健 on 15/9/14.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "ServiceCommentController.h"
#import "AddPhotoCollectionView.h"
#import "GlobeObject.h"
#import "Util.h"
#import "TakePhotoUpdateImg.h"
#import "PhotoDataModel.h"
#import "VApiManager.h"
#import "CWStarRateView.h"
#import "IQKeyboardManager.h"
#import "MBProgressHUD.h"
#import "WSProgressHUD.h"
#import "XFStarRateView.h"
#import <Photos/Photos.h>
#import "TZImagePickerController.h"
#import "UIAlertView+Extension.h"
#import "YSImageUploadManage.h"

#define MaxPhotoCount 7
@interface ServiceCommentController () <XFStarRateViewDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,TZImagePickerControllerDelegate>{
    
    VApiManager        *_vapManager;
    NSInteger          _stars;
}

@property (weak, nonatomic) IBOutlet AddPhotoCollectionView *addPhotoCollectionView;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addPhotoCollectionViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet CWStarRateView *startView;
@property (strong,nonatomic) XFStarRateView *rateView;
@property (weak, nonatomic) IBOutlet UILabel *labelTextViewPlaceholder;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@end

@implementation ServiceCommentController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    

    
    [self _init];
    
    [self _initAddPhotoCollectionView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] shouldResignOnTouchOutside];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}


- (void)viewWillDisappear:(BOOL)animate {
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}


#pragma mark ----------------------- private Method -----------------------
- (void)_init {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
    [YSThemeManager setNavigationTitle:self.ggName andViewController:self];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    _vapManager = [[VApiManager alloc] init];
    self.commentTextView.delegate = self;

    _stars = 0;
    self.commitButton.backgroundColor = [YSThemeManager buttonBgColor];
    XFStarRateView *rateView = [[XFStarRateView alloc] initWithFrame:CGRectMake(0,0, 173, 28) numberOfStars:5 foregroundImg:@"Star" backgroundImg:@"Star1"];
    rateView.allowIncompleteStar = NO;
    rateView.scorePercent = 0;
    rateView.delegate = self;
    [self.startView addSubview:rateView];
    self.rateView = rateView;
    
    self.imagePickerVc.delegate = self;
    
}


- (void)_initAddPhotoCollectionView {
    //设置默认的layout
    @weakify(self);
    [self.addPhotoCollectionView setDefaultLayout];
    self.addPhotoCollectionView.addPhotoBlock = ^{
        //添加照片
        @strongify(self);
        if (self.addPhotoCollectionView.photoArr.count >= MaxPhotoCount) {
            [Util ShowAlertWithOnlyMessage:@"最多只能评论6张"];
            return;
        }
     
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选择", nil];
        [actionSheet showInView:self.view];
    };

    CGFloat itemSize =  kScreenWidth / (375.0 / 72.0);
    self.addPhotoCollectionViewHeightConstraint.constant = itemSize;
    
    self.addPhotoCollectionView.deletePhotoBlock = ^(NSInteger index){
        @strongify(self);
        [self.addPhotoCollectionView.photoArr removeObjectAtIndex:index];
        [self _updatePhotoDataConfigure];
    };
}


//更新相片数据源之后的一些配置
-(void)_updatePhotoDataConfigure {
    CGFloat itemSize =  kScreenWidth / (375.0 / 72.0);
    if (self.addPhotoCollectionView.photoArr.count > 4) {
        if (self.addPhotoCollectionViewHeightConstraint.constant == itemSize) {
            CGFloat itemSize =  kScreenWidth / (375.0 / 156.0);
            self.addPhotoCollectionViewHeightConstraint.constant = itemSize;
        }
    }else {
        self.addPhotoCollectionViewHeightConstraint.constant = itemSize;
    }
    [self.addPhotoCollectionView reloadData];
    
//    [self performSelector:@selector(_PhotoImgScrollToBotton) withObject:nil afterDelay:1.0];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}


-(void)_PhotoImgScrollToBotton {
    
    [self.addPhotoCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathWithIndex:self.addPhotoCollectionView.photoArr.count-1] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
}


#pragma mark ----------------------- CWStartView delegate -----------------------
- (void)starRateView:(XFStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent
{
    _stars = (NSInteger)(newScorePercent * 5);
    JGLog(@"score:%ld",_stars);
}

#pragma mark ----------------------- text view delegate -----------------------
-(BOOL) textView :(UITextView *) textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *) text {
    
    if ([text isEqualToString:@"\n"]) {
        [self.commentTextView resignFirstResponder];
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 0) {
        self.labelTextViewPlaceholder.hidden = YES;
    }else{
        self.labelTextViewPlaceholder.hidden = NO;
    }
}
#pragma mark ----------------------- UIActionSheet delegate -----------------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self takePhoto];
    }else if (buttonIndex == 1){
        NSInteger maxImagesCount = 6 - (self.addPhotoCollectionView.photoArr.count - 1);
        if (maxImagesCount == 0) {
            [UIAlertView xf_showWithTitle:@"最多只能选择6张照片" message:nil delay:1.2 onDismiss:NULL];
            return;
        }
        [self pushImagePickerControllerWithMaxImagesCount:maxImagesCount];
    }
}


#pragma mark  ----------------------- image piker delegate -----------------------
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{

    [picker dismissViewControllerAnimated:YES completion:nil];
//    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    PhotoDataModel *model = [[PhotoDataModel alloc] init];
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    model.photoImg = image;

    [self.addPhotoCollectionView.photoArr insertObject:model atIndex:0];
    [self _updatePhotoDataConfigure];
    [picker dismissViewControllerAnimated:YES completion:^{
        //        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        //        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    }];
}

- (NSArray *)uploadImagesWithPhotoArray:(NSArray *)photoArray {
    NSMutableArray *images = [NSMutableArray array];
    for (NSUInteger i = 0; i < photoArray.count - 1; i++) {
        PhotoDataModel *model = (PhotoDataModel *)[photoArray xf_safeObjectAtIndex:i];
        [images xf_safeAddObject:model.photoImg];
    }
    return [images copy];
}

#pragma mark - 发布评论
- (IBAction)distributionCommentAction:(id)sender {
    
    
    
    
    //验证评论内容，评级
    if(![self _varyfyCommentContentAndCommentStart]) {//验证没过
        return ;
    }
    [WSProgressHUD showWithMaskType:WSProgressHUDMaskTypeDefault];
    //以;分割,上传图片到服务器，并获取到图片路径链接
    //有图片才上传
    if (self.addPhotoCollectionView.photoArr.count > 1) {
        [YSImageUploadManage uploadImagesShouldClips:NO targetImageSize:CGSizeZero images:[self uploadImagesWithPhotoArray:self.addPhotoCollectionView.photoArr] attrText:[NSAttributedString new] labels:[NSMutableArray array] composePosition:@"" uploadImageCompleted:^(NSString *msg) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 回到主线程
                [self postCommentRequsrWithUrlStr:msg];
            });
            
        } imagePathDividKeyword:@";" pathSourceType:YSUploadImageSourcePathFromEles];
        
        
        //上传图片报错
        [YSImageUploadManage sharedInstance].composeResultCallback = ^(BOOL result, NSString *msg) {
            
            if (result) {
                
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 回到主线程,执⾏UI刷新操作
                    [WSProgressHUD dismiss];
                    [UIAlertView xf_showWithTitle:msg message:nil delay:1.2 onDismiss:NULL];
                    return ;
                });
            }
        };

    }else{
        //没图片
        [self postCommentRequsrWithUrlStr:@""];
    }
    
    
    
    
    
}


- (void)postCommentRequsrWithUrlStr:(NSString *)strUrl{
    PersonalCommentSaveRequest *request = [[PersonalCommentSaveRequest alloc] init:GetToken];
    request.api_content = self.commentTextView.text;
    
    request.api_orderId = self.api_Id;
    
    if (strUrl.length > 5) {//表示有评论图片
        request.api_photo = strUrl;
    }
    request.api_evaluationAverage = @(_stars);
    [_vapManager personalCommentSave:request success:^(AFHTTPRequestOperation *operation, PersonalCommentSaveResponse *response) {
        [WSProgressHUD dismiss];
        if (response.errorCode) {
            [UIAlertView xf_showWithTitle:response.subMsg message:nil delay:1.0 onDismiss:NULL];
        }else{
            [UIAlertView xf_showWithTitle:@"评论成功" message:nil delay:1.0 onDismiss:NULL];
            [self performSelector:@selector(btnClick) withObject:nil afterDelay:1.0];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WSProgressHUD dismiss];
        [Util ShowAlertWithOnlyMessage:error.localizedDescription];
    }];
    
}


-(BOOL)_varyfyCommentContentAndCommentStart {

    if (!self.commentTextView.text || [self.commentTextView.text isEqualToString:@""]) {
        [UIAlertView xf_showWithTitle:@"评论内容不能为空" message:nil delay:1.2 onDismiss:NULL];
        return NO;
    }
    
    if (!_stars) {
        [UIAlertView xf_showWithTitle:@"你还未评级" message:nil delay:1.2 onDismiss:NULL];
        return NO;
    }
    
    return YES;
}
#pragma mark - UIImagePickerController
- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS8Later) {
        // 无权限 做一个友好的提示
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
#define push @#clang diagnostic pop
    } else { // 调用相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVc.sourceType = sourceType;
            //            if(iOS8Later) {
            //                _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            //            }
            [self presentViewController:_imagePickerVc animated:YES completion:nil];
        } else {
            JGLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
}

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
#pragma clang diagnostic pop
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}
- (void)pushImagePickerControllerWithMaxImagesCount:(NSInteger)maxImagesCount{
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxImagesCount delegate:self];
    imagePickerVc.allowTakePicture = NO;
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
#pragma mark - 到这里为止
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
     @weakify(self);
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        @strongify(self);
        for (NSInteger i = 0 ; i < photos.count; i++) {
            PhotoDataModel *model = [[PhotoDataModel alloc] init];
            model.photoImg = photos[i];
            [self.addPhotoCollectionView.photoArr insertObject:model atIndex:0];
        }
        [self _updatePhotoDataConfigure];
        [self.addPhotoCollectionView reloadData];
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}



@end
