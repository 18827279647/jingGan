//
//  InviteFriendsController.m
//  jingGang
//
//  Created by whlx on 2019/5/10.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "InviteFriendsController.h"

#import "WebViewController.h"

#import "YSAFNetworking.h"

#import "GlobeObject.h"

#import "InviteHeadView.h"

@interface InviteFriendsController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) NSInteger Page;

@property (nonatomic, strong) NSMutableArray * ModelArray;

@property (nonatomic, strong) UITableView * TableView;

@property (nonatomic, strong) InviteHeadView * HeadView;


@end

@implementation InviteFriendsController


- (UITableView *)TableView{
    if (!_TableView) {
        _TableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth , kScreenHeight - K_ScaleWidth(20)) style:UITableViewStylePlain];
        _TableView.delegate = self;
        _TableView.dataSource = self;
        _TableView.estimatedRowHeight = K_ScaleWidth(50);
        _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_TableView];
    }
    return _TableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
    //设置标题
    [YSThemeManager setNavigationTitle:@"邀请好友" andViewController:self];;
    
    UIButton *leftbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    
    [leftbutton setTitle:@"规则" forState:UIControlStateNormal];
    UIBarButtonItem *rightitem=[[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    self.navigationItem.rightBarButtonItem=rightitem;

    self.HeadView = [[InviteHeadView alloc]init];
    
    
    self.TableView.tableHeaderView = self.HeadView;
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


#pragma 获取邀请好友数据
- (void)GETData{
    
    NSString * url = [NSString stringWithFormat:@"%@%@",ShanrdURL,@"/v1/newRed/invictionList"];
    
    NSDictionary * dict = @{@"pageNum":[NSString stringWithFormat:@"%zd",self.Page],@"pageSize":@"10"};
    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [YSAFNetworking POSTUrlString:url parametersDictionary:dict successBlock:^(NSURLSessionDataTask *operation, id responseObject) {
        [hub hide:YES afterDelay:1.0f];
        NSString *str  = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData * data=[str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dict =[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        
        
        
    } failureBlock:^(NSURLSessionDataTask *operation, NSError *error) {
        [hub hide:YES afterDelay:1.0f];
    }];
    
}


#pragma 跳转规则Web
-(void)guize{
    WebViewController * web = [[WebViewController alloc] init];
    web.title = @"邀请专属领劵规则";
    web.Url = @"http://mobile.bhesky.cn/newRed/guize.htm";
    [self.navigationController pushViewController:web animated:YES];
}


#pragma tabelview代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.ModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [[UITableViewCell alloc]init];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return K_ScaleWidth(80);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth, K_ScaleWidth(80))];
    
    NSArray * Title = @[@"邀请神器",@"我的邀请"];
    
    for (NSInteger i = 0; i < Title.count; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, kScreenWidth / Title.count, view.height);
        button.tag = i ;
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (i == 0) {
            button.backgroundColor = [UIColor colorWithHexString:@"2611C9FF"];
        }else {
            button.backgroundColor = [UIColor colorWithHexString:@"B82935FF"];
        }
        
        [button addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
    
    return view;
}



#pragma 点击事件
- (void)Click:(UIButton *)sender{
    
    
    

    
}




@end
