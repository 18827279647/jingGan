//
//  YSPersonalCircleController.m
//  jingGang
//
//  Created by dengxf on 16/8/8.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSPersonalCircleController.h"
#import "YSFriendCircleRequestManager.h"
#import "YSCirclePersonalInfoView.h"
#import "YSFriendCircleCell.h"
#import "YSFriendCircleModel.h"

@interface YSPersonalCircleController ()<UITableViewDelegate,UITableViewDataSource>

@property (copy , nonatomic) NSString *uid;
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *dataArray;
@property (strong,nonatomic) NSMutableArray *photos;

@end

@implementation YSPersonalCircleController

- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat tableX = 0;
        CGFloat tableY = 0;
        CGFloat tableW = ScreenWidth;
        CGFloat tableH = ScreenHeight;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(tableX, tableY, tableW, tableH) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSMutableArray *)photos {
    if (!_photos) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (instancetype)initWithUid:(NSString *)uid
{
    self = [super init];
    if (self) {
        self.uid = uid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    self.view.backgroundColor = JGBaseColor;
    [super basicBuild];
    [YSThemeManager setNavigationTitle:@"个人信息" andViewController:self];
    [self buildRequest];
}

- (void)buildRequest {
//    [YSFriendCircleRequestManager postListWithPostName:@"游泳" success:^(NSArray *lists){
//        
//    } fail:^{
//        
//    } error:^{
//        
//    }];
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
//    @weakify(self);
//    [YSFriendCircleRequestManager circlePersonalInfomationWithUid:self.uid pageNum:<#(NSInteger)#> pageSize:<#(NSInteger)#> success:<#^(NSArray *, YSCircleUserInfo *)successCallback#> fail:<#^(void)failCallback#> error:<#^(void)errorCallback#> success:^(NSArray *lists,YSCircleUserInfo *userInfo){
//        @strongify(self);
//        YSCirclePersonalInfoView *infoView = [[YSCirclePersonalInfoView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200) configData:userInfo];
//        [self.view addSubview:infoView];
//        [self.dataArray removeAllObjects];
//        [self.dataArray xf_safeAddObjectsFromArray:lists];
//        self.tableView.tableHeaderView = infoView;
//        [self.tableView reloadData];
//    } fail:^{
//        
//    } error:^{
//        
//    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YSFriendCircleFrame *frame = [self.dataArray xf_safeObjectAtIndex:indexPath.row];
    return frame.cellHeight;;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSFriendCircleCell *cell = [YSFriendCircleCell setupCellWithTableView:tableView indexPath:indexPath];
    [self configCell:cell cellForRowAtIndexPath:indexPath];
    return cell;
}

- (void)configCell:(YSFriendCircleCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YSFriendCircleFrame *frame = [self.dataArray xf_safeObjectAtIndex:indexPath.row];
    cell.circleFrame = frame;
    YSFriendCircleModel *friendCircleModel = frame.friendCircleModel;
    @weakify(self);
    /**
     *  进入详情 */
    cell.friendCircleClickCallback = ^(ToolsButtonsClickType type) {
        @strongify(self);
        [self fixesToolsActionWithType:type indexPath:indexPath];
    };
    
    cell.clickImageCallback = ^(NSInteger imageIndex) {

    };
    
    cell.clickUserIconCallback = ^{
        @strongify(self);
        YSPersonalCircleController *personalInfoController = [[YSPersonalCircleController alloc] initWithUid:friendCircleModel.uid];
        [self.navigationController pushViewController:personalInfoController animated:YES];
    };
    
    cell.clickTopicCallback = ^(NSString *topic) {
        
        JGLog(@"click:%@",topic);
    };
}

- (void)fixesToolsActionWithType:(ToolsButtonsClickType)type indexPath:(NSIndexPath *)indexPath {
    YSFriendCircleFrame *frame = [self.dataArray xf_safeObjectAtIndex:indexPath.row];
    YSFriendCircleModel *friendCircleModel = frame.friendCircleModel;
    NSString *postId = friendCircleModel.postId;
    
    JGLog(@"frame:%@",frame);
    
    switch (type) {
        case ToolsButtonClickWithShareType:
            
            break;
        case ToolsButtonClickWithConmmentType:
            
            break;
        case  jubaoButtonClickWithAgreeType:
            
        JGLog(@"点击有反应吗");
            
            break;
        case ToolsButtonClickWithAgreeType:
        {
            /**
             *  点赞、取消点赞处理 */
            JGLog(@"赞处理---");
            
            
            
            [YSFriendCircleRequestManager agreeWithPostId:[postId integerValue] success:^{
                
                [self showSuccessHudWithText:@"点赞成功"];
                
            } fail:^{
                
                [self showSuccessHudWithText:@"点赞失败"];
                
            } error:^{
                [self showSuccessHudWithText:@"网络错误"];
                
            }];
            
        }
            break;
        default:
            break;
    }
    
}

@end
