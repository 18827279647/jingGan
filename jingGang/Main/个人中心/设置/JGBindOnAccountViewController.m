//
//  JGBindOnAccountViewController.m
//  jingGang
//
//  Created by Ai song on 16/2/25.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "JGBindOnAccountViewController.h"
#import "JGBindOnAccountTableViewCell.h"
#import "VApiManager.h"
#import "Util.h"
#import "PublicInfo.h"
#import "ThirdPaltFormLoginHelper.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApiObject.h"
#import "WXApi.h"
#import "AppDelegate.h"
#import "TieThirdPlatFormController.h"
#import "ThirdPlatformInfo.h"
#import "YSLoginManager.h"
#import "UIAlertView+Extension.h"
#import "WSProgressHUD.h"
#import "MJExtension.h"
@interface JGBindOnAccountViewController ()<UITableViewDataSource,UITableViewDelegate>{

    ThirdPaltFormLoginHelper    *_thirdPlatFormHelper;

}
@property (strong, nonatomic) UITableView *tableView;
@property (copy, nonatomic) NSMutableArray *titleArray;
@property (copy, nonatomic) NSMutableArray *pictureArray;
@property (copy, nonatomic) NSMutableArray *arrayData;
@property (copy,nonatomic)  NSString *thirdPlatOpenID;
@property (copy,nonatomic)  NSString *thirdPlatToken;
@property (nonatomic,copy)   NSString        * unionId;
@property (nonatomic,strong) VApiManager *vapiManager;
@property (nonatomic,assign)     NSInteger  thirdPlatNum;
@end

@implementation JGBindOnAccountViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestBindStutus];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vapiManager = [[VApiManager alloc] init];
    [self initUI];

}
- (void)initUI{
    
    
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    
    self.navigationController.navigationBar.translucent = NO;

    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
    //设置标题
    [YSThemeManager setNavigationTitle:@"账号绑定" andViewController:self];
    [self.view addSubview:self.tableView];
    
}

//tableView样式设置
- (UIView *)loadTableFootView{
    
    
    CGFloat tableFootViewHeight = kScreenHeight - 64 - 6 - self.arrayData.count * 64;
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, tableFootViewHeight, kScreenWidth, 1)];
    footView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    
    UIView *topLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    topLineView.backgroundColor = rgb(230, 230, 230, 1);
    [footView addSubview:topLineView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 16)];
    label.font = [UIFont systemFontOfSize:14.0];
    label.textColor = UIColorFromRGB(0xb8b8b8);
    label.text = @"账号绑定后可以多个账号登录";
    label.textAlignment = NSTextAlignmentCenter;
    [footView addSubview:label];
    
    return footView;
    
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 7, kScreenWidth, kScreenHeight -64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.tableFooterView = [self loadTableFootView];
        _tableView.separatorColor = UIColorFromRGB(0xf1f1f1);
    }
    return _tableView;
}

//- (void)initData{

//}
//request 绑定状态
- (void)requestBindStutus{
    [WSProgressHUD showWithMaskType:WSProgressHUDMaskTypeBlack];
    
    BindingListRequest *request = [[BindingListRequest alloc] init:GetToken];
    [self.vapiManager bindingList:request success:^(AFHTTPRequestOperation *operation, BindingListResponse *response) {
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:nil];
        
        JGLog(@"%@ %@",dict,response);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self dealResponseDataToReloadTableView:dict];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        JGLog(@"%@",error);
        [WSProgressHUD dismiss];
        [Util ShowAlertWithOnlyMessage:error.localizedDescription];
    }];
}

#pragma mark --- 请求成功后在这里做UI逻辑处理
- (void)dealResponseDataToReloadTableView:(NSDictionary *)dic{
    NSArray *arrayDat = dic[@"accounts"];
    self.arrayData = [NSMutableArray arrayWithArray:arrayDat];
    
    for (NSInteger i = 0; i < self.arrayData.count; i++) {
        NSDictionary *dictBindInfo = [NSDictionary dictionaryWithDictionary:self.arrayData[i]];
        NSString *accountType = [NSString stringWithFormat:@"%@",dictBindInfo[@"accountType"]];
        if ([YSLoginManager isThirdPlatformLogin] && ![accountType isEqualToString:@"2"] && self.arrayData.count == 1) {
            //如果是第三方平台登录，判断是否绑定手机号
                //如果没绑定就只显示手机账号绑定这一条
            self.titleArray = [NSMutableArray arrayWithObjects:@"手机账号",nil];
            self.pictureArray = [NSMutableArray arrayWithObjects:@"Accoud_Bind_PhoneNum",nil];
        }else{
            //如果绑定就显示4条
            self.titleArray = [NSMutableArray arrayWithObjects:@"手机账号",@"微信账号",@"微博账号",@"QQ帐号",nil];
            self.pictureArray = [NSMutableArray arrayWithObjects:@"Accoud_Bind_PhoneNum",@"Accoud_Bind_WeChat",@"Accoud_Bind_Sina",@"Accoud_Bind_QQ",nil];
        }
    }
    [WSProgressHUD dismiss];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indetifierStr = @"JGBindOnAccountTableViewCell";
    JGBindOnAccountTableViewCell *cell = (JGBindOnAccountTableViewCell *)[tableView dequeueReusableCellWithIdentifier:indetifierStr];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"JGBindOnAccountTableViewCell" owner:self options:nil];
        cell = [nib lastObject];
    }
    cell.imageV.image = [UIImage imageNamed:self.pictureArray[indexPath.row]];
    cell.titleLabel.text = self.titleArray[indexPath.row];

    cell.bindButton.selected = NO;
    cell.bindButton.tag = indexPath.row + 10086;
    [cell.bindButton addTarget:self action:@selector(bindButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell setBindStatuWithArray:self.arrayData.copy indexPath:indexPath];
    
    return cell;
}
- (void)bindButtonClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    
    
    if (button.selected) {
        NSString *strAlertMsg;
        if(button.tag == 10087){
            strAlertMsg = @"确定要解除微信绑定？";
        }
        else if (button.tag == 10088){
            strAlertMsg = @"确定要解除微博绑定？";
        }
        else if (button.tag == 10089){
            strAlertMsg = @"确定要解除QQ绑定？";
        }
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:strAlertMsg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self bindAndCancelBindWithButton:button];
            
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        [self bindAndCancelBindWithButton:button];
    }
    

    
    
}

- (void)bindAndCancelBindWithButton:(UIButton *)button
{
    if(button.selected){
        //        调解绑接口
        OpenIdBindingDeleteRequest *request = [[OpenIdBindingDeleteRequest alloc] init:GetToken];
        if(button.tag == 10087){//微信
            request.api_type = @"4";
        }
        else if (button.tag == 10088){//微博
            request.api_type = @"5";
        }
        else if (button.tag == 10089){//QQ
            request.api_type = @"3";
        }
        [self.vapiManager openIdBindingDelete:request success:^(AFHTTPRequestOperation *operation, OpenIdBindingDeleteResponse *response) {
            NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:nil];
            JGLog(@"%@",dict);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }else{
        //        调绑定接口
        if(button.tag == 10087){//微信
            self.thirdPlatNum = 4;
        }
        else if (button.tag == 10088){//微博
            self.thirdPlatNum = 5;
        }
        else if (button.tag == 10089){//QQ
            self.thirdPlatNum = 3;
        }
        [self _beginThirdLogin:button];
    }
}

- (void)_beginThirdLogin:(UIButton *)button{
    
    @weakify(self);
    if (button.tag == 10087 || button.tag == 10088 || button.tag == 10089) {
        //绑定第三方平台
        ShareType thirdAuthType;
        switch (self.thirdPlatNum) {
            case 3:
                //QQ
            {
                thirdAuthType = ShareTypeQQSpace;
                [YSLoginManager achieveThirdPlatformInfo:^(id<ISSPlatformUser> userInfo) {
                    self.thirdPlatOpenID = [userInfo uid];
                    id<ISSPlatformCredential> credential = [userInfo credential];
                    self.thirdPlatToken = [credential token];
                    //获取到opneID和token后开始请求绑定第三方
                    [self bindThirdAccountWithButton:button];
                } withPlatformType:YSThirdPlatformTypeTencent];
            }
                break;
            case 4:
                //微信
            {
                thirdAuthType = ShareTypeWeixiTimeline;
                
                [YSLoginManager achieveWXUnionId:^(NSString *msg) {
                    @strongify(self);
                    self.thirdPlatOpenID = msg;
                    //拿到uniID和token后开始请求绑定第三方
                    [self bindThirdAccountWithButton:button];
                    
                } fail:^(NSString *msg) {
                    
                    [UIAlertView xf_showWithTitle:msg message:nil delay:1.2 onDismiss:NULL];
                } info:^(NSString *msg) {
                    self.thirdPlatToken = msg;
                }];
            }
                break;
            case 5:
                //微博
            {
                thirdAuthType = ShareTypeSinaWeibo;
                [YSLoginManager achieveThirdPlatformInfo:^(id<ISSPlatformUser> userInfo) {
                    self.thirdPlatOpenID = [userInfo uid];
                    id<ISSPlatformCredential> credential = [userInfo credential];
                    self.thirdPlatToken = [credential token];
                    //获取到opneID和token后开始请求绑定第三方
                    [self bindThirdAccountWithButton:button];
                } withPlatformType:YSThirdPlatformTypeWB];
                break;
            }
            default:
                break;
        }

        
        
    }else{
        //绑定手机号
        if ([YSLoginManager isThirdPlatformLogin]) {
            [YSLoginManager thirdPlatformUserBindingCheckSuccess:^(BOOL isBinding,UIViewController *toController) {
                if (isBinding) {
                    [UIAlertView xf_showWithTitle:@"您已经绑定过手机!" message:nil delay:1.2 onDismiss:NULL];
                }
            } fail:^{
                [UIAlertView xf_showWithTitle:@"绑定失败,请重新再试！" message:nil delay:1.2 onDismiss:NULL];
            } controller:self unbindTelphoneSource:YSUserBindTelephoneSourceShopType isRemind:NO];
        }else {
            [UIAlertView xf_showWithTitle:@"用户信息出错，绑定失败!" message:nil delay:1.2 onDismiss:NULL];
        }
    }
}



- (void)bindThirdAccountWithButton:(UIButton *)button
{
    BindingThirdRequest *request = [[BindingThirdRequest alloc]init:GetToken];
    request.api_type = [NSNumber numberWithInteger:self.thirdPlatNum];
    request.api_openId = self.thirdPlatOpenID;
    request.api_token = self.thirdPlatToken;
    //开始请求绑定第三方
    [WSProgressHUD showWithMaskType:WSProgressHUDMaskTypeBlack];
    [self.vapiManager  bindingThird:request success:^(AFHTTPRequestOperation *operation, BindingThirdResponse *response) {
        [WSProgressHUD dismiss];
        if (response.errorCode.integerValue > 0) {
            
            [Util ShowAlertWithOnlyMessage:response.subMsg];
        }else{
            //绑定成功
            [self requestBindStutus];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [WSProgressHUD dismiss];
        [Util ShowAlertWithOnlyMessage:error.localizedDescription];
    }];
}



@end
