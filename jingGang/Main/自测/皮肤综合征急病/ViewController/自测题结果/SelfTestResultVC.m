//
//  SelfTestResultVC.m
//  jingGang
//
//  Created by 张康健 on 15/6/17.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "SelfTestResultVC.h"
#import "UIButton+Block.h"
#import "Util.h"
#import "VApiManager.h"
#import "GlobeObject.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Show.h"
#import "shareView.h"
#import "UIViewExt.h"
#import "PublicInfo.h"
#import "UIView+BlockGesture.h"
#import "ZongHeZhengVC.h"
#import "consultationViewController.h"
//#define MAS_SHORTHAND   //定义了这个，那么就不需要前缀was
#import "Masonry.h"
#import "JGShareView.h"
#import "CareChoosenCollectionView.h"
#import "GoodStoreRecommendTableView.h"
#import "PStoreInfoModel.h"
#import "GoodsDetailModel.h"
#import "YSShareManager.h"
#import "YSLoginManager.h"
#import "NSString+YYAdd.h"
@interface SelfTestResultVC (){

    VApiManager *_vapManager;
    
    
    UIView      *_maskView;
    
    NSInteger   _shareViewbottonGap;
    
    NSNumber    *_requestGoodsId;
    
    NSInteger    _invitationCode;

}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodStoreHeaderHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *careChoosenHeaderHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *careChoosenHeaderView;
@property (weak, nonatomic) IBOutlet UIView *goodStoreRecmmendHeaderView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *careChoosenViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodStoreViewHeightContraint;

@property (weak, nonatomic) IBOutlet GoodStoreRecommendTableView *goodStoreRecommendCollectionView;
@property (weak, nonatomic) IBOutlet CareChoosenCollectionView *careChoosenGoodsCollectionView;

@property (weak, nonatomic) IBOutlet UIButton *againTestButton;

@property (weak, nonatomic) IBOutlet UIButton *iKnowButton;
@property (weak, nonatomic) IBOutlet UIScrollView *ceshiview;

@property (nonatomic, strong)JGShareView *shareview;

//@property (retain, nonatomic) IBOutlet UITextView *testResultTextView;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *shareTobottnConstont;
//@property (retain, nonatomic) IBOutlet shareView *shareView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webHeightConstant;

@property (retain, nonatomic) shareView *shareView;
@property (strong, nonatomic) UIView *maskView;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *wangluozixunLeftConstraint;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *iknowRightConstraint;
@property (retain, nonatomic) IBOutlet UIWebView *testResultWebView;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (copy , nonatomic) NSString *userInvitationCode;

@property (nonatomic,strong)YSShareManager *shareManager;


@end

@implementation SelfTestResultVC

-(void)viewDidAppear:(BOOL)animated{
    _ceshiview.height = 1000;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _init];
    
    [self _loadNavLeft];
    
//    [self _loadRight];
    
    [self _loadTitleView];
    
    [self _initShareInfo];
    
    //自测结果请求
    [self _requesetTestResult];
    
    WeakSelf;
    [self _userInfoQueryWithUid:^(NSString *code) {
        bself.userInvitationCode = code;
    }];
    
    //请求精选商品和好店推荐
//    [self _requestCareChoosenGoods];
//    self.againTestButton.backgroundColor = [YSThemeManager buttonBgColor];
//    self.iKnowButton.backgroundColor = [YSThemeManager buttonBgColor];
}

#pragma mark - 请求精选商品和推荐店铺
- (void)_requestCareChoosenGoods {
    
    SnsRecommenGoodsAndStoreListRequest *request = [[SnsRecommenGoodsAndStoreListRequest alloc] init:nil];
    request.api_groupId = _requestGoodsId;
    [_vapManager snsRecommenGoodsAndStoreList:request success:^(AFHTTPRequestOperation *operation, SnsRecommenGoodsAndStoreListResponse *response) {
        
        NSLog(@"推荐response %@",response);
        [self _dealCareChoosenData:response.recommedGoodsList];
        [self _dealGoodStoreData:response.recommedStoreList];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        
    }];
}

#pragma mark - 处理精选商品数据
-(void)_dealCareChoosenData:(NSArray *)data {
    
    if (!data.count) {
        self.careChoosenHeaderView.hidden = YES;
        self.careChoosenHeaderHeightConstraint.constant = 1;
    }
    self.careChoosenViewHeightConstraint.constant = kCollectionHeight(data.count, kCareChoosenGoodsCellHeight);
    NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:data.count];
    for (NSDictionary *dic in data) {
        GoodsDetailModel *model = [[GoodsDetailModel alloc] initWithJSONDic:dic];
        model.goodsMainPhotoPath = dic[@"mainPhotoUrl"];
        model.goodsName = dic[@"title"];
        CGFloat mobilePrice =[dic[@"mobilePrice"] floatValue];
        //有手机专享价，并且手机专享价不为0
        if (mobilePrice > 0) {//有手机专享价
            model.actualPrice = mobilePrice;
        }else{
            model.actualPrice = [dic[@"storePrice"] floatValue];
        }
        [dataArr addObject:model];
    }
    self.careChoosenGoodsCollectionView.dataArr = (NSArray *)dataArr;
    [self.careChoosenGoodsCollectionView reloadData];
    
}


#pragma mark - 处理好店推荐数据
-(void)_dealGoodStoreData:(NSArray *)data {
    if (!data.count) {
        self.goodStoreRecmmendHeaderView.hidden = YES;
        self.goodStoreHeaderHeightConstraint.constant = 1;
    }
    self.goodStoreViewHeightContraint.constant = data.count * GoodStoreCellHeight;
    
    NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:data.count];
    for (NSDictionary *dic in data) {
        PStoreInfoModel *model = [[PStoreInfoModel alloc] initWithJSONDic:dic];
        model.photoPath = dic[@"storeInfoPath"];
        [dataArr addObject:model];
    }
    self.goodStoreRecommendCollectionView.dataArr = (NSArray *)dataArr;
    [self.goodStoreRecommendCollectionView reloadData];
    
}


-(void)_init{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _vapManager = [[VApiManager alloc] init];
    
//    NSString *resultText = [NSString stringWithFormat:@"恭喜你，你今天的得分是%ld分",self.test_Mark];
//    self.testResultTextView.text = resultText;
    self.shareTobottnConstont.constant = -200;
    
    CGFloat zixunIknowLeftConstraint = 0;
    [Util setValueIndiffScreensWithVarary:&zixunIknowLeftConstraint in4s:iPhone4_width*0.08 in5s:iPhone5_width*0.08 in6s:iPhone6_width*0.08 plus:iPhone6_width*0.08];
    self.wangluozixunLeftConstraint.constant = zixunIknowLeftConstraint;
    
//    _invitationCode = [[[kUserDefaults objectForKey:userInfoKey] objectForKey:@"invitationCode"] integerValue];
    
   
    
    CGFloat iknowRightConstraint = 0;
    [Util setValueIndiffScreensWithVarary:&iknowRightConstraint in4s:iPhone4_width*0.08 in5s:iPhone5_width*0.08 in6s:iPhone6_width*0.08 plus:iPhone6_width*0.08];
    self.iknowRightConstraint.constant = iknowRightConstraint;
    self.careChoosenGoodsCollectionView.collectionViewLayout = [self.careChoosenGoodsCollectionView getDefaultLayout];
}


#pragma mark - 初始化分享所需的信息
-(void)_initShareInfo{
    
    self.testUrl = [NSString stringWithFormat:@"%@%@?groupId=%ld",Base_URL,@"/check/question",self.test_GroupID];

}

#pragma mark - 过滤html标签
- (NSString *)removeHTML2:(NSString *)html{
    
    NSArray *components = [html componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
    NSMutableArray *componentsToKeep = [NSMutableArray array];
    
    for (int i = 0; i < [components count]; i = i + 2) {
        
        [componentsToKeep addObject:[components objectAtIndex:i]];
        
    }
    
    NSString *plainText = [componentsToKeep componentsJoinedByString:@""];
    
    return plainText; 
    
}





-(void)_loadNavLeft{
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];

    
}

- (void)btnClick{
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers xf_safeObjectAtIndex:1]
                                               animated:YES];
}

- (IBAction)fenxiang:(id)sender {
//
//    UIButton *navLeftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
//    [navLeftButton setBackgroundImage:[UIImage imageNamed:@"life_share"] forState:UIControlStateNormal];
//
//
//    @weakify(self);
//    [navLeftButton addActionHandler:^(NSInteger tag) {
//        @strongify(self);

        //分享内容
        NSString *shareContent = [self filterHTML:self.strShareContent];
        

        if (shareContent.length > 40) {
            shareContent = [shareContent substringWithRange:NSMakeRange(0,40)];
        }
        
        //分享标题
        NSString *strInviteTitle = self.strShareTitle;
        //把标题称转换成Base64编码拼在链接后面
        NSString *strTitleHtml = [strInviteTitle base64EncodedString];
        //取出存在本地的uid
        NSDictionary *dictUserInfo = [kUserDefaults objectForKey:kUserCustomerKey];
        //拼接邀请注册链接
        NSString *shareUrl = kShareSelfTestSubjectUrl(dictUserInfo[@"invitationCode"],strTitleHtml);
        //图片url
        NSString *imageUrlStr = self.strShareImgUrl;

        
        YSShareManager *shareManager = [[YSShareManager alloc] init];
        YSShareConfig *config = [YSShareConfig configShareWithTitle:strInviteTitle content:shareContent UrlImage:imageUrlStr shareUrl:shareUrl];
        [shareManager shareWithObj:config showController:self];
        self.shareManager = shareManager;
//    }];
    
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:navLeftButton];
//    self.navigationItem.rightBarButtonItem = item;
//
//    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
//                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//                                       target:nil action:nil];
//    negativeSpacer.width = -18;
//    self.navigationItem.rightBarButtonItems = @[negativeSpacer,item];
}



-(void)_userInfoQueryWithUid:(void(^)(NSString *))uidBlock{
    dispatch_async(dispatch_get_main_queue(), ^{
        UsersCustomerSearchRequest *request = [[UsersCustomerSearchRequest alloc] init:GetToken];
        [[[VApiManager alloc] init] usersCustomerSearch:request success:^(AFHTTPRequestOperation *operation, UsersCustomerSearchResponse *response) {
            
            NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:nil];
            NSDictionary   *dictUserList = [dict objectForKey:@"customer"];
            [[NSUserDefaults standardUserDefaults]setObject:dictUserList forKey:kUserCustomerKey];
            [[NSUserDefaults standardUserDefaults] synchronize];

            NSDictionary *cus = [NSDictionary dictionaryWithDictionary:(NSDictionary *)response.customer];
            NSString *uid = TNSString(cus[@"uid"]) ;
            BLOCK_EXEC(uidBlock,uid);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            BLOCK_EXEC(uidBlock,nil);
        }];
    });
    
}




-(void)_loadTitleView{
    
    [YSThemeManager setNavigationTitle:@"测试结果" andViewController:self];
}


-(void)_requesetTestResult{
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hub.labelText = @"正在请求结果..";
    SnsCheckResultRequest *request = [[SnsCheckResultRequest alloc] init:GetToken];
    request.api_groupId = @(self.test_GroupID);
    request.api_resultScore = @(self.test_Mark);
    [_vapManager snsCheckResult:request success:^(AFHTTPRequestOperation *operation, SnsCheckResultResponse *response) {
        [hub hide:YES];
        _requestGoodsId = response.resultId;
        NSLog(@"%@",response);
        if ([response.getDayIntegralFlag integerValue] == 1) {
            self.integralLabel.text = @"+0";
        }else {
            NSString *integreal = [NSString stringWithFormat:@"%@",response.integral.stringValue];
            if (!integreal || [integreal isEqualToString:@"(null)"]) {
                integreal = @"0";
            }
            self.integralLabel.text = [NSString stringWithFormat:@"+%@ ",integreal] ;
        }
        [self.testResultWebView loadHTMLString:response.checkResult baseURL:nil];
        [self _requestCareChoosenGoods];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        self.integralLabel.text = @"网络出错";
        hub.labelText = @"请求出错";
        [hub hide:YES];
    }];
}//自测结果请求


- (IBAction)iWantToZiXun:(id)sender {
    
//    //进入咨询页
//    consultationViewController *consultVC = [[consultationViewController alloc] init];
//    consultVC.comminFromSelfTest = YES;
//    [self.navigationController pushViewController:consultVC animated:YES];

    
}//我要咨询

- (IBAction)testAgain:(id)sender {

    if (self.retestBlock) {
        //回调到自测题重新测试
        self.retestBlock(self.test_GroupID);
    }
    
}//再测一次


- (void)webViewDidFinishLoad:(UIWebView *)webView { //webview 自适应高度
    
    
    CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;
    
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    
    NSLog(@"webFrame: %@",NSStringFromCGRect(frame));
    NSLog(@"webSize: %@",NSStringFromCGSize(fittingSize));
    
    frame.size = fittingSize;
//    webView.frame = frame;

    NSLog(@"size: %f, %f", fittingSize.width, fittingSize.height);
    self.webHeightConstant.constant = fittingSize.height;
    [self.view layoutIfNeeded];
}





- (IBAction)iKnow:(id)sender {

    if (self.iknowBlock) {
//        [self.navigationController popViewControllerAnimated:YES];
////        //回到自测题列表页
//        self.iknowBlock();
        [self.navigationController popToViewController:[self.navigationController.viewControllers xf_safeObjectAtIndex:1] animated:YES];
    }
}//我知道了

-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    
    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    html = [html stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"&nbsp" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"nbsp;" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"nbsp" withString:@""];
    NSString * regEx = @"<([^>]*)>";
    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}

@end
