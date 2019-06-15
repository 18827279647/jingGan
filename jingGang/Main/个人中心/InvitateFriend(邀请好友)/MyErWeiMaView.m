//
//  MyErWeiMaView.m
//  jingGang
//
//  Created by 张康健 on 15/11/14.
//  Copyright © 2015年 yi jiehuang. All rights reserved.
//

#import "MyErWeiMaView.h"
#import "GlobeObject.h"
#import "UIView+Screenshot.h"
#import "TakePhotoUpdateImg.h"
#import "HZQRCodeCreater.h"
#import "PublicInfo.h"
#import "UIImage+YYAdd.h"
#import "YSShareManager.h"
#import "NSString+YYAdd.h"
#import "YSImageConfig.h"
#import "YSAdaptiveFrameConfig.h"
@interface MyErWeiMaView()<UIWebViewDelegate>{


}
@property (weak, nonatomic) IBOutlet UIView *MyView;
@property (weak, nonatomic) IBOutlet UIButton *shareErWeiMaBtn;

@property (weak, nonatomic) IBOutlet UILabel *labelShareContent;

@property (weak, nonatomic) IBOutlet UIView *userErweimaBgView;
@property (weak, nonatomic) IBOutlet UIView *userInfoBgView;
@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImgView;

@property (weak, nonatomic) IBOutlet UILabel *userNickNameLabel;
/**
 *  邀请人数label
 */

@property (weak, nonatomic) IBOutlet UILabel *userInvitationLabel;
/**
 *  二维码imageView
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageViewQRCode;
//@property (weak, nonatomic) IBOutlet UIWebView *userErWeiMaWebView;


@property (nonatomic,strong) UIImage *shareImage;
@property (weak, nonatomic) IBOutlet UIView *bgView;

/**
 *  提示信息
 */
@property (weak, nonatomic) IBOutlet UILabel *labelPointOutInfo;
/**
 *  背景view的高度,相当于scollView的滚动距离
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewHeight;

@property (weak, nonatomic) IBOutlet UISegmentedControl *inviteSegmentView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSex;

@property (weak, nonatomic) IBOutlet UIImageView *invitateFriendCodelImageView;
/**
 *  邀请码label
 */
@property (weak, nonatomic) IBOutlet UIView *bjVIewOne;

@property (weak, nonatomic) IBOutlet UILabel *labelInvitateFriendCode;
@property (weak, nonatomic) IBOutlet UILabel *myLabelInvitateFriendCode;
//邀请背景图片距离顶部距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *invitateFriendCodelImageViewWithTopSpace;
//邀请码距离顶部距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *invitateFriendCodeLabelWithTopSpace;
//邀请码背景图片高
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *invitateFriendCodelImageViewHeight;
//邀请码背景图片宽
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *invitateFriendCodelImageViewWidth;


@end

@implementation MyErWeiMaView



-(void)awakeFromNib {
    self.labelInvitateFriendCode.hidden = YES;
    self.myLabelInvitateFriendCode.hidden=YES;
    self.invitateFriendCodelImageView.hidden = YES;
    self.imageViewQRCode.hidden = NO;
    self.bjVIewOne.hidden = NO;
    [super awakeFromNib];
    self.shareErWeiMaBtn.layer.cornerRadius =15;// m_button_cornerRadius;

    self.bgView.layer.cornerRadius = 10.0;
    self.bgView.clipsToBounds = YES;
    self.userHeaderImgView.layer.cornerRadius = 25.0;
    self.userHeaderImgView.clipsToBounds = YES;
    self.userHeaderImgView.image = kDefaultUserIcon;
//
//    self.invitateFriendCodelImageViewHeight.constant = [YSAdaptiveFrameConfig width:218.0];
//    self.invitateFriendCodelImageViewWidth.constant = [YSAdaptiveFrameConfig width:242.0];
//    self.labelInvitateFriendCode.font = [UIFont systemFontOfSize:[YSAdaptiveFrameConfig width:40.0]];
//    self.myLabelInvitateFriendCode.hidden=YES;
//    if (iPhone5 || iPhone4) {
//        self.bgViewHeight.constant = 568;
//        self.invitateFriendCodelImageViewWithTopSpace.constant = 10;
//        self.invitateFriendCodeLabelWithTopSpace.constant = 99;
//    }else if(iPhone6 || iPhone6p){
//        self.bgViewHeight.constant = kScreenHeight - 64;
//        if (iPhone6p) {
//            self.invitateFriendCodeLabelWithTopSpace.constant = 152;
//        }
//    }
    self.inviteSegmentView.tintColor =[UIColor colorWithHexString:@"65BBB1"];// [YSThemeManager buttonBgColor];
//    self.shareErWeiMaBtn.backgroundColor =[UIColor colorWithHexString:@"65BBB1"];// [YSThemeManager buttonBgColor];
    [self.shareErWeiMaBtn setBackgroundImage:[UIImage imageNamed:@"button222"] forState:UIControlStateNormal];
    
}
/**
 *  选项卡事件
 */
- (IBAction)segmentedControl:(id)sender {
    UISegmentedControl *segmented = (UISegmentedControl *)sender;
    if (segmented.selectedSegmentIndex == 0) {
         self.bjVIewOne.hidden = NO;
        self.labelInvitateFriendCode.hidden = YES;
        self.myLabelInvitateFriendCode.hidden=YES;
        self.invitateFriendCodelImageView.hidden = YES;
        self.imageViewQRCode.hidden = NO;
        CALayer *layer=[_imageViewQRCode layer];
        //是否设置边框以及是否可见
        [layer setMasksToBounds:YES];
        //设置边框圆角的弧度
        [layer setCornerRadius:8.0];
        //设置边框线的宽
        //
        [layer setBorderWidth:5];
        //设置边框线的颜色
        [layer setBorderColor:[UIColor whiteColor].CGColor];
   
        self.labelPointOutInfo.text = @"扫描上面的二维码，邀请好友";
    }else{
        self.bjVIewOne.hidden = YES;
        self.labelInvitateFriendCode.hidden = NO;
        self.myLabelInvitateFriendCode.hidden=NO;
        self.invitateFriendCodelImageView.hidden = NO;
        self.imageViewQRCode.hidden = YES;
        self.MyView.height = NO;
        self.labelPointOutInfo.text = @"分享邀请码，邀请好友";
       
        
        
    }
}


#pragma mark - 分享二维码/邀请码
- (IBAction)shareErWeimaAction:(id)sender {
    if (self.imageViewQRCode.hidden) {
        
        if (self.myErWeiMaViewImmediatelyInviteButtonClickBlock) {
            self.myErWeiMaViewImmediatelyInviteButtonClickBlock();
        }

    }else{//分享二维码
        if (self.shareErweimaBlock) {
            self.shareErweimaBlock();
        }
        if (self.shareErweimaButtonClickBlock) {
            self.shareErweimaButtonClickBlock();
        }
    }
}

-(void)_snapErweiMaView {

    //分享出去的背景图片
//     UIImage *imageBg = [UIImage imageNamed:@"Share_QRCode_Bg"];
    
    //二维码图片
//    NSString *strHtmltitleBase64 = [shareTitle base64EncodedString];

//    NSString *strShareUrl = kShareInvitationFriendUrl(self.erweimoModel.userInvitationCode,strHtmltitleBase64);
//    UIImage *imageQRCode = [HZQRCodeCreater createrQRCodeWithStrUrl:strShareUrl withLengthSide:170];
    
    //头像图片
//     @weakify(self);
//    UIImageView *imageViewHeader = [[UIImageView alloc]initWithFrame:CGRectMake(35, 597, 60, 60)];
//    [imageViewHeader sd_setImageWithURL:[NSURL URLWithString:self.erweimoModel.userHeaderUrlStr] placeholderImage:kDefaultUserIcon completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        @strongify(self);
//        //头像加载完成后就生成分享图片
//        //头像切圆角
//        UIImage *imageHeaderClipRadius = [imageViewHeader.image imageByRoundCornerRadius:imageViewHeader.image.size.height/2];
//
//        //把图片都拼接到同一张图片上
////        self.shareImage = [self addImage:imageBg toImage:imageQRCode toImage:imageHeaderClipRadius];
//         [self asynAddImage:imageBg toQRImage:imageQRCode toImage:imageHeaderClipRadius returnImageCallback:^(UIImage *resultImage) {
//             @strongify(self);
//             self.shareImage = resultImage;
//             if (self.erweimaSnapUrlGetBlock) {
//                 self.erweimaSnapUrlGetBlock(self.shareImage,nil);
//             }
//        }];
//    }];
}

-(void)setErweimoModel:(ErweiMoModel *)erweimoModel
{
    _erweimoModel = erweimoModel;
    
    
//     @weakify(self);
//    [self.userHeaderImgView setImageWithURL:[NSURL URLWithString:erweimoModel.userHeaderUrlStr]  placeholder:kDefaultUserIcon options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
////        @strongify(self);
////        self.userHeaderImgView.image = [image imageByRoundCornerRadius:image.size.height/2];
//    }];
//
    
    
    
    if (erweimoModel.sex.integerValue == 2) {
        self.imageViewSex.image = [UIImage imageNamed:@"My_GirlsIcon"];
    }else {
        self.imageViewSex.image = [UIImage imageNamed:@"My_BoyIcon"];
    }

    
    
    [YSImageConfig sd_view:self.userHeaderImgView setImageWithURL:[NSURL URLWithString:erweimoModel.userHeaderUrlStr] placeholderImage:kDefaultUserIcon options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    
    //小伙伴的个数
    self.userNickNameLabel.text = erweimoModel.userNickName;
    self.labelInvitateFriendCode.text = erweimoModel.userInvitationCode;
    self.userInvitationLabel.text = erweimoModel.userInvitationCount;
    CGFloat QRCodeLengthSide = kScreenWidth/(320.0/ 206.0);
    


    //把用户昵称转换成Base64编码拼在链接后面
    NSString *strHtmltitleBase64 = [erweimoModel.userNickName base64EncodedString];
    NSString *strShareUrl = kShareInvitationFriendUrl(erweimoModel.userInvitationCode,strHtmltitleBase64);
    self.imageViewQRCode.image = [HZQRCodeCreater createrQRCodeWithStrUrl:strShareUrl withLengthSide:QRCodeLengthSide];
    
    //延迟执行
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //延迟执行截图操作，避免网速过快截图的时候画面出现卡顿
    [self _snapErweiMaView];
//    });
    

}

- (void)asynAddImage:(UIImage *)imageBg toQRImage:(UIImage *)qrImage toImage:(UIImage *)imageHeader returnImageCallback:(void(^)(UIImage *resultImage))returnImageCallback {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIGraphicsBeginImageContextWithOptions(imageBg.size, NO, [UIScreen mainScreen].scale);
        // Draw 背景
        [imageBg drawInRect:CGRectMake(0, 0, imageBg.size.width, imageBg.size.height)];
        
        // Draw 二维码
        [qrImage drawInRect:CGRectMake(103, 169, qrImage.size.width, qrImage.size.height)];
        // Draw 头像
        
        [imageHeader drawInRect:CGRectMake(35, 589, 60, 60)];
        
        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            BLOCK_EXEC(returnImageCallback,resultingImage);
        });
    });

    
    
    
// resultingImage
}

- (UIImage *)addImage:(UIImage *)imageBg toImage:(UIImage *)imageQRCode toImage:(UIImage *)imageHeader{
    //模糊
//    UIGraphicsBeginImageContext(imageBg.size);
    //高清
    UIGraphicsBeginImageContextWithOptions(imageBg.size, NO, [UIScreen mainScreen].scale);
    // Draw 背景
    [imageBg drawInRect:CGRectMake(0, 0, imageBg.size.width, imageBg.size.height)];
    
    // Draw 二维码
    [imageQRCode drawInRect:CGRectMake(103, 169, imageQRCode.size.width, imageQRCode.size.height)];
    // Draw 头像
    
    [imageHeader drawInRect:CGRectMake(35, 589, 60, 60)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

@end


@implementation ErweiMoModel


@end
