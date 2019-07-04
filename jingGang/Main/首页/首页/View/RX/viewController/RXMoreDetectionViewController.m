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

#import "RXAllParamDatasResponse.h"

#import "YSMultipleTypesTestController.h"

#import "examineResultViewController.h"
#import "menuViewController.h"
#import "HearingTestVC.h"

#import "RXWmViewController.h"

#import "RXMoreWebViewController.h"

//听力
#import "blindnessResultViewController.h"
//视力
#import "examineResultViewController.h"
//肺活量
#import "WSJLungResultViewController.h"
#import "YSStepManager.h"
#import "RXLISHIViewController.h"

#import "YSStepManager.h"

//默认有12个分组，根据数据添加,
#define headIndex 0

@interface RXMoreDetectionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic)UITableView*mtableview;
@property(nonatomic,strong)NSMutableArray*dataArray;
@property(nonatomic,strong)RXParamDetailResponse*paramResponse;

@property(nonatomic,strong)RxMoreDetectionShowView*moreView;
@property(nonatomic,strong)RXAllParamDatasResponse*response;

@property(nonatomic,assign)double myKaluli;
@property(nonatomic,assign)double myGongli;
@property(nonatomic,assign)int myStep;

@end

@implementation RXMoreDetectionViewController

-(void)viewWillAppear:(BOOL)animated;{
    [super viewWillAppear:animated];
    [YSThemeManager settingAppThemeType:YSAppThemeNewYearType];
    self.navigationController.navigationBar.barTintColor = [YSThemeManager themeColor];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlack;
    self.navigationController.navigationBar.translucent=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [YSThemeManager setNavigationTitle:@"更多检测" andViewController:self];
    [self setUI];
    [self request];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(request) name:@"manualTestNotification" object:nil];
}
-(void)request;{
    if (!self.response) {
        self.response=[[RXAllParamDatasResponse alloc]init];
    }
    [self showHUD];
    RXAllParamDatasRequest*request=[[RXAllParamDatasRequest alloc]init:GetToken];
    VApiManager *manager = [[VApiManager alloc]init];
    [manager RXAllParamDatasRequest:request
                      success:^(AFHTTPRequestOperation *operation, RXAllParamDatasResponse *response) {
          dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
          dispatch_after(delayTime, dispatch_get_main_queue(), ^{
              [self hideAllHUD];
              [self.mtableview.mj_header endRefreshing];
          });
          self.response = response;
          if (self.response.healthList.count>0) {
              [self.dataArray removeAllObjects];
              for (NSDictionary*dic in self.response.healthList) {
                  NSMutableDictionary*dic1=[[NSMutableDictionary alloc]initWithDictionary:dic];
                  [dic1 setObject:[NSNumber numberWithBool:false] forKey:@"mySelectType"];
                  [dic1 setObject:[NSNumber numberWithBool:false] forKey:@"myZhankaiType"];
                  [self.dataArray addObject:dic1];
              }
          }
          [self.mtableview reloadData];
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
          dispatch_after(delayTime, dispatch_get_main_queue(), ^{
              [self hideAllHUD];
              [self.mtableview.mj_header endRefreshing];
          });
          [self.mtableview reloadData];
      }];
}
-(void)setNavUI;{
    //首页
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 60, 44);
    [rightButton setTitleColor:[UIColor whiteColor]
                      forState:UIControlStateNormal];
    [rightButton setTitle:@"历史记录" forState:UIControlStateNormal];
    [rightButton setTitle:@"历史记录" forState:UIControlStateSelected];

    rightButton.titleLabel.font = JGFont(15);
    [rightButton setAdjustsImageWhenHighlighted:NO];
    [rightButton addTarget:self action:@selector(backRightViewController) forControlEvents:UIControlEventTouchUpInside];
    // 修改导航栏左边的item
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}
 //历史记录
-(void)backRightViewController;{
    RXMoreWebViewController*view=[[RXMoreWebViewController alloc]init];
    view.titlestring=@"运动";
    view.urlstring=@"http://api.bhesky.com/resources/jkgl/resultList.html";
    view.code=@"12";
    NSMutableArray*array=[[NSMutableArray alloc]init];
    for (NSMutableDictionary*dic in [RXTabViewHeightObjject getMorenArray]) {
        NSString*string=[RXTabViewHeightObjject getItemCodeNumber:dic];
        if ([string isEqualToString:@"听力"]||[string isEqualToString:@"视力"]||[string isEqualToString:@"肺活量"]) {
            break;
        }
        [array addObject:[Unit JSONString:dic key:@"itemName"]];
    }
    view.type=true;
    view.dataArray=[RXTabViewHeightObjject getMorenArray];
    view.titleArray=array;
    [self.navigationController pushViewController:view animated:NO];
}

-(void)leftBackFounctionButton;{
    RXUserH5UrlRequest*request=[[RXUserH5UrlRequest alloc]init:GetToken];
    request.code=@"4";
    VApiManager *manager = [[VApiManager alloc]init];
    [self showHUD];
    [manager RXRXUserH5UrlRequest:request
                          success:^(AFHTTPRequestOperation *operation, RXUserH5UrlResponse *response) {
          [self hideAllHUD];
          if (response.isMember==0) {
              [self showStringHUD:@"会员到期" second:0];
              //              dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
              //              dispatch_after(delayTime, dispatch_get_main_queue(), ^{
              //                  RXbutlerServiceViewController*vc=[[RXbutlerServiceViewController alloc]init];
              //                  [self.navigationController pushViewController:vc animated:NO];
              //              });
          }else{
              NSString*string=@"我的健康报告";
              RXWmViewController*view=[[RXWmViewController alloc]init];
              view.titlestring=string;
              view.htmlstring=response.messageH5;
              [self.navigationController pushViewController:view animated:NO];
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          [self hideAllHUD];
          [self showStringHUD:@"网络错误" second:0];
      }];
}

-(void)leftBackButton;{
    if (self.url.length>0) {
        NSString*string=@"我的健康报告";
        RXLISHIViewController*view=[[RXLISHIViewController alloc]init];
        view.titlestring=string;
        view.urlstring=self.url;
        [self.navigationController pushViewController:view animated:NO];
    }
}
-(void)setUI;{
    
    [self setNavUI];
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    int myhight=statusRect.size.height;
    if (!self.moreView) {
        self.moreView=[[[NSBundle mainBundle]loadNibNamed:@"RxMoreDetectionShowView" owner:self options:nil]firstObject];
        if (kScreenHeight>800) {
            self.moreView.frame=CGRectMake(0,0,kScreenWidth,160+myhight);
        }else{
            self.moreView.frame=CGRectMake(0,0,kScreenWidth,160);
        }
        self.moreView.backImage.backgroundColor=JGColor(101, 187, 177, 1);
        
        self.moreView.tiButtonImage.layer.masksToBounds=YES;
        self.moreView.tiButtonImage.layer.cornerRadius=15;
        self.moreView.tiButtonImage.layer.borderWidth=1;
        self.moreView.tiButtonImage.layer.borderColor=[UIColor whiteColor].CGColor;
        self.moreView.tiButtonImage.backgroundColor=JGColor(101, 187, 177, 1);
        
        UITapGestureRecognizer*headTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftBackFounctionButton)];
        self.moreView.userInteractionEnabled=YES;
        [self.moreView addGestureRecognizer:headTap];
        
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftBackButton)];
        self.moreView.tiButtonImage.userInteractionEnabled=YES;
        [self.moreView.tiButtonImage addGestureRecognizer:tap];
    }
    [self.view addSubview:self.moreView];
    self.dataArray=[[NSMutableArray alloc]init];
    [self.dataArray addObject:@{@"itemName":@"运动",@"mySelectType":@"false",@"myZhankaiType":@"false",@"itemCode":@12}];
    [self.dataArray addObject:@{@"itemName":@"血压",@"mySelectType":@"false",@"myZhankaiType":@"false",@"itemCode":@4}];
    [self.dataArray addObject:@{@"itemName":@"血糖",@"mySelectType":@"false",@"myZhankaiType":@"false",@"itemCode":@9}];
    [self.dataArray addObject:@{@"itemName":@"体重",@"mySelectType":@"false",@"myZhankaiType":@"false",@"itemCode":@16}];
    _mtableview=[[UITableView alloc]initWithFrame:CGRectMake(0,self.moreView.frame.size.height-kNarbarH,kScreenWidth,kScreenHeight-self.moreView.frame.size.height) style:0];
    _mtableview.backgroundColor =JGColor(250, 250, 250, 1);
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
    self.mtableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self request];
    }];
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
        if (section<self.dataArray.count){
            NSMutableDictionary*dic=self.dataArray[section];
            NSMutableDictionary*keyValue=[Unit ParseJSONObject:dic[@"keyValue"]];
            if (keyValue.count>0) {
                return 100;
            }
            return 80;
        }
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
            
            RXZhangKaiTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:reusstring];
            NSMutableDictionary*dic=self.dataArray[indexPath.section];
            if (cell==nil) {
                NSInteger index=[RXTabViewHeightObjject getRXZhangKaiTableViewCell:dic];
                if (index==1) {
                    cell=[[NSBundle mainBundle]loadNibNamed:@"RXZhangKaiTableViewCell" owner:self options:nil][3];
                }
                if (index==2) {
                    cell=[[NSBundle mainBundle]loadNibNamed:@"RXZhangKaiTableViewCell" owner:self options:nil][2];
                }
                if (index==3) {
                    cell=[[NSBundle mainBundle]loadNibNamed:@"RXZhangKaiTableViewCell" owner:self options:nil][1];
                }
                if (index==4) {
                    cell=[[NSBundle mainBundle]loadNibNamed:@"RXZhangKaiTableViewCell" owner:self options:nil][0];
                }
            }
            //背景
            if ([Unit JSONInt:dic key:@"execption"]==1) {
                cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:253/255.0 blue:246/255.0 alpha:1.0];
            }else{
                cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
            }
            //处理显示图片
            [RXTabViewHeightObjject getButtonShowCell:cell with:dic];
            
            NSInteger index=[RXTabViewHeightObjject getRXZhangKaiTableViewCell:dic];
            if (index==1) {
                [cell.fiveOneButton addTarget:self action:@selector(oneOneButtonFountion:) forControlEvents:UIControlEventTouchUpInside];
                cell.fiveOneButton.titleLabel.text=[NSString stringWithFormat:@"%ld",indexPath.section];
            }else if (index==2) {
                [cell.freeOneButton addTarget:self action:@selector(oneOneButtonFountion:) forControlEvents:UIControlEventTouchUpInside];
                [cell.freeTwoButton addTarget:self action:@selector(oneOneButtonFountion:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.freeTwoButton.titleLabel.text=[NSString stringWithFormat:@"%ld",indexPath.section];
                cell.freeOneButton.titleLabel.text=[NSString stringWithFormat:@"%ld",indexPath.section];
                
            }else if (index==3) {
                
                [cell.twoOneButon addTarget:self action:@selector(oneOneButtonFountion:) forControlEvents:UIControlEventTouchUpInside];
                [cell.twoTwoButton addTarget:self action:@selector(oneOneButtonFountion:) forControlEvents:UIControlEventTouchUpInside];
                [cell.twoFreeButton addTarget:self action:@selector(oneOneButtonFountion:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.twoOneButon.titleLabel.text=[NSString stringWithFormat:@"%ld",indexPath.section];
                cell.twoTwoButton.titleLabel.text=[NSString stringWithFormat:@"%ld",indexPath.section];
                cell.twoFreeButton.titleLabel.text=[NSString stringWithFormat:@"%ld",indexPath.section];
                
            }else if (index==4) {
                [cell.oneOneButton addTarget:self action:@selector(oneOneButtonFountion:) forControlEvents:UIControlEventTouchUpInside];
                [cell.oneTwoButton addTarget:self action:@selector(oneOneButtonFountion:) forControlEvents:UIControlEventTouchUpInside];
                [cell.oneFreeButton addTarget:self action:@selector(oneOneButtonFountion:) forControlEvents:UIControlEventTouchUpInside];
                [cell.oneFiveButton addTarget:self action:@selector(oneOneButtonFountion:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.oneOneButton.titleLabel.text=[NSString stringWithFormat:@"%ld",indexPath.section];
                cell.oneTwoButton.titleLabel.text=[NSString stringWithFormat:@"%ld",indexPath.section];
                cell.oneFreeButton.titleLabel.text=[NSString stringWithFormat:@"%ld",indexPath.section];
                cell.oneFiveButton.titleLabel.text=[NSString stringWithFormat:@"%ld",indexPath.section];
            }
            cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    UITableViewCell*cell=[[UITableViewCell alloc]init];
    return cell;
}
//点击展开界面
-(void)oneOneButtonFountion:(UIButton*)button;{
    NSInteger index=[button.titleLabel.text integerValue];
    NSMutableDictionary*dic=self.dataArray[index];
    NSMutableArray*array=[RXTabViewHeightObjject getRXZhangKaiTablelViewImageArray:dic];
    NSString*string=array[button.tag];
    if ([string isEqualToString:@"智能设备"]) {
        [self showStringHUD:@"功能正在开发,请期待" second:0];
        return;
    }
    if ([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"运动"]&&[string isEqualToString:@"手机检测"]) {
        if ([YSStepManager healthyKitAccess]) {
            @weakify(self);
            [YSStepManager healthStoreDataWithStartDate:nil endDate:nil WithFailAccess:^{
                @strongify(self);
                [self showErrorHudWithText:@"无数据获取权限"];
            } walkRunningCallback:^(NSNumber *walkRunning) {
            } stepCallback:^(NSNumber *step) {
                if ([step intValue]==0) {
                    [self showErrorHudWithText:@"无法获取数据，请检查"];
                    self.myStep= [step intValue];
                    self.myGongli=[step doubleValue] * 0.00065;
                    self.myKaluli=62*self.myGongli*0.8;
                    [self.mtableview reloadData];
                }else{
                    [self showErrorHudWithText:@"数据已经更新"];
                    self.myStep= [step intValue];
                    self.myGongli=[step doubleValue] * 0.00065;
                    self.myKaluli=62*self.myGongli*0.8;
                    [self.mtableview reloadData];
                }
            }];
        }
    }else{
        YSMultipleTypesTestController *multipleTypesTestController = [[YSMultipleTypesTestController alloc] initWithTestType:YSInputValueWithBloodPressureType];
        multipleTypesTestController.rxArray=array;
        multipleTypesTestController.rxDic=dic;
        multipleTypesTestController.rxIndex=button.tag;
        [self.navigationController pushViewController:multipleTypesTestController animated:YES];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.dataArray.count>0) {
        //先判断是否可以展开
        NSMutableDictionary*dic=self.dataArray[section];
        NSMutableDictionary*keyValue=[Unit ParseJSONObject:dic[@"keyValue"]];
        
        UIView*rxheadView=[[UIView alloc]init];
        if (keyValue.count>0) {
            rxheadView.frame=CGRectMake(0,0,kScreenWidth,100);
        }else{
            rxheadView.frame=CGRectMake(0,0,kScreenWidth,80);
        }
        UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,10,kScreenWidth-20,rxheadView.frame.size.height-15)];
        //背景
        if ([Unit JSONInt:dic key:@"execption"]==1) {
            imageView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:253/255.0 blue:246/255.0 alpha:1.0].CGColor;
        }else{
            imageView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
        }
        imageView.layer.cornerRadius = 8;
        imageView.layer.shadowColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:0.9].CGColor;
        imageView.layer.shadowOffset = CGSizeMake(0,0);
        imageView.layer.shadowOpacity = 1;
        imageView.layer.shadowRadius = 10;
        [rxheadView addSubview:imageView];
        
        //头像距离位置
        float myheight=0;
        if (keyValue.count>0) {
            myheight=30;
        }else{
            myheight=(rxheadView.frame.size.height-15)/2;
        }
        //头像
        UIImageView*iconImage=[[UIImageView alloc]initWithFrame:CGRectMake(30,myheight,24, 24)];
        iconImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_image",[Unit JSONString:dic key:@"itemCode"]]];
        iconImage.layer.masksToBounds=YES;
        iconImage.layer.borderWidth=1;;
        iconImage.layer.borderColor=[UIColor whiteColor].CGColor;
        
        [rxheadView addSubview:iconImage];
        //说明
        UILabel*itemNamelabel=[[UILabel alloc]init];
        itemNamelabel.text=self.dataArray[section][@"itemName"];
        itemNamelabel.font=JGFont(15);
        itemNamelabel.textColor=JGColor(51, 51, 51, 1);
        [rxheadView addSubview:itemNamelabel];
        
        [itemNamelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(iconImage.mas_centerY);
            make.left.equalTo(iconImage.mas_right).offset(10);
        }];
        //文字
        UILabel*shuominglabel=[[UILabel alloc]init];
        shuominglabel.text=@"--";
        shuominglabel.textColor=JGColor(101, 187, 177, 1);
        [rxheadView addSubview:shuominglabel];
        [shuominglabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(itemNamelabel.mas_centerY);
            make.left.equalTo(itemNamelabel.mas_right).offset(25);
        }];
        //单位
        UILabel*danweilabel=[[UILabel alloc]init];
        danweilabel.text=@"--";
        [rxheadView addSubview:danweilabel];
        [danweilabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(itemNamelabel.mas_centerY);
            make.left.equalTo(shuominglabel.mas_right).offset(5);
        }];
        danweilabel.hidden=YES;
        
        //是否正常
        UILabel*typelabel=[[UILabel alloc]init];
        typelabel.frame=CGRectMake(30,myheight+24+10,40,20);
        [rxheadView addSubview:typelabel];
        
        //时间
        UILabel*timelabel=[[UILabel alloc]init];
        timelabel.frame=CGRectMake(kScreenWidth-20-50,myheight+24+10,50,20);
        timelabel.textColor=JGColor(170, 170, 170, 1);
        timelabel.font=JGFont(12);
        timelabel.textAlignment=NSTextAlignmentRight;
        [rxheadView addSubview:timelabel];
        
        //来源
        UILabel*laiyuanlabel=[[UILabel alloc]init];
        [rxheadView addSubview:laiyuanlabel];
        [laiyuanlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(typelabel.mas_centerY);
            make.left.equalTo(itemNamelabel.mas_right).offset(25);
        }];
        laiyuanlabel.hidden=YES;
        timelabel.hidden=YES;
        typelabel.hidden=YES;
        
        if ([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"运动"]){
            if (self.myStep!=0) {
                shuominglabel.textColor=JGColor(101, 187, 177, 1);
                [shuominglabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
                shuominglabel.text=[NSString stringWithFormat:@"%d",self.myStep];
                self.myGongli=self.myStep * 0.00065;
                self.myKaluli=62*self.myGongli*0.8;
                danweilabel.hidden=NO;
                danweilabel.text=@"步";
                danweilabel.textColor=JGColor(136, 136, 136, 1);
                danweilabel.font=JGFont(12);
            }else{
                shuominglabel.text=@"--";
            }
        }else{
            if (keyValue.count>0) {
                //当有数据时统一配置
                if ([Unit JSONInt:dic key:@"execption"]==1) {
                    typelabel.hidden=NO;
                    typelabel.text=[NSString stringWithFormat:@" %@ ",[Unit JSONString:dic key:@"testgrade"]];
                    typelabel.frame=CGRectMake(30,myheight+24+10,12*typelabel.text.length,20);
                    typelabel.font=JGFont(12);
                    typelabel.textColor=JGColor(239, 82, 80, 1);
                    typelabel.backgroundColor=JGColor(252, 238, 233, 1);
                    typelabel.layer.masksToBounds=YES;
                    typelabel.layer.cornerRadius=10;
                    typelabel.textAlignment=1;
                }
                if ([Unit JSONString:dic key:@"timeName"].length>0) {
                    timelabel.hidden=NO;
                    timelabel.text=[Unit JSONString:dic key:@"timeName"];
                }
                
                laiyuanlabel.hidden=NO;
                laiyuanlabel.textColor=JGColor(153, 153, 153, 1);
                laiyuanlabel.font=JGFont(12);
                if ([Unit JSONInt:keyValue key:@"type"]==0) {
                    laiyuanlabel.text=[NSString stringWithFormat:@"来源:健康一体机录入"];
                }else if ([Unit JSONInt:keyValue key:@"type"]==1) {
                    laiyuanlabel.text=[NSString stringWithFormat:@"来源:手动录入"];
                }else if ([Unit JSONInt:keyValue key:@"type"]==2) {
                    laiyuanlabel.text=[NSString stringWithFormat:@"来源:智能硬件录入"];
                }else if ([Unit JSONInt:keyValue key:@"type"]==3) {
                    laiyuanlabel.text=[NSString stringWithFormat:@"来源:手机检测"];
                }else{
                    laiyuanlabel.hidden=YES;
                }
                shuominglabel.textColor=JGColor(101, 187, 177, 1);
                [shuominglabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
                danweilabel.hidden=NO;
                danweilabel.text=[Unit JSONString:dic key:@"unit"];
                danweilabel.textColor=JGColor(136, 136, 136, 1);
                danweilabel.font=JGFont(12);
                if ([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"血压"]) {
                    shuominglabel.text=[NSString stringWithFormat:@"%@/%@",[Unit JSONString:keyValue key:@"highValue"],[Unit JSONString:keyValue key:@"lowValue"]];
                }else if ([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"血脂"]) {
                    shuominglabel.text=[NSString stringWithFormat:@"%@",[Unit JSONString:dic key:@"testgrade"]?[Unit JSONString:dic key:@"testgrade"]:@"--"];
                }else if ([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"体脂"]) {
                    shuominglabel.text=[NSString stringWithFormat:@"%@",[Unit JSONString:keyValue key:@"inValue"]?[Unit JSONString:keyValue key:@"inValue"]:@"--"];
                }else if ([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"腰臀比"]) {
                    shuominglabel.text=[NSString stringWithFormat:@"%@",[Unit JSONString:keyValue key:@"whrValue"]?[Unit JSONString:keyValue key:@"whrValue"]:@"--"];
                }else if ([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"视力"]) {
                    shuominglabel.text=[NSString stringWithFormat:@"%@",[Unit JSONString:keyValue key:@"inValue"]?[Unit JSONString:keyValue key:@"inValue"]:@"--"];
                }else if ([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"听力"]) {
                    shuominglabel.text=[NSString stringWithFormat:@"%@",[Unit JSONString:keyValue key:@"lowValue"]?[Unit JSONString:keyValue key:@"lowValue"]:@"--"];
                }else{
                    shuominglabel.text=[NSString stringWithFormat:@"%@",[Unit JSONString:keyValue key:@"inValue"]?[Unit JSONString:keyValue key:@"inValue"]:@"--"];
                }
            }
        }
        //添加button
        UIButton*addButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [rxheadView addSubview:addButton];
        
        addButton.tag=section;
        addButton.userInteractionEnabled=YES;
        [addButton addTarget:self action:@selector(rxheadViewAddButton:) forControlEvents:UIControlEventTouchUpInside];
        
        addButton.selected=[Unit JSONBool:dic key:@"mySelectType"];
        [addButton setBackgroundImage:[UIImage imageNamed:@"rx_right_image-1"] forState:UIControlStateNormal];
        [addButton setBackgroundImage:[UIImage imageNamed:@"rx_right_image-1"] forState:UIControlStateSelected];
    
        //展开button
        UIButton*zhangkiaButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [rxheadView addSubview:zhangkiaButton];
        zhangkiaButton.selected=[Unit JSONBool:dic key:@"myZhankaiType"];
        [zhangkiaButton setBackgroundImage:[UIImage imageNamed:@"Consummate_add_image"] forState:UIControlStateNormal];
        [zhangkiaButton setBackgroundImage:[UIImage imageNamed:@"取消"] forState:UIControlStateSelected];
        zhangkiaButton.tag=10000+section;
        [zhangkiaButton addTarget:self action:@selector(rxheadViewZhankaiButton:) forControlEvents:UIControlEventTouchUpInside];
        if ([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"运动"]){
            addButton.frame=CGRectMake(kScreenWidth-20-20-42/2,20,42,42);
            zhangkiaButton.frame=CGRectMake(kScreenWidth-20-20-10-42-42/2,20,42,42);
        }else if([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"听力"]){
            addButton.hidden=YES;
            zhangkiaButton.frame=CGRectMake(kScreenWidth-20-20-42/2,myheight-10,42,42);
        }else if([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"视力"]){
            addButton.hidden=YES;
            zhangkiaButton.frame=CGRectMake(kScreenWidth-20-20-42/2,myheight-10,42,42);
        }else if([[RXTabViewHeightObjject getItemCodeNumber:dic] isEqualToString:@"肺活量"]){
            addButton.hidden=YES;
            zhangkiaButton.frame=CGRectMake(kScreenWidth-20-20-42/2,myheight-10,42,42);
        }else{
            if (keyValue.count>0){
                addButton.frame=CGRectMake(kScreenWidth-20-20-42/2,20,42,42);
                zhangkiaButton.frame=CGRectMake(kScreenWidth-20-20-10-42-42/2,20,42,42);
            }else{
                addButton.hidden=YES;
                zhangkiaButton.frame=CGRectMake(kScreenWidth-20-20-42/2,myheight-10,42,42);
            }
        }
        return rxheadView;
    }
    return [UIView new];
}
//首页展开
-(void)rxheadViewZhankaiButton:(UIButton*)button;{

    NSDictionary*dic1=self.dataArray[button.tag-10000];
    NSMutableDictionary*dic=[[NSMutableDictionary alloc]initWithDictionary:dic1];
    NSString*stringTitle=[RXTabViewHeightObjject getItemCodeNumber:dic];
    if ([stringTitle isEqualToString:@"听力"]) {
        //听力检测
        HearingTestVC *hearingTestVC = [[HearingTestVC alloc] init];
        [self.navigationController pushViewController:hearingTestVC animated:YES];

    }else if ([stringTitle isEqualToString:@"肺活量"]) {
        //肺活量测试
        menuViewController *eyeecharVC = [[menuViewController alloc] init];
        eyeecharVC.titleText = @"肺活量测试";
        eyeecharVC.menuContentArray = @[@"手机测量",@"手动输入"];
        eyeecharVC.contentView = @[@"lungPhoneView",@"lungManualView"];
        [self.navigationController pushViewController:eyeecharVC animated:YES];
    }else if ([stringTitle isEqualToString:@"视力"]) {
        //视力检测
        menuViewController *eyeecharVC = [[menuViewController alloc] init];
        eyeecharVC.titleText = @"检查视力";
        eyeecharVC.menuContentArray = @[@"视力表",@"视力检查",@"色盲测试",@"散光测试"];
        eyeecharVC.contentView = @[@"eyeChartView",@"eyeTestView",@"colourBlindnessView",@"astigmatismView"];
        [self.navigationController pushViewController:eyeecharVC animated:YES];
    }else{
        button.selected = !button.selected;
        if ([Unit JSONBool:dic key:@"myZhankaiType"]) {
            [dic setObject:[NSNumber numberWithBool:false] forKey:@"myZhankaiType"];
        }else{
            [dic setObject:[NSNumber numberWithBool:true] forKey:@"myZhankaiType"];
        }
        [dic setObject:[NSNumber numberWithBool:false] forKey:@"mySelectType"];
        [self.dataArray replaceObjectAtIndex:button.tag-10000 withObject:dic];
        [self.mtableview reloadData];
    }
}

-(void)rxheadViewAddButton:(UIButton*)button;{
    NSMutableDictionary*dic=self.dataArray[button.tag];
    NSString*stringTitle=[RXTabViewHeightObjject getItemCodeNumber:dic];
    NSString*string=stringTitle;
    RXMoreWebViewController*view=[[RXMoreWebViewController alloc]init];
    view.titlestring=string;
    view.urlstring=@"http://api.bhesky.com/resources/jkgl/resultList.html";
    view.code=[NSString stringWithFormat:@"%d",[Unit JSONInt:dic key:@"itemCode"]];
    NSMutableArray*array=[[NSMutableArray alloc]init];
    for (NSMutableDictionary*dic in [RXTabViewHeightObjject getMorenArray]) {
        NSString*string=[RXTabViewHeightObjject getItemCodeNumber:dic];
        if ([string isEqualToString:@"听力"]||[string isEqualToString:@"视力"]||[string isEqualToString:@"肺活量"]) {
            break;
        }
        [array addObject:[Unit JSONString:dic key:@"itemName"]];
    }
    view.type=true;
    view.dataArray=[RXTabViewHeightObjject getMorenArray];
    view.titleArray=array;
    [self.navigationController pushViewController:view animated:NO];
}
-(void)dealloc;{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"manualTestNotification" object:nil];
}
@end
