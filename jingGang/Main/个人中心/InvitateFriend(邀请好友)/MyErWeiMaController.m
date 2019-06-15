//
//  InvitateFriendController.m
//  jingGang
//
//  Created by 张康健 on 15/10/27.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "MyErWeiMaController.h"
#import "VApiManager.h"
#import "GlobeObject.h"
#import "MJExtension.h"
#import "PublicInfo.h"
#import "MyErWeiMaView.h"
#import "H5page_URL.h"
#import "Masonry.h"
#import "InputInviteCodeController.h"
#import "InviteDetailController.h"
#import "ShareSettingController.h"
#import "UIView+Screenshot.h"
#import "TakePhotoUpdateImg.h"
#import "YSShareManager.h"
#import "UIAlertView+Extension.h"
#import "YSLoginManager.h"
#import "NSString+YYAdd.h"
@interface MyErWeiMaController () <UIActionSheetDelegate>{

    VApiManager *_vapManager;
    NSNumber    *_giveIntegral;
    NSString    *_invitationCode;
    BOOL        _isShowMyErWeiMa;

}
/**
 *  网络请求对象
 */
@property (nonatomic, strong) VApiManager *vapiManager;
@property (nonatomic, strong)ErweiMoModel *erweiMaModel;

@property (nonatomic, strong)MyErWeiMaView *myErWeiMaView;

@property (nonatomic, strong)NSString *strShareContent;

@property (nonatomic,strong) YSShareManager *shareManager;

@property (nonatomic, strong) UIImage *shareImage;
/**
 *  用户名字,分享者名称，如果有名字就用名字，如果没有名字就用昵称
 */
@property (nonatomic, copy)  NSString *strName;
/**
 *  分享二维码QQ空间，微博需要图片url。微信直接可以发图片
 */
@property (nonatomic, copy)  NSString *strShareErWeiMaImageUrl;
@property (nonatomic,assign) NSInteger   inviterType;

/**
 *  1级加载页数
 */
@property (nonatomic,assign)   NSInteger       pageNumOneLv;
/**
 *  2级加载页数
 */
@property (nonatomic,assign)   NSInteger       pageNumTwoLv;
/**
 *  3级加载页数
 */
@property (nonatomic,assign)   NSInteger       pageNumThreeLv;
/**
 *  选项卡
 */
@property (nonatomic,strong) UISegmentedControl *segmentdControl;



@end

@implementation MyErWeiMaController

- (void)viewDidLoad {
    [super viewDidLoad];
    _vapManager = [[VApiManager alloc] init];
    [self _init];
    
    self.inviterType = 1;
    self.pageNumOneLv = 1;
    self.pageNumTwoLv = 1;
    self.pageNumThreeLv = 1;
    //获取用户信息，得到邀请码
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [self _usersInfoRequest];
    //请求分享内容
    [self _requestShareContent];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [YSUMMobClickManager endLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}
- (void)_requestShareContent {
    UsersShareInfoGetRequest *request = [[UsersShareInfoGetRequest alloc] init:GetToken];
     @weakify(self);
    [_vapManager usersShareInfoGet:request success:^(AFHTTPRequestOperation *operation, UsersShareInfoGetResponse *response) {
        @strongify(self);
        NSLog(@"分享 response %@",response);
        self.strShareContent = response.shareInfo;
        self.erweiMaModel.userShareContent = self.strShareContent;
        
        [self _usersInfoRequest];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
}

- (void)netWorkRequst
{
    WEAK_SELF
    UsersRelationLevelListRequest *request = [[UsersRelationLevelListRequest alloc]init:GetToken];
    request.api_level = [NSNumber numberWithInteger:self.inviterType];
    request.api_pageSize = @10;
    NSNumber *pageNum;
    if (self.inviterType == 1) {
        pageNum = [NSNumber numberWithInteger:self.pageNumOneLv];
    }else if (self.inviterType == 2){
        pageNum = [NSNumber numberWithInteger:self.pageNumTwoLv];
    }else if (self.inviterType == 3){
        pageNum = [NSNumber numberWithInteger:self.pageNumThreeLv];
    }
    request.api_pageNum = pageNum;
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.vapiManager usersRelationLevelList:request success:^(AFHTTPRequestOperation *operation, UsersRelationLevelListResponse *response) {
        //设置人数
        //
        if (isEmpty(response.levelOneCount)) {
            response.levelOneCount = @0;
        }
        if (isEmpty(response.levelTwoCount)) {
            response.levelTwoCount = @0;
        }
        if (isEmpty(response.levelThreeCount)) {
            response.levelThreeCount = @0;
        }
        
        NSLog(@"----%@",response.levelOneCount);
        self.erweiMaModel.userInvitationCode = _invitationCode;

        self.erweiMaModel.userInvitationCount = [NSString stringWithFormat:@"%@",response.levelOneCount];
           [self showMyErWeiMaCongigure];
        //        处理邀请人的列表数据
        //        [weak_self loadNetWorkDataWith:[array copy] isNeedRemoveObj:isNeedRemoveObj];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [MBProgressHUD hideAllHUDsForView:weak_self.view animated:YES];
        [MBProgressHUD showSuccess:@"网络错误，请检查网络" toView:weak_self.view delay:1];
    }];
    
    
}


- (void)_init {
    [YSThemeManager setNavigationTitle:@"邀请好友" andViewController:self];
    self.view.backgroundColor = [UIColor whiteColor];
        self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
    self.navigationItem.rightBarButtonItem = [self rightButton];
    self.erweiMaModel = [[ErweiMoModel alloc] init];
 
    [self.view addSubview:self.myErWeiMaView];
    WEAK_SELF;
    [self.myErWeiMaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weak_self.view);
    }];
}



-(void)_usersInfoRequest {

     @weakify(self);
    UsersCustomerSearchRequest *request = [[UsersCustomerSearchRequest alloc] init:GetToken];
    [_vapManager usersCustomerSearch:request success:^(AFHTTPRequestOperation *operation, UsersCustomerSearchResponse *response) {
        @strongify(self);
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:nil];
        
        NSDictionary   *dictUserList = [dict objectForKey:@"customer"];
        
        //打印出来的字典
        
        NSLog(@"打印出的字典：%@",dict);
        
        [[NSUserDefaults standardUserDefaults]setObject:dictUserList forKey:kUserCustomerKey];
        [[NSUserDefaults standardUserDefaults] synchronize];

        UserCustomer *customer = [UserCustomer objectWithKeyValues:response.customer];
        JGLog(@" 邀请码 %@",customer.invitationCode);
        _invitationCode = customer.invitationCode;
        
//        if (!customer.name || [customer.name isEqualToString:@"(null)"]||[customer.name isEqualToString:@""]) {
            self.strName = customer.nickName;
//        }else{
//            weak_self.strName = customer.name;
//        }
        
//        self.erweiMaModel.userInvitationCode = _invitationCode;
        self.erweiMaModel.userNickName = customer.nickName;
        self.erweiMaModel.sex    = customer.sex;
        self.erweiMaModel.userHeaderUrlStr = customer.headImgPath;
        [self netWorkRequst];
        

//        self.erweiMaModel.userInvitationCount = [NSString stringWithFormat:@"%@",customer.inviteNumber];
     
        [MBProgressHUD hideHUDForView:self.view animated:YES];
             
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self hideHubWithOnlyText:@"网络错误，请检查网络"];
    }];
    

}






-(void)lookMyErWeiMaView {

    [self showActionSheet];

}

-(void)showActionSheet {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"填写邀请码",@"邀请明细",@"分享设置", nil];
    [actionSheet showInView:self.view];
    
}

#pragma mark -- -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    UIViewController *viewController;
    if (buttonIndex == 0) {
        //填写邀请码
        InputInviteCodeController *inputInviteCodeController = [[InputInviteCodeController alloc]init];
        viewController = inputInviteCodeController;
    }else if (buttonIndex == 1){
        //邀请明细
        InviteDetailController *inviteDetailController = [[InviteDetailController alloc]init];
        viewController = inviteDetailController;
    }else if (buttonIndex == 2){
        //分享设置
        ShareSettingController *shareSettinVC = [[ShareSettingController alloc] init];
        shareSettinVC.shareTitle = self.strShareContent;
         @weakify(self);  
        shareSettinVC.shareContentEditSuccessBlcok = ^(NSString *shareContent) {
            @strongify(self);
       
            self.strShareContent = shareContent;
        
            self.erweiMaModel.userShareContent = shareContent;
        
            self.myErWeiMaView.erweimoModel = self.erweiMaModel;
        };
        viewController = shareSettinVC;
    }
    if (viewController) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}


- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *subViwe in actionSheet.subviews) {
        if ([subViwe isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)subViwe;
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
    }
}



-(void)showMyErWeiMaCongigure {
//    if (!self.myErWeiMaView.erweimoModel) {
        self.myErWeiMaView.erweimoModel = _erweiMaModel;
//    }
    self.myErWeiMaView.hidden = NO;
    _isShowMyErWeiMa = YES;

}



#pragma mark---分享邀请码
- (void)myErWeiMaViewImmediatelyInviteButtonClick
{
    NSString *strNullReturn = [self descriptionNullStringWithUserName:self.strName invitationCode:_invitationCode];
    if (strNullReturn) {
        [self hideHubWithOnlyText:strNullReturn];
        return;
    }
    
    NSString *strContent = self.strShareContent;
    if (!strContent || strContent.length == 0) {
        strContent = kShareInvitationFriendDefaultContent;
    }
    
    NSString *shareTitle = [NSString stringWithFormat:@"我是%@，我为e生康缘代言",self.strName];
    
    //把用户昵称转换成Base64编码拼在链接后面
    NSString *strHtmltitleBase64 = [self.strName base64EncodedString];
     NSString *strShareUrl = kShareInvitationFriendUrl(_invitationCode,strHtmltitleBase64);
    YSShareManager *shareManager = [[YSShareManager alloc] init];
    
    YSShareConfig *config = [YSShareConfig configShareWithTitle:shareTitle content:strContent UrlImage:k_ShareImage shareUrl:strShareUrl];
    [shareManager shareWithObj:config showController:self];
    self.shareManager = shareManager;

}
#pragma mark ---分享二维码
- (void)shareErweimaButtonClick {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"shareImage.png"]];
    // 保存文件的名称
    BOOL result = [UIImagePNGRepresentation(self.shareImage)writeToFile:filePath atomically:YES];
    if (result) {
        JGLog(@"---图片保存成功，路径是---%@",filePath);
        NSString *strNullReturn = [self descriptionNullStringWithUserName:self.strName invitationCode:_invitationCode];
        if (strNullReturn) {
            [self hideHubWithOnlyText:strNullReturn];
            return;
        }
        
        NSString *shareContent = [NSString stringWithFormat:@"我为e生康缘代言，专业健康管理创富平台，赶紧下载注册分享，一起创造财富!"];
        NSString *strContent = self.strShareContent;
        if (!strContent) {
            strContent = kShareInvitationFriendDefaultContent;
        }
        
        NSString *strShareUrl = KShareGoToWeChatStoreUrl(_invitationCode);
        YSShareManager *shareManager = [[YSShareManager alloc] init];
        YSShareConfig *config = [YSShareConfig configShareWithTitle:strContent content:shareContent projectImage:filePath shareUrl:strShareUrl];
        [shareManager shareWithObj:config showController:self];
        self.shareManager = shareManager;
    }else {
        [UIAlertView xf_showWithTitle:@"正在为您生成二维码图片，请重新分享" message:nil delay:1.2 onDismiss:NULL];
    }
}

//右侧按钮
- (UIBarButtonItem *)rightButton
{
    UIButton *navRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    navRightButton.frame= CGRectMake(0, 0, 70, 36);

    [navRightButton addTarget:self action:@selector(lookMyErWeiMaView) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 15, 25, 7)];
    imageView.image = [UIImage imageNamed:@"invitation_icon_menu"];
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 10, 70, 36)];
    view.backgroundColor = [UIColor clearColor];
    
    [view addSubview:imageView];
    [view addSubview:navRightButton];
    //为了解决按钮过小问题，加了一个透明的大按钮
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
    return item;
}





-(MyErWeiMaView *)myErWeiMaView {
    if (!_myErWeiMaView) {
        _myErWeiMaView = BoundNibView(@"ErweimaView", MyErWeiMaView);

//        [self.view addSubview:_myErWeiMaView];

        WEAK_SELF

//        邀请码截图获取block
        _myErWeiMaView.erweimaSnapUrlGetBlock = ^(UIImage *image, NSString *shareImageUrl){
        
            weak_self.shareImage = image;
            weak_self.strShareErWeiMaImageUrl = shareImageUrl;
        };
        
        
        _myErWeiMaView.shareErweimaButtonClickBlock = ^(void){
            //分享二维码
//            [weak_self shareErweimaButtonClick];
            [weak_self myErWeiMaViewImmediatelyInviteButtonClick];
        };
        
        _myErWeiMaView.myErWeiMaViewImmediatelyInviteButtonClickBlock = ^(void){
            //分享邀请码
            [weak_self myErWeiMaViewImmediatelyInviteButtonClick];
        };
    }
    
    return _myErWeiMaView;
}

- (BOOL)judgeStringIsNoNull:(NSString *)str
{
    
    if(!str || [str isEqualToString:@"(null)"] || [str isEqualToString:@""]){
        return YES;
    }else{
        return NO;
    }
}
- (NSString *)descriptionNullStringWithUserName:(NSString *)userName invitationCode:(NSString *)invitationCode{
    if ([self judgeStringIsNoNull:userName]) {
        return @"因网络问题用户昵称不存在";
    }if ([self judgeStringIsNoNull:invitationCode]) {
        return @"因网络问题分享码不存在";
    }else{
        return nil;
    }
}
- (VApiManager *)vapiManager
{
    if (_vapiManager == nil) {
        _vapiManager = [[VApiManager alloc ]init];
    }
    return _vapiManager;
}
//- (void)dealloc
//{
//    JGLog(@"销毁l");
//}

@end
