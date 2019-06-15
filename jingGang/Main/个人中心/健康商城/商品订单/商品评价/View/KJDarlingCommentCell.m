//
//  KJDarlingCommentCell.m
//  jingGang
//
//  Created by 张康健 on 15/8/17.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "KJDarlingCommentCell.h"
#import "GlobeObject.h"
#import "RateView.h"
#import "Masonry.h"
#import "Util.h"
#import "ALActionSheetView.h"
#import "UIView+firstResponseController.h"
#import "AFNetworking.h"
#import "H5Base_url.h"
#import "UITextView+Placeholder.h"
#import "XFStarRateView.h"
#import <Photos/Photos.h>
#import "YSAddPhotoCollectionView.h"
#import "TZImagePickerController.h"
#import "UIAlertView+Extension.h"
#import "YSImageConfig.h"

@interface KJDarlingCommentCell()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,XFStarRateViewDelegate,UIActionSheetDelegate,TZImagePickerControllerDelegate>{
    NSArray *_commentLevelButtonArrs;

}

@property (weak, nonatomic) IBOutlet UIView *descriptionRateView;
@property (weak, nonatomic) IBOutlet UIView *serviceAtitudeRateView;
@property (weak, nonatomic) IBOutlet UIView *deleverServiceRateView;

//好评，中评，差评
@property (weak, nonatomic) IBOutlet UIButton *goodCommentButton;
@property (weak, nonatomic) IBOutlet UIButton *middleCommentButton;
@property (weak, nonatomic) IBOutlet UIButton *badCommentButton;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (weak, nonatomic) IBOutlet YSAddPhotoCollectionView *addPhotoCollectionView;



@end


@implementation KJDarlingCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self _initInfo];
    // Initialization code
    [self _initRateView];
    
    self.goodsPriceLabel.textColor = [YSThemeManager priceColor];
    
    self.commentContentTextView.placeholder = @"亲，您的意见对其他买家很有帮助哦！";
    self.commentContentTextView.delegate = self;

}


-(void)_initInfo{
    
    _commentLevelButtonArrs = @[_goodCommentButton,_middleCommentButton,_badCommentButton];
     @weakify(self);
    
    self.addPhotoCollectionView.addPhotoBlock = ^{
        //添加照片
        @strongify(self);
        if (self.addPhotoCollectionView.photoArr.count >= 4) {
            [UIAlertView xf_showWithTitle:@"最多只能上传3张" message:nil delay:1.2 onDismiss:NULL];
            return;
        }
        NSInteger maxImagesCount = 3 - (self.model.commentImgArr.count - 1);
        NSString *sheetTitle = [NSString stringWithFormat:@"亲，您还可以上传 %ld 张照片",maxImagesCount];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:sheetTitle delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选择", nil];
        [actionSheet showInView:[self getCurrentVC].view];
    };
    
    
    self.addPhotoCollectionView.deletePhotoBlock = ^(NSInteger selectItem){
        [self.model.commentImgArr removeObjectAtIndex:selectItem];
        self.addPhotoCollectionView.photoArr = [self.model.commentImgArr copy];
        [self.addPhotoCollectionView reloadData];
    };
    
    
}

#pragma mark ----------------------- UIActionSheet delegate -----------------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self takePhoto];
    }else if (buttonIndex == 1){
        NSInteger maxImagesCount = 3 - (self.model.commentImgArr.count - 1);
        [self pushImagePickerControllerWithMaxImagesCount:maxImagesCount];
    }
}



- (void)_initRateView {
    
    XFStarRateView *descRateView = [[XFStarRateView alloc] initWithFrame:CGRectMake(0,11, 173, 28) numberOfStars:5 foregroundImg:@"Star" backgroundImg:@"Star1"];
    descRateView.allowIncompleteStar = NO;
    descRateView.scorePercent = 1;
    descRateView.delegate = self;
    [self.descriptionRateView addSubview:descRateView];
    self.descRateView = descRateView;
    
    
    XFStarRateView *serviceRateView = [[XFStarRateView alloc] initWithFrame:CGRectMake(0,11, 173, 28) numberOfStars:5 foregroundImg:@"Star" backgroundImg:@"Star1"];
    serviceRateView.allowIncompleteStar = NO;
    serviceRateView.scorePercent = 1;
    serviceRateView.delegate = self;
    [self.serviceAtitudeRateView addSubview:serviceRateView];
    self.serviceRateView = serviceRateView;
    
    
    XFStarRateView *deleverRateView = [[XFStarRateView alloc] initWithFrame:CGRectMake(0,11, 173, 28) numberOfStars:5 foregroundImg:@"Star" backgroundImg:@"Star1"];
    deleverRateView.allowIncompleteStar = NO;
    deleverRateView.scorePercent = 1;
    deleverRateView.delegate = self;
    [self.deleverServiceRateView addSubview:deleverRateView];
    self.deleverRateView = deleverRateView;


    
}

#pragma mark ----------------------- CWStartView delegate -----------------------
- (void)starRateView:(XFStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent
{
    
    NSInteger stars = (NSInteger)(newScorePercent * 5);
    if (starRateView == self.descRateView) {
        self.model.descriptionStars = stars;
    }else if(starRateView == self.serviceRateView){
        self.model.serviceAltitudeStars = stars;
    }else if (starRateView == self.deleverRateView){
        self.model.deliveryServiceStars = stars;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)layoutSubviews {
    
    [super layoutSubviews];
    self.commentContentTextView.text = self.model.commentTextContent;
    
    //总评级
    for (NSInteger i=0; i<_commentLevelButtonArrs.count; i++) {
        UIButton *button = (UIButton *)_commentLevelButtonArrs[i];
        button.selected = (i == self.model.commentLevel - 1) ? YES : NO;
    }
}


- (void)showPickerWithType:(UIImagePickerControllerSourceType)photoType
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = photoType;
    picker.delegate = self;
    [self.firstResponseController presentViewController:picker animated:YES completion:nil];
}

#pragma mark - textView delegate
- (void)textViewDidChange:(UITextView *)textView {

    self.model.commentTextContent = textView.text;
    
}

-(BOOL) textView :(UITextView *) textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *) text {
    
    if ([text isEqualToString:@"\n"]) {
        [self.commentContentTextView resignFirstResponder];
    }
    
    return YES;
}

//总评价
- (IBAction)commentLevelAction:(id)sender {
    UIButton *selectedButton = (UIButton *)sender;
    if (selectedButton.isSelected) {
        return;
    }
    UIButton *lastSeletedButton = [Util getSeletedButtonAtBtnArr:_commentLevelButtonArrs];
    lastSeletedButton.selected = NO;
    selectedButton.selected = YES;
    
    NSInteger commentLevel = selectedButton.tag - 20;
    self.model.commentLevel = commentLevel;
    //刷新cell
    [self setNeedsLayout];
}

-(void)setModel:(DarlingCommentModel *)model{
    _model = model;
    self.addPhotoCollectionView.photoArr = [model.commentImgArr copy];
    [self.addPhotoCollectionView reloadData];
    
    self.descRateView.scorePercent = (CGFloat)(model.descriptionStars / 5.0);
    
    self.serviceRateView.scorePercent = (CGFloat)(model.serviceAltitudeStars / 5.0);
    
    self.deleverRateView.scorePercent = (CGFloat)(model.deliveryServiceStars / 5.0);
    
}



-(void)setGoodsInfoModel:(GoodsInfoModel *)goodsInfoModel{
    _goodsInfoModel = goodsInfoModel;
    NSString *newStr = _goodsInfoModel.goodsMainphotoPath;
    [YSImageConfig sd_view:self.goodsImgView setimageWithURL:[NSURL URLWithString:newStr] placeholderImage:DEFAULTIMG];
    self.goodsNameLabel.text = _goodsInfoModel.goodsName;
    self.goodsPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",    _goodsInfoModel.goodsPrice.floatValue];
    //把商品信息给评论产生的模型
    self.model.goodsId = _goodsInfoModel.goodsId;
    self.model.goodsCount = _goodsInfoModel.goodsCount;
    self.model.goodsPrice = _goodsInfoModel.goodsPrice;
    self.model.goodsGspVal = _goodsInfoModel.goodsGspVal;
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
            [[self getCurrentVC] presentViewController:_imagePickerVc animated:YES completion:nil];
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
        _imagePickerVc.navigationBar.barTintColor = [self getCurrentVC].navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = [self getCurrentVC].navigationController.navigationBar.tintColor;
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
            
            UIImage *imageSelectPhoto = photos[i];
            [self.model.commentImgArr insertObject:imageSelectPhoto atIndex:0];
        }

        self.addPhotoCollectionView.photoArr = [self.model.commentImgArr copy];
        [self.addPhotoCollectionView reloadData];
        
    }];
    
    [[self getCurrentVC] presentViewController:imagePickerVc animated:YES completion:nil];
}
#pragma mark  ----------------------- image piker delegate -----------------------
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    [self.model.commentImgArr insertObject:image atIndex:0];
    self.addPhotoCollectionView.photoArr = [self.model.commentImgArr copy];
    [self.addPhotoCollectionView reloadData];
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    }];
}

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
