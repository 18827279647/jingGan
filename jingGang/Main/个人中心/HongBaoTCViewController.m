//
//  HongBaoTCViewController.m
//  jingGang
//
//  Created by whlx on 2019/4/23.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "HongBaoTCViewController.h"
#import "YSCloudMoneyDetailController.h"
#import "HongbaoViewController.h"
#import "XRViewController.h"
#import "VApiManager.h"

@interface HongBaoTCViewController ()

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (nonatomic,copy) NSString * userTapy;
@end

@implementation HongBaoTCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    if(_isJK ==YES){
        [_button setTitle:@"查看健康豆" forState:UIControlStateNormal];
    }else{
        [_button setTitle:@"立即使用" forState:UIControlStateNormal];
        
    }
   //_View.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    //Do any additional setup after loading the view from its nib.
}

- (IBAction)back:(UIButton *)sender {
  
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)pushVIew:(id)sender {
    
    NSLog(@"点击了没有?");
    
    if(_isJK ==NO){
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        if ([_userTapy isEqualToString:@"2"]) {
            
            HongbaoViewController * hongbao = [[HongbaoViewController alloc] init];
            hongbao.string = @"hongbaobeijing1";
            [_nav pushViewController:hongbao animated:YES];
            
        }else if ([_userTapy isEqualToString:@"1"]){
            
            HongbaoViewController * hongbao = [[HongbaoViewController alloc] init];
            hongbao.string = @"bongbaobeijing";
          [_nav pushViewController:hongbao animated:YES];
            
        }else if ([_userTapy isEqualToString:@"0"]){
            XRViewController * xt = [[XRViewController alloc] init];
            [_nav pushViewController:xt animated:YES];
        }
        
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
        
        YSCloudMoneyDetailController *VC = [[YSCloudMoneyDetailController alloc] init];
        [_nav pushViewController:VC animated:YES];

    }
    
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
  
    [self  getUserInfo];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
-(void)getUserInfo
{
    VApiManager * mage = [[VApiManager alloc] init];
    NSString *accessToken = [userDefaultManager GetLocalDataString:@"Token"];
    UsersCustomerSearchRequest * usersCustomerSearchRequest = [[UsersCustomerSearchRequest alloc]init:accessToken];
    
    [mage usersCustomerSearch:usersCustomerSearchRequest success:^(AFHTTPRequestOperation *operation, UsersCustomerSearchResponse *response) {
    
        //NSLog(@"response.userType%@",response.customer.invitationCode);
        _userTapy = [NSString stringWithFormat:@"%@",response.userType] ;
 
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showSuccess:@"网络错误，请检查网络" toView:self delay:1];
    }
     
     ];
    
}
/*

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
