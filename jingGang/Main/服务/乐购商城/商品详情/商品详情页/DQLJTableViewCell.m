//
//  DQLJTableViewCell.m
//  jingGang
//
//  Created by whlx on 2019/3/6.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "DQLJTableViewCell.h"
#import "GlobeObject.h"
#import "VApiManager.h"
#import "LQyouhuiRequest.h"
@interface DQLJTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *JjineLabel;

@property (weak, nonatomic) IBOutlet UILabel *shiyongtjLabel;
@property (weak, nonatomic) IBOutlet UILabel *shiyongsjLabel;
@property (weak, nonatomic) IBOutlet UIButton *LQButton;
@property (nonatomic,readonly)int ztnumber;
@property (nonatomic,strong)NSString * appID;
@end
@implementation DQLJTableViewCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
    }
    return self;
}



- (void)awakeFromNib {
       self.selectionStyle = UITableViewCellSelectionStyleNone;
    [super awakeFromNib];
    // Initialization code
}
- (void) willCellWithModel:(NSDictionary *)dict{
    _ztnumber = [dict[@"Recive"] intValue];
    _appID = dict[@"id"];
    if(_ztnumber == 1){
        [_LQButton setTitle:@"已领取" forState:UIControlStateNormal];
        
        [_LQButton setTitleColor:kGetColor(193, 213, 211) forState:UIControlStateNormal];
    }
    
    NSLog(@"dict++++++%@",dict);
    _JjineLabel.text = [dict[@"couponAmount"] stringValue];
    
    _shiyongtjLabel.text = [NSString stringWithFormat:@"满%@使用",[dict[@"couponOrderAmount"] stringValue]];
    
    _shiyongsjLabel.text = [NSString stringWithFormat:@"%@-%@",dict[@"startTime"],dict[@"endTime"]];


}
- (IBAction)gaibianYHJ:(id)sender {
    
    if(_ztnumber == 0 &&[_LQButton.titleLabel.text isEqualToString:@"立即领取"]){
        [_LQButton setTitle:@"已领取" forState:UIControlStateNormal];
        [_LQButton setTitleColor:kGetColor(193, 213, 211) forState:UIControlStateNormal];
        
        [self LQyhuijuan:_appID];
    }
    
    NSLog(@"点击了 状态是%d+ID是%@+%@",_ztnumber,_appID,_LQButton.titleLabel.text);
}

-(void)LQyhuijuan:(NSString *)appid{
    
    VApiManager *manager = [[VApiManager alloc] init];
    LQyouhuiRequest *request = [[LQyouhuiRequest alloc]init:GetToken];
    request.appId = appid;
    
    
    
    [manager LQyouhui:request success:^(AFHTTPRequestOperation *operation, LQyouhuiResponse *response) {
        

        NSLog(@"response+++++++%@",response);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
