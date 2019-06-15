//
//  YSShoppingMallController.m
//  jingGang
//
//  Created by whlx on 2019/5/6.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "YSShoppingMallController.h"

#import "RecommendationController.h"

#import "HongBaoTCViewController.h"

#import "ZoneController.h"

#import "YSAFNetworking.h"

#import "ShoppingModel.h"

#import "MJExtension.h"

#import "UIButton+YYWebImage.h"

#import "SPMarqueeView.h"

#import "LampListModel.h"

#import "XRViewController.h"

#import "WSJKeySearchViewController.h"

#import "YSGoodsClassifyController.h"

#import "HWGuidePageManager.h"

#import "GlobeObject.h"

@interface YSShoppingMallController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *NewUserButton;
@property (weak, nonatomic) IBOutlet UIScrollView *TitleScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *ControllerScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TitleScrollViewY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TitleScrollViewX;

//存放标题栏文字
@property (nonatomic, strong) NSMutableArray * AllButtonArrays;
//标记控制器滑动tableview 标题栏重新布局
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ButtonViewY;
@property (nonatomic, assign) NSInteger TempInteger;
//记录偏移值
@property (nonatomic, assign) CGFloat TempContentOffset;

@property (nonatomic, strong) UIView * LineView;
@property (weak, nonatomic) IBOutlet UIView *NewView;

@property (nonatomic, strong) NSMutableArray * DataModelArray;

@property (nonatomic, strong) NSMutableArray * IDArray;

@property (nonatomic, strong) SPMarqueeView * MarqueeView;

@property (nonatomic, strong) NSMutableArray * LampListArray;

@property (nonatomic, weak) UIButton * TempButton;

@end

@implementation YSShoppingMallController


#pragma 懒加载可变数组
- (NSMutableArray *)AllButtonArrays{
    if (!_AllButtonArrays) {
        _AllButtonArrays = [NSMutableArray array];
    }
    return _AllButtonArrays;
}

- (NSMutableArray *)IDArray{
    if (!_IDArray) {
        _IDArray = [NSMutableArray array];
    }
    return _IDArray;
}

- (NSMutableArray *)DataModelArray{
    if (!_DataModelArray) {
        _DataModelArray = [NSMutableArray array];
    }
    return _DataModelArray;
}

- (NSMutableArray *)LampListArray{
    if (!_LampListArray) {
        _LampListArray = [NSMutableArray array];
    }
    return _LampListArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    

    //接收通知(监听) 标题栏上移还是还原
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HiddenScrollView) name:@"HiddenScrollView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShowScrollView) name:@"ShowScrollView" object:nil];
    
    [self SetInit];
    
   
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.NewView.hidden = YES;
    self.TitleScrollView.hidden = YES;
    self.ControllerScrollView.hidden = YES;
    
    self.navigationController.navigationBar.barTintColor =[UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
   
    [self reqeustconfirmJiankangdouReadCount];
    [self reqeustconfirmYouhuiquanReadCount];
    
     [self GETData];
    
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
   
    self.navigationController.navigationBar.barTintColor = COMMONTOPICCOLOR;
}

#pragma 显示新功能引导页
- (void)showGuidePage
{
    // 判断是否已显示过
    if (![[NSUserDefaults standardUserDefaults] boolForKey:HWGuidePageHomeKey]) {
        // 显示
        [[HWGuidePageManager shareManager] showGuidePageWithType:HWGuidePageTypeHome completion:^{
            [[HWGuidePageManager shareManager] showGuidePageWithType:HWGuidePageTypeMajor completion:^{
                [[HWGuidePageManager shareManager] showGuidePageWithType:HWGuidePageTypeThree];
            }];
        }];
    }
}

- (void)GETData{
    
    NSString * url = [NSString stringWithFormat:@"%@%@",ShanrdURL,@"v1/channelTop/channelOneList"];

    NSDictionary * dict = @{@"pageTypeId":@"2"};
    [self.AllButtonArrays removeAllObjects];
    [self.DataModelArray removeAllObjects];
    
    for (UIViewController *  ViewController in self.childViewControllers) {
        [ViewController.view removeFromSuperview];
    }
    
    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
        
    DefineWeakSelf;
    [YSAFNetworking POSTUrlString:url parametersDictionary:dict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        NSString *str  = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData * data=[str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dict =[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
    
        NSArray * dataArray = dict[@"channelList"];
        
        weakSelf.DataModelArray = [ShoppingModel arrayOfModelsFromDictionaries:dataArray error:nil];
    
        //添加子控制器
        [weakSelf SetUpControllerScrollView];
        
        //添加标题按钮
        [weakSelf SetUpTitleButton];
        
        
        
    } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {

        NSLog(@"error---%@",error);
    }];
    
}



//创建视图
- (void)SetInit{

    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(0, 0, K_ScaleWidth(562), 35);
    [searchButton setImage:[UIImage imageNamed:@"sousuo_huise"] forState:UIControlStateNormal];
    [searchButton setTitle:@"请输入商品关键词" forState:UIControlStateNormal];
    searchButton.backgroundColor = [UIColor colorWithHexString:@"F4F4F4"];
    searchButton.titleLabel.font = [UIFont systemFontOfSize:13];
    searchButton.layer.cornerRadius = searchButton.height/2;
    searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    [searchButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = searchButton;
    
    UIButton * left = [[UIButton alloc]initWithFrame:CGRectMake(0, 6,K_ScaleWidth(48), K_ScaleWidth(48))];
    [left setImage:[UIImage imageNamed:@"jump"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(left) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:left];
    
}

- (void)left{
    YSGoodsClassifyController *goodsClassfyVC = [[YSGoodsClassifyController alloc]init];
    goodsClassfyVC.api_classId = nil;
    goodsClassfyVC.superiorSelectIndex = 0;
    goodsClassfyVC.hidesBottomBarWhenPushed   = YES;
    [self.navigationController pushViewController:goodsClassfyVC animated:YES];
}

- (void)searchButtonClick:(UIButton *)button {
    WSJKeySearchViewController *shopSearchVC = [[WSJKeySearchViewController alloc] init];
    shopSearchVC.shopType = searchShopType;
    shopSearchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shopSearchVC animated:YES];
}

-(void)reqeustconfirmJiankangdouReadCount {
    if (GetToken) {
        VApiManager *manager = [[VApiManager alloc] init];
        ConfirmJiankangdouRequest *request = [[ConfirmJiankangdouRequest alloc]init:GetToken];
        @weakify(self);
        
        [manager ConfirmJiankangdou:request success:^(AFHTTPRequestOperation *operation, ConfirmJiankangdouResponse *response) {
            
            @strongify(self);
            if([response.show intValue] ==1){
                
                HongBaoTCViewController * hongbao  = [[HongBaoTCViewController alloc] init];
                hongbao.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                hongbao.titleLabel.text = [NSString stringWithFormat:@"%@元健康豆已放至账户",response.num];
                hongbao.contentLabel.text = @"邀请用户下单奖励";
                hongbao.lable.text = @"健康豆专享";
                hongbao.totalLabel.text = [NSString stringWithFormat:@"¥%@",response.money];
                hongbao.modalPresentationStyle = UIModalPresentationCustom;
                hongbao.nav = self.navigationController;
                hongbao.isJK = YES;
                self.modalPresentationStyle = UIModalPresentationCustom;
                [self presentViewController:hongbao animated:YES completion:^{
                    
                    
                }];
                
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
    }
}

-(void)reqeustconfirmYouhuiquanReadCount {
    if (GetToken) {
        VApiManager *manager = [[VApiManager alloc] init];
        confirmYouhuiquanRequest *request = [[confirmYouhuiquanRequest alloc]init:GetToken];
        @weakify(self);
        
        [manager confirmYouhuiquan:request success:^(AFHTTPRequestOperation *operation, ConfirmJiankangdouResponse *response) {
            
            @strongify(self);
            if([response.show intValue] ==1){
                HongBaoTCViewController * hongbao  = [[HongBaoTCViewController alloc] init];
                hongbao.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                hongbao.titleLabel.text = [NSString stringWithFormat:@"%@张优惠券已放至账户",response.num];
                
                hongbao.contentLabel.text = @"优惠券限时，快去使用吧!";
                hongbao.lable.text = @"专享优惠券";
                hongbao.nav = self.navigationController;
                hongbao.totalLabel.text = [NSString stringWithFormat:@"¥%@",response.money];
                hongbao.modalPresentationStyle = UIModalPresentationCustom;
                
                self.modalPresentationStyle = UIModalPresentationCustom;
                [self presentViewController:hongbao animated:YES completion:^{
                    
                    
                }];
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
    }
}

#pragma 标题栏上移
- (void)HiddenScrollView{
    if (self.TempInteger == 0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.TitleScrollViewY.constant = - self.NewUserButton.height;
            self.ButtonViewY.constant = - self.NewUserButton.height;
            [self.view layoutIfNeeded];
            
        }];
        self.TempInteger = 1;
    }
}

#pragma 标题栏还原
- (void)ShowScrollView{
    if (self.TempInteger == 1) {
        [UIView animateWithDuration:0.5 animations:^{
            self.TitleScrollViewY.constant = 0;
            self.ButtonViewY.constant = 0;
            [self.view layoutIfNeeded];
        }];
        self.TempInteger = 0;
    }
}



#pragma 设置标题栏按钮文字
- (void)SetUpTitleButton{

    NSInteger count = self.childViewControllers.count;
    
    CGFloat titleWidth = K_ScaleWidth(166);
    //    //每个内容页面占据的高度
    CGFloat contentH = self.ControllerScrollView.height;
    
    for (NSInteger i = 0; i < count; i++) {
        
        //先拿到对应的子控制器
        UIViewController * controller = self.childViewControllers[i];
        controller.view.frame = CGRectMake(i * kScreenWidth, 0,kScreenWidth, contentH);
        [self.ControllerScrollView addSubview:controller.view];

        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;

        button.titleLabel.font = [UIFont systemFontOfSize:15];

        [button setTitle:controller.title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];

        //设置每一个按钮的frame
        CGFloat X = i * titleWidth;
        
        button.frame = CGRectMake(X, 0, titleWidth, self.TitleScrollView.height);
        [self.TitleScrollView addSubview:button];
        [self.AllButtonArrays addObject:button];

        //监听点击事件
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    
    //设置标题滚动区的范围
    self.TitleScrollView.contentSize = CGSizeMake(titleWidth * count, 0);
    self.TitleScrollView.showsHorizontalScrollIndicator = NO;
    //设置内容滚动区的范围
    self.ControllerScrollView.contentSize = CGSizeMake(kScreenWidth * count, 0);
    self.ControllerScrollView.showsHorizontalScrollIndicator = NO;
    self.ControllerScrollView.pagingEnabled = YES;
    //设置标题初始化状态
    UIButton * FirstButton = self.AllButtonArrays.firstObject;
    [FirstButton setTitleColor:[UIColor colorWithHexString:@"65BBB1"] forState:UIControlStateNormal];
    self.TempButton = FirstButton;
    [self titleClick:FirstButton];

    self.LineView = [[UIView alloc]initWithFrame:CGRectMake(0,self.TitleScrollView.height - K_ScaleWidth(4), FirstButton.width,K_ScaleWidth(4))];
    self.LineView.backgroundColor = [UIColor colorWithHexString:@"65BBB1"];

    [self.TitleScrollView addSubview:self.LineView];
    
    
   [self showGuidePage];
    
}

-(CGFloat)widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height
{
    UIFont *font=[UIFont boldSystemFontOfSize:fontSize];
    CGRect sizeToFit = [value boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{                                                                                        NSFontAttributeName:font} context:nil];
    
    return sizeToFit.size.width;
}

#pragma 添加子控制器
- (void)SetUpControllerScrollView{
    
    self.TitleScrollView.hidden = NO;
    self.ControllerScrollView.hidden = NO;
    
    ShoppingModel * model = self.DataModelArray.firstObject;
    self.TitleScrollView.backgroundColor = [UIColor whiteColor];
    self.NewView.backgroundColor = [UIColor whiteColor];
    if ([model._id integerValue ] == 1) {
        self.NewView.hidden = NO;
        self.NewUserButton.backgroundColor = [UIColor whiteColor];
        self.TitleScrollViewX.constant = 80;
        [self.NewUserButton setImageWithURL:[NSURL URLWithString:model.headImg] forState:UIControlStateNormal placeholder:nil];
        self.NewUserButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [self.NewUserButton.layer addAnimation:[self scale:[NSNumber numberWithFloat:0.9f] orgin:[NSNumber numberWithFloat:1.2f] durTimes:0.5f Rep:MAXFLOAT] forKey:nil];
    }else {
        self.NewView.hidden = YES;
        self.TitleScrollViewX.constant = - self.NewView.width;
    }
    
    for (NSInteger i = 0; i < self.DataModelArray.count; i++) {
        ShoppingModel * model = self.DataModelArray[i];
        if (self.NewView.hidden) {
            if (i == 0) {
                RecommendationController * dation = [[RecommendationController alloc]init];
                dation.title = model.channelName;
                dation.channelOneId = model._id;
                [self addChildViewController:dation];
                
            }else {
                ZoneController * zone = [[ZoneController alloc] init];
                zone.title = model.channelName;
                zone.channelOneId = model._id;
                [self addChildViewController:zone];
            }
        }else{
        
            if (i == 1) {
                RecommendationController * dation = [[RecommendationController alloc]init];
                dation.title = model.channelName;
                dation.channelOneId = model._id;
                [self addChildViewController:dation];
            }else if (i > 1){
                ZoneController * zone = [[ZoneController alloc]init];
                zone.title = model.channelName;
                zone.channelOneId = model._id;
                [self addChildViewController:zone];
            }
        }
        
        
        
        
    }
   
    
    
    
    
    
    
    
}

#pragma 按钮的点击事件
- (void)titleClick:(UIButton *)sender{
    //标题文字滚动区，选中的标题自动回根据情况移动居中
    [self TitleScrollViewChangeWithButtonTag:sender.tag];
    
    //controller 滚动区
    [self ContentScrollViewChangeWithButtonTag:sender.tag];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.LineView.x = sender.x;
    }];

    
}

#pragma 标题文字 根据角标变化
- (void)TitleScrollViewChangeWithButtonTag:(NSInteger)sender{
    [self.TempButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    UIButton * button = self.AllButtonArrays[sender];
    [button setTitleColor:[UIColor colorWithHexString:@"65BBB1"] forState:UIControlStateNormal];
    self.TempButton = button;
    //计算出当前应该设置的偏移量
    CGFloat offset = button.center.x - (kScreenWidth - self.NewView.width) * 0.5;
    
    if (offset < 0) {
        offset = 0;
    }
    
    CGFloat maxOffset = self.TitleScrollView.contentSize.width - (kScreenWidth - self.NewView.width);
    
    if (offset > maxOffset) {
        offset = maxOffset;
    }
    
    //动态设置标题滚动区的偏移量
    [self.TitleScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.LineView.x = button.x;
    }];
    
}
#pragma 内容滚动区
- (void)ContentScrollViewChangeWithButtonTag:(NSInteger)tag{
    ShoppingModel * model = self.DataModelArray[tag];
    //创建通知
    NSNotification * Notification = [NSNotification notificationWithName:@"刷新数据" object:model.channelTypeId];
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotification:Notification];
    
    //计算当前内容区域的偏移量
    CGFloat offset = kScreenWidth * tag;

    [self.ControllerScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
    
    
    
}

#pragma scrllview 滑动事件
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //通过偏移量来计算当前几页
    NSInteger i = scrollView.contentOffset.x / kScreenWidth;
    
    //结束页面滚动，重新设置title按钮的位置
    [self TitleScrollViewChangeWithButtonTag:i];
    
    //判断左右滑动
    if (scrollView.contentOffset.x < self.TempContentOffset || scrollView.contentOffset.x > self.TempContentOffset) {
        [UIView animateWithDuration:0.5 animations:^{
            self.TitleScrollViewY.constant = 0;
            self.ButtonViewY.constant = 0;
            [self.view layoutIfNeeded];
        }];
    }
    
    
    
    
}

#pragma 图片缩小放大动画
- (CABasicAnimation *)scale:(NSNumber *)Multiple orgin:(NSNumber *)orginMultiple durTimes:(float)time Rep:(float)repertTimes{
    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = Multiple;
    animation.toValue = orginMultiple;
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = repertTimes;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    return animation;
    
}

#pragma 新人专享按钮
- (IBAction)Click:(UIButton *)sender {
    
    XRViewController * XRView = [[XRViewController alloc]init];
    XRView.navigationController.navigationBar.barTintColor =[UIColor whiteColor];
    [self.navigationController pushViewController:XRView animated:YES];
}



@end
