//
//  LJTableViewCell.m
//  jingGang
//
//  Created by whlx on 2019/3/6.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "LJTableViewCell.h"
#import "ZZCircleProgress.h"
#import "GlobeObject.h"
#import "LQyouhuiRequest.h"
@interface LJTableViewCell ()

@property (strong, nonatomic) ZZCircleProgress *progressView;
@property (weak, nonatomic) IBOutlet UILabel *baifenbiLabel;
@property (nonatomic,readonly)BOOL ztnumber;
@property (nonatomic,readonly)int reciveCount;
@property (nonatomic,readonly)int couponCount;
@property (nonatomic, readonly, copy) NSString *appid;

@end
@implementation LJTableViewCell
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
  ;
    [super awakeFromNib];
    // Initialization code
}

-(void)setYHJModel:(YHJModel *)YHJModel{
    _yilingquImageView.hidden = YES;
     _YHJModel = YHJModel;
    _appid = YHJModel.appid;
    _jageLabel.text= [NSString stringWithFormat:@"¥ %@",[YHJModel.couponAmount stringValue]];
    
    _sytiaojianLabel.text = [NSString stringWithFormat:@"满%@可以使用",[YHJModel.couponOrderAmount stringValue]];
    _nameLabel.text = YHJModel.couponName;
    
    _timeLabel.text = [NSString stringWithFormat:@"%@ - %@",YHJModel.startTime,YHJModel.endTime];
    
    _ztnumber = *(YHJModel.Recive);
    
    _reciveCount = [YHJModel.reciveCount intValue];
   
    _couponCount = [YHJModel.couponCount intValue];

    if (_reciveCount >=_couponCount) {
        [_lingButton setTitle:@"已抢完" forState:UIControlStateNormal];
        _baifenbiLabel.text=@"100%";
        _baifenbiLabel.textColor =JGColor(214, 214, 214, 1);
        _yiqiangLabel.textColor = JGColor(214, 214, 214, 1);
        [_lingButton setBackgroundColor:JGColor(214, 214, 214, 1)];;
    }
    
    if(!_ztnumber){
        [_lingButton setTitle:@"去使用" forState:UIControlStateNormal];
         _yilingquImageView.hidden = NO;
        self.jinduLabel.hidden = YES;
        [_lingButton setBackgroundColor:JGColor(247, 117, 69, 1)];
    }
    //CGFloat baifenbi = _reciveCount/_couponCount;

    [self addProgressViewByFrame];
   
}
- (void)addProgressViewByFrame{
    self.progressView = [[ZZCircleProgress alloc] initWithFrame:CGRectMake(0,0,60,80) pathBackColor:[UIColor lightGrayColor] pathFillColor:JGColor(101, 187, 177, 1) startAngle:0 strokeWidth:10];
     self.progressView.startAngle = 110;
    self.progressView.reduceAngle = 40;
     self.progressView.strokeWidth = 2;
     self.progressView.showPoint = NO;
     self.progressView.showProgressText = NO;
     self.progressView.increaseFromLast =YES;
    self.progressView.duration = 1;
    NSLog(@"_couponCount/_reciveCount:%d,%d,%d",_couponCount/_reciveCount,_couponCount,_reciveCount);
    self.progressView.progress = (_couponCount *1.0) /(_reciveCount * 1.0);
    [self.jinduLabel addSubview:self.progressView];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)liquYouHuiJ:(id)sender {
    
    
    if(_ztnumber &&[_lingButton.titleLabel.text isEqualToString:@"立即领取"]){
        [_lingButton setTitle:@"去使用" forState:UIControlStateNormal];
        [_lingButton setTitleColor:kGetColor(193, 213, 211) forState:UIControlStateNormal];
        _yilingquImageView.hidden = NO;
        [self LQyhuijuan:_appid];
    }
    
}

-(void)LQyhuijuan:(NSString *)appid{
    
    VApiManager *manager = [[VApiManager alloc] init];
    LQyouhuiRequest *request = [[LQyouhuiRequest alloc]init:GetToken];
    request.appId = appid;
    
    
    
    [manager LQyouhui:request success:^(AFHTTPRequestOperation *operation, LQyouhuiResponse *response) {
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
    
}

@end
