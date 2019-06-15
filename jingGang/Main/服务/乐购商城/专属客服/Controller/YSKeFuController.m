//
//  YSKeFuController.m
//  jingGang
//
//  Created by whlx on 2019/5/9.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "YSKeFuController.h"

#import "UIImageView+WebCache.h"

#import "YSKefuModel.h"

#import "YSAFNetworking.h"

#import "YSEnvironmentConfig.h"

#import "VApiManager.h"

#import "YSKeFuResponse.h"
#import "YSKeFuRequest.h"

#import "GlobeObject.h"

#import "YSShareManager.h"
#import "PublicInfo.h"



@interface YSKeFuController ()<UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *NickLabel;

@property (weak, nonatomic) IBOutlet UIImageView *HeadImageView;
@property (weak, nonatomic) IBOutlet UIImageView *CodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *WXLabel;
@property (weak, nonatomic) IBOutlet UILabel *ContextFristLabel;
@property (weak, nonatomic) IBOutlet UILabel *ContentTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *ContentThreeLabel;


@property (nonatomic, copy) NSString * WXNumber;



@end

@implementation YSKeFuController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self SetInit];
    
//    [self.HeadImageView sd_setImageWithURL:[NSURL URLWithString:self.HeadString]];
//
//    [self.CodeImageView sd_setImageWithURL:[NSURL URLWithString:self.CodeString]];
//
//    self.WXLabel.text = [NSString stringWithFormat:@"微信号:%@",self.WXString];
    
    
}

#pragma 初始化页面
- (void)SetInit{
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    
    self.navigationController.navigationBar.translucent = NO;
    
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
    //设置标题
    [YSThemeManager setNavigationTitle:@"专属客服" andViewController:self];
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    VApiManager *manager = [[VApiManager alloc] init];

    YSKeFuRequest *request = [[YSKeFuRequest alloc]init:GetToken];
    @weakify(self);
    [manager YSKeFuResponse:request success:^(AFHTTPRequestOperation *operation, YSKeFuResponse *response) {
        
        NSDictionary * dict = (NSDictionary *)response.kefu;
  
        [self.HeadImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"headImgPath"]]];

        [self.CodeImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"qrCode"]]];

        self.WXLabel.text = [NSString stringWithFormat:@"微信号:%@",dict[@"number"]];
        self.WXNumber = dict[@"number"];
        self.ContentTwoLabel.text = dict[@"content2"];
        self.ContentThreeLabel.text = dict[@"content3"];
        self.ContextFristLabel.text = dict[@"content1"];
        self.NickLabel.text = dict[@"name"];
      [hub hide:YES afterDelay:1.0f];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    

    }];
    
//    [YSAFNetworking POSTUrlString:@"http://api.bhesky.cn/v1/kefu" parametersDictionary:dict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
//        NSString *str  = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSData * data=[str dataUsingEncoding:NSUTF8StringEncoding];
//        NSDictionary * dict =[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
//
//
//        NSLog(@"---%@",dict);
//
//
//    } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
//        NSLog(@"---%@",error);
//    }];
    
}


- (IBAction)Click:(UIButton *)sender {
   
    //0 保存二维码  1 跳转微信
    if (sender.tag == 0) {
        [self loadImageFinished:self.CodeImageView.image];
    }else {
        
        [self openWechat];
    }
    
}

#pragma 保存图片到手机
- (void)loadImageFinished:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
 
    if (error) {
        [self hideHubWithOnlyText:@"保存失败"];
    }else {
        [self hideHubWithOnlyText:@"保存成功"];
    }
    
}

#pragma 打开微信
-(void)openWechat{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.self.WXNumber;
    NSURL * url = [NSURL URLWithString:@"weixin://"];
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
    //先判断是否能打开该url
    if (canOpen)
    {   //打开微信
        [[UIApplication sharedApplication] openURL:url];
    }else {
        [self hideHubWithOnlyText:@"您的设备未安装微信APP"];
    }
}
@end
