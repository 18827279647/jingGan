//
//  JGIndividualCenterTopView.m
//  jingGang
//
//  Created by HanZhongchou on 16/7/23.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "JGIndividualCenterTopView.h"
#import "GlobeObject.h"
#import "TakePhotoUpdateImg.h"
#import "VApiManager.h"
#import "YSLoginManager.h"
#import "YSImageConfig.h"

@interface JGIndividualCenterTopView ()

/**
 *  背景View
 */
@property (nonatomic,strong) UIView *topBgView;
//我的模块名称
@property (nonatomic,strong) NSArray *blockName;

/**
 *  头像imageView
 */
@property (nonatomic,strong) UIImageView *imageViewHead;
/**
 *  用户昵称label
 */
@property (nonatomic,strong) UILabel *labelNickName;
@property (nonatomic,strong)UIButton *buttonInfo ;
/**
 *  图片上传
 */
@property (nonatomic,strong) TakePhotoUpdateImg *takePhotoUpdateImg;
/**
 *  用户等级
 */
@property (nonatomic,strong) UILabel *labelAssociatorLv;
/**
 *  达人名称
 */
@property (nonatomic,strong) UILabel *labelFancier;
/**
 *  用户积分label
 */
@property (nonatomic,strong) UILabel *labelUsersIntegral;
/**
 *  用户健康豆label
 */
@property (nonatomic,strong) UILabel *labelUsersYunMoney;
/**
 *  性别显示图片
 */
@property (nonatomic,strong) UIImageView *imageViewSex;

/**
 *  临时存储上传头像图片
 */
@property (nonatomic,strong) UIImage *imageHeaderTemp;
/**
 *  预分润
 */
@property (nonatomic,strong) UILabel *labelBeforehandMoney;
/**
 *  云购币label
 */
@property (nonatomic,strong) UILabel *labelCloudBuyMoney;
@property (nonatomic,strong) VApiManager *vapiManager;
@property (copy , nonatomic) voidCallback clickIconCallback;
//用户钱币view
@property (nonatomic,strong) UIView *viewUserInfoValue;
//邀请好友
@property (nonatomic,strong) UIView *invitationFriendView;
//我的健康
@property (nonatomic,strong) UIView *myHealthView;
//我的商城
@property (nonatomic,strong) UIView *myTmallView;
//我的服务
@property (nonatomic,strong) UIView *myServiceView;
//其它
@property (nonatomic,strong) UIView *otherView;
@property (strong,nonatomic) UILabel *shopIntegralLab;
@property (nonatomic,strong) UIImageView *rightButton;

@end

@implementation JGIndividualCenterTopView



- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
  //  _blockName=@[@"健康任务",@"健康档案",@"健康设备",@"我的订单",@"优惠券",@"收货地址",@"兑换订单",@"商品退货",@"领劵中心",@"服务订单",@"便民出行订单",@"我发的帖子",@"我的收藏",@"设置"];
    
      _blockName=@[@"健康任务",@"健康档案",@"健康设备",@"我的订单",@"收货地址",@"兑换订单",@"商品退货",@"服务订单",@"便民出行订单",@"我发的帖子",@"我的收藏",@"设置"];
    if (self) {
        self.frame = frame;
        [self addSubview:self.topBgView];
    }
    return self;
}

#pragma mark --setter

/**
 *  头像
 */
- (void)setStrHeadImageUrl:(NSString *)strHeadImageUrl{
    _strHeadImageUrl = strHeadImageUrl;
    [YSImageConfig sd_view:self.imageViewHead setImageWithURL:[NSURL URLWithString:strHeadImageUrl] placeholderImage:kDefaultUserIcon options:SDWebImageRefreshCached];
}
/**
 *  昵称
 */
- (void)setStrNickName:(NSString *)strNickName{
    _strNickName = strNickName;
    //拿到字符串后计算出label所需的宽度
    CGSize sizeNickName = CGSizeMake(MAXFLOAT, 25);
    NSDictionary *dicNickName = @{NSFontAttributeName : [UIFont systemFontOfSize:25]};
    
    CGSize ssizeNickName = [strNickName boundingRectWithSize:sizeNickName
                                                           options:NSStringDrawingUsesLineFragmentOrigin attributes:dicNickName
                                                           context:nil].size;
    
    self.labelNickName.width = ssizeNickName.width;
    self.labelNickName.x = (kScreenWidth-ssizeNickName.width)/2;
    
    //昵称label算出宽度后还需要设置性别imageView的X坐标
    self.imageViewSex.x = CGRectGetMaxX(self.labelNickName.frame) + 5;
    self.labelNickName.text = strNickName;
    _buttonInfo.frame=self.labelNickName.frame;
}
/**
 *  积分
 */
- (void)setStrUsersIntegral:(NSString *)strUsersIntegral{
    _strUsersIntegral = strUsersIntegral;
    self.labelUsersIntegral.text = strUsersIntegral;
}
/**
 *  健康豆
 */
- (void)setStrUsersYunMoney:(NSString *)strUsersYunMoney{
    _strUsersYunMoney = strUsersYunMoney;
    self.labelUsersYunMoney.text = strUsersYunMoney;
    
}
/**
 *  性别
 */
- (void)setStrSex:(NSString *)strSex{
    _strSex = strSex;
    if ([strSex isEqualToString:@"2"]) {
        self.imageViewSex.image = [UIImage imageNamed:@"My_GirlsIcon"];
    }else {
        self.imageViewSex.image = [UIImage imageNamed:@"My_BoyIcon"];
    }
}
/**
 *  云购币
 */

- (void)setStrCloudBuyMoney:(NSString *)strCloudBuyMoney{
    _strCloudBuyMoney = strCloudBuyMoney;
    self.labelCloudBuyMoney.text = strCloudBuyMoney;
}

/**
 *  可提现健康豆
 */

- (void)setStrBeforehandMoney:(NSString *)strBeforehandMoney{
    _strBeforehandMoney = strBeforehandMoney;
    self.labelBeforehandMoney.text = strBeforehandMoney;
}
#pragma  mark --Action

//头像点击操作
- (void)imageAction{
    //访问摄像头，添加照片
    @weakify(self);
    [self.takePhotoUpdateImg showInVC:[self getCurrentVC] getPhoto:^(UIImagePickerController *picker, UIImage *image, NSDictionary *editingDic) {
        @strongify(self);
        self.imageHeaderTemp = image;
        [[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO];
        
    } upDateImg:^(NSString *updateImgUrl, NSError *updateImgError) {
        @strongify(self);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserHeadImgChangedNotification" object:updateImgUrl];
        [self _uploadUserHeaderImgUrl:updateImgUrl];
    }];
}

/**
 *  健康豆按钮事件
 */
- (void)buttonUsersYunMoneyButtonClick{
    if ([self.delegate respondsToSelector:@selector(UsersYunMoneyButtonAndUsersIntegralButtonClick:)]) {
        self.integralCloudValueValueType = CloudValueButtonType;
        [self.delegate UsersYunMoneyButtonAndUsersIntegralButtonClick:self.integralCloudValueValueType];
    }
}
/**
 *  邀请好友按钮事件
 */
- (void)buttonInvitationFriendButtonClick{
    if ([self.delegate respondsToSelector:@selector(UsersYunMoneyButtonAndUsersIntegralButtonClick:)]) {
        self.integralCloudValueValueType = InvitationFriendType;
        [self.delegate UsersYunMoneyButtonAndUsersIntegralButtonClick:self.integralCloudValueValueType];
    }
}
/**
 *  查看规则按钮事件
 */
- (void)buttonViewRuleButtonClick{
    if ([self.delegate respondsToSelector:@selector(UsersYunMoneyButtonAndUsersIntegralButtonClick:)]) {
        self.integralCloudValueValueType = ViewRuleType;
        [self.delegate UsersYunMoneyButtonAndUsersIntegralButtonClick:self.integralCloudValueValueType];
    }
}

/**
 *  积分按钮事件
 */
- (void)buttonUsersIntegralButtonClick{
    if ([self.delegate respondsToSelector:@selector(UsersYunMoneyButtonAndUsersIntegralButtonClick:)]) {
        self.integralCloudValueValueType = IntegralButtonType;
        [self.delegate UsersYunMoneyButtonAndUsersIntegralButtonClick:self.integralCloudValueValueType];
    }
}

/**
 *  个人信息按钮事件
 */
- (void)userInfoCenterButtonClick{
    if ([self.delegate respondsToSelector:@selector(usersInfoCenterButtonClick)]) {
        [self.delegate usersInfoCenterButtonClick];
    }
}
//我的模块中的点击事件
-(void)myBlockButtonClick:(UIGestureRecognizer *)sender
{
    if ([self.delegate respondsToSelector:@selector(myBlockButtonClick:)]) {
        [self.delegate myBlockButtonClick:sender.view.tag];
    }
}
#pragma mark - 上传头像给服务器
-(void)_uploadUserHeaderImgUrl:(NSString *)userHeaderUrl {
    
    UsersCustomerUpdateImgRequest *request = [[UsersCustomerUpdateImgRequest alloc] init:GetToken];
    request.api_headImgPath = userHeaderUrl;
    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    hub.labelText = @"正在上传用户头像....";
     @weakify(self);
    [self.vapiManager usersCustomerUpdateImg:request success:^(AFHTTPRequestOperation *operation, UsersCustomerUpdateImgResponse *response) {
        @strongify(self);
        //上传头像成功后需要修改本地存储的url
        NSDictionary *dictUserInfo = [kUserDefaults objectForKey:kUserCustomerKey];
        NSMutableDictionary *dictMutableUserInfo = [NSMutableDictionary dictionaryWithDictionary:dictUserInfo];
        [dictMutableUserInfo setValue:userHeaderUrl forKey:@"headImgPath"];
        dictUserInfo = [NSDictionary dictionaryWithDictionary:dictMutableUserInfo];
        [kUserDefaults setObject:dictUserInfo forKey:kUserCustomerKey];
        [kUserDefaults synchronize];
        
        hub.labelText = @"上传头像成功";
        [hub hide:YES afterDelay:1.0f];
        
        self.imageViewHead.image = self.imageHeaderTemp;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hub.labelText = @"上传头像失败";
        [hub hide:YES afterDelay:1.0f];
        
    }];
}

- (void)updateShopIntegral:(NSInteger)shopIntegral isCNUser:(BOOL)isCNUser {
    if (isCNUser) {
        //等待开启
//        self.shopIntegralLab.text = [NSString stringWithFormat:@"购物积分：%ld",shopIntegral];
        self.shopIntegralLab.hidden = NO;
        self.labelNickName.y = self.imageViewHead.y+self.imageViewHead.height + 4;
    }else {
        self.shopIntegralLab.hidden = YES;
        self.labelNickName.y = self.imageViewHead.y+self.imageViewHead.height + 4;
    }
    self.imageViewSex.centerY = self.labelNickName.centerY;
    self.shopIntegralLab.y = MaxY(self.labelNickName) + 1.8;
}

#pragma  mark --getter
/**
 *  背景View
 */
- (UIView *)topBgView {
    if (_topBgView == nil) {
        _topBgView = [[UIView alloc]init];
        _topBgView.backgroundColor = [UIColor colorWithHexString:@"#f9f9f9"];
        _topBgView.frame = CGRectMake(0, 0, kScreenWidth, 1100);
        UIImage *bg=[UIImage imageNamed:@"Myback"];
        UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,
                                                                            260)];
        bgImgView.image=bg;
        
        CGFloat imageIconScale = 8;
        CGFloat btnBounds = kScreenWidth/imageIconScale;
        CGFloat imageIconYScale = 320.0/10.0;

        UIView *imageViewBJHead = [[UIView alloc] init];
        imageViewBJHead.backgroundColor = [UIColor whiteColor];
        imageViewBJHead.frame = CGRectMake((kScreenWidth-58) / 2, kScreenWidth / imageIconYScale+48.5, 58, 58);
        imageViewBJHead.layer.cornerRadius = 58 / 2.0;
        
        [_topBgView addSubview:imageViewBJHead];
        
        [_topBgView addSubview:bgImgView];
        [_topBgView sendSubviewToBack:bgImgView];
        [_topBgView addSubview:self.imageViewHead];
        [_topBgView addSubview:self.labelNickName];
        [_topBgView addSubview:self.imageViewSex];
        [_topBgView addSubview:self.shopIntegralLab];
        
        self.labelNickName.y = self.imageViewHead.y+self.imageViewHead.height+4;
        self.imageViewSex.centerY = self.labelNickName.centerY;
        
        self.viewUserInfoValue = [self loadUserInfoView];
        [_topBgView addSubview:self.viewUserInfoValue];
        
        self.shopIntegralLab.x = self.labelNickName.x;
        self.shopIntegralLab.y = MaxY(self.labelNickName);
        self.shopIntegralLab.width = 160.;
        self.shopIntegralLab.height = 17.;
        
//        UIImageView *imageViewArrRight = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"My_Select"]];
//        imageViewArrRight.frame = CGRectMake(kScreenWidth - 8 - 20, 0, 8, 12);
//        imageViewArrRight.centerY = self.imageViewHead.centerY;
//        [_topBgView addSubview:imageViewArrRight];
        
        //进入消息中心
       
        
        if (iPhoneX_X) {
           _rightButton = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-40, 0, 25, 110)];
        } else {
            _rightButton = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-40, 0, 25, 70)];
        }
        _rightButton.tag=-1;
        _rightButton.userInteractionEnabled=YES;
//        [rightButton addTarget:self action:@selector(myBlockButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *image = [UIImage imageNamed:@"ys_healthmanager_comment"];
        _rightButton.image=image;
        _rightButton.contentMode=UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myBlockButtonClick:)];
        [_rightButton addGestureRecognizer:tap1];
        [_topBgView addSubview:_rightButton];
        //个人信息按钮
        _buttonInfo = [UIButton buttonWithType:UIButtonTypeCustom];
        _buttonInfo.frame =self.labelNickName.frame;
        _buttonInfo.center=self.labelNickName.center;
        _buttonInfo.x=self.labelNickName.x;
        [_buttonInfo addTarget:self action:@selector(userInfoCenterButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_topBgView addSubview:_buttonInfo];
         [_topBgView addSubview:self.invitationFriendView];
        [_topBgView addSubview:self.myHealthView];
        [_topBgView addSubview:self.myTmallView];
        [_topBgView addSubview:self.myServiceView];
        [_topBgView addSubview:self.otherView];
    }
    return _topBgView;
}
/**
 *  头像imageView
 */
- (UIImageView *)imageViewHead {
    if (!_imageViewHead) {
        
        CGFloat imageIconScale = 320.0/45.0;
        CGFloat btnBounds = kScreenWidth/imageIconScale;
        
        _imageViewHead = [[UIImageView alloc] init];
        _imageViewHead.userInteractionEnabled = YES;
        NSDictionary *dic = [kUserDefaults objectForKey:userInfoKey];
        
        [YSImageConfig sd_view:_imageViewHead setimageWithURL:[NSURL URLWithString:dic[@"headImgPath"]] placeholderImage:kDefaultUserIcon];
        _imageViewHead.contentMode = UIViewContentModeScaleAspectFill;
        
        CGFloat imageIconYScale = 320.0/10.0;
        CGFloat imageIconXScale = 320.0/12.0;
        _imageViewHead.frame = CGRectMake((kScreenWidth-55) / 2, kScreenWidth / imageIconYScale+50, 55, 55);
        _imageViewHead.layer.cornerRadius = 55 / 2.0;
        _imageViewHead.clipsToBounds = YES;
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoCenterButtonClick)];
        [_imageViewHead addGestureRecognizer:tap1];
    }
    return _imageViewHead;
}
/**
 *  用户昵称label
 */
- (UILabel *)labelNickName {
    if (_labelNickName == nil) {
        
        CGFloat labelNickNameYScale = 320.0/20.0;
        _labelNickName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.imageViewHead.frame) + 12 , kScreenWidth / labelNickNameYScale, 250, 25)];
        _labelNickName.textColor = kGetColor(255, 255, 255);
        _labelNickName.font = [UIFont systemFontOfSize:18];
        _labelNickName.textAlignment = NSTextAlignmentCenter;
    }
    return _labelNickName;
}
/**
 *  用户等级
 */
- (UILabel *)labelAssociatorLv{
    if (!_labelAssociatorLv) {
        
        CGFloat labelAssociatorLvYScale = 320.0/5.0;
        CGRect rect = CGRectMake(self.labelNickName.x, CGRectGetMaxY(self.labelNickName.frame) + kScreenWidth / labelAssociatorLvYScale, 35, 20);
        _labelAssociatorLv = [[UILabel alloc]initWithFrame:rect];
        _labelAssociatorLv.textColor = kGetColor(254, 0, 0);
        _labelAssociatorLv.font = [UIFont systemFontOfSize:15];
        _labelAssociatorLv.text = @"Lv.10";
        _labelAssociatorLv.textAlignment = NSTextAlignmentLeft;
    }
    return _labelAssociatorLv;
}
/**
 *  性别imageView
 */
//- (UIImageView *)imageViewSex
//{
//    if (!_imageViewSex) {
//        CGRect rect = CGRectMake(0, 0, 16, 16);
//        _imageViewSex.centerY = self.labelNickName.centerY;
//        _imageViewSex = [[UIImageView alloc]initWithFrame:rect];
//    }
//    return _imageViewSex;
//}

/**
 *  CN用户购物积分 */
- (UILabel *)shopIntegralLab {
    if (!_shopIntegralLab) {
        _shopIntegralLab = [[UILabel alloc] init];
        _shopIntegralLab.textAlignment = NSTextAlignmentLeft;
        _shopIntegralLab.font = YSPingFangRegular(12);
        _shopIntegralLab.textColor = [UIColor colorWithHexString:@"#9b9b9b"];
        
        //等待开启
        
//        _shopIntegralLab.text = @"购物积分：0";
        _shopIntegralLab.hidden = YES;
    }
    return _shopIntegralLab;
}

/**
 *  达人等级
 */
- (UILabel *)labelFancier{
    if (!_labelFancier) {
        CGRect rect = CGRectMake(CGRectGetMaxX(self.labelAssociatorLv.frame) + 5, 0, 150, 20);
        _labelFancier = [[UILabel alloc] initWithFrame:rect];
        _labelFancier.textColor = kGetColor(31, 31, 31);
        _labelFancier.font = [UIFont systemFontOfSize:15];
        _labelFancier.text = @"美食达人";
        _labelFancier.centerY = self.labelAssociatorLv.centerY;
        _labelFancier.textAlignment = NSTextAlignmentLeft;
    }
    return _labelFancier;
}

- (void)refreshTopView{
    for(UIView *view in [self.viewUserInfoValue subviews])
    {
        [view removeFromSuperview];
    }
    
    self.viewUserInfoValue = [self loadUserInfoView];
    [self.topBgView addSubview:self.viewUserInfoValue];
    self.backgroundColor = [UIColor colorWithHexString:@"#f9f9f9"];
}

- (UIView *)loadUserInfoView{
    CGFloat viewYScale = 320.0/10.0;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.imageViewHead.frame) + kScreenWidth / viewYScale+30, kScreenWidth-20, 150)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius=5;
    NSArray *arrayLabel;
    NSArray *arrayTitle;
    arrayLabel = [NSArray arrayWithObjects:self.labelUsersYunMoney ,self.labelBeforehandMoney,self.labelUsersIntegral, nil];
    arrayTitle = [NSArray arrayWithObjects:@"健康豆",@"预分润",@"积分", nil];
    
    //需要for循环创建多少个
    NSInteger index = arrayLabel.count;
    CGFloat buttonWidth = kScreenWidth / index;
    
    //按钮
    for (NSInteger i = 0; i < index; i++) {
        
        CGRect rect = CGRectMake( buttonWidth * i, 10, kScreenWidth / index - 0.5, 17);
        UIButton *buttonTrs = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonTrs.frame = rect;
        buttonTrs.height = view.height - 10;
        
        NSString *strTitle = arrayTitle[i];
        //显示数据的label
        UILabel *labelTrs = arrayLabel[i];
        CGFloat labelY = 18;
        if (iPhone5) {
            labelY = 9;
        }else if (iPhone6p){
            labelY = 21;
        }
        labelTrs.textAlignment = NSTextAlignmentCenter;
        UIView *continer=[[UIView alloc]initWithFrame:CGRectMake(buttonWidth * i + 0, labelY, rect.size.width, buttonTrs.frame.size.height+buttonTrs.frame.origin.y-labelY)];
        labelTrs.frame=CGRectMake(0, 10, rect.size.width, 30);
        UILabel *line2=[[UILabel alloc]initWithFrame:CGRectMake(0, 40, rect.size.width, 30)];
        UILabel *line3=[[UILabel alloc]initWithFrame:CGRectMake(0, 70, rect.size.width, 10)];
        labelTrs.font=[UIFont systemFontOfSize:22];line2.font=[UIFont systemFontOfSize:14];
        line3.font=[UIFont systemFontOfSize:11];
        line3.textColor=[UIColor grayColor];
        labelTrs.textAlignment=line2.textAlignment=line3.textAlignment=NSTextAlignmentCenter;
        if ([strTitle isEqualToString:@"健康豆"]){
            line2.text=@"健康豆";
            line3.text=@"了解健康豆";
            [buttonTrs addTarget:self action:@selector(buttonUsersYunMoneyButtonClick) forControlEvents:UIControlEventTouchUpInside];
        }else if ([strTitle isEqualToString:@"预分润"]){
            line2.text=@"预分润";
            line3.text=@"好友消费利润的收益";
            [buttonTrs addTarget:self action:@selector(buttonUsersYunMoneyButtonClick) forControlEvents:UIControlEventTouchUpInside];
        }else if ([strTitle isEqualToString:@"积分"]){
            line2.text=@"红包卡劵";
            line3.text=@"优惠券积分明细";
            [buttonTrs addTarget:self action:@selector(buttonUsersIntegralButtonClick) forControlEvents:UIControlEventTouchUpInside];
        }
        [continer addSubview:labelTrs];
        [continer addSubview:line2];
        [continer addSubview:line3];
        [view addSubview:continer];
        [view addSubview:buttonTrs];
    }
    return view;
}
/*
 *邀请好友
 */
-(UIView *)invitationFriendView{
    if(!_invitationFriendView){
            _invitationFriendView=[[UIView alloc]initWithFrame:CGRectMake(10, self.loadUserInfoView.frame.origin.y+self.loadUserInfoView.frame.size.height+10, kScreenWidth-20 , 145)];
            _invitationFriendView.layer.cornerRadius=5;
            _invitationFriendView.backgroundColor=UIColorFromRGB(0xffffff);
//            UILabel *desc=[[UILabel alloc]initWithFrame:CGRectMake(-10, 10, kScreenWidth , 30)];
//            NSString *strIntegral=@"分享好友能赚钱，好友越多越富裕! ";
//            NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc]initWithString:strIntegral];
//            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
//            attch.image = [UIImage imageNamed:@"MyRecommdFriend"];
//            attch.bounds = CGRectMake(-5, -6, 20, 20);
//            NSAttributedString *imageAtt = [NSAttributedString attributedStringWithAttachment:attch];
//            [strAtt insertAttributedString:imageAtt atIndex:0];
//            [strAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, strIntegral.length)];
//            [strAtt addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x525252) range:NSMakeRange(0, strIntegral.length)];
//            desc.attributedText = strAtt;
//            CGFloat whs=540/132;
//            UIButton *invitationButton=[[UIButton alloc]initWithFrame:CGRectMake((_invitationFriendView.frame.size.width-220)/2, 50, 220 , 45)];
//            invitationButton.layer.cornerRadius=5;
//            [invitationButton setBackgroundImage:[UIImage imageNamed:@"invitationFriendButton"] forState:UIControlStateNormal];
//            [invitationButton setTitle:@"邀请好友" forState:UIControlStateNormal];
//            [invitationButton addTarget:self action:@selector(buttonInvitationFriendButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *invitationButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, _invitationFriendView.width , _invitationFriendView.height)];
        invitationButton.layer.cornerRadius=5;
        [invitationButton setBackgroundImage:[UIImage imageNamed:@"newhongbao"] forState:UIControlStateNormal];
       // [invitationButton setTitle:@"邀请好友" forState:UIControlStateNormal];
        [invitationButton addTarget:self action:@selector(buttonInvitationFriendButtonClick) forControlEvents:UIControlEventTouchUpInside];
//            UIButton *rule=[[UIButton alloc]initWithFrame:CGRectMake((_invitationFriendView.frame.size.width-100)/2, 112, 100 , 20)];
//            [rule setTitle:@"查看规则" forState:UIControlStateNormal];
//            rule.titleLabel.font = [UIFont systemFontOfSize: 14.0];
//            [rule setTitleColor:UIColorFromRGB(0x969696) forState:UIControlStateNormal];
//            [rule addTarget:self action:@selector(buttonViewRuleButtonClick) forControlEvents:UIControlEventTouchUpInside]; rule.titleLabel.textAlignment=desc.textAlignment=invitationButton.titleLabel.textAlignment=NSTextAlignmentCenter;
//            [_invitationFriendView addSubview:desc];
            [_invitationFriendView addSubview:invitationButton];
//            [_invitationFriendView addSubview:rule];
    }
    return _invitationFriendView;
}
//我的健康
/*
 *我的健康
 */
-(UIView *)myHealthView{
    if(!_myHealthView){
        _myHealthView=[[UIView alloc]initWithFrame:CGRectMake(10, self.invitationFriendView.frame.origin.y+self.invitationFriendView.frame.size.height+10, kScreenWidth-20 , 130)];
        _myHealthView.layer.cornerRadius=5;
        _myHealthView.backgroundColor=UIColorFromRGB(0xffffff);
        UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, _myHealthView.size.width , 30)];
        title.text=@"我的健康";
        title.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.f];
        title.textColor=[UIColor colorWithHexString:@"#333333"];
        UILabel *line=[[UIView alloc]initWithFrame:CGRectMake(0, 40, _myHealthView.size.width , 1)];
        line.backgroundColor=[UIColor colorWithHexString:@"#EBEBEB"];
        UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0, 40, _myHealthView.size.width , 100)];
        UIView *healthyTask=[self genItemTitle:@"健康任务" imageName:@"healthyTask" width:_myHealthView.size.width/3];
        UIView *healthyDoc=[self genItemTitle:@"健康档案" imageName:@"healthyDoc" width:_myHealthView.size.width/3];
        UIView *healthyDevice=[self genItemTitle:@"健康设备" imageName:@"healthyDevice" width:_myHealthView.size.width/3];
        healthyDoc.x=_myHealthView.size.width/3;
        healthyDevice.x=_myHealthView.size.width/3*2;
        [line1 addSubview:healthyTask]; [line1 addSubview:healthyDoc]; [line1 addSubview:healthyDevice];
        [_myHealthView addSubview:title]; [_myHealthView addSubview:line]; [_myHealthView addSubview:line1];
    }
    return _myHealthView;
}
//我的商城
-(UIView *)myTmallView{
    if(!_myTmallView){
        _myTmallView=[[UIView alloc]initWithFrame:CGRectMake(10, self.myHealthView.frame.origin.y+self.myHealthView.frame.size.height+10, kScreenWidth-20 , 220)];
        _myTmallView.layer.cornerRadius=5;
        _myTmallView.backgroundColor=UIColorFromRGB(0xffffff);
        UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, _myTmallView.size.width , 30)];
        title.text=@"我的商城";
        title.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.f];
        title.textColor=[UIColor colorWithHexString:@"#333333"];
        UILabel *line=[[UIView alloc]initWithFrame:CGRectMake(0, 40, _myTmallView.size.width , 1)];
        line.backgroundColor=[UIColor colorWithHexString:@"#EBEBEB"];
        UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0, 40, _myTmallView.size.width , 200)];
        UIView *myOrder=[self genItemTitle:@"我的订单" imageName:@"myorder" width:_myTmallView.size.width/3];
        //UIView *quan=[self genItemTitle:@"优惠券" imageName:@"quan" width:_myTmallView.size.width/3];
           UIView *quan=[self genItemTitle:@"收货地址" imageName:@"address" width:_myTmallView.size.width/3];
      
        UIView *address=[self genItemTitle:@"兑换订单" imageName:@"duihuanorder" width:_myTmallView.size.width/3];
          
        quan.x=_myTmallView.size.width/3;
        address.x=_myTmallView.size.width/3*2;
        UIView *duihuanOrder=[self genItemTitle:@"商品退货" imageName:@"tuihuo" width:_myHealthView.size.width/3];
       // UIView *tuihuo=[self genItemTitle:@"商品退货" imageName:@"tuihuo" width:_myHealthView.size.width/3];
     //     UIView *tuihuo1=[self genItemTitle:@"领劵中心" imageName:@"lingjuan" width:_myHealthView.size.width/3];
       // tuihuo.x=_myTmallView.size.width/3;
        //tuihuo1.x= _myTmallView.size.width/3*2;
        
        duihuanOrder.y=90;
      //  tuihuo.y=90;
       // tuihuo1.y=90;
        [line1 addSubview:myOrder]; [line1 addSubview:quan]; [line1 addSubview:address];[line1 addSubview:duihuanOrder];
        //[line1 addSubview:tuihuo];[line1 addSubview:tuihuo1];
        [_myTmallView addSubview:title]; [_myTmallView addSubview:line]; [_myTmallView addSubview:line1];
    }
    return _myTmallView;
}
/*
 *我的服务
 */
-(UIView *)myServiceView{
    if(!_myServiceView){
        _myServiceView=[[UIView alloc]initWithFrame:CGRectMake(10, self.myTmallView.frame.origin.y+self.myTmallView.frame.size.height+10, kScreenWidth-20 , 130)];
        _myServiceView.layer.cornerRadius=5;
        _myServiceView.backgroundColor=UIColorFromRGB(0xffffff);
        UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, _myServiceView.size.width , 30)];
        title.text=@"我的服务";
        title.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.f];
        title.textColor=[UIColor colorWithHexString:@"#333333"];
        UILabel *line=[[UIView alloc]initWithFrame:CGRectMake(0, 40, _myServiceView.size.width , 1)];
        line.backgroundColor=[UIColor colorWithHexString:@"#EBEBEB"];
        UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0, 40, _myServiceView.size.width , 100)];
        UIView *serviceorder=[self genItemTitle:@"服务订单" imageName:@"serviceorder" width:_myServiceView.size.width/3];
        UIView *chuxingorder=[self genItemTitle:@"便民出行订单" imageName:@"chuxingorder" width:_myServiceView.size.width/3];
        chuxingorder.x=_myServiceView.size.width/3;
        [line1 addSubview:serviceorder]; [line1 addSubview:chuxingorder];
        [_myServiceView addSubview:title]; [_myServiceView addSubview:line]; [_myServiceView addSubview:line1];
    }
    return _myServiceView;
}
/*
 *我的健康
 */
-(UIView *)otherView{
    if(!_otherView){
        _otherView=[[UIView alloc]initWithFrame:CGRectMake(10, self.myServiceView.frame.origin.y+self.myServiceView.frame.size.height+10, kScreenWidth-20 , 130)];
        _otherView.layer.cornerRadius=5;
        _otherView.backgroundColor=UIColorFromRGB(0xffffff);
        UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, _otherView.size.width , 30)];
        title.text=@"我的健康";
        title.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.f];
        title.textColor=[UIColor colorWithHexString:@"#333333"];
        UILabel *line=[[UIView alloc]initWithFrame:CGRectMake(0, 40, _otherView.size.width , 1)];
        line.backgroundColor=[UIColor colorWithHexString:@"#EBEBEB"];
        UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0, 40, _otherView.size.width , 100)];
        UIView *mytiezi=[self genItemTitle:@"我发的帖子" imageName:@"mytiezi" width:_otherView.size.width/3];
        UIView *myshoucang=[self genItemTitle:@"我的收藏" imageName:@"myshoucang" width:_otherView.size.width/3];
        UIView *setting=[self genItemTitle:@"设置" imageName:@"setting" width:_otherView.size.width/3];
        myshoucang.x=_otherView.size.width/3;
        setting.x=_otherView.size.width/3*2;
        [line1 addSubview:mytiezi]; [line1 addSubview:myshoucang]; [line1 addSubview:setting];
        [_otherView addSubview:title]; [_otherView addSubview:line]; [_otherView addSubview:line1];
    }
    return _otherView;
}
//生成单项
-(UIView *)genItemTitle:(NSString *)title imageName:(NSString *)imageName width:(CGFloat)width{
    UIView *item=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 90)];
    
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 30, 30)];
    img.image=[UIImage imageNamed:imageName];
    img.centerX=item.centerX;
    [item addSubview:img];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 50, width, 20)];
    titleLabel.text=title;
    titleLabel.centerX=item.centerX;
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor colorWithHexString:@"#525252"];
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16.f];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myBlockButtonClick:)];
    [item addGestureRecognizer:tap1];
    [item addSubview:titleLabel];
    item.tag=[_blockName indexOfObject:title];
    return item;
}


- (TakePhotoUpdateImg *)takePhotoUpdateImg {
    if (_takePhotoUpdateImg == nil) {
        _takePhotoUpdateImg = [[TakePhotoUpdateImg alloc] init];
    }
    return _takePhotoUpdateImg;
}
- (VApiManager *)vapiManager{
    if (!_vapiManager) {
        _vapiManager = [[VApiManager alloc]init];
    }
    return _vapiManager;
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}
- (UILabel *)labelUsersYunMoney{
    if (!_labelUsersYunMoney) {
        _labelUsersYunMoney = [[UILabel alloc]init];
    }
    return _labelUsersYunMoney;
}
- (UILabel *)labelBeforehandMoney{
    if (!_labelBeforehandMoney) {
        _labelBeforehandMoney = [[UILabel alloc]init];
    }
    return _labelBeforehandMoney;
}

- (UILabel *)labelCloudBuyMoney{
    if (!_labelCloudBuyMoney) {
        _labelCloudBuyMoney = [[UILabel alloc]init];
    }
    return _labelCloudBuyMoney;
}
- (UILabel *)labelUsersIntegral{
    if (!_labelUsersIntegral) {
        _labelUsersIntegral = [[UILabel alloc]init];
    }
    return _labelUsersIntegral;
}


@end
