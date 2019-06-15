//
//  WSJKeySearchViewController.m
//  jingGang
//
//  Created by thinker on 15/8/12.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "WSJKeySearchViewController.h"
#import "PublicInfo.h"
#import "GlobeObject.h"
#import "VApiManager.h"
#import "WSJSearchResultViewController.h"
#import "AppDelegate.h"
#import "MerchantListViewController.h"
#import "DownToUpAlertView.h"
#import "KJShoppingAlertView.h"
#import "UIButton+Block.h"


static NSString *const kSearchHistoryKey = @"kSearchHistoryKey";

@interface WSJKeySearchViewController ()<UITextFieldDelegate>
{
    VApiManager *_vapManager;
}

@property (nonatomic, strong) UITextField    *SearchContentTextField;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UILabel *lblSearchTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UIScrollView *contentView;

@property (strong, nonatomic) NSMutableArray<UIButton *> *buttons;
@property (strong, nonatomic) NSMutableSet<NSString *> *hisSource;
@end

@implementation WSJKeySearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    self.buttons = [NSMutableArray array];
    self.hisSource = [NSMutableSet setWithArray:CRUserObj(kSearchHistoryKey)];
    [self.btnDelete addTarget:self action:@selector(btnDeleteOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self refreshUI];
//    switch (self.shopType) {
//        case searchShopType:
//        {
//            [self requestShopData];
//        }
//            break;
//        case searchO2Oype:
//        {
//            [self requestO2OData];
//        }
//            break;
//        default:
//            break;
//    }
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    CRUserSetObj(self.hisSource.allObjects, kSearchHistoryKey);
    [self.SearchContentTextField becomeFirstResponder];
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [YSUMMobClickManager endLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}
- (void)refreshUI
{
    if (self.hisSource.count) {
        self.lblSearchTitle.hidden = self.btnDelete.hidden = NO;
    }
    else
    {
        self.lblSearchTitle.hidden = self.btnDelete.hidden = YES;

    }
    [self.buttons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.buttons removeAllObjects];
    CGFloat margin = 12;
    CGFloat height = 32;
    [self.hisSource enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:obj forState:UIControlStateNormal];
        btn.titleLabel.font = kPingFang_Regular(14);
        [btn setTitleColor:UIColorHex(333333) forState:UIControlStateNormal];
        btn.backgroundColor = UIColorHex(F5F5F5);
        btn.cornerRadius = 5;
        CGFloat width = [btn.currentTitle widthForFont:btn.titleLabel.font] + 2 * margin;
        UIButton *last = self.buttons.lastObject;
        CGFloat btnX = 0;
        CGFloat btnY = 0;
        if (last) {
            btnX = last.right + margin;
            btnY = last.y;
            CGFloat needW = btnX + width;
            if (needW > self.contentView.width) {
                btnX = 0;
                btnY = last.bottom + margin;
            }
        }
        btn.frame = CGRectMake(btnX, btnY, width, height);
        
        btn.userInfo = obj;
        [btn addTarget:self action:@selector(btnTagOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        [self.buttons addObject:btn];
    }];
}
- (void)btnDeleteOnClick:(UIButton *)btn
{
    CRPresentAlert(nil, @"确认删除全部历史记录?", ^(UIAlertAction *action) {
        if ([@"确定" isEqualToString:action.title]) {
            [self.hisSource removeAllObjects];
            CRUserRemoveObj(kSearchHistoryKey);
            [self refreshUI];
        }
    }, @"取消", @"确定", nil);
 
}
- (void)btnTagOnClick:(UIButton *)btn
{
    self.SearchContentTextField.text = btn.userInfo;
    [self searchClick];

}
#pragma mark - 网络数据请求-----O2O服务-----
- (void)requestO2OData
{
     @weakify(self);
    PersonalHotSearchRequest *searchRequest = [[PersonalHotSearchRequest alloc ]init:GetToken];
    [_vapManager personalHotSearch:searchRequest success:^(AFHTTPRequestOperation *operation, PersonalHotSearchResponse *response) {
        JGLog(@"cheshi ---- %@",response);
        @strongify(self);
        for (NSString *str in response.hotSearch)
        {
            [self.dataSource addObject:str];
        }
        [self initButton];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"cheshi ---- %@",error);
    }];
}

#pragma mark - 网络数据请求-----商城-----
-(void)requestShopData
{
    
    SearchGoodsHotKeywordRequest *hotKeywordRequest = [[SearchGoodsHotKeywordRequest alloc] init:GetToken];
    WEAK_SELF
    [_vapManager searchGoodsHotKeyword:hotKeywordRequest success:^(AFHTTPRequestOperation *operation, SearchGoodsHotKeywordResponse *response) {
        for (NSString *str in response.hotKey)
        {
            [weak_self.dataSource addObject:str];
        }
        [weak_self initButton];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ;
    }];
}
#pragma mark - 实例化按钮控件
- (void)initButton
{
    NSInteger rowNum = self.dataSource.count / 3 + ((self.dataSource.count % 3 == 0) ? 0 : 1);
    for (NSInteger row = 0 ; row < rowNum; row ++)
    {
        for (NSInteger list = 0 ; list < 3; list ++)
        {
            if (self.dataSource.count > row * 3 + list)
            {
                UIButton *btn = [UIButton buttonWithType: UIButtonTypeSystem];
                btn.frame = CGRectMake(((__MainScreen_Width - 40) / 3 + 10) *list + 10, 115 + row * 45, (__MainScreen_Width - 40) / 3, 35);
                [btn setTitleColor:rgb(101, 187, 177, 1) forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:15];
                btn.backgroundColor = [UIColor whiteColor];
                btn.layer.cornerRadius = 20.0;//2.0是圆角的弧度，根据需求自己更改
                CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
                
                CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){101.0/255.0,187.0/255.0,177.0/255.0,1});
                
                [btn.layer setBorderColor:color];
//                btn.layer.borderColor.cgcolor = [UIColor redColor];//设置边框颜色
                btn.layer.borderWidth = 1.0f;//设置边框颜色
                [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag = row * 3 + list;
                [btn setTitle:self.dataSource[row *3 + list] forState:UIControlStateNormal];
                [self.view addSubview:btn];
            }
        }
    }
}
#pragma mark - 按钮控件点击触发事件
- (void)buttonAction:(UIButton *)btn
{
    if (self.searchKey)
    {
        self.searchKey(self.dataSource[btn.tag]);
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        switch (self.shopType)
        {
            case searchShopType:
            {
                WSJSearchResultViewController *searchRVC = [[WSJSearchResultViewController alloc] init];
                searchRVC.type = keywordSearch;
                searchRVC.keyword = self.dataSource[btn.tag];
                [self.navigationController pushViewController:searchRVC animated:YES];
            }
                break;
            case searchO2Oype:
            {
                MerchantListViewController *merchantVC = [[MerchantListViewController alloc] initWithNibName:@"MerchantListViewController" bundle:nil];
                merchantVC.keyword = self.dataSource[btn.tag];
                merchantVC.searchType = SearchKeyword;
                [self.navigationController pushViewController:merchantVC animated:YES];
            }
                break;
            default:
                break;
        }
    }
}
#pragma mark - 实例化UI
- (void)initUI
{
    self.dataSource = [NSMutableArray array];
    _vapManager = [[VApiManager alloc] init];
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setImage:CRImageNamed(@"backimage_black") forState:UIControlStateNormal];
    btnBack.size = CGSizeMake(20, 20);
    [btnBack addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
   
    btnBack.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    btnBack.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    //返回上一级控制器按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
//    self.navigationController.navigationBar.barTintColor = COMMONTOPICCOLOR;
    //点击搜索按钮
    UIButton *button_search = [[UIButton alloc]initWithFrame:CGRectMake(20, 30, 40, __NavScreen_Height-15)];
    [button_search setTitle:@"搜索" forState:UIControlStateNormal];
    [button_search setTitleColor:CRCOLOR_BLACK forState:UIControlStateNormal];
    [button_search addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithCustomView:button_search];
    self.navigationItem.rightBarButtonItem = rightBar;
    //设置背景颜色
//    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = CRCOLOR_WHITE;
    self.SearchContentTextField = [[UITextField alloc]initWithFrame:CGRectMake(__MainScreen_Width/2 - 70, __StatusScreen_Height + 5 , 220, 30)];
    self.SearchContentTextField.textAlignment = NSTextAlignmentCenter;
    switch (self.shopType) {
        case searchO2Oype:
        {
            self.SearchContentTextField.placeholder = @"搜索附近的服务或门店";
        }
            break;
        case searchShopType:
        {
            self.SearchContentTextField.placeholder = @"搜索你要的商品";
        }
            break;
        default:
            break;
    }
    UIImageView *search = CRImageViewNamed(@"icon_search");
    search.size = CGSizeMake(15, 15);
    UIView *container = [UIView viewWithSize:CGSizeMake(30, 30)];
    [container addSubview:search];
    [search centerInSuperview];
    
    self.SearchContentTextField.leftView = container;
    self.SearchContentTextField.leftViewMode = UITextFieldViewModeAlways;
    self.SearchContentTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.SearchContentTextField.tintColor = COMMONTOPICCOLOR;
    self.SearchContentTextField.delegate = self;
    self.SearchContentTextField.font = [UIFont systemFontOfSize:15];
    self.SearchContentTextField.returnKeyType = UIReturnKeySearch;
    self.SearchContentTextField.textColor = [UIColor blackColor];
//    self.SearchContentTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.SearchContentTextField.backgroundColor = [UIColor whiteColor];

    self.SearchContentTextField.layer.cornerRadius = 15.0;
    self.navigationItem.titleView = self.SearchContentTextField;
    self.navigationController.navigationBar.translucent = YES;
//    self.navigationController.navigationBar.barTintColor = CRCOLOR_WHITE;

//    AppDelegate *app = kAppDelegate;
//    [app.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
//    [app.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
}

//返回上一级界面
- (void) btnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
//点击搜索事件
- (void) searchClick
{

    if (self.SearchContentTextField.text.length == 0) {
        switch (self.shopType)
        {
            case searchShopType:
                [KJShoppingAlertView showAlertTitle:@"请输入您感兴趣的商品" inContentView:self.view];
                break;
            case searchO2Oype:
                [KJShoppingAlertView showAlertTitle:@"请输入您感兴趣的服务" inContentView:self.view];
                break;
            default:
                break;
        }
        return;
    }
    if (self.searchKey)
    {
        self.searchKey(self.SearchContentTextField.text);
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        switch (self.shopType)
        {
            case searchShopType:
            {
                WSJSearchResultViewController *searchRVC = [[WSJSearchResultViewController alloc] init];
                searchRVC.type = keywordSearch;
                searchRVC.keyword = self.SearchContentTextField.text;
                [self.navigationController pushViewController:searchRVC animated:YES];
            }
                break;
            case searchO2Oype:
            {
                MerchantListViewController *merchantVC = [[MerchantListViewController alloc] init];
                merchantVC.keyword = self.SearchContentTextField.text;
                merchantVC.searchType = SearchKeyword;
                [self.navigationController pushViewController:merchantVC animated:YES];
            }
                break;
            default:
                break;
        }
    }
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"搜索结果：%@",textField.text);
    NSString *keyword = [textField.text stringByTrim];
    if (!CRIsNullOrEmpty(keyword)) {
        [self.hisSource addObject:keyword];
        [self refreshUI];
    }
    [self searchClick];
    return YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hiddenKey];
    self.navigationController.navigationBar.translucent = NO;
}
- (void) hiddenKey
{
    [self.SearchContentTextField resignFirstResponder];
}
- (IBAction)hiddenKey:(id)sender
{
    [self hiddenKey];
}

@end
