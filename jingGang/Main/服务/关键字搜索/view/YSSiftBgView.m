//
//  YSSiftBgView.m
//  jingGang
//
//  Created by HanZhongchou on 2017/2/21.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSSiftBgView.h"
#import "GlobeObject.h"
#import "Masonry.h"
#import "YSGoodsListSiftCell.h"
#import "YSLoginManager.h"
@interface YSSiftBgView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIView *topLineView;
@property (strong,nonatomic) NSArray *arrayData;
//库存
@property (assign,nonatomic) BOOL isStockSelect;
//包邮
@property (assign,nonatomic) BOOL isFreeFranking;
//是否拼团商品
@property (assign,nonatomic) BOOL isUniteGoods;


@property(nonatomic,strong)UIView *footView;
@end

@implementation YSSiftBgView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
//    self = [[UIView alloc]initWithFrame:CGRectMake(0, 42 + 64, kScreenWidth, 0)];
    
}

- (instancetype)initWithSiftViewFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
- (void)initUI{
    
    UIColor *color = [UIColor blackColor];
    self.backgroundColor = [color colorWithAlphaComponent:0.5];
    
    [self addSubview:self.tableView];
    
    
    self.topLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1.0)];
    self.topLineView.backgroundColor = UIColorFromRGB(0xf3f2f2);
    
    [self addSubview:self.topLineView];
}

- (void)showView{
    self.height = kScreenHeight - 64.0 - 42.0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.height = 211.0;
        self.topLineView.hidden = NO;
    }];
    
    
}
- (void)hideView{
    self.height = 0.0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.height = 0.0;
        self.topLineView.hidden = YES;
    }];
    
    
}
#pragma mark --- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayData.count;;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifile = @"siftCell";
    YSGoodsListSiftCell *cell = (YSGoodsListSiftCell *)[tableView dequeueReusableCellWithIdentifier:identifile];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"YSGoodsListSiftCell" owner:self options:nil];
        cell = [nib lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.labelTitleSift.text = [NSString stringWithFormat:@"%@",self.arrayData[indexPath.row]];
    return cell;
}
#pragma mark --- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YSGoodsListSiftCell *siftCell = (YSGoodsListSiftCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
    siftCell.buttonSelectSsift.selected = !siftCell.buttonSelectSsift.selected;
    if (indexPath.row == 0) {
        
        self.isUniteGoods = siftCell.buttonSelectSsift.selected;
    }else if (indexPath.row == 1){
        self.isStockSelect = siftCell.buttonSelectSsift.selected;
    }else if (indexPath.row == 2){
        self.isFreeFranking = siftCell.buttonSelectSsift.selected;
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}

- (void)confirmButtonClick{
    [self hideView];
    if (self.siftBlock) {
        self.siftBlock(self.isStockSelect,self.isFreeFranking,self.isUniteGoods);
    }
}


- (UIView *)tableViewFootView{
    
    
    _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 1, kScreenWidth, 64)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [YSThemeManager buttonBgColor];
    button.frame = CGRectMake(kScreenWidth - 30 - 82, 16, 82, 30);
    button.layer.cornerRadius = 3.0;
    [button setTitle:@"确定" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_footView addSubview:button];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    lineView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    [_footView addSubview:lineView];
    return _footView;
}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) style:UITableViewStylePlain];
        _tableView.tableFooterView = [self tableViewFootView];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorColor = UIColorFromRGB(0xf1f1f1);
        _tableView.rowHeight = 48.0;
    }
    return _tableView;
}
- (NSArray *)arrayData{
    if (!_arrayData) {
        _arrayData = [NSArray arrayWithObjects:@"拼团商品",@"有库存",@"包邮", nil];
    }
    return _arrayData;
}


@end
