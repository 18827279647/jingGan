//
//  RXMoreWebViewController.m
//  jingGang
//
//  Created by 荣旭 on 2019/6/28.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "RXMoreWebViewController.h"
#import <WebKit/WebKit.h>
#import "GlobeObject.h"
#import "SPPageMenu.h"
#import "RXTabViewHeightObjject.h"
#import "Unit.h"

//运动
#import "RXMoreTableViewCell.h"
#import "YSStepManager.h"
#import "SDViewController.h"
#import "RXWeekViewController.h"

#import "RXShoppingTableViewCell.h"
#import "RXHealthyTableViewCell.h"
#import "KJGoodsDetailViewController.h"
#import "YSHealthTaskTableViewCell.h"
#import "YSHealthyTaskCell.h"
#import "YSHealthyTaskView.h"


#import "RXShowMoreView.h"
#import "YSMultipleTypesTestController.h"

#import "YSHotInfoTableViewCell.h"
#import "WebDayVC.h"
#import "RXMoreWebTableViewCell.h"

#import "AppDelegate.h"

#import "RXWebViewController.h"

#import "YSGestureNavigationController.h"

static NSString *heathInfoCellID = @"RXHotInfoTableViewCell";

@interface RXMoreWebViewController ()<WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate,SPPageMenuDelegate,UITableViewDelegate,UITableViewDataSource,shopinageDelegate>

@property (strong) WKWebView *webview;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) SPPageMenu *pageMenu;
@property (nonatomic, strong) UIScrollView *scrollView;

@property(nonatomic,strong)UIImageView*imageImage;
@property(nonatomic,strong)UILabel*labelName;
@property(strong,nonatomic)UITableView*mtableview;
@property(nonatomic,strong)NSMutableArray*tabDataArray;
@property(nonatomic,strong)WKWebViewConfiguration *config;

@property(nonatomic,strong)UIButton*addbutton;

@property(nonatomic,strong)NSMutableArray*iconImageArray;
@property(nonatomic,strong)NSMutableDictionary*iconDic;

@property(nonatomic,assign)double myKaluli;
@property(nonatomic,assign)double myGongli;
@property(nonatomic,assign)int myStep;


@property(nonatomic,strong)RXShowMoreView*showMoreView;
@property(nonatomic,strong)RXParamDetailResponse*paramResponse;

@property(nonatomic,assign)bool finshType;

@end

@implementation RXMoreWebViewController

-(void)viewWillAppear:(BOOL)animated;{
    [super viewWillAppear:animated];
    [YSThemeManager settingAppThemeType:YSAppThemeNewYearType];
    self.navigationController.navigationBar.barTintColor = [YSThemeManager themeColor];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlack;
    self.navigationController.navigationBar.translucent=NO;
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = COMMONTOPICCOLOR;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavUI];
    [self setNavButton];
    [self configContent];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestSDView) name:@"SDViewControllerNotification" object:nil];
    self.finshType=false;
}

-(void)setNavButton;{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 60, 44);
    [leftButton setTitleColor:[UIColor whiteColor]
                     forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"navigationBarBack"]
                forState:UIControlStateNormal];
    leftButton.titleLabel.font = JGFont(15);
    [leftButton setAdjustsImageWhenHighlighted:NO];
    [leftButton addTarget:self action:@selector(backLastViewController) forControlEvents:UIControlEventTouchUpInside];
    // 修改导航栏左边的item
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    //  隐藏tabbar
    self.hidesBottomBarWhenPushed = YES;
}
//重写返回
-(void)backLastViewController;{

    if ([self.webview canGoBack]) {
        self.navigationItem.rightBarButtonItem=nil;
        [self.view resignFirstResponder];
        [self.webview goBack];
    }else if([self.urlstring rangeOfString:@"resources/jkgl/healthData"].location!= NSNotFound){
        [self.view resignFirstResponder];
        [self.navigationController popToRootViewControllerAnimated:NO];
    }else{
//        if (self.finshType) {
//            [self back];
//        }else{
//            [self.view resignFirstResponder];
//            [self.navigationController popViewControllerAnimated:NO];
//        }
         [self back];
    }
}

-(void)back;{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UITabBarController *tabBarController = (UITabBarController *)appDelegate.window.rootViewController;
    UINavigationController *navController = tabBarController.selectedViewController;
    [navController popViewControllerAnimated:NO];
}
-(void)setNavUI;{

    if (self.labelName==nil) {
        self.labelName =[[UILabel alloc]init];
    }
    self.labelName.frame=CGRectMake(80/2-(self.titlestring.length*16)/2,(44-20)/2,self.titlestring.length*16, 20);
    self.labelName.font=JGFont(16);
    self.labelName.text=self.titlestring;
    self.labelName.textColor=[UIColor whiteColor];

    UITapGestureRecognizer*tapLabel=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showAllQuestions)];
    self.labelName.userInteractionEnabled=YES;
    [self.labelName addGestureRecognizer:tapLabel];
    
    if (self.imageImage==nil) {
        self.imageImage=[[UIImageView alloc]initWithFrame:CGRectMake(self.labelName.frame.origin.x+self.titlestring.length*16+10,(44-13)/2,13,13)];
    }
    UITapGestureRecognizer*tapImage=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showAllQuestions)];
    self.imageImage.userInteractionEnabled=YES;
    [self.imageImage addGestureRecognizer:tapImage];
    
    
    self.imageImage.image=[UIImage imageNamed:@"rx_motion_向下"];
    
    UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,80,44)];
    imageView.userInteractionEnabled=YES;
    [imageView addSubview:self.labelName];
    [imageView addSubview:self.imageImage];
    
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showAllQuestions)];
    [imageView addGestureRecognizer:tap];

    self.navigationItem.titleView =imageView;
}

-(void)showAllQuestions;{
    self.type=false;
    if (self.pageMenu.hidden) {
        self.pageMenu.hidden=NO;
        self.scrollView.hidden=NO;
        self.addbutton.hidden=YES;
        self.imageImage.image=[UIImage imageNamed:@"rx_motion_向上"];
    }else{
        self.addbutton.hidden=NO;
        self.pageMenu.hidden=YES;
        self.scrollView.hidden=YES;
        self.imageImage.image=[UIImage imageNamed:@"rx_motion_向下"];
    }
}
-(void)tapGestureRecognizer;{
    self.type=false;
    if (self.pageMenu.hidden) {
        self.pageMenu.hidden=NO;
        self.scrollView.hidden=NO;
        self.addbutton.hidden=YES;
        self.imageImage.image=[UIImage imageNamed:@"rx_motion_向上"];
    }else{
        self.pageMenu.hidden=YES;
        self.scrollView.hidden=YES;
        self.addbutton.hidden=NO;
        self.imageImage.image=[UIImage imageNamed:@"rx_motion_向下"];
    }
}

//运动的时候请求数据
-(void)request;{
    RXParamDetailRequest*request=[[RXParamDetailRequest alloc]init:GetToken];
    request.paramCode=self.code;
    request.id=[NSString stringWithFormat:@"2036"];
    [self showHUD];
    VApiManager *manager = [[VApiManager alloc]init];
    [manager RXMakeParamDetail:request success:^(AFHTTPRequestOperation *operation, RXParamDetailResponse *response) {
        [self hideAllHUD];
        if (!self.paramResponse) {
            self.paramResponse=[[RXParamDetailResponse alloc]init];
        }
        self.paramResponse=response;
        [self.mtableview reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideAllHUD];
      //  [self showStringHUD:@"网络错误" second:0];
        [self.mtableview reloadData];
    }];
}
- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    if (!self.type) {
        self.finshType=false;
        NSMutableDictionary*dic=self.dataArray[toIndex];
        NSString*stringTitle=[RXTabViewHeightObjject getItemCodeNumber:dic];
        if ([stringTitle isEqualToString:@"运动"]) {
            self.titlestring=stringTitle;
            self.code=[NSString stringWithFormat:@"12"];
            [self request];
            self.mtableview.hidden=NO;
            self.webview.hidden=YES;
            [self.mtableview reloadData];
        }else{
            self.mtableview.hidden=YES;
            self.webview.hidden=NO;
            self.titlestring=stringTitle;
            self.code=[Unit JSONString:dic key:@"itemCode"];
            [_webview loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlstring]]];
        }
        [self setNavUI];
        [self configContent];
        self.pageMenu.hidden=YES;
        self.scrollView.hidden=YES;
        self.addbutton.hidden=NO;
    }
}
//滑动控件
- (SPPageMenu *)pageMenu {
    if (_pageMenu==nil) {
        _pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0,0, kScreenWidth,44) trackerStyle:SPPageMenuTrackerStyleLineLongerThanItem];
        NSArray*array=[NSArray arrayWithArray:self.titleArray];
        int index=0;
        for (int i=0;i<self.titleArray.count;i++) {
            NSString*string=self.titleArray[i];
            if ([string isEqualToString:self.titlestring]) {
                index=i;
            }
        }
        [_pageMenu setItems:array selectedItemIndex:index];
        _pageMenu.userInteractionEnabled=YES;
        _pageMenu.delegate = self;
        _pageMenu.itemTitleFont = JGFont(14);
        _pageMenu.selectedItemTitleColor = [UIColor whiteColor];
        _pageMenu.unSelectedItemTitleColor = [UIColor whiteColor];
        _pageMenu.tracker.backgroundColor = [UIColor whiteColor];
        _pageMenu.permutationWay = SPPageMenuPermutationWayScrollAdaptContent;
        _pageMenu.backgroundColor=JGColor(101, 187, 177, 1);
        _pageMenu.bridgeScrollView = self.scrollView;
    }
    return _pageMenu;
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0,44,kScreenWidth,kScreenHeight-44);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(kScreenWidth,kScreenHeight-44);
        _scrollView.backgroundColor =JGColor(0,0,0,0.5);
        _scrollView.userInteractionEnabled=YES;
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognizer)];
        [_scrollView addGestureRecognizer:tap];
    }
    return _scrollView;
}

- (NSString *)reSizeImageWithHTML:(NSString *)html {
    return [NSString stringWithFormat:@"<meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'><meta name='apple-mobile-web-app-capable' content='yes'><meta name='apple-mobile-web-app-status-bar-style' content='black'><meta name='format-detection' content='telephone=no'><style type='text/css'>img{width:%fpx}</style>%@", kScreenWidth-20, html];
}
- (void)configContent {
    
    self.view.backgroundColor = JGColor(165, 11, 34, 1);

    if ([self.titlestring isEqualToString:@"运动"]) {
        self.code=[NSString stringWithFormat:@"12"];
        [self request];
        [self setTabView];
    }else{
        [self setWebView];
    }
    
    [self.view addSubview:self.pageMenu];
    [self.view addSubview:self.scrollView];
    self.pageMenu.hidden=YES;
    self.scrollView.hidden=YES;
    
    if (self.addbutton==nil) {
        self.addbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    }
    self.addbutton.frame=CGRectMake(ScreenWidth-80,ScreenHeight-90-kNarbarH,70,70);
    [self.addbutton  setBackgroundImage:[UIImage imageNamed:@"rx_add_xuanFu_image"] forState:UIControlStateSelected];
    [self.addbutton  setBackgroundImage:[UIImage imageNamed:@"rx_add_xuanFu_image"] forState:UIControlStateNormal];
    [self.addbutton  addTarget:self action:@selector(addButtonFounction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addbutton];
}

-(void)addButtonFounction:(UIButton*)button;{
    
    if ([self.titlestring isEqualToString:@"运动"]) {
        self.iconImageArray=[[NSMutableArray array]init];
        [self.iconImageArray addObject:@"智能硬件_1"];
        [self.iconImageArray addObject:@"智能硬件_2"];
        [self.iconImageArray addObject:@"quxiao_lishi_image"];
    }
    button.selected=!button.selected;
    if (button.selected) {
        if (self.showMoreView!=nil) {
            [self.showMoreView p_dismissView];
            self.showMoreView=nil;
        }
        self.showMoreView=[[RXShowMoreView alloc]init];
        [self.showMoreView showQuickreqlyView:[NSArray arrayWithArray:self.iconImageArray] with:self with:@selector(rxshowButton:)];
        self.addbutton.hidden=YES;
    }else{
        self.addbutton.hidden=NO;
        if (self.showMoreView!=nil) {
            [self.showMoreView p_dismissView];
            self.showMoreView=nil;
        }
    }
}
-(void)rxshowButton:(NSString*)tag;{
    self.addbutton.hidden=NO;
    self.addbutton.selected=false;
    NSInteger index=[tag integerValue];
    if (index==10) {
        if (self.showMoreView!=nil) {
            [self.showMoreView p_dismissView];
            self.showMoreView=nil;
        }
    }else{
        if ([self.titlestring isEqualToString:@"运动"]) {
            NSString*string=self.iconImageArray[index];
            if ([string isEqualToString:@"智能硬件_1"]) {
                [self showStringHUD:@"功能正在开发，请期待" second:0];
            }else if ([string isEqualToString:@"智能硬件_2"]){
                if ([YSStepManager healthyKitAccess]) {
                    @weakify(self);
                    [YSStepManager healthStoreDataWithStartDate:nil endDate:nil WithFailAccess:^{
                        @strongify(self);
                        [self showErrorHudWithText:@"无数据获取权限"];
                    } walkRunningCallback:^(NSNumber *walkRunning) {
                    } stepCallback:^(NSNumber *step) {
                        if ([step intValue]==0) {
                            [self showErrorHudWithText:@"无法获取数据，请检查"];
                            self.myStep= [step intValue];
                            self.myGongli=[step doubleValue] * 0.00065;
                            self.myKaluli=62*self.myGongli*0.8;
                        }else{
                            [self showErrorHudWithText:@"数据已经更新"];
                            self.myStep= [step intValue];
                            self.myGongli=[step doubleValue] * 0.00065;
                            self.myKaluli=62*self.myGongli*0.8;
                            
                        }
                        [self.mtableview reloadData];
                    }];
                }
            }
        }else{
            NSString*string=self.iconImageArray[index];
            NSMutableDictionary*dicData=[[NSMutableDictionary alloc]init];
            for (NSMutableDictionary*dic in [RXTabViewHeightObjject getMorenArray]) {
                NSString*string=[Unit JSONString:dic key:@"itemName"];
                if ([self.titlestring isEqualToString:string]) {
                    dicData=dic;
                }
            }
            if ([string isEqualToString:@"智能硬件_1"]) {
                YSMultipleTypesTestController *multipleTypesTestController = [[YSMultipleTypesTestController alloc] initWithTestType:YSInputValueWithBloodPressureType];
                multipleTypesTestController.rxArray=[RXTabViewHeightObjject getRXZhangKaiTablelViewImageArray:self.iconDic];
                multipleTypesTestController.rxDic=dicData;
                multipleTypesTestController.rxIndex=index;
                [self.navigationController pushViewController:multipleTypesTestController animated:YES];
                
            }else if([string isEqualToString:@"智能硬件_2"]){
                YSMultipleTypesTestController *multipleTypesTestController = [[YSMultipleTypesTestController alloc] initWithTestType:YSInputValueWithBloodPressureType];
                multipleTypesTestController.rxArray=[RXTabViewHeightObjject getRXZhangKaiTablelViewImageArray:self.iconDic];
                multipleTypesTestController.rxDic=dicData;
                multipleTypesTestController.rxIndex=index;
                [self.navigationController pushViewController:multipleTypesTestController animated:YES];
                
            }else if([string isEqualToString:@"智能硬件_3"]){
                YSMultipleTypesTestController *multipleTypesTestController = [[YSMultipleTypesTestController alloc] initWithTestType:YSInputValueWithBloodPressureType];
                multipleTypesTestController.rxArray=[RXTabViewHeightObjject getRXZhangKaiTablelViewImageArray:self.iconDic];
                multipleTypesTestController.rxDic=dicData;
                multipleTypesTestController.rxIndex=index;
                [self.navigationController pushViewController:multipleTypesTestController animated:YES];
            }else if([string isEqualToString:@"智能硬件_4"]){
                YSMultipleTypesTestController *multipleTypesTestController = [[YSMultipleTypesTestController alloc] initWithTestType:YSInputValueWithBloodPressureType];
                multipleTypesTestController.rxArray=[RXTabViewHeightObjject getRXZhangKaiTablelViewImageArray:self.iconDic];
                multipleTypesTestController.rxDic=dicData;
                multipleTypesTestController.rxIndex=index;
                [self.navigationController pushViewController:multipleTypesTestController animated:YES];
            }else{
                if (self.showMoreView!=nil) {
                    [self.showMoreView p_dismissView];
                    self.showMoreView=nil;
                }
            }
        }
    }
}

-(void)setWebView;{
    if (_config==nil) {
        _config = [WKWebViewConfiguration new];
    }
    //初始化偏好设置属性：preferences
    _config.preferences = [WKPreferences new];
    //The minimum font size in points default is 0;
    _config.preferences.minimumFontSize = 10;
    //是否支持JavaScript
    _config.preferences.javaScriptEnabled = YES;
    //不通过用户交互，是否可以打开窗口
    
    if (_webview==nil) {
        _webview = [[WKWebView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth, kScreenHeight-kNarbarH) configuration:_config];
    }
    _webview.UIDelegate = self;
    _webview.navigationDelegate = self;
    if(_urlstring.length){
        [_webview loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlstring]]];
    }else{
        _webview.scrollView.delegate = self;
        _webview.scrollView.scrollEnabled = YES;
        [_webview loadHTMLString:[self reSizeImageWithHTML:_htmlstring] baseURL:[NSURL URLWithString:@"http://s.amazeui.org/"]];
    }
    [self.view addSubview:_webview];
    
    [self.webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    if (self.progressView==nil) {
        self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, 2)];
    }
    self.progressView.backgroundColor =JGColor(112, 210, 172, 1);
    
    self.progressView.tintColor = [UIColor clearColor];
    self.progressView.trackTintColor =  [UIColor clearColor];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:self.progressView];
}

-(void)setTabView;{
    if ([YSStepManager healthyKitAccess]) {
        @weakify(self);
        [YSStepManager healthStoreDataWithStartDate:nil endDate:nil WithFailAccess:^{
            @strongify(self);
            [self showErrorHudWithText:@"无数据获取权限"];
        } walkRunningCallback:^(NSNumber *walkRunning) {
        } stepCallback:^(NSNumber *step) {
            if ([step intValue]==0) {
                [self showErrorHudWithText:@"无法获取数据，请检查"];
                self.myStep= [step intValue];
                self.myGongli=[step doubleValue] * 0.00065;
                self.myKaluli=62*self.myGongli*0.8;
            }else{
                [self showErrorHudWithText:@"数据已经更新"];
                self.myStep= [step intValue];
                self.myGongli=[step doubleValue] * 0.00065;
                self.myKaluli=62*self.myGongli*0.8;
                
            }
            [self.mtableview reloadData];
        }];
    }
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    int myhight=statusRect.size.height;
    if (_mtableview==nil) {
        _mtableview=[[UITableView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-kNarbarH) style:0];
    }
     [_mtableview registerClass:[YSHotInfoTableViewCell class] forCellReuseIdentifier:heathInfoCellID];
    _mtableview.backgroundColor =JGColor(250, 250, 250, 1);
    _mtableview.delegate = self;
    _mtableview.dataSource = self;
    _mtableview.sectionFooterHeight = 0;
    _mtableview.estimatedRowHeight = 0;
    _mtableview.estimatedSectionHeaderHeight = 0;
    _mtableview.estimatedSectionFooterHeight = 0;
    _mtableview.backgroundColor = JGColor(250, 250, 250, 1);
    _mtableview.separatorColor =JGColor(250, 250, 250, 1);
    _mtableview.delegate = self;
    _mtableview.dataSource = self;
    _mtableview.tableFooterView = [UIView new];
    if (@available(iOS 11.0, *)) {
        _mtableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.mtableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:_mtableview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    if (indexPath.row==0) {
        return 300;
    }else if (indexPath.row==1) {
        return 160;
    }else if (indexPath.row==2) {
        
//        if (self.taskList.result) {
//            if (self.taskList.successCode) {
//                if (self.taskList.healthTaskList.count) {
//                    return 140.0;
//                }else {
//                    return kHealthyTaskCellHeight(140);
//                }
//            }else {
//                return kHealthyTaskCellHeight(140);
//            }
//        }else{
//        }
        return kHealthyTaskCellHeight(140)+84/2;
    }else if (indexPath.row==3) {
        if (self.paramResponse.invitationList.count>0) {
            return 125+84.0/2;
        }else{
            return 0;
        }
    }else if (indexPath.row==4) {
        //商品推荐
        if (self.paramResponse.keywordGoodsList.count>0) {
                return 250;
        }else{
            return 0;
        }
    }
    return 0;
}
#define user_tiezi @"/circle/look_invitation?invitationId="
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    if (indexPath.row==0) {
        RXMoreTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"RXMoreTableViewCell"];
        if(!cell){
           cell=[[NSBundle mainBundle]loadNibNamed:@"RXMoreTableViewCell" owner:self options:nil][0];
        }
        cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.layer.masksToBounds=YES;
        cell.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
        cell.layer.cornerRadius = 20;
        
        cell.sheButton.layer.masksToBounds=YES;
        cell.sheButton.layer.cornerRadius=25/2;
        cell.sheButton.backgroundColor=JGColor(101, 187, 177, 1);
        
        cell.bushulabel.textColor=JGColor(34, 34, 34, 1);
        [cell.bushulabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:30]];
        
        cell.relianglabel.textColor=JGColor(51, 51, 51, 1);
        cell.gonglilabel.textColor=JGColor(51, 51, 51, 1);
        
        cell.relianglabel.text=[NSString stringWithFormat:@"%.1f",self.myKaluli];
        cell.gonglilabel.text=[NSString stringWithFormat:@"%.1f",self.myGongli];
        cell.bushulabel.text=[NSString stringWithFormat:@"%d",self.myStep];
    
        //默认视图
        CircleLoader *view=[[CircleLoader alloc]initWithFrame:CGRectMake(ScreenWidth/2-150/2,cell.iconImage.frame.origin.y,cell.iconImage.frame.size.width,cell.iconImage.frame.size.height)];
        
        NSString*string=[[NSUserDefaults standardUserDefaults] objectForKey:@"sdbs"];
        if (string.length>0) {
            cell.mubiaolabel.text=[NSString stringWithFormat:@"目标%@步",string];
            float myIndex=[string floatValue];
            float floatMy=self.myStep/myIndex;
            view.progressValue=floatMy;
        }else{
            cell.mubiaolabel.text=[NSString stringWithFormat:@"未设置目标步数"];
            view.progressValue=0;
        }
        [cell.sheButton addTarget:self action:@selector(sheButtonFouction) forControlEvents:UIControlEventTouchUpInside];

        //设置轨道宽度
        view.lineWidth=8.0;
        //设置轨道颜色
        view.trackTintColor=JGColor(204, 240, 236, 1);
        //设置进度条颜色
        view.progressTintColor=JGColor(77, 236, 161, 1);
        //设置是否转到 YES进度不用设置
        view.animationing=NO;
        [cell addSubview:view];
        return cell;
    }else if(indexPath.row==1){
        RXMoreWebTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RXMoreWebTableViewCell"];
        if (cell == nil) {
            cell =[[NSBundle mainBundle]loadNibNamed:@"RXMoreWebTableViewCell" owner:self options:nil][0];
        }
        cell.namelabel.textColor=JGColor(51, 51, 51, 1);
        cell.namelabel.font=JGFont(16);
        
        [cell.gengButton setTitleColor:JGColor(136, 136, 136, 1) forState:UIControlStateNormal];
        cell.gengButton.titleLabel.font=JGFont(12);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.gengButton addTarget:self action:@selector(gengButtonFounction) forControlEvents:UIControlEventTouchUpInside];
        [cell.namelabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        
        
        cell.imageZhou.userInteractionEnabled=YES;
        cell.imageYue.userInteractionEnabled=YES;
        
        UITapGestureRecognizer*tapZhou=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zhouImageButton)];
        [cell.imageZhou addGestureRecognizer:tapZhou];
        
        UITapGestureRecognizer*tapYue=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(yueImageButton)];
        [cell.imageYue addGestureRecognizer:tapYue];
    
        return cell;
    }else if(indexPath.row==2){
        YSHealthTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RXShowhealthtaskcellid"];
        if (cell == nil) {
            cell = [[YSHealthTaskTableViewCell alloc] initWithStyle:UITableViewCellSelectionStyleNone reuseIdentifier:@"RXShowhealthtaskcellid"];
            //设置你的cell
        }
//        cell.models = [HealthyManageData taskDatasWithTaskList:self.taskList];
//        cell.delegate = self;
//        cell.addTask = ^{
//            YSHealthyManageWebController *testWebController = [[YSHealthyManageWebController alloc] initWithWebType:YSHealthyManageAddTaskType uid:self.userCustome.uid];
//            [self.navigationController pushViewController:testWebController animated:YES];
//        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.row==3){
        if (self.paramResponse.invitationList.count>0) {
            YSHotInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RXHotInfoTableViewShowCell"];
            if (!cell) {
                cell = [[YSHotInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"RXHotInfoTableViewShowCell"];
            }
            NSDictionary * dic = self.paramResponse.invitationList[0];
            NSString *url = [NSString stringWithFormat:@"%@%@%@",Base_URL,user_tiezi,[dic objectForKey:@"id"]];
            cell.strUrl = url;
            cell.models=self.paramResponse.invitationList[0];
            cell.dic =self.paramResponse.invitationList[0];
            cell.nav1 = self.navigationController;
            cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell panduandianzan];
            cell.isRX=true;
            return cell;
        }else{
            UITableViewCell*cell=[[UITableViewCell alloc]init];
            return cell;
        }
    }else if(indexPath.row==4){
        if (self.paramResponse.keywordGoodsList>0) {
            RXShoppingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RXShoppingTableViewCell"];
            if (cell == nil) {
                cell = [[RXShoppingTableViewCell alloc] initWithStyle:UITableViewCellSelectionStyleNone reuseIdentifier:@"RXShoppingTableViewCell"];
            }
            cell.keywordGoodsList=[NSMutableArray arrayWithArray:self.paramResponse.keywordGoodsList];
            cell.delegate=self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            UITableViewCell*cell=[[UITableViewCell alloc]init];
            return cell;
        }
    }
    UITableViewCell*cell=[[UITableViewCell alloc]init];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;{
    if(indexPath.row==3){
        static NSString *heathInfoCellID = @"RXHotInfoTableViewCell";
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [[NSUserDefaults standardUserDefaults]setObject:self.paramResponse.invitationList[0] forKey:@"circleTitle"];
        WebDayVC *weh = [[WebDayVC alloc]init];
        NSDictionary * dic = self.paramResponse.invitationList[0];
        [[NSUserDefaults standardUserDefaults]setObject:dic[@"title"]  forKey:@"circleTitle"];
        NSString *url = [NSString stringWithFormat:@"%@%@%@",Base_URL,user_tiezi,[dic objectForKey:@"id"]];
        weh.strUrl = url;
        weh.ind = 1;
        weh.dic = self.paramResponse.invitationList[0];
        weh.backBlock = ^(){
        };
        UINavigationController *nas = [[UINavigationController alloc]initWithRootViewController:weh];
        nas.navigationBar.barTintColor = COMMONTOPICCOLOR;
        [self presentViewController:nas animated:YES completion:^{
        }];
    }
}
//设置分组间隔
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;{
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0,0,ScreenWidth,10)];
    view.backgroundColor=JGColor(250, 250, 250, 1);
    return view;
}
//商品列表
-(void)getKeyGoodId:(NSNumber*)goodId;{
    KJGoodsDetailViewController *goodsDetailVC = [[KJGoodsDetailViewController alloc] init];
    goodsDetailVC.goodsID = goodId;
    goodsDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodsDetailVC animated:YES];
}
-(void)shoppingButton;{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UITabBarController *tabViewController = (UITabBarController *) app.window.rootViewController;
    [tabViewController setSelectedIndex:1];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//更多button
-(void)gengButtonFounction;{
    NSString*title=@"week";
    RXWeekViewController*view=[[RXWeekViewController alloc]init];
    view.type=title;
    //    view.urlstring=@"http://192.168.8.164:8082/carnation-apis-resource/resources/jkgl/weekly.html";
    view.urlstring=@"http://api.bhesky.com/resources/jkgl/weekly.html";
    view.getItemCode=self.code;
    [self.navigationController pushViewController:view animated:NO];
}

//设定目标
-(void)sheButtonFouction;{
    SDViewController*vc=[[SDViewController alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
}
-(void)requestSDView;{
    [self.mtableview reloadData];
}

//原生周报详情
-(void)zhouImageButton;{
    RXUserlastweeklyreportdetailRequest*request=[[RXUserlastweeklyreportdetailRequest alloc]init:GetToken];
    request.itemCode=@"12";
    VApiManager *manager = [[VApiManager alloc]init];
    [manager RXUserlastweeklyreportdetailRequest:request success:^(AFHTTPRequestOperation *operation, RXUserweeklyreportdetailResponse *response) {
        if (response.message.length>0) {
            RXWebViewController*vc=[[RXWebViewController alloc]init];
            vc.htmlstring=response.message;
            vc.titlestring=@"周报详情";
            [self.navigationController pushViewController:vc animated:NO];
        }else{
            [self showStringHUD:@"暂无周报信息" second:0];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self showStringHUD:@"网络错误" second:0];
    }];
}
//原生月报详情
-(void)yueImageButton;{
    RXUserlastmouthreportdetailRequest*request=[[RXUserlastmouthreportdetailRequest alloc]init:GetToken];
    request.itemCode=@"12";
    VApiManager *manager = [[VApiManager alloc]init];
    [manager RXUserlastmouthreportdetailRequest:request success:^(AFHTTPRequestOperation *operation, RXUserweeklyreportdetailResponse *response) {
        if (response.message.length>0) {
            RXWebViewController*vc=[[RXWebViewController alloc]init];
            vc.htmlstring=response.message;
            vc.titlestring=@"月报详情";
            [self.navigationController pushViewController:vc animated:NO];
        }else{
            [self showStringHUD:@"暂无月报信息" second:0];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showStringHUD:@"网络错误" second:0];
    }];
}







- (void)applicationDidReceiveMemoryWarning:(UIApplication*)application
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

// alert的处理
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    if (message) {
        if ([message rangeOfString:@"isCon"].location != NSNotFound) {
            NSString *str4 = [message substringFromIndex:5];
            NSMutableDictionary*dic=[Unit ParseJSONObject:str4];
            self.iconDic=dic;
            self.iconImageArray=[RXTabViewHeightObjject getRXLISHITablelViewImageArray:dic];
            [self.iconImageArray addObject:@"quxiao_lishi_image"];
        }
        if ([message rangeOfString:@"look"].location!=NSNotFound) {
            NSString*str4=[message substringFromIndex:4];
            RXWebViewController*web=[[RXWebViewController alloc]init];
            //                web.urlstring=@"http://192.168.8.164:8082/carnation-apis-resource/resources/jkgl/result.html";
            web.urlstring=@"http://api.bhesky.com/resources/jkgl/result.html";
            web.titlestring=[NSString stringWithFormat:@"%@检测结果",self.titlestring];
            web.type=[NSString stringWithFormat:@"%@",self.code];
            web.historyId=str4;
            [self.navigationController pushViewController:web animated:NO];
        }
    }
    completionHandler();
}
//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载网页");
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
}
#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *URL = navigationAction.request.URL;
    //[self handleCustomAction:URL];
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    if (prompt) {
        if ([prompt isEqualToString:@"requestGetToken"]) {
            completionHandler(GetToken);
        }
        if ([prompt isEqualToString:@"getRequestCode"]) {
            completionHandler([NSString stringWithFormat:@"%@",self.code]);
        }
        if ([prompt isEqualToString:@"toWeek"]) {
            [self toWeekButton];
            completionHandler([NSString stringWithFormat:@"0"]);
        }
    }
}

-(void)toWeekButton;{
    NSString*title=@"week";
    RXWeekViewController*view=[[RXWeekViewController alloc]init];
    view.type=title;
    //    view.urlstring=@"http://192.168.8.164:8082/carnation-apis-resource/resources/jkgl/weekly.html";
    view.urlstring=@"http://api.bhesky.com/resources/jkgl/weekly.html";
    view.getItemCode=self.code;
    [self.navigationController pushViewController:view animated:NO];
}
//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载完成");
    //加载完成后隐藏progressView
    self.progressView.hidden = YES;
    if(self.htmlstring.length){
        [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable value, NSError * _Nullable error) {
            CGFloat height = [value floatValue];
            if(height<kScreenHeight){
                height = kScreenHeight;
            }
            CGRect rect = self.webview.frame;
            rect.size.height += height;
            self.webview.scrollView.contentSize = CGSizeMake(kScreenWidth, 10000);
        }];
    }
}
//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败");
    //加载失败同样需要隐藏progressView
    self.progressView.hidden = YES;
    self.finshType=true;
    [self hideAllHUD];
    [self showStringHUD:@"加载失败" second:0];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webview.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc {
    [self.webview removeObserver:self forKeyPath:@"estimatedProgress"];
    self.webview.scrollView.delegate = nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
