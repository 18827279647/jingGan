//
//  YSShareManager.m
//  jingGang
//
//  Created by dengxf on 16/8/16.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSShareManager.h"
#import "JGDropdownMenu.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import <ShareSDK/ShareSDK.h>
#import "WeiboSDK.h"
#import "JGShare.h"
#import "YSLoginManager.h"
#import "UIAlertView+Extension.h"
#import "TieThirdPlatFormController.h"
#import "YSGestureNavigationController.h"
#import "AppDelegate.h"
#import "ThirdPlatformInfo.h"
#import "YSShareBgView.h"
#import "YSSharePreviewView.h"

@implementation YSShareRequestConfig

+ (void)checkUserBindingWXSuccess:(void(^)(BOOL isBinding))success fail:(msg_block_t)failCallback error:(msg_block_t)errorCallback
{
    VApiManager *manager = [[VApiManager alloc] init];
    WxBindingCheckRequest *request = [[WxBindingCheckRequest alloc] init:GetToken];
    
    [manager wxBindingCheck:request success:^(AFHTTPRequestOperation *operation, WxBindingCheckResponse *response) {
        if ([response.errorCode integerValue]) {
            BLOCK_EXEC(failCallback,response.subMsg);
        }else {
            BLOCK_EXEC(success,[response.binding integerValue]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        BLOCK_EXEC(errorCallback,error.domain);
    }];
}

+ (void)bindingWXUnionid:(NSString *)unionId success:(voidCallback)success fail:(msg_block_t)failCallback {
    VApiManager *manager = [[VApiManager alloc] init];
    BindingWeiXinRequest *request = [[BindingWeiXinRequest alloc] init:GetToken];
    request.api_unionId = unionId;
    [manager bindingWeiXin:request success:^(AFHTTPRequestOperation *operation, BindingWeiXinResponse *response) {
        if ([response.errorCode integerValue]) {
            BLOCK_EXEC(failCallback,response.subMsg);
        }else {
            if ([response.isBinding integerValue]) {
                BLOCK_EXEC(success);
            }else {
                BLOCK_EXEC(failCallback,@"绑定失败!");
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        BLOCK_EXEC(failCallback,error.domain);
    }];
}


+ (void)checkUserPhoneIsBindWXWithPhoneNum:(NSString *)phoneNum success:(void(^)(NSNumber *isBinding,NSString *unionID))success fail:(msg_block_t)failCallback
{
    VApiManager *vapiManager = [[VApiManager alloc]init];
    MobileBindingCheckRequest *requst = [[MobileBindingCheckRequest alloc]init:@""];
    requst.api_mobile = phoneNum;
    
    [vapiManager mobileBindingCheck:requst success:^(AFHTTPRequestOperation *operation, MobileBindingCheckResponse *response) {
        if ([response.errorCode integerValue]) {
            BLOCK_EXEC(failCallback,response.subMsg);
        }else {
            BLOCK_EXEC(success,response.binding,response.unionID);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        BLOCK_EXEC(failCallback,error.domain);
    }];
}


@end

@implementation YSShareConfig

+ (instancetype)configShareWithTitle:(NSString *)title content:(NSString *)content projectImage:(NSString *)image shareUrl:(NSString *)url {
    YSShareConfig *config = [[YSShareConfig alloc] init];
    if (title == nil || title.length == 0) {
        title = @" ";
    }
    config.title = title;
    config.content = content;
    config.prjImage = image;
    config.url = url;
    return config;
}

+ (instancetype)configShareWithTitle:(NSString *)title content:(NSString *)content UrlImage:(NSString *)image shareUrl:(NSString *)url {
    YSShareConfig *config = [[YSShareConfig alloc] init];
    if (title == nil || title.length == 0) {
        title = @" ";
    }
    // http://api.bhesky.com/carnation-apis-resource/v1/share/shareProduct?mobilePath=http://mobile.bhesky.com&url=http://mobile.bhesky.com/goods_4465.htm?invitationCode=117902
    config.title = title;
    config.content = content;
    config.urlImage = image;
    config.url = url;
    return config;
}

@end

@interface YSShareManager ()

@property (strong,nonatomic) JGDropdownMenu *menu;

@property (strong,nonatomic) YSShareConfig *shareConfig;

@end

@implementation YSShareManager

- (void)shareWithShareConfig:(YSShareConfig *)shareConfig {
    if ([[YSLoginManager userAccount] isEqualToString:@"18129936086"]) {
        return;
    }

    self.shareConfig = shareConfig;
    JGDropdownMenu *menu = [JGDropdownMenu menu];
    [menu configTouchViewDidDismissController:YES];
    [menu configBgShowMengban];
    
    UIViewController *viewCtrl = [[UIViewController alloc] init];
    viewCtrl.view.backgroundColor = JGClearColor;
    viewCtrl.view.width = ScreenWidth;
    viewCtrl.view.height = ScreenHeight;
    menu.contentController = viewCtrl;
    [menu showWithFrameWithDuration:0.25];
    self.menu = menu;
    
    CGFloat height = 34 + (ScreenWidth / 4) * 2 - 10 + 38 + 40;
    @weakify(self);
    CGRect rect = CGRectMake(0, ScreenHeight - height, ScreenWidth, height);
    YSShareBgView *shareBgView = [[YSShareBgView alloc] initWithFrame:rect shareCallback:^(UIButton *button) {
        @strongify(self);
        if (shareConfig.orderModel) {
            [self shareOrderWithOrderModel:shareConfig.orderModel button:button];
        }
        else
            [self beginShare:button];
    }];
    shareBgView.cancleCallback = ^(){
        @strongify(self);
        [self.menu dismiss];
    };
    [viewCtrl.view addSubview:shareBgView];
    
}

- (void)shareWithObj:(YSShareConfig *)shareConfig showController:(UIViewController *)controller{
    UNLOGIN_HANDLE
    [self shareWithShareConfig:shareConfig];
    return;
}

- (void)cancleShare {
    [self.menu dismiss];
}
- (void)shareOrderWithOrderModel:(GoodsDetailsModel *)model button:(UIButton *)button
{
    YSSharePreviewView *sharePreview = [YSSharePreviewView sharePreviewView];
    sharePreview.qrIMage.image = [self qrImageWithUrl:self.shareConfig.url];
    sharePreview.model = model;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIImage *snapshotImage = [sharePreview snapshotImage];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        if (![WXApi isWXAppInstalled]) {
            [Util ShowAlertWithOutCancelWithTitle:@"确定" message:@"未安装微信客户端"];
            return;
        }
        id<ISSCAttachment> shareImage = [ShareSDK pngImageWithImage:snapshotImage];
        id<ISSContent> publishContent = [ShareSDK content:nil defaultContent:nil
                                                    image:shareImage
                                                    title:nil
                                                      url:nil
                                              description:nil
                                                mediaType:SSPublishContentMediaTypeImage];
        ShareType shareType = ShareTypeWeixiSession;
        if (button.tag != 100) {
            shareType = ShareTypeWeixiTimeline;
        }
        [ShareSDK shareContent:publishContent
                          type:shareType
                   authOptions:nil
                  shareOptions:nil
                 statusBarTips:YES
                        result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                            if (state == SSResponseStateSuccess)
                            {
                                NSTimeInterval delay = 1.2;
                                if (type == ShareTypeWeixiTimeline) {
                                    [UIAlertView xf_showWithTitle:@"朋友圈分享成功!" message:nil delay:delay onDismiss:NULL];
                                }else if (type == ShareTypeWeixiSession) {
                                    [UIAlertView xf_showWithTitle:@"微信好友分享成功!" message:nil delay:delay onDismiss:NULL];
                                }
                                
                                //调用增加积分接口
                                VApiManager *vapManager = [[VApiManager alloc] init];
                                SnsHealthTaskSaveRequest *request = [[SnsHealthTaskSaveRequest alloc] init:GetToken];
                                request.api_integralType = @2;
                                [vapManager snsHealthTaskSave:request success:^(AFHTTPRequestOperation *operation, SnsHealthTaskSaveResponse *response) {
                                    
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    
                                }];
                                
                            }
                            else if (state == SSResponseStateFail)
                            {
                                [UIAlertView xf_showWithTitle:@"授权失败,请重新再试!" message:nil
                                                        delay:1.2 onDismiss:NULL];
                            }
                        }];//这个方法，在自己的事件里调用这个就好

    });
}

- (UIImage *)qrImageWithUrl:(NSString *)codeUrl
{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜恢复默认设置
    [filter setDefaults];
    // 2. 给滤镜添加数据
    NSString *string = codeUrl; //加入二维码url
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 3. 生成高清二维码
    CIImage *image = [filter outputImage];
    CGAffineTransform transform = CGAffineTransformMakeScale(5.0f, 5.0f);
    CIImage *output = [image imageByApplyingTransform: transform];
    UIImage *newImage = [UIImage imageWithCIImage:output scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    // 4. 显示二维码
    return newImage;
    
}
- (void)beginShare:(UIButton *)button {
    AppDelegate *appDelegate = kAppDelegate;
    if (appDelegate.window.subviews.count) {
        [SVProgressHUD showInView:[appDelegate.window.subviews lastObject]];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    
    NSInteger tag = button.tag;
    switch (tag) {
        case 100:
        {
            /**
             *  微信好友 */
            if ([YSLoginManager isThirdPlatformLogin]) {
                // 第三方平台用户不需要绑定微信 直接分享
                if (![WXApi isWXAppInstalled]) {
                    [Util ShowAlertWithOutCancelWithTitle:@"确定" message:@"未安装微信客户端"];
                    return;
                }
                if (self.shareConfig.prjImage) {
                    [self shareWithImageType:ShareTypeWeixiSession];
                }else{
                    [self shareWithShareType:ShareTypeWeixiSession];
                }
                return;
            }
            @weakify(self);
            [YSShareRequestConfig checkUserBindingWXSuccess:^(BOOL isBinding) {
                @strongify(self);
                if (isBinding) {
                    // 用户已经绑定直接分享
                    //微信好友
                    if (![WXApi isWXAppInstalled]) {
                        [Util ShowAlertWithOutCancelWithTitle:@"确定" message:@"未安装微信客户端"];
                        return;
                    }
                    if (self.shareConfig.prjImage) {
                        [self shareWithImageType:ShareTypeWeixiSession];
                    }else{
                        [self shareWithShareType:ShareTypeWeixiSession];
                    }
                }else {
                    // 未绑定，去微信授权
                    if (![WXApi isWXAppInstalled]) {
                        [Util ShowAlertWithOutCancelWithTitle:@"确定" message:@"未安装微信客户端"];
                        return;
                    }else {
                        // 微信登录授权
                        [YSLoginManager achieveWXUnionId:^(NSString *unionId) {
                            [YSShareRequestConfig bindingWXUnionid:unionId success:^{
                                if (self.shareConfig.prjImage) {
                                    [self shareWithImageType:ShareTypeWeixiSession];
                                }else{
                                    [self shareWithShareType:ShareTypeWeixiSession];
                                }
                                
                            } fail:^(NSString *msg) {
                                [UIAlertView xf_showWithTitle:msg message:nil delay:1.2 onDismiss:NULL];
                            }];
                        } fail:^(NSString *msg) {
                            [UIAlertView xf_showWithTitle:msg message:nil delay:1.2 onDismiss:NULL];
                        } info:^(NSString *msg) {
                            
                        }];
                    }
                }
            } fail:^(NSString *msg) {
                [UIAlertView xf_showWithTitle:msg message:nil delay:1.2 onDismiss:NULL];

            } error:^(NSString *msg) {
                [UIAlertView xf_showWithTitle:msg message:nil delay:1.2 onDismiss:NULL];
            }];
        }
            break;
        case 101:
        {
            /**
             *  微信朋友圈 */
            if ([YSLoginManager isThirdPlatformLogin]) {
                // 第三方平台用户不需要绑定微信 直接分享
                if (![WXApi isWXAppInstalled]) {
                    [Util ShowAlertWithOutCancelWithTitle:@"确定" message:@"未安装微信客户端"];
                    return;
                }
                if (self.shareConfig.prjImage) {
                    //健康体检、健康圈分享朋友圈，标题与内容位置要互换
                    if ([self.shareConfig.url containsString:@"page_post_detail"] || [self.shareConfig.url containsString:@"share_examination.html"]) {
                        NSString *title = self.shareConfig.title;
                        NSString *content = self.shareConfig.content;
                        self.shareConfig.title = content;
                        self.shareConfig.content = title;
                        [self shareWithImageType:ShareTypeWeixiTimeline];
                    }else {
                        
                        [self shareWithImageType:ShareTypeWeixiTimeline];
                    }
                }else{
                    //健康体检、健康圈分享朋友圈，标题与内容位置要互换
                    if ([self.shareConfig.url containsString:@"page_post_detail"] || [self.shareConfig.url containsString:@"share_examination.html"]) {
                        NSString *title = self.shareConfig.title;
                        NSString *content = self.shareConfig.content;
                        self.shareConfig.title = content;
                        self.shareConfig.content = title;
                        [self shareWithShareType:ShareTypeWeixiTimeline];
                    }else {
                        [self shareWithShareType:ShareTypeWeixiTimeline];

                    }
                }
                return;
            }
            @weakify(self);
            [YSShareRequestConfig checkUserBindingWXSuccess:^(BOOL isBinding) {
                @strongify(self);
                if (isBinding) {
                    // 用户已经绑定直接分享
                    //微信好友
                    if (![WXApi isWXAppInstalled]) {
                        [Util ShowAlertWithOutCancelWithTitle:@"确定" message:@"未安装微信客户端"];
                        return;
                    }
                    //微信朋友圈
                    if (self.shareConfig.prjImage) {
                        //健康体检、健康圈分享朋友圈，标题与内容位置要互换
                        if ([self.shareConfig.url containsString:@"page_post_detail"] || [self.shareConfig.url containsString:@"share_examination.html"]) {
                            NSString *title = self.shareConfig.title;
                            NSString *content = self.shareConfig.content;
                            self.shareConfig.title = content;
                            self.shareConfig.content = title;
                            [self shareWithImageType:ShareTypeWeixiTimeline];
                        }else {
                            
                            [self shareWithImageType:ShareTypeWeixiTimeline];
                        }
                    }else{
                        //健康体检、健康圈分享朋友圈，标题与内容位置要互换
                        if ([self.shareConfig.url containsString:@"page_post_detail"] || [self.shareConfig.url containsString:@"share_examination.html"]) {
                            NSString *title = self.shareConfig.title;
                            NSString *content = self.shareConfig.content;
                            self.shareConfig.title = content;
                            self.shareConfig.content = title;
                            [self shareWithShareType:ShareTypeWeixiTimeline];
                        }else {
                            [self shareWithShareType:ShareTypeWeixiTimeline];
                            
                        }
                    }
                }else {
                    // 未绑定，去微信授权
                    if (![WXApi isWXAppInstalled]) {
                        [Util ShowAlertWithOutCancelWithTitle:@"确定" message:@"未安装微信客户端"];
                        return;
                    }else {
                        [YSLoginManager achieveWXUnionId:^(NSString *unionId) {
                            [YSShareRequestConfig bindingWXUnionid:unionId success:^{
                                if (self.shareConfig.prjImage) {
                                    //健康体检、健康圈分享朋友圈，标题与内容位置要互换
                                    if ([self.shareConfig.url containsString:@"page_post_detail"] || [self.shareConfig.url containsString:@"share_examination.html"]) {
                                        NSString *title = self.shareConfig.title;
                                        NSString *content = self.shareConfig.content;
                                        self.shareConfig.title = content;
                                        self.shareConfig.content = title;
                                        [self shareWithImageType:ShareTypeWeixiTimeline];
                                    }else {
                                        
                                        [self shareWithImageType:ShareTypeWeixiTimeline];
                                    }
                                }else{
                                    //健康体检、健康圈分享朋友圈，标题与内容位置要互换
                                    if ([self.shareConfig.url containsString:@"page_post_detail"] || [self.shareConfig.url containsString:@"share_examination.html"]) {
                                        NSString *title = self.shareConfig.title;
                                        NSString *content = self.shareConfig.content;
                                        self.shareConfig.title = content;
                                        self.shareConfig.content = title;
                                        [self shareWithShareType:ShareTypeWeixiTimeline];
                                    }else {
                                        [self shareWithShareType:ShareTypeWeixiTimeline];
                                        
                                    }
                                }
                                
                            } fail:^(NSString *msg) {
                                [UIAlertView xf_showWithTitle:msg message:nil delay:1.2 onDismiss:NULL];
                            }];
                        } fail:^(NSString *msg) {
                            [UIAlertView xf_showWithTitle:msg message:nil delay:1.2 onDismiss:NULL];
                        } info:^(NSString *msg) {
                            
                        }];
                    }
                }
            } fail:^(NSString *msg) {
                [UIAlertView xf_showWithTitle:msg message:nil delay:1.2 onDismiss:NULL];
                
            } error:^(NSString *msg) {
                [UIAlertView xf_showWithTitle:msg message:nil delay:1.2 onDismiss:NULL];
            }];

        }
            break;
        case 102:
        {
            /**
             *  新浪 */
            /**
             *  qq空间 */
            if (![QQApiInterface isQQInstalled]){
                [Util ShowAlertWithOutCancelWithTitle:@"确定" message:@"未安装QQ客户端"];
                return;
            }
            [self.menu dismiss];
            if (self.shareConfig.prjImage) {
                [self shareWithImageType:ShareTypeQQSpace];
            }else{
                [self shareWithShareType:ShareTypeQQSpace];
            }

        }
            break;
        case 103:
        {
            /**
             *  qq好友 */
            if (![QQApiInterface isQQInstalled]){
                [Util ShowAlertWithOutCancelWithTitle:@"确定" message:@"未安装QQ客户端"];
                return;
            }
            [self.menu dismiss];
            if (self.shareConfig.prjImage) {
                [self shareWithImageType:ShareTypeQQ];
            }else {
                [self shareWithShareType:ShareTypeQQ];
            }
        }
            break;
        case 104:
        {
            /**
             *  新浪微博 */
            // isWeiboAppInstalled
            if (![WeiboSDK isWeiboAppInstalled]){
                [Util ShowAlertWithOutCancelWithTitle:@"确定" message:@"未安装新浪微博客户端"];
                return;
            }
            [self.menu dismiss];
            if (self.shareConfig.prjImage) {
                [self shareWithImageType:ShareTypeSinaWeibo];
            }else{
                [self shareWithShareType:ShareTypeSinaWeibo];
            }
        }
            break;
        default:
            break;
    }
}

- (void)shareWithShareType:(ShareType)shareType{
    [SVProgressHUD dismiss];
    [self.menu dismiss];
    JGShare *share = [JGShare shareWithTitle:self.shareConfig.title
                    content:self.shareConfig.content
               headerImgUrl:self.shareConfig.urlImage
                   shareUrl:self.shareConfig.url
                  shareType:shareType];
   @weakify(self);
    share.successCallback = ^(){
        @strongify(self);
        [self.menu dismiss];
    };
    
    share.failCallback = ^(){
        @strongify(self);
        [self.menu dismiss];
    };
}

- (void)shareWithImageType:(ShareType)shareType{
    [SVProgressHUD dismiss];
    [self.menu dismiss];
    JGShare *share = [JGShare shareWithImage:self.shareConfig.prjImage
             shareWithTitle:self.shareConfig.title
                    content:self.shareConfig.content
               headerImgUrl:nil
                   shareUrl:self.shareConfig.url
                  shareType:shareType];
    
    
    @weakify(self);
    share.successCallback = ^(){
        @strongify(self);
        [self.menu dismiss];
    };
    
    share.failCallback = ^(){
        @strongify(self);
        [self.menu dismiss];
    };
}

- (void)dealloc
{
    JGLog(@"YSShareManager ---- dealloc");
}

@end
