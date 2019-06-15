//
//  YSActivityController.m
//  jingGang
//
//  Created by dengxf on 16/12/15.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//
#import "PayOrderViewController.h"

#import "YSActivityController.h"
#import "GlobeObject.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "KJGoodsDetailViewController.h"
#import "YSShareManager.h"
#import "loginViewController.h"
#import "JGActivityHelper.h"
#import "YSLoginManager.h"
#import "YSLoginPopManager.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "YSJPushHelper.h"
#import "YSJuanPiWebViewController.h"
#import "YSActivitiesInfoData.h"
#import "YSNearAdContentModel.h"
#import "YSLiquorDomainWebController.h"
#import "YSLocationManager.h"
#import "YSLinkElongHotelWebController.h"
#import "ServiceDetailController.h"
#import "WSJMerchantDetailViewController.h"
#import "YSSurroundAreaCityInfo.h"
#import "YSHealthAIOController.h"
#import "YSHealthyMessageDatas.h"
#import "YSLinkCYDoctorWebController.h"
#import "YSNearClassListDataManager.h"
#import "YSNearClassListModel.h"
#import "MerchantListViewController.h"
#import "JGDESUtils.h"

#define kDefaultTitle @"全场活动"

@interface YSActivityController ()<UIWebViewDelegate,NJKWebViewProgressDelegate,YSAPIManagerParamSource,YSAPICallbackProtocol,UIGestureRecognizerDelegate,NSURLSessionDelegate>

typedef NS_ENUM(NSUInteger, YSNearClassListRequestType) {
    YSNearClassListMainRequestType = 0,
    YSNearClassListAssitanceRequestType
};

@property (strong,nonatomic) UIWebView *webView;
@property (strong,nonatomic) YSShareManager *shareManager;
@property (strong,nonatomic) NJKWebViewProgressView *progressView;
@property (strong,nonatomic) NJKWebViewProgress *progressProxy;
@property (strong,nonatomic) YSNearClassListDataManager *classListDataManager;
@property (assign, nonatomic) YSNearClassListRequestType nearClassListRequestType;
@property (strong,nonatomic) YSGroupClassItem *tempClassItem;
@property (strong,nonatomic) NSArray *mainGroupClassList;
@property (strong,nonatomic) NSString  * tilte1;
@property (strong,nonatomic) NSString  * desc1;
@property (strong,nonatomic) NSString  * imgUrl1;
@property (strong,nonatomic) NSString  * link1;

@property (strong,nonatomic) NSString  * imgUrl;
@end

@implementation YSActivityController

- (YSNearClassListDataManager *)classListDataManager {
    if (!_classListDataManager) {
        _classListDataManager = [[YSNearClassListDataManager alloc] init];
        _classListDataManager.delegate = self;
        _classListDataManager.paramSource = self;
    }
    return _classListDataManager;
}

- (NSArray *)combinateMainGroupClassListWithDatas:(NSArray *)datas {
    NSMutableArray *tempArrays = [NSMutableArray arrayWithArray:datas];
    YSGroupClassItem *allItem = [[YSGroupClassItem alloc] init];
    allItem.gcName = @"全部";
    [tempArrays insertObject:allItem atIndex:0];
    return [tempArrays copy];
}

- (void)managerCallBackDidSuccess:(YSAPIBaseManager *)manager {
    [self hiddenHud];
    YSResponseDataReformer *reformer = [[YSResponseDataReformer alloc] init];
    YSNearClassListModel *classListModel = [reformer reformDataWithAPIManager:manager];
    if (classListModel.groupClassList.count) {
        switch (self.nearClassListRequestType) {
            case YSNearClassListMainRequestType:
            {
                for (YSGroupClassItem *classItem in classListModel.groupClassList) {
                    if (classItem.gcType == 0) {
                        self.tempClassItem = classItem;
                        break;
                    }
                }
                if (self.tempClassItem) {
                    // shopCategoryVC.selectedItem = tempClassItem
                    // shopCategoryVC.o2oDatas = classListModel.groupClassList
                    self.mainGroupClassList = [self combinateMainGroupClassListWithDatas:classListModel.groupClassList];
                    self.nearClassListRequestType = YSNearClassListAssitanceRequestType;
                    [self showHud];
                    [self.classListDataManager requestData];
                }
            }
                break;
            case YSNearClassListAssitanceRequestType:
            {
                NSMutableArray *assitantsArray = [NSMutableArray arrayWithArray:classListModel.groupClassList];
                MerchantListViewController *merchantVC = [[MerchantListViewController alloc] initWithNibName:@"MerchantListViewController" bundle:nil];
                merchantVC.classId = @0;
                merchantVC.parentClassId = self.mainGroupClassList;
                merchantVC.subClassId = [assitantsArray copy];
                [self.navigationController pushViewController:merchantVC animated:YES];
            }
                break;
            default:
                break;
        }
    }
}

- (void)managerCallBackDidFailed:(YSAPIBaseManager *)manager {
    [self hiddenHud];
}

- (NSDictionary *)paramsForApi:(YSAPIBaseManager *)manager {
    switch (self.nearClassListRequestType) {
        case YSNearClassListMainRequestType:
        {
            return @{
                     @"classNum":@1,
                     };
        }
            break;
        case YSNearClassListAssitanceRequestType:
        {
            return @{
                     @"classNum":@2,
                     @"classId":[NSNumber numberWithInteger:self.tempClassItem.groupId]
                     
                     };
        }
            break;

    }
    return @{};
}

- (void)setActivityInfoItem:(YSActivitiesInfoItem *)activityInfoItem {
    _activityInfoItem = activityInfoItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
    self.navigationController.navigationBarHidden = NO;
    NSString *navTitle;

    if (!self.activityInfoItem) {
        self.navigationController.navigationBar.barTintColor = [YSThemeManager themeColor];
        if (![self.activityTitle isEmpty]) {
            navTitle = self.activityTitle;
        }else {
            navTitle = kDefaultTitle;
        }
    }else {
        NSString *colorHexString = self.activityInfoItem.backGroundColor;
        UIColor *barTintColor;
        if (![colorHexString isEmpty]) {
            barTintColor = [UIColor colorWithHexString:colorHexString];
        }else {
            barTintColor = [YSThemeManager themeColor];
        }
        self.navigationController.navigationBar.barTintColor = barTintColor;
        
        if (!self.activityTitle) {
            NSString *activityName = self.activityInfoItem.hotName;
            if ([activityName isEmpty]) {
                navTitle = kDefaultTitle;
            }else{
                navTitle = activityName;
            }
        }else {
            navTitle = self.activityTitle;
        }
    }
    [YSThemeManager setNavigationTitle:navTitle andViewController:self];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
    self.navigationController.navigationBar.barTintColor = COMMONTOPICCOLOR;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = JGWhiteColor;
    self.navigationController.navigationBar.translucent = NO;
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    if (!CRIsNullOrEmpty(GetToken)) {
        NSString *encryptToken = [JGDESUtils encryptUseDES:GetToken key:kDESEncryptKey];
        NSString *tokenQuery = CRString(@"token=%@", encryptToken);
        self.activityUrl = [self.activityUrl URLStringByAppendingQueryString:tokenQuery];
    }

    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBarHeight)];
    NSString *loadUrl;
    
    if (self.activityUrl) {
        
        if([self.activityUrl isEqualToString:@"http://mobile.bhesky.cn/yjkindex.htm"]){
            
            UIButton *leftbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
            [leftbutton setBackgroundImage:[UIImage imageNamed:@"JuanPi_ShareGoods_Icon"] forState:UIControlStateNormal];
            UIBarButtonItem *rightitem=[[UIBarButtonItem alloc]initWithCustomView:leftbutton];
            self.navigationItem.rightBarButtonItem=rightitem;
            [leftbutton addTarget:self action:@selector(fenxiang) forControlEvents:UIControlEventTouchUpInside];
       
            NSString *const kDESEncryptKey = @"JgYeScOM_abc_12345678_kEHrDooxWHCWtfeSxvDvgqZq";
            
            NSString * to = [JGDESUtils encryptUseDES:GetToken key:kDESEncryptKey];
            loadUrl = [NSString stringWithFormat:@"%@?token=%@",self.activityUrl,to];
            NSLog(@"%@",loadUrl);
         
            
           
            [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",loadUrl]]]];
            [self.view addSubview:web];
            
            self.webView = web;
            
            
            UILongPressGestureRecognizer* longPressed = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
            longPressed.delegate = self;
            [self.webView addGestureRecognizer:longPressed];
            
        }else{
            
            loadUrl = self.activityUrl;
            [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",loadUrl]]]];
            [self.view addSubview:web];
            
            self.webView = web;
        }
   

//        loadUrl = @"http://api.bhesky.com/circle/look_invitation?invitationId=8019";
    }else {
        if (!self.activityInfoItem) {
             NSLog(@"___________%@",self.activityInfoItem);
            loadUrl = [NSString stringWithFormat:@"%@%@",MobileWeb_Url,@"/carnation-web-mobile/zeroList.htm?ysysgo_app=true"];
            
            [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",loadUrl]]]];
            [self.view addSubview:web];
            
            self.webView = web;
        }else {
            NSString *adsURL = [NSString stringWithFormat:@"%@",self.activityInfoItem.adsURL];
            if ([adsURL isEmpty]) {
                loadUrl = [NSString stringWithFormat:@"%@%@",MobileWeb_Url,@"/carnation-web-mobile/zeroList.htm?ysysgo_app=true"];
                [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",loadUrl]]]];
                [self.view addSubview:web];
                
                self.webView = web;
            }else {
                loadUrl = adsURL;
                [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",loadUrl]]]];
                [self.view addSubview:web];
                
                self.webView = web;
            }
        }
    }
    

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BLOCK_EXEC(self.pushCompleted);
    });
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    self.webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    
}

- (void)btnClick
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        return;
    }
    switch (self.comeType) {
        case YSComeControllerPushType:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case YSComeControllerPresentType:
        {
//            BLOCK_EXEC(self.backCallback);
            [[NSNotificationCenter defaultCenter] postNotificationName:kDismissActivityMenuKey object:nil];
        }
            break;
        default:
            break;
    }
}

// 字符串转json
- (id)jsonStringToParamas:(NSString *)string {
    NSError *error;
    NSString *requestTmp = [NSString stringWithString:string];
    NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
    id  params = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableContainers error:&error];  //解析
    if (!error) {
        return params;
    }else {
        return nil;
    }
    
}

#pragma mark  contextJS交互---
-(void)makeJsEnvirement{
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    @weakify(self);
//    context[@"requestZeroDetails"] = ^() {
//        @strongify(self);
//        NSArray *args = [JSContext currentArguments];
//        long shopId = [[args[0] toNumber] longValue];
//        return ;
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            KJGoodsDetailViewController *goodsDetailVC = [[KJGoodsDetailViewController alloc] init];
//            goodsDetailVC.goodsID = [NSNumber numberWithLong:shopId];
//            goodsDetailVC.hidesBottomBarWhenPushed = YES;
//            
//            if (self.comeType == YSComeControllerPresentType) {
//                goodsDetailVC.isComeFormPresent = YES;
//            }
//            [self.navigationController pushViewController:goodsDetailVC animated:YES];
//
//        });
//    };
    // 请求领券事件响应
    context[@"requestClientResult"] = ^(){
        @strongify(self);
        NSArray *args = [JSContext currentArguments];
        NSString *urlString = [[args xf_safeObjectAtIndex:0] toString];
        NSString *method = [[args xf_safeObjectAtIndex:1] toString];
        NSString *http_m_type = [[args xf_safeObjectAtIndex:2] toString];
        NSString *paramsJsonString = [[args xf_safeObjectAtIndex:3] toString];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURLSessionDataTask *dataTask = nil;
            NSString *url = [NSString stringWithFormat:@"%@",urlString];
            BOOL checkLoginState = CheckLoginState(NO);
            AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
            // 添加text/html支持
            mgr.responseSerializer = [AFJSONResponseSerializer serializer];
            mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
            if (checkLoginState) {
                JGLog(@"用户登录");
                NSString *strToken = [NSString stringWithFormat:@"bearer %@",[YSLoginManager queryAccessToken]];
                [mgr.requestSerializer setValue: strToken forHTTPHeaderField:@"Authorization"];
                [mgr.requestSerializer setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            }else {
                JGLog(@"用户未登录");
            }
            if ([[http_m_type uppercaseString] isEqualToString:@"GET"]) {
                dataTask = [mgr GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    NSDictionary *responseDict = [NSDictionary dictionaryWithDictionary:(NSDictionary *)responseObject];
                    JSContext *robContext =  [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];;
                    NSString *jsString = nil;
                    jsString =  [NSString stringWithFormat:@"%@(%@)",method,[self dictionaryToJson:responseDict]];
                    [robContext evaluateScript:jsString];
                    JGLog(@"responseObject:%@",responseObject);
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    JGLog(@"error:%@",error);
                    JSContext *robContext =  [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];;
                    NSString *jsString = nil;
                    jsString =  [NSString stringWithFormat:@"%@(%@)",method,@"0"];
                    [robContext evaluateScript:jsString];
                }];
                
            }else if([[http_m_type uppercaseString] isEqualToString:@"POST"]){
                dataTask = [mgr POST:url parameters:[self jsonStringToParamas:paramsJsonString] success:^(NSURLSessionDataTask *task, id responseObject) {
                    NSDictionary *responseDict = [NSDictionary dictionaryWithDictionary:(NSDictionary *)responseObject];
                    JSContext *robContext =  [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];;
                    NSString *jsString = nil;
                    jsString =  [NSString stringWithFormat:@"%@(%@)",method,[self dictionaryToJson:responseDict]];
                    [robContext evaluateScript:jsString];
                    JGLog(@"responseObject:%@",responseObject);
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    JGLog(@"error:%@",error);
                    JSContext *robContext =  [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];;
                    NSString *jsString = nil;
                    jsString =  [NSString stringWithFormat:@"%@(%@)",method,@"0"];
                    [robContext evaluateScript:jsString];
                }];
            }
        });
    };
    
    context[@"requestLogin"] = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            CheckLoginState(YES);
        });
    };
    
    context[@"requestProDetails"] = ^(){
        @strongify(self);
        NSArray *args = [JSContext currentArguments];
        JGLog(@"---args:%@",args);
        long shopId = [[args[0] toNumber] longValue];
        NSString *skipType = [NSString stringWithFormat:@"%@",[args[1] toString]];
        JGLog(@"skipType:%@",skipType);
        // skipType 一个类型为以后扩展  0，1 （0为0元购  1为年货、3卷皮商品）
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([skipType isEqualToString:@"3"]) {
                if (CheckLoginState(YES)) {
                    NSString *targetUrlM = [NSString stringWithFormat:@"%@",[args[2] toString]];
                    [self toJuanPiWebViewControllerWithGoodID:[NSNumber numberWithLong:shopId] Url:targetUrlM];
                }
            }else{
                // 根据商品id跳转到商品详情
                [self toShopDetailControllerWithShopId:[NSNumber numberWithLong:shopId]];
            }
        });
    };
    
    context[@"requestCommonShare"] = ^(){
        @strongify(self);
        if (self.comeType == YSComeControllerPresentType  && IsEmpty(GetToken)) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"此功能需要登录，请先登录" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *canelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                YSLoginPopManager *loginPopManager = [[YSLoginPopManager alloc] init];
                [loginPopManager showLogin:^{
                    [YSLoginManager loginout];
                } cancelCallback:^{
                    
                }];
            }];
            [alertController addAction:canelAction];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            return ;
        }
        
        NSArray *args = [JSContext currentArguments];
        JGLog(@"args:%@",args);
        id obj = [args[0] toObject];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *argDic = [NSDictionary dictionaryWithDictionary:(NSDictionary *)obj];
            NSString *imgUrl = argDic[@"imgUrl"];
            NSString *title = argDic[@"title"];
            NSString *strShareContent = argDic[@"desc"];
            NSString *shareUrl = argDic[@"link"];
            NSDictionary *userDict = [YSLoginManager userCustomer];
            NSString *invitationCode = [NSString stringWithFormat:@"%@",userDict[@"invitationCode"]];
            
            if ([shareUrl containsString:@"?"]) {
                shareUrl = [shareUrl stringByAppendingString:[NSString stringWithFormat:@"&invitationCode=%@",invitationCode]];
            }else {
                shareUrl = [shareUrl stringByAppendingString:[NSString stringWithFormat:@"?invitationCode=%@",invitationCode]];
            }
            
            YSShareConfig *config = [YSShareConfig configShareWithTitle:title content:strShareContent  UrlImage:imgUrl shareUrl:shareUrl];
            if (!self.shareManager) {
                YSShareManager *shareManager = [[YSShareManager alloc] init];
                [shareManager shareWithObj:config showController:self];
                self.shareManager = shareManager;
            }else {
                [self.shareManager shareWithObj:config showController:self];
            }
        }
    };
    
    context[@"requestAppView"] = ^(NSString *skipType,NSString *code){
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            if ([skipType integerValue] == 7 && [code isEqualToString:@"MERCHANTS"]) {
                // 跳转商户列表
                [self showHud];
                self.nearClassListRequestType = YSNearClassListMainRequestType;
                [self.classListDataManager requestData];
            }else {
                YSNearAdContent *adItem = [[YSNearAdContent alloc]init];
                adItem.link = code;
                adItem.type = [skipType integerValue];
                [self clickAdvertItem:adItem];
            }
        });
    };
    //这里是js发出需要传用户uid的指令
    context[@"requestUid"] = ^() {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            // 回到主线程,执⾏UI刷新操作
            //本地判断用户是否登录
            //            if (self.isFirstPo) {
            //                //第一次只检查登陆并传UID，不弹框
            //                if (CheckLoginState(NO)) {
            //                    [self userLoginForJS];
            //                }
            //                self.isFirstPo = NO;
            //            }else{
            if (CheckLoginState(YES)) {
                [self userLoginForJS];
            }
            //            }
        });
    };
    
    context[@"requestOrder"] = ^(NSString *orderID,NSString * orderNumber,NSString* totalPrice)
    {
        
        PayOrderViewController *payOrderVC = [[PayOrderViewController alloc] init];
        payOrderVC.orderID = (NSNumber *)orderID;
        payOrderVC.orderNumber = orderNumber;
        payOrderVC.jingGangPay = ShoppingPay;
        payOrderVC.totalPrice = [totalPrice floatValue];
             dispatch_async(dispatch_get_main_queue(), ^{
                 // 回到主线程,执⾏UI刷新操作
                 [self.navigationController pushViewController:payOrderVC animated:YES];
        });
    };
    
    
    
    
//    context[@"getShareContent"] = ^()
//
//    {
//
//        NSArray *args = [JSContext currentArguments];
//        JGLog(@"args:%@",args);
//        for (id obj in args) {
//            NSLog(@"%@",obj);
//        }
////        id obj = [args[0] toObject];
////        if ([obj isKindOfClass:[NSDictionary class]]) {
////            NSDictionary *argDic = [NSDictionary dictionaryWithDictionary:(NSDictionary *)obj];
////            NSString *imgUrl = argDic[@"imgUrl"];
////            NSString *title = argDic[@"title"];
////            NSString *strShareContent = argDic[@"desc"];
////            NSString *shareUrl = argDic[@"link"];
////
////            NSLog(@"%@,%@",imgUrl,title);
////        }
//        //取出存在本地的uid
////        NSDictionary *dictUserInfo = [kUserDefaults objectForKey:kUserCustomerKey];
////
////        NSLog(@"%@",dictUserInfo);
//
//        YSShareManager *shareManager = [[YSShareManager alloc] init];
////        YSShareConfig *config = [YSShareConfig configShareWithTitle:title content:desc UrlImage:imgUrl shareUrl:[NSString stringWithFormat:@"%@",link]];
////        [shareManager shareWithObj:config showController:self];
//        self.shareManager = shareManager;
////        dispatch_async(dispatch_get_main_queue(), ^{
////            // 回到主线程,执⾏UI刷新操作
////            [self.navigationController pushViewController:payOrderVC animated:YES];
////        });
//    };
//
    
    
}

-(void)fenxiang{
    
    NSLog(@"分享什么啊");
    
    NSString *str =   [_webView stringByEvaluatingJavaScriptFromString:@"getShareContentIOS()"];
    
    NSLog(@"getShareContent():%@",str);
    
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:nil];
    NSDictionary *dictUserInfo = [kUserDefaults objectForKey:kUserCustomerKey];
    NSLog(@"dictUserInfo:%@",dictUserInfo);
     NSLog(@"%@",dic[@"title"]);

    
    if(!str.length){
        _tilte1 = @"新社交  让我们走得更近";
        _desc1 = @"关注健康 更关心你 e键链接 互动改变生活";
        _imgUrl1  = [NSString stringWithFormat: @"http://mobile.bhesky.cn/resources/yjk/img/yjk.jpg?d=%u",100 +  (arc4random() % 1001)];
        _link1 =[NSString stringWithFormat:@"http://mobile.bhesky.cn/yjkindex.htm?shareUserId=%@",dictUserInfo[@"uid"]];;
        
    }else{
        
        _tilte1 = dic[@"title"];
        _desc1 = dic[@"desc"];
        _imgUrl1 = dic[@"imgUrl"];
        _link1 =dic[@"link"];
        
    }
    
    YSShareConfig *config = [YSShareConfig configShareWithTitle:_tilte1 content:_desc1  UrlImage:_imgUrl1 shareUrl:_link1];
    
    if (!_shareManager) {
        YSShareManager *shareManager = [[YSShareManager alloc] init];
        [shareManager shareWithObj:config showController:self];
        _shareManager = shareManager;
    }else {
        [_shareManager shareWithObj:config showController:self];
    }

}

- (void)userLoginForJS{
    //创建JSContext对象，（此处通过当前webView的键获取到jscontext）
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //取出存在本地的uid
    NSDictionary *dictUserInfo = [kUserDefaults objectForKey:kUserCustomerKey];
    NSString *strUid = dictUserInfo[@"uid"];
    NSString *jsRequstString = [NSString stringWithFormat:@"getUserId(\"%@\")",strUid];
    [context evaluateScript:jsRequstString];
}
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (void)toJuanPiWebViewControllerWithGoodID:(NSNumber *)goodsID Url:(NSString *)url{
    YSJuanPiWebViewController *juanPiWebVC = [[YSJuanPiWebViewController alloc]initWithUrlType:YSGoodsDetileType];
    juanPiWebVC.goodsID = goodsID;
    juanPiWebVC.strWebUrl = url;
    juanPiWebVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:juanPiWebVC animated:YES];
}
- (void)toShopDetailControllerWithShopId:(NSNumber *)shopId {
    KJGoodsDetailViewController *goodsDetailVC = [[KJGoodsDetailViewController alloc] init];
    goodsDetailVC.goodsID = shopId;
    goodsDetailVC.hidesBottomBarWhenPushed = YES;
    if (self.comeType == YSComeControllerPresentType) {
        goodsDetailVC.isComeFormActivityController = YES;
    }
    [self.navigationController pushViewController:goodsDetailVC animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self makeJsEnvirement];
   
 
    
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}
#pragma mark --- 弹框H5广告模板点击事件处理
- (void)clickAdvertItem:(YSNearAdContent *)adItem{
    if ([adItem.needLogin integerValue]) {
        // 需要登录
        BOOL ret = CheckLoginState(YES);
        if (!ret) {
            // 没登录 直接返回
            return;
        }
    }
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@%@",@"um_",@"HM_",@"adItemIndex_H5"]];
    switch (adItem.type) {
        case 1:
        {
            if ([adItem.link containsString:@"ys.zjtech.cc"]) {
                //是酒业
                YSLiquorDomainWebController *liquorDomainWebVC = [[YSLiquorDomainWebController alloc]initWithUrlType:YSLiquorDomainZoneType];
                liquorDomainWebVC.strUrl = adItem.link;
                [self.navigationController pushViewController:liquorDomainWebVC animated:YES];
            }else if ([adItem.link containsString:@"union.juanpi.com"]){
                //卷皮商品
                YSJuanPiWebViewController *juanPiVC = [[YSJuanPiWebViewController alloc]initWithUrlType:YSGoodsDetileType];
                juanPiVC.goodsID  = [juanPiVC getJuanPiGoodsIdWithJuanPiGoodsUrl:adItem.link];
                juanPiVC.strWebUrl = adItem.link;
                [self.navigationController pushViewController:juanPiVC animated:YES];
            }else{
                //其他链接
                NSString *appendUrlString;
                if([adItem.link rangeOfString:@"?"].location !=NSNotFound)//_roaldSearchText
                {
                    appendUrlString = [NSString stringWithFormat:@"%@&cityName=%@",adItem.link,[YSLocationManager currentCityName]];
                }else{
                    appendUrlString = [NSString stringWithFormat:@"%@?cityName=%@",adItem.link,[YSLocationManager currentCityName]];
                }
                appendUrlString = [appendUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                // 链接
                YSLinkElongHotelWebController *elongHotelWebController = [[YSLinkElongHotelWebController alloc] initWithWebUrl:appendUrlString];
                elongHotelWebController.hidesBottomBarWhenPushed = YES;
                elongHotelWebController.navTitle = adItem.name;
                [self.navigationController pushViewController:elongHotelWebController animated:YES];
            }
        }
            break;
        case 2:
        {
            // 商品详情
            KJGoodsDetailViewController *goodsDetailVC = [[KJGoodsDetailViewController alloc] init];
            goodsDetailVC.goodsID = [NSNumber numberWithInteger:[adItem.link integerValue]];
            goodsDetailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:goodsDetailVC animated:YES];
        }
            break;
        case 5:
        {
            // 商户详情
            WSJMerchantDetailViewController *goodStoreVC = [[WSJMerchantDetailViewController alloc] init];
            goodStoreVC.api_classId = [NSNumber numberWithInteger:[adItem.link integerValue]];
            goodStoreVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:goodStoreVC animated:YES];
        }
            break;
        case 6:
        {
            //服务详情
            ServiceDetailController *serviceDetailVC = [[ServiceDetailController alloc] init];
            serviceDetailVC.serviceID = [NSNumber numberWithInteger:[adItem.link integerValue]];
            serviceDetailVC.hidesBottomBarWhenPushed = YES;
            if ([YSSurroundAreaCityInfo isElseCity]) {
                serviceDetailVC.api_areaId = [YSSurroundAreaCityInfo achieveElseSelectedAreaInfo].areaId;
            }else {
                YSLocationManager *locationManager = [YSLocationManager sharedInstance];
                serviceDetailVC.api_areaId = locationManager.cityID;
            }
            [self.navigationController pushViewController:serviceDetailVC animated:YES];
        }
            break;
        case 7:
        {
            // 原生类别区分 link
            if ([adItem.link isEqualToString:YSAdvertOriginalTypeAIO]) {
                // 跳转精准健康检测
                YSHealthAIOController *healthAIOController = [[YSHealthAIOController alloc] init];
                healthAIOController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:healthAIOController animated:YES];
            }else if ([adItem.link isEqualToString:YSAdvertOriginalTypeCYDoctor]) {
                // 春雨医生
                [self showHud];
                @weakify(self);
                @weakify(adItem);
                [YSHealthyMessageDatas  chunYuDoctorUrlRequestWithResult:^(BOOL ret, NSString *msg) {
                    @strongify(self);
                    @strongify(adItem);
                    [self hiddenHud];
                    if (ret) {
                        YSLinkCYDoctorWebController *cyDoctorController = [[YSLinkCYDoctorWebController alloc] initWithWebUrl:msg];
                        cyDoctorController.navTitle = adItem.name;
                        cyDoctorController.tag = 100;
                        cyDoctorController.controllerPushType = YSControllerPushFromHealthyManagerType;
                        [self.navigationController pushViewController:cyDoctorController animated:YES];
                    }else {
                        [UIAlertView xf_showWithTitle:msg message:nil delay:2.0 onDismiss:NULL];
                    }
                }];
            }
        }
            break;
        default:
            break;
    }
    
}


-(void)dealloc {
    [UIWebView cleanCacheAndCookie];
}
- (void)longPressed:(UILongPressGestureRecognizer*)recognizer
{
    if (recognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    CGPoint touchPoint = [recognizer locationInView:self.webView];
    
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
    NSString *urlToSave = [self.webView stringByEvaluatingJavaScriptFromString:imgURL];
    
    if (urlToSave.length == 0) {
        return;
    }
    
    [self showImageOptionsWithUrl:urlToSave];
}
- (void)showImageOptionsWithUrl:(NSString *)imageUrl
{
    _imgUrl = imageUrl;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否保存图片到本地!" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
    
    [alert show];
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 0) {
        [self saveImageToDiskWithUrl:_imgUrl];
    }
}

- (void)saveImageToDiskWithUrl:(NSString *)imageUrl
{
    NSURL *url = [NSURL URLWithString:imageUrl];
    
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue new]];
    
    NSURLRequest *imgRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];
    
    NSURLSessionDownloadTask  *task = [session downloadTaskWithRequest:imgRequest completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            return ;
        }
        
        NSData * imageData = [NSData dataWithContentsOfURL:location];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage * image = [UIImage imageWithData:imageData];
            
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        });
    }];
    
    [task resume];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (error) {
      
        hud.labelText = @"保存失败";
           [hud hide:YES afterDelay:1.0f];
    }else{
        hud.labelText = @"保存成功";
           [hud hide:YES afterDelay:1.0f];
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
