//
//  YSGoMissionController.m
//  jingGang
//
//  Created by HanZhongchou on 16/8/25.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "YSGoMissionController.h"
#import "YSGoMissionTopView.h"
#import "YSGoMissionCell.h"
#import "YSGoMissionModel.h"
#import "YSMyHealthMissonController.h"
#import "MyErWeiMaController.h"
#import "YSRiskLuckController.h"
#import "IntegralNewHomeController.h"
#import "GlobeObject.h"
#import "JGIntegarlCloudController.h"
#import "AppDelegate.h"
#import "YSHealthySelfTestController.h"
#import "DefuController.h"
#import "YSHealthyManageWebController.h"
#import "YSMyHealthMissonController.h"
#import "MyErWeiMaController.h"
#import "YSGestureNavigationController.h"
#import "TZImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZVideoPlayerController.h"
#import "TZImageManager.h"
#import "YSComposeStatusController.h"
#import "YSHealthyManageWebController.h"
#import "JGIntegralValueController.h"
#import "YSLoginManager.h"
#import "YSIntegralSwitchController.h"


@interface YSGoMissionController ()<UITableViewDelegate,UITableViewDataSource,YSGoMissionCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *arrayData;
@property (nonatomic,strong) YSGoMissionTopView *goMissionTopView;
//@property (strong,nonatomic) YSHealthyManageTestLinkConfig *testLinkConfig;

@end

@implementation YSGoMissionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [YSThemeManager setNavigationTitle:@"赚积分" andViewController:self];
    
    [self.view addSubview:self.tableView];
    
    [self tableViewLineRepair:self.tableView];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestUserIntergral];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
     [YSUMMobClickManager endLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

#pragma mark - 用户积分请求
-(void)requestUserIntergral{
    
    @weakify(self);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UsersIntegralGetRequest *request = [[UsersIntegralGetRequest alloc] init:GetToken];
    [self.vapiManager usersIntegralGet:request success:^(AFHTTPRequestOperation *operation, UsersIntegralGetResponse *response) {
        @strongify(self);
        NSDictionary *integralDic = (NSDictionary *)response.integral;
        if (integralDic) {
            NSString *strUserIntegal = [NSString stringWithFormat:@"%@",integralDic[@"integral"]];
            [self.goMissionTopView.buttonIntegral setTitle:strUserIntegal forState:UIControlStateNormal];
            self.goMissionTopView.labelIntegralToday.text = [NSString stringWithFormat:@"%@积分",integralDic[@"integralToday"]];
            self.goMissionTopView.labelIntegralCeiling.text = [NSString stringWithFormat:@"%@积分",integralDic[@"integralCeiling"]];
        }
        
        NSMutableArray *integralTodayArray = [NSMutableArray arrayWithArray:response.integralToday];
        NSMutableArray *integralOtherArray = [NSMutableArray arrayWithArray:response.integralOther];
        //两个数组拼接起来
        [integralTodayArray addObjectsFromArray:integralOtherArray];
        [self diposeGainIntergralListForModelWithArrry:[integralTodayArray copy]];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    
}


- (void)diposeGainIntergralListForModelWithArrry:(NSArray *)dataArray
{
    
    
    [self.arrayData removeAllObjects];
    for (NSInteger i = 0; i < dataArray.count; i++) {
        NSDictionary *dicDetailsList = [NSDictionary dictionaryWithDictionary:dataArray[i]];
        
        [self.arrayData addObject:[YSGoMissionModel objectWithKeyValues:dicDetailsList]];
        
    }
    
    [self.tableView reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    
}


//tableview的线补齐
- (void)tableViewLineRepair:(UITableView *)tableView{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma  mark --- Action
- (void)exchangeButtonClick
{
    IntegralNewHomeController *integralNewHomeController = [[IntegralNewHomeController alloc]init];
    [self.navigationController pushViewController:integralNewHomeController animated:YES];
}


#pragma mark --- UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifile = @"missionCell";
    YSGoMissionCell *cell = (YSGoMissionCell *)[tableView dequeueReusableCellWithIdentifier:identifile];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"YSGoMissionCell" owner:self options:nil];
        cell = [nib lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    YSGoMissionModel *model = self.arrayData[indexPath.row];
    cell.model = model;
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}

#pragma mark --- UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *viewBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 42)];
    viewBg.backgroundColor = UIColorFromRGB(0xf7f7f7);
    
    UIView *viewWhite = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 42)];
    viewWhite.backgroundColor = UIColorFromRGB(0Xf7f7f7);
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(8, 10, 3, 22)];
    view.backgroundColor = rgb(110,186,176,1);
    [viewWhite addSubview:view];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, 200, 18)];
    label.text = @"今日可赚积分列表";
    label.font = [UIFont systemFontOfSize:14.0];
    label.textColor = UIColorFromRGB(0x4a4a4a);
    [viewWhite addSubview:label];
    
//    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, viewWhite.height - 1, kScreenWidth, 1)];
//    viewLine.backgroundColor = UIColorFromRGB(0xf1f1f1);
//    [viewWhite addSubview:viewLine];
//
    [viewBg addSubview:viewWhite];
    
    return viewBg;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 42.0;
}

#pragma mark ---YSGoMissionCellDelegate
- (void)goMissionCellButtonClickWithindexPath:(NSIndexPath *)indexPath
{
    UIViewController *VC;
    YSGoMissionModel *model = self.arrayData[indexPath.row];
    NSString *strType = model.type;
    if ([strType isEqualToString:@"integral_flip_cards"]) {
        //拼手气赚积分
        YSRiskLuckController *riskLuskVC = [[YSRiskLuckController alloc]init];
        riskLuskVC.isComeForGoMissionVC = YES;
        YSGestureNavigationController * nav = [[YSGestureNavigationController alloc]initWithRootViewController:riskLuskVC];
        [self presentViewController:nav animated:YES completion:nil];
        
    }else if([strType isEqualToString:@"integral_jianKangQuan_dianZan"] || [strType isEqualToString:@"integral_jianKangQuan_pingLun"]){
        //点赞      //评论  点击一下啊 ------------------
        switch (self.enterControllerType) {
            case YSEnterEarnInteralControllerWithHealthyManagerMainPage:
            {
                AppDelegate * app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
                [app gogogoWithTag:0];
            }
                break;
            case YSEnterEarnInteralControllerWithRiskLuck:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kSigninDismissPostKey" object:@1];
            }
                break;
            default:
                break;
        }
    }else if([strType isEqualToString:@"integral_jianKangQuan_faTie"] || [strType isEqualToString:@"integral_jianKangQuan_beiPingLun"] || [strType isEqualToString:@"integral_jianKangQuan_beiDianZan"]){
  
        //发帖    //帖子被点赞     //帖子被评论
        [self achievePhotos];

    }else if([strType isEqualToString:@"integral_health_tiJian"]){
        //健康体检
        DefuController *defuVC = [[DefuController alloc] init];
        VC = defuVC;
        
    }else if([strType isEqualToString:@"integral_health_ziCe"]){
        //健康自测
        YSHealthySelfTestController *healthySelfTestController = [[YSHealthySelfTestController alloc] init];
        VC = healthySelfTestController;
        
    }else if([strType isEqualToString:@"integral_health_ceShi"]){
        //健康测试
        NSDictionary *dict = [kUserDefaults objectForKey:kUserCustomerKey];
        YSHealthyManageWebController *testWebController = [[YSHealthyManageWebController alloc] initWithWebType:YSHealthyManageHealthyTestType uid:dict[@"uid"]];
        VC = testWebController;
        
    }else if([strType isEqualToString:@"integral_health_fengXianPingGu"]){
        //疾病风险评估
        YSHealthyManageWebController *illnessTestController = [[YSHealthyManageWebController alloc] initWithWebType:YSHealthyManageIllnessTestType uid:nil];
        VApiManager *manager = [[VApiManager alloc]init];
        HealthManageIndexRequest *request = [[HealthManageIndexRequest alloc] init:GetToken];
        request.api_pageNum = @0;
        request.api_pageSize = @10;
        request.api_postType = @0;
        @weakify(self);
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [manager healthManageIndex:request success:^(AFHTTPRequestOperation *operation, HealthManageIndexResponse *response) {
            @strongify(self);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if([response.errorCode integerValue] == 0){
                YSHealthyManageTestLinkConfig *config = [YSHealthyManageTestLinkConfig linkConfigWithResponse:response];
                illnessTestController.linkConfig = [NSString stringWithFormat:@"%@%@",Base_URL,config.retestURL];
                [self.navigationController pushViewController:illnessTestController animated:YES];
            }else {
               
               
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];

    }else if([strType isEqualToString:@"integral_health_renWu"]){
        //健康任务
        YSMyHealthMissonController *myHealthMissonController = [[YSMyHealthMissonController alloc]init];
        VC = myHealthMissonController;
        
    }else if([strType isEqualToString:@"integral_invite_friends"]){
        //邀请好友
        MyErWeiMaController *erWeiMaVC = [[MyErWeiMaController alloc]init];
        VC = erWeiMaVC;
        
    }else if([strType isEqualToString:@"integral_consumer"]){
        //商城购物
        switch (self.enterControllerType) {
            case YSEnterEarnInteralControllerWithHealthyManagerMainPage:
            {
                AppDelegate * app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
                [app gogogoWithTag:1];
            }
                break;
            case YSEnterEarnInteralControllerWithRiskLuck:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kSigninDismissPostKey" object:@3];
            }
                break;
            default:
                break;
        }
    }else if ([strType isEqualToString:@"integral_o2o_shop"]){
        AppDelegate * app = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        [app gogogoWithTag:3];
    }
    if (VC) {
        [self.navigationController pushViewController:VC animated:YES];
    }
}

- (void)achievePhotos {
    JGLog(@"achievePhotos-");
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePickerVc.allowTakePicture = NO;
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}

#pragma mark -- getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.goMissionTopView.height, kScreenWidth, kScreenHeight - self.goMissionTopView.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorColor:UIColorFromRGB(0Xf7f7f7)];
        _tableView.rowHeight = 50.0;
        _tableView.backgroundColor = UIColorFromRGB(0Xf7f7f7);
        _tableView.tableFooterView = [self loadtableFootView];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    
    return _tableView;
}

- (NSMutableArray *)arrayData
{
    if (!_arrayData) {
        _arrayData = [NSMutableArray array];
    }
    return _arrayData;
}

- (UIView *)loadtableFootView
{
    CGFloat viewBgHeight = 181.0;
    UIView *viewBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,viewBgHeight)];
    viewBg.backgroundColor = UIColorFromRGB(0Xf7f7f7);
    
    CGFloat buttonSpaceY = viewBgHeight - 48.0 - 25;
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(14,buttonSpaceY, kScreenWidth - 28, 48);
//    [button setTitle:@"积分兑换" forState:UIControlStateNormal];
//    button.backgroundColor = [YSThemeManager buttonBgColor];
//    button.layer.cornerRadius = 6.0;
//    [button addTarget:self action:@selector(exchangeButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    button.titleLabel.font = [UIFont systemFontOfSize:20.0];
//    
//    [viewBg addSubview:button];
    
    return viewBg;
}

- (YSGoMissionTopView *)goMissionTopView
{
    if (!_goMissionTopView) {
        _goMissionTopView = BoundNibView(@"YSGoMissionTopView", YSGoMissionTopView);
        [self.view addSubview:_goMissionTopView];
        [_goMissionTopView mas_makeConstraints:^(MASConstraintMaker *make) {
    
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.height.mas_equalTo(500);
           
        }];
         @weakify(self);
        //返回按钮
        _goMissionTopView.backButtonClickBlock = ^{
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        };
        //积分规则跳转
        _goMissionTopView.integralRuleButtonClickBlock = ^{
            @strongify(self);
            JGIntegarlCloudController *jg = [[JGIntegarlCloudController alloc] init];
            jg.RuleValueType = IntegralRuleType;
            [self.navigationController pushViewController:jg animated:YES];
        };
        //跳转积分明细
        _goMissionTopView.goIntegralDetailList = ^{
        @strongify(self);
            JGIntegralValueController *VC = [[JGIntegralValueController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        };
        //跳转积分转换
        _goMissionTopView.gojifenzhuanhuanlist = ^{
            @strongify(self);
              [UIAlertView xf_showWithTitle:@"新功能开发完善中，敬请期待" message:nil delay:2.0 onDismiss:NULL];
//            YSIntegralSwitchController *integralNewHomeVC = [[YSIntegralSwitchController alloc]init];
//            [self.navigationController pushViewController:integralNewHomeVC animated:YES];
        };
        
        _goMissionTopView.gojifenduihuanList = ^{
             @strongify(self);
           
            IntegralNewHomeController *integralNewHomeVC = [[IntegralNewHomeController alloc]init];
            [self.navigationController pushViewController:integralNewHomeVC animated:YES];
        };
        
    
    }
    return _goMissionTopView;
}

#pragma mark -- UIImagePickerControllerDelegate --
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    [self dismissViewControllerAnimated:NO completion:^{
        [self presentControllerWithPhotos:photos assets:nil];
    }];
    JGLog(@"--%s",__func__);
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    JGLog(@"--%s",__func__);
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    JGLog(@"--%s",__func__);
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^{
            [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                    [tzImagePickerVc hideProgressHUD];
                    TZAssetModel *assetModel = [models lastObject];
                    JGLog(@"----assetModel:%@",assetModel);
                }];
            }];
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)presentControllerWithPhotos:(NSArray *)photos assets:(NSArray *)assets {
    YSComposeStatusController *composeStatusController = [[YSComposeStatusController alloc] init];
    composeStatusController.selectedPhotos = [NSMutableArray arrayWithArray:photos];
    @weakify(composeStatusController);
    composeStatusController.composeCallback = ^(){
        
        JGLog(@"composed");
    };
    composeStatusController.cancelCallback = ^(){
        @strongify(composeStatusController);
        [composeStatusController.selectedAssets removeAllObjects];
        [composeStatusController.selectedPhotos removeAllObjects];

    };
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:composeStatusController];
    [self presentViewController:nav animated:NO completion:NULL];
}



@end
