//
//  YSSelectOnlieOrderTypeBgView.m
//  jingGang
//
//  Created by HanZhongchou on 2017/3/6.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSSelectOnlieOrderTypeBgView.h"
#import "GlobeObject.h"
#import "YSSelectOnlieOrderTypeCell.h"

@interface YSSelectOnlieOrderTypeBgView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *arrayData;

//记录点击了第几行
@property (nonatomic,assign) NSInteger selectIndexPath;
@end

@implementation YSSelectOnlieOrderTypeBgView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
- (instancetype)initWithSelectTypeViewFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    
    self.arrayData = [NSArray arrayWithObjects:@"我的订单",@"套餐券订单",@"代金券订单",@"优惠买单订单",@"扫码支付订单",@"酒店订单", nil];
    UIColor *color = [UIColor blackColor];
    self.backgroundColor = [color colorWithAlphaComponent:0.5];
    
    [self addSubview:self.tableView];
}

- (void)showView{
    self.height = kScreenHeight - 64.0;
    
    [UIView animateWithDuration:0.3 animations:^{
            self.tableView.height = self.arrayData.count * self.tableView.rowHeight;
    }];
    
    
}
- (void)hideView{
    self.height = 0.0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.height = 0.0;
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *selectCell = @"selectCell";
    YSSelectOnlieOrderTypeCell *cell = (YSSelectOnlieOrderTypeCell *)[tableView dequeueReusableCellWithIdentifier:selectCell];
    if (!cell) {
        cell = [[YSSelectOnlieOrderTypeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:selectCell];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    cell.labelSelectTitle.text = self.arrayData[indexPath.row];
    if (indexPath.row == self.selectIndexPath) {
        cell.isSelect = YES;
    }else{
        cell.isSelect = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    YSSelectOnlieOrderTypeCell *cell = (YSSelectOnlieOrderTypeCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    self.selectIndexPath = indexPath.row;
    [self.tableView reloadData];
    
    
    NSString *didSelectStr = self.arrayData[indexPath.row];
    if (self.didSelectCellBlock) {
        self.didSelectCellBlock(indexPath,didSelectStr);
    }
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) style:UITableViewStylePlain];
        _tableView.rowHeight = 48.0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}

@end
