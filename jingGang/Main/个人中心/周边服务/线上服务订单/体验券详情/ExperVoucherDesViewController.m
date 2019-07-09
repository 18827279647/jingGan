//
//  ExperVoucherDesViewController.m
//  jingGang
//
//  Created by 荣旭 on 2019/7/9.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "ExperVoucherDesViewController.h"
#import "GlobeObject.h"
#import "Unit.h"

//头部
#import "UnderFlashTableViewCell.h"

//消费码
#import "ConsumptionCodeTableViewCell.h"

//内容
#import "OrderContentTableViewCell.h"

//地址
#import "AddressinformationTableViewCell.h"

//消费码
#import "ConCodeShowView.h"

@interface ExperVoucherDesViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic)UITableView*mtableview;
@property(nonatomic,strong)NSMutableArray*dataArray;


//中间信息数据
@property (nonatomic) NSArray *titlearray;

//消费码
@property(nonatomic,strong)ConCodeShowView*conCodeView;


@end

@implementation ExperVoucherDesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [YSThemeManager setNavigationTitle:@"订单详情" andViewController:self];
    _titlearray = @[@"订单编号",@"订单状态",@"手机号",@"付款方式",@"付款时间",@"有效期至"];
    [self setUI];
}
-(void)setUI;{
    _mtableview=[[UITableView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-kNarbarH) style:0];
    _mtableview.backgroundColor =JGColor(249, 249, 249, 1);
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
//    self.mtableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//
//    }];
    if (@available(iOS 11.0, *)) {
        _mtableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.mtableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:_mtableview];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==0) {
        return 0;
    }
    return 10;
}
//cell内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    if (indexPath.section==0) {
        static  NSString *reusstring = @"UnderFlashTableViewCell";
        UnderFlashTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:reusstring];
        if (cell==nil) {
            cell=[[NSBundle mainBundle]loadNibNamed:@"UnderFlashTableViewCell" owner:self options:nil][1];
        }
        [cell willCustomDesCellWithData:@{}];
        cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section==1){
        static  NSString *reusstring = @"ConsumptionCodeTableViewCell";
        ConsumptionCodeTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:reusstring];
        if (cell==nil) {
            cell=[[NSBundle mainBundle]loadNibNamed:@"ConsumptionCodeTableViewCell" owner:self options:nil][0];
        }
        [cell consumptionCodeWithData:@{}];
        cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section==2){
        static  NSString *reusstring = @"OrderContentTableViewCell";
        OrderContentTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:reusstring];
        if (cell==nil) {
            cell=[[NSBundle mainBundle]loadNibNamed:@"OrderContentTableViewCell" owner:self options:nil][0];
        }
        cell.namelabel.text = _titlearray[indexPath.row];
        cell.namelabel.font = JGFont(14);
        cell.namelabel.textColor=JGColor(102, 102, 102, 1);
        
        cell.datalabel.textColor=JGColor(51,51,51, 1);
        cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section==3){
        static  NSString *reusstring = @"OrderContentTableViewCell";
        OrderContentTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:reusstring];
        if (cell==nil) {
            cell=[[NSBundle mainBundle]loadNibNamed:@"OrderContentTableViewCell" owner:self options:nil][0];
        }
        cell.namelabel.text = @"总价";
        cell.namelabel.font = JGFont(14);
        cell.namelabel.textColor=JGColor(102, 102, 102, 1);
        cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section==4){
        static  NSString *reusstring = @"AddressinformationTableViewCell";
        AddressinformationTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:reusstring];
        if (cell==nil) {
            cell=[[NSBundle mainBundle]loadNibNamed:@"AddressinformationTableViewCell" owner:self options:nil][0];
        }
        cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section==5){
        static  NSString *reusstring = @"OrderContentTableViewCell";
        OrderContentTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:reusstring];
        if (cell==nil) {
            cell=[[NSBundle mainBundle]loadNibNamed:@"OrderContentTableViewCell" owner:self options:nil][0];
        }
        cell.namelabel.text = @"合计:";
        cell.namelabel.font = JGFont(14);
        cell.namelabel.textColor=JGColor(102, 102, 102, 1);
        cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    UITableViewCell*cell=[UITableViewCell new];
    return cell;
}

//cell 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;{
    if (indexPath.section==1||indexPath.section==0) {
        return 110;
    }
    if (indexPath.section==4) {
        return 130;
    }
    return 50;
}
//cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    if (section==2) {
        return _titlearray.count;
    }
    return 1;
}

//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        if (_conCodeView!=nil) {
            [_conCodeView p_dismissView];
            _conCodeView=nil;
        }
        _conCodeView=[[ConCodeShowView alloc]init];
        [_conCodeView showFlashSaleView:[UIImage imageNamed:@""] with:self with:@selector(showConCode)];
    }
}
//点击消费码的回调，不一定有用
-(void)showConCode;{
    
}
@end
