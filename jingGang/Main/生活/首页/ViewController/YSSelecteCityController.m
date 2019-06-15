//
//  YSSelecteCityController.m
//  jingGang
//
//  Created by dengxf on 16/11/23.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "YSSelecteCityController.h"
#import "YSSelecteCityView.h"
#import "YSLocationManager.h"
#import "AppDelegate.h"
#import "PYSearch.h"
#import "UIImage+SizeAndTintColor.h"
#import "UIImage+YYAdd.h"

@interface YSSelecteCityController ()<YSSelecteCityViewDelegate,PYSearchViewControllerDelegate>

@property (strong,nonatomic) NSArray *cities;
@property (copy , nonatomic) id_block_t selectedCallback;
@property (assign, nonatomic) BOOL showHeaderView;
@property (strong,nonatomic) PYSearchViewController *searchViewController;

@end

@implementation YSSelecteCityController

- (instancetype)initWithCities:(NSArray *)cities selected:(id_block_t)selectedCallback showHeaderView:(BOOL)show
{
    self = [super init];
    if (self) {
        self.cities = cities;
        self.selectedCallback = selectedCallback;
        self.showHeaderView = show;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    [SVProgressHUD show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    [self hiddenNavBarPopButton];
    NSString *title;
    JGLog(@"---%@",[YSLocationManager sharedInstance].cityName);
    if ([[YSLocationManager sharedInstance].cityName isEmpty]) {
        title = @"深圳市";
    }else {
        title = [YSLocationManager sharedInstance].cityName;
    }
    [YSThemeManager setNavigationTitle:[NSString stringWithFormat:@"当前城市-%@",title] andViewController:self];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.width = 44.;
    button.height = button.width;
    [button setImage:[UIImage imageNamed:@"ys_near_selectecity_close"] forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -16);
    @weakify(self);
    [button addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        @strongify(self);
        if (self.showHeaderView) {
            AppDelegate *appDelegate = kAppDelegate;
            [appDelegate gogogoWithTag:0];
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    YSSelecteCityView *selecteCityView =[[YSSelecteCityView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBarHeight) citys:self.cities selected:^(id obj) {
        @strongify(self);
        BLOCK_EXEC(self.selectedCallback,obj);
        [self.navigationController popViewControllerAnimated:YES];
    } showHeaderView:self.showHeaderView];
    selecteCityView.delegate = self;
    [self.view addSubview:selecteCityView];
}

#pragma mark YSSelecteCityViewDelegate
- (void)didClickSearckWithSelecteCityView:(YSSelecteCityView *)selecteCityView {
    // 1.创建热门搜索
    NSArray *hotSeaches = @[];
    @weakify(self);
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"搜索城市" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText, BOOL didSelecteSuggestCell,NSDictionary *selectedSuggestDict) {
        // 开始搜索执行以下代码
        @strongify(self);
        if (didSelecteSuggestCell) {
            JGLog(@"--- 选择建议列表Cell");
            JGLog(@"--- suggestDict:%@",selectedSuggestDict);
            [self didSelecteSuggestCellWithDict:selectedSuggestDict];
        }else {
            JGLog(@"--- 选择城市列表");
        }
        JGLog(@"点击搜索---searchText:%@",searchText);
    }];
    searchViewController.hotSearchStyle = PYHotSearchStyleNormalTag; // 热门搜索风格根据选择
    searchViewController.searchHistoryStyle = PYHotSearchStyleDefault; // 搜索历史风格为default
    // 4. 设置代理
    searchViewController.delegate = self;
    UIImage *shotImage = [[UIImage snapshot:self.view] imageByBlurWithTint:[[UIColor whiteColor] colorWithAlphaComponent:0.8]];
    searchViewController.shotImage = shotImage;
    self.searchViewController = searchViewController;
    // 5. 跳转到搜索控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    searchViewController.navigationController.navigationBar.barTintColor = JGColor(247, 247, 247, 1);
    [self presentViewController:nav animated:YES completion:NULL];
}

- (void)didSelecteSuggestCellWithDict:(NSDictionary *)dict {
    [self.searchViewController dismissViewControllerAnimated:YES completion:NULL];
    [SVProgressHUD show];
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        [SVProgressHUD dismiss];
        BLOCK_EXEC(self.selectedCallback,dict);
        [self.navigationController popViewControllerAnimated:YES];
    });
}

#pragma mark - PYSearchViewControllerDelegate
- (void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText
{
    JGLog(@"模拟搜索----searchText:%@",searchText);
    if (searchText.length) { // 与搜索条件再搜索
        // 根据条件发送查询（这里模拟搜索）
        @weakify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 搜素完毕
            // 显示建议搜索结果
            @strongify(self);
            [self matchCitiesWithSearchText:searchText results:^(NSArray* obj) {
                JGLog(@"---result");
                JGLog(@"obj:%@",obj);
                searchViewController.searchSuggestions = obj;
            }];
        });
    }
}

- (void)matchCitiesWithSearchText:(NSString *)searchText results:(id_block_t)results{
    if (!self.cities.count) {
        BLOCK_EXEC(results,@[]);
    }
    @weakify(self);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @strongify(self);
        NSMutableArray *matchResults = [NSMutableArray array];
        for (NSArray *indexs in self.cities) {
            for (NSDictionary *indexDict in indexs) {
                NSString *areaName = [indexDict objectForKey:@"areaName"];
                if ([areaName isEqualToString:searchText] || [areaName containsString:searchText]) {
                    [matchResults xf_safeAddObject:indexDict];
                }
                NSInteger enumIndex = [self.cities indexOfObject:indexs];
                if (enumIndex == (self.cities.count - 1)) {
                    // 遍历最后一组
                    NSDictionary *enumLastDict = [indexs lastObject];
                    NSString *enumLastId = [NSString stringWithFormat:@"%@",[enumLastDict objectForKey:@"id"]];
                    NSString *enumId = [NSString stringWithFormat:@"%@",[indexDict objectForKey:@"id"]];
                    if ([enumLastId isEqualToString:enumId]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            BLOCK_EXEC(results,[matchResults copy]);
                        });
                    }
                }
            }
        }
    });
}

-(void)dealloc {
    
}


@end

