//
//  RxHealthIntegrationMachineViewController.m
//  jingGang
//
//  Created by 荣旭 on 2019/6/25.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "RxHealthIntegrationMachineViewController.h"
#import "RxHeadHealthIntegrationMachineTableViewCell.h"
#import "RxTwoHealthIntegrationMachineTableViewCell.h"
#import "GlobeObject.h"

@interface RxHealthIntegrationMachineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) UITableView *mtableview;

@end

@implementation RxHealthIntegrationMachineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor= JGBaseColor;
    [self setUI];
}
-(void)setUI;{
    _mtableview = [[UITableView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,ScreenHeight-100-kNarbarH-44)style:0];
    _mtableview.delegate = self;
    _mtableview.dataSource = self;
    _mtableview.backgroundColor = JGBaseColor;
    _mtableview.tableFooterView = [UIView new];
    [self.view addSubview:_mtableview];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;{
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
};
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row==0) {
//        static NSString*reusstring=@"RxHeadHealthIntegrationMachineTableViewCell";
//        RxHeadHealthIntegrationMachineTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:reusstring];
//        if (cell==nil) {
//            cell=[[[NSBundle mainBundle]loadNibNamed:@"RxHeadHealthIntegrationMachineTableViewCell" owner:self options:nil]firstObject];
//        }
//        cell.backgroundColor=[UIColor whiteColor];
//
//        cell.twoNameLabel.font=JGFont(15);
//        cell.twoNameLabel.textColor=JGColor(34, 34, 34, 1);
//
//        cell.dinamelabel.textColor=JGColor(34, 34, 34, 1);
//        cell.dinamelabel.font=JGFont(14);
//        cell.dizhilabel.font=JGFont(12);
//        cell.dizhilabel.textColor=JGColor(153, 153, 153, 1);
//
//        cell.backimage.layer.backgroundColor=[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
//        cell.backimage.layer.cornerRadius = 8;
//        cell.backimage.layer.shadowColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:0.9].CGColor;
//        cell.backimage.layer.shadowOffset = CGSizeMake(0,0);
//        cell.backimage.layer.shadowOpacity = 1;
//        cell.backimage.layer.shadowRadius = 10;
//
//
//        cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
//    }else
    if(indexPath.row==0){
        static NSString*reusstring=@"RxTwoHealthIntegrationMachineTableViewCell";
        RxTwoHealthIntegrationMachineTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:reusstring];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"RxTwoHealthIntegrationMachineTableViewCell" owner:self options:nil]firstObject];
        }
        cell.backgroundColor=[UIColor whiteColor];
        cell.namelabel.textColor=JGColor(34, 34, 34, 1);
        cell.oneNamelabel.backgroundColor=JGColor(101, 187, 177, 1);
        cell.oneNamelabel.layer.masksToBounds=YES;
        cell.oneNamelabel.layer.cornerRadius=10;
        cell.oneTitlelabel.textColor=JGColor(102, 102, 102, 1);
        
        cell.twoNamelabel.backgroundColor=JGColor(101, 187, 177, 1);
        cell.twoNamelabel.layer.masksToBounds=YES;
        cell.twoNamelabel.layer.cornerRadius=10;
        cell.twoTitlelabel.textColor=JGColor(102, 102, 102, 1);
        
        
        cell.freeNamelabel.backgroundColor=JGColor(101, 187, 177, 1);
        cell.freeNamelabel.layer.masksToBounds=YES;
        cell.freeNamelabel.layer.cornerRadius=10;
        cell.freeTitlelabel.textColor=JGColor(102, 102, 102, 1);
        
        

        cell.separatorInset = UIEdgeInsetsMake(0,kScreenWidth, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    UITableViewCell*cell=[[UITableViewCell alloc]init];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.row==0){
        if (kScreenHeight>800) {
            return 950;
        }
        return 900;
    }
    return 0;
}

@end
