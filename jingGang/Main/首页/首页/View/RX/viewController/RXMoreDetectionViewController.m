//
//  RXMoreDetectionViewController.m
//  jingGang
//
//  Created by 荣旭 on 2019/6/20.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "RXMoreDetectionViewController.h"
//个人信息
#import "RXUserInfoVIew.h"
#import "GlobeObject.h"
#import "RXTabViewHeightObjject.h"

#import "RXParamDetailResponse.h"
#import "Unit.h"
//#import "WRNavigationBar.h"
//首页
#import "RXYuHeadView.h"

#import "RXHealthyTableViewCell.h"

#import "RxMoreDetectionShowView.h"

//默认有12个分组，根据数据添加,
#define headIndex 0

@interface RXMoreDetectionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic)UITableView*mtableview;
@property(nonatomic,strong)NSMutableArray*dataArray;
@property(nonatomic,strong)RXParamDetailResponse*paramResponse;

@property(nonatomic,strong)RxMoreDetectionShowView*moreView;

@end

@implementation RXMoreDetectionViewController

-(void)viewWillAppear:(BOOL)animated;{
    [super viewWillAppear:animated];
//    [self wr_setNavBarBackgroundImage:[self buttonImageFromColor:JGColor(101, 187, 177, 1)]];
//    [self wr_setNavBarShadowImageHidden:true];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [YSThemeManager setNavigationTitle:@"更多检测" andViewController:self];
    [self setUI];
}
-(void)setUI;{
    
    if (!self.moreView) {
        self.moreView=[[[NSBundle mainBundle]loadNibNamed:@"RxMoreDetectionShowView" owner:self options:nil]firstObject];
        self.moreView.frame=CGRectMake(0,0,kScreenWidth,160);
        self.moreView.backImage.backgroundColor=JGColor(101, 187, 177, 1);
    }
    [self.view addSubview:self.moreView];
    self.dataArray=[[NSMutableArray alloc]init];
    [self.dataArray addObject:@{@"itemName":@"运动步数",@"mySelectType":@"false",@"myZhankaiType":@"false",@"itemCode":@12}];
    [self.dataArray addObject:@{@"itemName":@"血压",@"mySelectType":@"false",@"myZhankaiType":@"false",@"itemCode":@4}];
    [self.dataArray addObject:@{@"itemName":@"血糖",@"mySelectType":@"false",@"myZhankaiType":@"false",@"itemCode":@9}];
    [self.dataArray addObject:@{@"itemName":@"体重",@"mySelectType":@"false",@"myZhankaiType":@"false",@"itemCode":@16}];
    
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    int myhight=statusRect.size.height;
    _mtableview=[[UITableView alloc]initWithFrame:CGRectMake(0,160-kNarbarH,kScreenWidth,kScreenHeight-160) style:0];
    _mtableview.tableFooterView = [UIView new];
    _mtableview.backgroundColor =[UIColor whiteColor];
    _mtableview.delegate = self;
    _mtableview.dataSource = self;
    _mtableview.sectionFooterHeight =1;
    _mtableview.estimatedRowHeight = 1;
    _mtableview.estimatedSectionHeaderHeight = 1;
    _mtableview.estimatedSectionFooterHeight = 1;

    if (@available(iOS 11.0, *)) {
        _mtableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.mtableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:_mtableview];
}

/****tabview代理方法*****/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    
    //dataarray为默认显示数据，+1是给其他更多的分组
    if (self.dataArray.count>0) {
        return headIndex+self.dataArray.count;
    }
    //默认不显示数组
    return headIndex;
}
//cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.dataArray.count>0) {
   
        return [RXTabViewHeightObjject getTabviewNumber:self.dataArray[section] with:self.paramResponse];
        
    }
    return 0;
}
//cell 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count>0) {
        if(indexPath.row==0){
            return [RXTabViewHeightObjject getTabViewHeight:self.dataArray[indexPath.section]];
        }
        
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.dataArray.count>0) {
        NSMutableDictionary*dic=self.dataArray[section];
        NSMutableDictionary*keyValue=[Unit ParseJSONObject:dic[@"keyValue"]];
        if (keyValue.count>0) {
            return 100;
        }
        return 80;
    }
    return 0.01;
}
//设置分组间隔
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==0) {
        return 0.01;
    }
    if (section<self.dataArray.count){
        return 0.01;
    }
    return 10;
}
//cell内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    if (self.dataArray.count>0) {
        //显示展示那4个
        if ([Unit JSONBool:self.dataArray[indexPath.section] key:@"myZhankaiType"]) {
            static  NSString *reusstring = @"RXZhangKaiTableViewCell";
            RXHealthyTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:reusstring];
            if (cell==nil) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"RXZhangKaiTableViewCell" owner:self options:nil]firstObject];
            }
            cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    UITableViewCell*cell=[[UITableViewCell alloc]init];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (self.dataArray.count>0) {
        //先判断是否可以展开
        NSMutableDictionary*dic=self.dataArray[section];
        
        RXYuHeadView*rxheadView=[[[NSBundle mainBundle]loadNibNamed:@"RXYuHeadView" owner:self options:nil]firstObject];
        rxheadView.userInteractionEnabled=YES;
        rxheadView.backgroundColor=[UIColor whiteColor];
        rxheadView.iconImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_image",[Unit JSONString:dic key:@"itemCode"]]];
        rxheadView.titelabel.text=self.dataArray[section][@"itemName"];
        rxheadView.backImage.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
        rxheadView.backImage.layer.cornerRadius = 8;
        rxheadView.backImage.layer.shadowColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:0.9].CGColor;
        rxheadView.backImage.layer.shadowOffset = CGSizeMake(0,0);
        rxheadView.backImage.layer.shadowOpacity = 1;
        rxheadView.backImage.layer.shadowRadius = 10;
        
        rxheadView.addButton.hidden=YES;
        rxheadView.laiyuanlabel.hidden=YES;
        rxheadView.timeLabel.hidden=YES;
        rxheadView.shuominglabel.hidden=YES;
        rxheadView.zhangkileft.constant=-42;
        rxheadView.danweilabel.hidden=YES;
        NSMutableDictionary*keyValue=[Unit ParseJSONObject:dic[@"keyValue"]];
        //判断是否有数据
        if (keyValue.count>0) {
            rxheadView.headTop.constant=20;
            //判断是否有异常数据
            if ([Unit JSONInt:dic key:@"execption"]==1) {
                rxheadView.addButton.hidden=NO;
                rxheadView.zhangkileft.constant=10;
            }
        }else{
            rxheadView.headTop.constant=70/2-12;
        }
        //赋值
        if (keyValue.count>0) {
            //当有数据时统一配置
            rxheadView.shujulabel.textColor=JGColor(101, 187, 177, 1);
            [rxheadView.shujulabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
            
            rxheadView.laiyuanlabel.hidden=NO;
            rxheadView.timeLabel.hidden=NO;
            rxheadView.danweilabel.hidden=NO;
            rxheadView.danweilabel.text=[Unit JSONString:dic key:@"unit"];
            rxheadView.danweilabel.textColor=JGColor(136, 136, 136, 1);
            if ([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"血压"]) {
                rxheadView.shujulabel.text=[NSString stringWithFormat:@"%@/%@",[Unit JSONString:keyValue key:@"highValue"],[Unit JSONString:keyValue key:@"lowValue"]];
                if ([Unit JSONInt:dic key:@"execption"]==1) {
                    rxheadView.shuominglabel.hidden=NO;
                    rxheadView.shuominglabel.text=[Unit JSONString:dic key:@"testgrade"];
                    rxheadView.shuominglabel.textColor=JGColor(239, 82, 80, 1);
                }else{
                    rxheadView.shuominglabel.hidden=YES;
                }
            }else if ([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"血脂"]) {
                rxheadView.shujulabel.text=[NSString stringWithFormat:@"%@",[Unit JSONString:keyValue key:@"inValue"]];
                if ([Unit JSONInt:dic key:@"execption"]==1) {
                    rxheadView.shuominglabel.hidden=YES;
                    rxheadView.shuominglabel.text=[Unit JSONString:dic key:@"testgrade"];
                    rxheadView.shuominglabel.textColor=JGColor(239, 82, 80, 1);
                }else{
                    rxheadView.shuominglabel.hidden=YES;
                }
            }else{
                rxheadView.shujulabel.text=[NSString stringWithFormat:@"%@",[Unit JSONString:keyValue key:@"inValue"]];
                rxheadView.shuominglabel.hidden=YES;
            }
        }
        rxheadView.addButton.tag=section;
        rxheadView.addButton.userInteractionEnabled=YES;
        //            [rxheadView.addButton addTarget:self action:@selector(rxheadViewAddButton:) forControlEvents:UIControlEventTouchUpInside];
        rxheadView.zhangkiaButton.tag=10000+section;
        [rxheadView.zhangkiaButton addTarget:self action:@selector(rxheadViewZhankaiButton:) forControlEvents:UIControlEventTouchUpInside];
        
        return rxheadView;
    }
    return [UIView new];
}
//首页展开
-(void)rxheadViewZhankaiButton:(UIButton*)button;{
    button.selected = !button.selected;
    NSDictionary*dic1=self.dataArray[button.tag-10000];
    NSMutableDictionary*dic=[[NSMutableDictionary alloc]initWithDictionary:dic1];
    if ([Unit JSONBool:dic key:@"myZhankaiType"]) {
        [dic setObject:[NSNumber numberWithBool:false] forKey:@"myZhankaiType"];
    }else{
        [dic setObject:[NSNumber numberWithBool:true] forKey:@"myZhankaiType"];
    }
    [dic setObject:[NSNumber numberWithBool:false] forKey:@"mySelectType"];
    [self.dataArray replaceObjectAtIndex:button.tag-10000 withObject:dic];
    [self.mtableview reloadData];
}

@end
