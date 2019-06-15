//
//  YSJuanPiWebViewController.m
//  jingGang
//
//  Created by HanZhongchou on 2017/8/31.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSJuanPiWebViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "YSGotoJuanPiWaitView.h"
#import "YSJuanPiWebLoadErrorView.h"
#import "YSShareManager.h"
#import "WSProgressHUD.h"
#import "YSLoginManager.h"
@interface YSJuanPiWebViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate>
@property (nonatomic,strong) UIWebView *webView;
@property (strong,nonatomic) NJKWebViewProgressView *progressView;
@property (strong,nonatomic) NJKWebViewProgress *progressProxy;
@property (nonatomic,strong) YSGotoJuanPiWaitView *gotoJuanPiWaitView;
@property (nonatomic,strong) YSJuanPiWebLoadErrorView *juanPiWebErrorView;
@property (nonatomic,strong) YSShareManager *shareManager;
@property (nonatomic,assign) YSJuanPiUrlType juanPiUrlType;
@property (nonatomic,strong) UIButton *navRightButton;
@end

@implementation YSJuanPiWebViewController


- (instancetype)initWithUrlType:(YSJuanPiUrlType)juanPiUrlType{
    if (self = [super init]) {
        self.juanPiUrlType = juanPiUrlType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.gotoJuanPiWaitView];
    [self initUI];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
}

- (void)setJuanPiUrlType:(YSJuanPiUrlType)juanPiUrlType{
    _juanPiUrlType = juanPiUrlType;
    if (juanPiUrlType == YSGoodsDetileType) {
        [YSThemeManager setNavigationTitle:@"商品详情" andViewController:self];
        [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@%@%@",@"um_",@"Shop_",@"JuanPi_",@"GoodsDetail"]];
    }else if (juanPiUrlType == YSOrderListType){
        [YSThemeManager setNavigationTitle:@"订单详情" andViewController:self];
        self.navRightButton.hidden = YES;
    }
}

- (void)initUI{
    self.navigationItem.rightBarButtonItem = [self rightButton];
    self.navRightButton.enabled            = NO;
    //取出存在本地的uid
    NSDictionary *dictUserInfo = [kUserDefaults objectForKey:kUserCustomerKey];
    NSString *strUid = [NSString stringWithFormat:@"%@",dictUserInfo[@"uid"]];
    //拼在卷皮链接后面再开始请求
    NSString *url = @"";
    if (self.juanPiUrlType == YSGoodsDetileType) {
        url = [NSString stringWithFormat:@"%@&subchannel=%@",self.strWebUrl,strUid];
    }else if(self.juanPiUrlType == YSOrderListType){
        url = [NSString stringWithFormat:@"%@?subchannel=%@",self.strWebUrl,strUid];
        self.navRightButton.hidden = YES;
    }
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.gotoJuanPiWaitView];
    
    _progressProxy                      = [[NJKWebViewProgress alloc] init];
    self.webView.delegate               = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate     = self;
    CGFloat progressBarHeight           = 2.f;
    CGRect navigationBarBounds          = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.navigationController.navigationBar addSubview:_progressView];
}

- (void)rightShareButtonClick{
    if (!CheckLoginState(YES)) {
        return;
    }
     @weakify(self);
    VApiManager *vapiManager       = [[VApiManager alloc]init];
    ShopJuanpiShareRequest *requst = [[ShopJuanpiShareRequest alloc]init:GetToken];
    requst.api_goodsId             = self.goodsID;
    [WSProgressHUD showWithMaskType:WSProgressHUDMaskTypeBlack];
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@%@%@",@"um_",@"Shop_",@"JuanPi_",@"ShareButtonClick"]];
    [vapiManager shopJuanpiShare:requst success:^(AFHTTPRequestOperation *operation, ShopJuanpiShareResponse *response) {
        @strongify(self);
        [WSProgressHUD dismiss];
        NSDictionary *dict        = (NSDictionary *)response.juanpiShare;
        NSString *strShareContent = [NSString stringWithFormat:@"%@",dict[@"context"]];
        NSString *strImageUrl     = [NSString stringWithFormat:@"%@",dict[@"imgUrl"]];
        NSString *strShareUrl     = [NSString stringWithFormat:@"%@",dict[@"url"]];
        NSString *strShareTitel   = [NSString stringWithFormat:@"%@",dict[@"title"]];
        //取出存在本地的uid
        //    NSDictionary *dictUserInfo = [kUserDefaults objectForKey:kUserCustomerKey];
        //拼接邀请注册链接
        YSShareManager *shareManager = [[YSShareManager alloc] init];
        YSShareConfig *config        = [YSShareConfig configShareWithTitle:strShareTitel content:strShareContent UrlImage:strImageUrl shareUrl:strShareUrl];
        [shareManager shareWithObj:config showController:self];
        self.shareManager = shareManager;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WSProgressHUD dismiss];
        [UIAlertView xf_showWithTitle:@"请求分享内容网络错误，请稍后再试" message:nil delay:2 onDismiss:NULL];
    }];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    _juanPiWebErrorView.hidden = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    if (webView.isLoading) {
        return;
    }
    self.navRightButton.enabled = YES;
    if (_gotoJuanPiWaitView) {
        self.gotoJuanPiWaitView.hidden = YES;
    }
    
//        NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//        if (title.length == 0) {
//            title = self.title;
//        }
//    [YSThemeManager setNavigationTitle:title andViewController:self];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    if (webView.isLoading) {
        return;
    }
    self.navRightButton.enabled = NO;
    if (!_juanPiWebErrorView) {
        [self.view addSubview:self.juanPiWebErrorView];
    }
    _juanPiWebErrorView.hidden = NO;
}



//右侧分享按钮
- (UIBarButtonItem *)rightButton
{
    self.navRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.navRightButton.frame= CGRectMake(0, 0, 40, 40);
    self.navRightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [self.navRightButton setImage:[UIImage imageNamed:@"JuanPi_ShareGoods_Icon"] forState:UIControlStateNormal];
    [self.navRightButton addTarget:self action:@selector(rightShareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.navRightButton];
    return item;
}

- (YSGotoJuanPiWaitView *)gotoJuanPiWaitView{
    if (!_gotoJuanPiWaitView) {
        _gotoJuanPiWaitView = [[YSGotoJuanPiWaitView alloc]init];
    }
    return _gotoJuanPiWaitView;
}

- (YSJuanPiWebLoadErrorView *)juanPiWebErrorView{
    if (!_juanPiWebErrorView) {
         @weakify(self);
        _juanPiWebErrorView = [[YSJuanPiWebLoadErrorView alloc]init];
        _juanPiWebErrorView.backButtonClick = ^{
            @strongify(self);
            [self.navigationController popToRootViewControllerAnimated:YES];
        };
    }
    return _juanPiWebErrorView;
}

- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    }
    return _webView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSNumber *)getJuanPiGoodsIdWithJuanPiGoodsUrl:(NSString *)juanPiUrl{
    //计算出url中YSJuanPiGoodsID=这个字符串的位置并截取从等号后面所有的字符串作为卷皮id返回
    NSRange range = [juanPiUrl rangeOfString:@"YSJuanPiGoodsID="];
    NSString *strGoodsID = [juanPiUrl substringFromIndex:(range.location + range.length)];
    NSNumber *goodsID = @(strGoodsID.integerValue);
    return goodsID;
}
- (void)dealloc{
    
}


@end
