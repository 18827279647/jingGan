//
//  SettingVC.m
//  jingGang
//
//  Created by wangying on 15/6/13.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "SettingVC.h"
#import "AboutYunEs.h"
#import "PublicInfo.h"
//#import <PgySDK/PgyManager.h>
#import "WebDayVC.h"
#import "userDefaultManager.h"
#import "GlobeObject.h"
#import "AppDelegate.h"
#import "H5page_URL.h"
#import "MBProgressHUD.h"
#import "WWSideslipViewController.h"
#import "HelpController.h"
#import "FeelBackQuestionController.h"
#import "JGSettingCell.h"
#import "ChangeLoginViewController.h"
#import "ChangYunbiPasswordViewController.h"
#import "JGClientServerController.h"
#import "JGBindOnAccountViewController.h"
#import "YSCacheManager.h"
#import "YSLoginManager.h"
#import "YSVersionConfig.h"
#import "NSBundle+Extension.h"
#import "YSEnvironmentConfig.h"
#import "AppDelegate.h"

#import "HongbaoViewController.h"
#import "PTViewController.h"
#define kVersionUpdateAlertTag 1001

@interface SettingVC ()<UIApplicationDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>{

    MBProgressHUD *_logOuthub;

}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewLogoTopHeight;
@property (nonatomic,strong) NSMutableArray *arrayData;
@property (copy , nonatomic) NSString *requestVersion;
@property (copy , nonatomic) NSString *requestDownUrl;
@property (weak, nonatomic) IBOutlet UILabel *versionLab;

@end

@implementation SettingVC

- (NSMutableArray *)arrayData
{
    if (!_arrayData) {
        NSArray *arrayUserInfo = [NSArray arrayWithObjects:@"登录密码",@"支付密码" ,nil];
        NSArray *arrayAboutUs = [NSArray arrayWithObjects:@"绑定账号",@"用户协议",@"关于我们",@"客服中心",@"去给e生康缘一个好评", nil];
        NSArray *arrayChsh = [NSArray arrayWithObjects:@"清除缓存",@"当前版本",nil];
        //,@"待开放页面"
        _arrayData = [NSMutableArray array];
        //CN账号隐藏修改登陆密码和健康豆密码选项
        if ([YSLoginManager isCNAccount]) {
            [_arrayData xf_safeAddObject:arrayAboutUs];
            [_arrayData xf_safeAddObject:arrayChsh];
        }else{
            [_arrayData xf_safeAddObject:arrayUserInfo];
            [_arrayData xf_safeAddObject:arrayAboutUs];
            [_arrayData xf_safeAddObject:arrayChsh];
        }
    }
    return _arrayData;
}

- (void)viewWillAppear:(BOOL)animated
{

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self request];


}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [YSUMMobClickManager endLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (void)request {
    [self showHud];
    @weakify(self);
    [YSVersionConfig appVersionCheck:^(BOOL ret, NSString *versionMsg, NSString *downUrl) {
        @strongify(self);
        [self hiddenHud];
        if (ret) {
            self.versionLab.hidden = NO;
            self.versionLab.text = [NSString stringWithFormat:@"版本号 %@",[NSBundle version]];
            self.requestVersion = versionMsg;
            if (self.arrayData.count) {
                self.requestVersion = versionMsg;
                self.requestDownUrl = downUrl;
                NSArray *array = [self.arrayData lastObject];
                NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
                [mutableArray xf_safeAddObject:@"检查版本"];
                [self.arrayData replaceObjectAtIndex:self.arrayData.count - 1 withObject:mutableArray];
                [self.tableView reloadData];
            }
        }else {
            if ([appChannels integerValue] == 11) {
                // appstore
                self.versionLab.hidden = YES;
            }else if ([appChannels integerValue] == 12) {
                // pgy
                self.versionLab.hidden = NO;
                self.versionLab.text = [NSString stringWithFormat:@"v %@",[NSBundle version]];
            }
        }
    }];
}

- (void)initUI
{
    self.navigationController.navigationBar.translucent = NO;
    [self setupNavBarPopButton];
    //设置标题
    [YSThemeManager setNavigationTitle:@"设置" andViewController:self];
    //设置tableview
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [self loadFootView];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.separatorColor = UIColorFromRGB(0xf1f1f1);
#ifdef DEBUG // 处于开发阶段
    YSProjectEnvironmentMode currentDevelopMode = [YSEnvironmentConfig currentMode];
    NSString *title ;
    switch (currentDevelopMode) {
        case YSProject209EnvironmentModel:
            title = @".102";
            break;
        case YSProjectCNEnvironmentMode:
            title = @".cn";
            break;
        case YSProjectCOMEnvironmentMode:
            title = @".com";
            break;
        default:
            break;
    }
    
   self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(developModeChange)];
#else // 处于发布阶段
    
#endif
}


#pragma mark ---UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 5.0)];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 5.0)];
    view.backgroundColor = [UIColor clearColor];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    lineView.backgroundColor = [YSThemeManager getTableViewLineColor];
    [view addSubview:lineView];
    
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrayData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.arrayData[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifile = @"JGSettingCell";
    JGSettingCell *cell = (JGSettingCell *)[tableView dequeueReusableCellWithIdentifier:identifile];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"JGSettingCell" owner:self options:nil];
        cell = [nib lastObject];
    }
    NSArray *array = [self.arrayData xf_safeObjectAtIndex:indexPath.section];
    cell.bageImageView.hidden = YES;
    NSInteger CNAccountIndex = 2;
    if ([YSLoginManager isCNAccount]) {
        //CN账号
        CNAccountIndex = 1;
    }
    if (indexPath.section == CNAccountIndex) {
        [YSCacheManager cacheSize:^(CGFloat totleSize) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (totleSize) {
                    cell.accessLab.hidden = NO;
                    cell.accessLab.text = [NSString stringWithFormat:@"%.1fMB",totleSize];
                    if (indexPath.row == 0) {
                        if (totleSize > 40) {
                            cell.accessLab.text = [NSString stringWithFormat:@"大于40MB"];
                        }else if(totleSize < 0.2) {
                            cell.accessLab.text = [NSString stringWithFormat:@"0MB"];
                        }
                    }else if (indexPath.row == 1){
                        cell.accessLab.text = [NSString stringWithFormat:@"v %@",[NSBundle version]];
                        if (self.requestVersion && self.requestVersion.length && [self.requestVersion xf_contains:@"."] && ![self.requestVersion isKindOfClass:[NSNull class]] && ![self.requestVersion isEqualToString:@"(null)"] && ![self.requestVersion isEqualToString:@"null"] ) {
                            if ([self.requestVersion isEqualToString:[NSBundle version]]) {
                                cell.bageImageView.hidden = YES;
                            }else {
                                cell.bageImageView.hidden = NO;
                            }
                        }else {
                            cell.bageImageView.hidden = YES;
                        }
                    }else if (indexPath.row == 2) {
                        cell.accessLab.text = @"";
                    }
                }
            });
        }];
    }
    
    cell.labelTitle.text = [array xf_safeObjectAtIndex:indexPath.row];
    return cell;
}

#pragma mark --- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *controller;
    //如果是CN账号，隐藏登录密码，健康豆密码点击事件
    if ([YSLoginManager isCNAccount]) {
       if (indexPath.section == 0){
            if (indexPath.row == 0){
                //            跳账号绑定页面
                JGBindOnAccountViewController *bindOnAccountVC = [[JGBindOnAccountViewController alloc] init];
                controller = bindOnAccountVC;
            }else if (indexPath.row == 1){//用户协议
                
                AboutYunEs *about = [[AboutYunEs alloc]initWithType:YSHtmlControllerWithUserServicetreaty];
                controller = about;
            }else if (indexPath.row == 2){//关于我们
                
                AboutYunEs *about = [[AboutYunEs alloc]initWithType:YSHtmlControllerWithAboutUs];
                about.strUrl = AboutYunESheng;
                controller = about;
                RELEASE(about);
             
            }else if (indexPath.row == 3){//客服中心
                JGClientServerController *clientServerVC = [[JGClientServerController alloc]init];
                controller = clientServerVC;
            }else if (indexPath.row == 4){
                
                NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", @"1434177842"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                
                
            
                
            }
        }else if (indexPath.section == 1){
            //清除缓存
            if (indexPath.row == 0) {
                [YSCacheManager clearCacheWithHudShowView:self.view completion:^{
                    JGSettingCell *cell = (JGSettingCell *)[tableView cellForRowAtIndexPath:indexPath];
                    cell.accessLab.text = @"0MB";
                }];
            }else if (indexPath.row == 1) {
                JGLog(@"检查版本更新");
                [self updateVersion:(JGSettingCell*)[tableView cellForRowAtIndexPath:indexPath]];
            }
        }
    }else{
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {//登陆密码/修改密码
                ChangeLoginViewController *changeLoginVC = [[ChangeLoginViewController alloc]init];
                controller = changeLoginVC;
            }else if (indexPath.row == 1){
                ChangYunbiPasswordViewController *changYunbiPasswordVC = [[ChangYunbiPasswordViewController alloc]init];
                
                controller = changYunbiPasswordVC;
            }
        }else if (indexPath.section == 1){
            if (indexPath.row == 0){
                //            跳账号绑定页面
                JGBindOnAccountViewController *bindOnAccountVC = [[JGBindOnAccountViewController alloc] init];
                controller = bindOnAccountVC;
            }else if (indexPath.row == 1){//用户协议
                
                AboutYunEs *about = [[AboutYunEs alloc]initWithType:YSHtmlControllerWithUserServicetreaty];
                controller = about;
            }else if (indexPath.row == 2){//关于我们
                
                AboutYunEs *about = [[AboutYunEs alloc]initWithType:YSHtmlControllerWithAboutUs];
                about.strUrl = AboutYunESheng;
                controller = about;
                RELEASE(about);
                
            }else if (indexPath.row == 3){//客服中心
                JGClientServerController *clientServerVC = [[JGClientServerController alloc]init];
                controller = clientServerVC;
            }else if (indexPath.row == 4){
                
                NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", @"1434177842"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                
                
            }
            
        }else if (indexPath.section == 2){
            if (indexPath.row == 0) {
                //清除缓存
                [YSCacheManager clearCacheWithHudShowView:self.view completion:^{
                    JGSettingCell *cell = (JGSettingCell *)[tableView cellForRowAtIndexPath:indexPath];
                    cell.accessLab.text = @"0MB";
                }];   
            }else if (indexPath.row == 1) {
                JGLog(@"检查版本更新");
                [self updateVersion:(JGSettingCell*)[tableView cellForRowAtIndexPath:indexPath]];
            }else if (indexPath.row == 2) {
                
                PTViewController * view  = [[PTViewController alloc] init];
                view.orderID = @(3573);
                view.pdorderID = @"1339358201904241828590";
                [self.navigationController pushViewController:view animated:YES];
            }
        }
    }
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)developModeChange {
    [UIAlertView xf_shoeWithTitle:@"提示" message:@"更改测试环境" buttonsAndOnDismiss:@"取消",@".102内网环境",@".cn测试环境",@".com正式环境", ^(UIAlertView *alertView, NSInteger index){
        switch (index) {
            case 0:
                // 取消
                break;
            case 1:
                // .209
                [YSEnvironmentConfig configProjectEnvironmentWithMode:YSProject209EnvironmentModel];
                break;
            case 2:
                // .cn
                [YSEnvironmentConfig configProjectEnvironmentWithMode:YSProjectCNEnvironmentMode];
                break;
            case 3:
                // .com
                [YSEnvironmentConfig configProjectEnvironmentWithMode:YSProjectCOMEnvironmentMode];
                break;
            default:
                break;
        }
        if (index) {
            [UIAlertView xf_showWithTitle:@"提示" message:@"正在切换环境" delay:2.4 onDismiss:^{
                [self logOut];
                [self performSelector:@selector(beGinLogin) withObject:nil afterDelay:0.2];
            }];
        }
    }];

}

- (void)updateVersion:(JGSettingCell *)cell {
    if (cell.bageImageView.hidden) {
        [UIAlertView xf_showWithTitle:@"已是最新版本!" message:nil delay:1.4 onDismiss:NULL];
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发现最新的版本" message:nil delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"去下载", nil];
        alertView.tag = kVersionUpdateAlertTag;
        [alertView show];
    }
}

- (UIView *)loadFootView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 130)];
    view.backgroundColor = [UIColor clearColor];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 12, kScreenWidth, 47);
    [button setTitle:@"退出当前账号" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    return view;
}

- (void)buttonClick
{
    UIAlertView *logOutAlert = [[UIAlertView alloc] initWithTitle:@"退出登录" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [logOutAlert show];
}

-(void)btnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == kVersionUpdateAlertTag) {
        if (buttonIndex == 1) {
            // 去下载最新版本
            JGLog(@"down-url:%@",self.requestDownUrl);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.requestDownUrl]];
        }
    }else {
        if (buttonIndex == 1) {//确定
            [self logOut];
            _logOuthub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self performSelector:@selector(beGinLogin) withObject:nil afterDelay:1.0f];
        }
    }
}

-(void)logOut{
    // 友盟统计  停止sign-in PUID的统计
    [YSLoginManager loginout];
}//退出

- (IBAction)gotoFeedback:(id)sender {
    FeelBackQuestionController *VC = [[FeelBackQuestionController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)beGinLogin{
    [_logOuthub hide:YES];
    //退出登录
    AppDelegate *appDelegate = kAppDelegate;
    [appDelegate gogogoWithTag:4];
    [self.navigationController popViewControllerAnimated:YES];
//    [appDelegate beGinLoginWithType:YSLoginCommonCloseType toLogin:YES];
//    //延迟执行
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        //延迟执行函数
//        [appDelegate gogogoWithTag:0];
//    });
}

- (void)dealloc {

}

@end
