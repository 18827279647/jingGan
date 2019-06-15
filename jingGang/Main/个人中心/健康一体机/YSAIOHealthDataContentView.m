//
//  YSAIOHealthDataContentView.m
//  jingGang
//
//  Created by dengxf on 2017/8/31.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSAIOHealthDataContentView.h"
#import "YSAIODataContentCell.h"
#import "YSAIODataItem.h"

@interface YSAIOHealthDataContentView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation YSAIOHealthDataContentView

- (YSAIOTableViewHeaderView *)aioHearderView {
    if (!_aioHearderView) {
        _aioHearderView = [[YSAIOTableViewHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 90.)];
        @weakify(self);
        _aioHearderView.selectedTimeCallback = ^(NSString *currentButtonTitle){
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(contentView:didSelectTime:)]) {
                [self.delegate contentView:self didSelectTime:currentButtonTitle];
            }
        };
    }
    return _aioHearderView;
}


- (void)setDataItem:(YSAIODataItem *)dataItem {
    _dataItem = dataItem;
    [self.aioHearderView configHeaderDate:dataItem.aioDataMO.time];
    [self.tableView reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self setup];
    }
    return self;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60.;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = JGBaseColor;
        _tableView.separatorColor = [UIColor colorWithHexString:@"#F1F1F1"];
        [self addSubview:_tableView];
    }
    return _tableView;
}

- (void)setup {
    self.tableView.tableHeaderView = self.aioHearderView;
    @weakify(self);
    self.tableView.mj_header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        BLOCK_EXEC(self.tableViewRefreshCallback);
    }];
}

- (void)endTableViewRefresh {
    [self.tableView.mj_header endRefreshing];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSAIODataContentCell *cell = [YSAIODataContentCell setupCellWithTableView:tableView indexPath:indexPath];
    cell.dataItem = self.dataItem;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *spliceUrl;
    NSString *itemTitle;
    NSString *characteristicCode;
    /**
     *  
     一体机数据说明：
     特征码
     yiti_pappblood  --血压
     yiti_ecd        --心电图
     yiti_pappoximeter --血氧
     yiti_ua     --尿酸
     yiti_tc    --总胆固醇
     yiti_bodyt  --体温
     yiti_bloodsugar 血糖
     */
    switch (indexPath.row) {
        case 0:
        {
            spliceUrl = self.dataItem.aioDataMO.hrUrl;
            itemTitle = @"心电图";
            characteristicCode = @"yiti_ecd";
        }
            break;
        case 1:
        {
            spliceUrl = self.dataItem.aioDataMO.gluUrl;
            itemTitle = @"血糖";
            characteristicCode = @"yiti_bloodsugar";
        }
            break;
        case 2:
        {
            spliceUrl = self.dataItem.aioDataMO.sysDiaUrl;
            itemTitle = @"血压";
            characteristicCode = @"yiti_pappblood";
        }
            break;
        case 3:
        {
            spliceUrl = self.dataItem.aioDataMO.spoUrl;
            itemTitle = @"血氧";
            characteristicCode = @"yiti_pappoximeter";
        }
            break;
        case 4:
        {
            spliceUrl = self.dataItem.aioDataMO.uaUrl;
            itemTitle = @"尿酸";
            characteristicCode = @"yiti_ua";
        }
            break;
        case 5:
        {
            spliceUrl = self.dataItem.aioDataMO.cholUrl;
            itemTitle = @"总胆固醇";
            characteristicCode = @"yiti_tc";
        }
            break;
        case 6:
        {
            spliceUrl = self.dataItem.aioDataMO.tpUrl;
            itemTitle = @"体温";
            characteristicCode = @"yiti_bodyt";
        }
            break;
        default:
            break;
    }
    if ([self.delegate respondsToSelector:@selector(contentView:didSelecteDetailRowWithUrl:itemTitle:characteristicCode:)]) {
        [self.delegate contentView:self didSelecteDetailRowWithUrl:spliceUrl itemTitle:itemTitle characteristicCode:characteristicCode];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
