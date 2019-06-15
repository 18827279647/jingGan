//
//  JGIntegralShopHeaderView.m
//  jingGang
//
//  Created by HanZhongchou on 16/7/28.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "JGIntegralShopHeaderView.h"
#import "userDefaultManager.h"
#import "VApiManager.h"
#import "GlobeObject.h"
#import "YSLoginManager.h"
#import "YSImageConfig.h"
#import "NSString+Font.h"
@interface JGIntegralShopHeaderView ()
/**
 *  去赚积分按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonGoIntegral;

@property  (nonatomic,strong) VApiManager *vapiManager;
/**
 *  用户头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageViewICon;
/**
 *  用户昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *labelNickName;
/**
 *  用户积分
 */
@property (weak, nonatomic) IBOutlet UILabel *labelUserIntgral;
/**
 *  性别
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageViewSex;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *integralLabelWidth;

@end

@implementation JGIntegralShopHeaderView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.buttonGoIntegral.layer.cornerRadius = 15.0;
    self.imageViewICon.layer.cornerRadius = self.imageViewICon.height/2;
    self.imageViewICon.clipsToBounds = YES;
//    self.buttonGoIntegral.backgroundColor = [YSThemeManager buttonBgColor];
//    self.labelUserIntgral.textColor = [YSThemeManager buttonBgColor];
    self.labelUserIntgral.layer.borderColor = [YSThemeManager buttonBgColor].CGColor;
    self.labelUserIntgral.layer.cornerRadius = 7;
    self.labelUserIntgral.layer.borderWidth = 0.5;
    [self requestUserInfo];
    [self requestUserIntergral];
}
#pragma mark - 用户个人信息请求
- (void)requestUserInfo{
    NSString *accessToken = [userDefaultManager GetLocalDataString:@"Token"];
    UsersCustomerSearchRequest * usersCustomerSearchRequest = [[UsersCustomerSearchRequest alloc]init:accessToken];
    
    @weakify(self);
    [self.vapiManager usersCustomerSearch:usersCustomerSearchRequest success:^(AFHTTPRequestOperation *operation, UsersCustomerSearchResponse *response) {
        //        JGLog(@"查询用户信息成功sssss");
        @strongify(self);
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:nil];
        
        NSDictionary   *dictUserList = [dict objectForKey:@"customer"];
        //昵称
        self.labelNickName.text = [NSString stringWithFormat:@"%@",dictUserList[@"nickName"]];
        
        //头像
        NSString *strHeadImageUrl = [NSString stringWithFormat:@"%@",dictUserList[@"headImgPath"]];
        [YSImageConfig sd_view:self.imageViewICon setimageWithURL:[NSURL URLWithString:strHeadImageUrl] placeholderImage:kDefaultUserIcon];
        
        //性别
        NSString *strSex = [NSString stringWithFormat:@"%@",dictUserList[@"sex"]];
        if ([strSex isEqualToString:@"2"]) {
            self.imageViewSex.image = [UIImage imageNamed:@"My_GirlsIcon"];
        }else{
            self.imageViewSex.image = [UIImage imageNamed:@"My_BoyIcon"];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserHeadImgChangedNotification" object:[dictUserList objectForKey:@"headImgPath"]];
        
        [[NSUserDefaults standardUserDefaults]setObject:dictUserList forKey:kUserCustomerKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        JGLog(@"查询用户信息sssss%@",error);
        
    }];
}
#pragma mark - 用户积分请求
-(void)requestUserIntergral{
    
     @weakify(self);
    UsersIntegralGetRequest *request = [[UsersIntegralGetRequest alloc] init:GetToken];
    [self.vapiManager usersIntegralGet:request success:^(AFHTTPRequestOperation *operation, UsersIntegralGetResponse *response) {
        @strongify(self);
        NSDictionary *integralDic = (NSDictionary *)response.integral;
        if (integralDic) {
            NSString *strIntegral = [NSString stringWithFormat:@"%@",integralDic[@"integral"]];
            
            CGSize size = [strIntegral sizeWithFont:[UIFont systemFontOfSize:12] maxH:15];
            self.integralLabelWidth.constant = size.width + 10;
            self.labelUserIntgral.text = strIntegral;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
- (IBAction)goMissionWithIntegral:(id)sender {
    
    if (self.goIntegralWithMissionBlock) {
        self.goIntegralWithMissionBlock();
    }
}

- (VApiManager *)vapiManager
{
    if (!_vapiManager) {
        _vapiManager = [[VApiManager alloc]init];
    }
    return _vapiManager;
}

@end
