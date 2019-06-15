//
//  YSCloudBuyMoneyListHeaderView.m
//  jingGang
//
//  Created by HanZhongchou on 2017/7/21.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//精选专区头部

#import "YSCloudBuyMoneyListHeaderView.h"
#import "GlobeObject.h"
#import "YSImageConfig.h"
#import "NSString+Font.h"
#import "YSThumbnailManager.h"
#import "YSLoginManager.h"
#import "YSAdContentItem.h"
#import "YSAdContentView.h"
#import "VApiManager.h"
@interface YSCloudBuyMoneyListHeaderView ()
/**
 *  用户头像imageView
 */

@property (nonatomic, strong) VApiManager *vapiManager;
@property (nonatomic,strong) UIImageView *imageViewHeadIcon;

@property (nonatomic,strong) UIImageView *seximage;
/**
 *  用户昵称label
 */
@property (nonatomic,strong) UILabel *labelUserNickName;
/**
 *  用户积分label
 */
@property (nonatomic,strong) UILabel *labelUserIntegral;
/**
 *  用户积分标题label
 */
@property (nonatomic,strong) UILabel *labelUserIntegralTitel;
/**
 *  CN用户购物积分label
 */
@property (nonatomic,strong) UILabel *labelCNShoppingIntegral;
/**
 *  CN用户重消label
 */
@property (nonatomic,strong) UILabel *labelCNUserCXB;

@property (nonatomic,strong) YSAdContentView *adContentView;



@end

@implementation YSCloudBuyMoneyListHeaderView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initUI];
      
//        NSLog(@"dic+++%@",dic);
    }
    return self;
}
- (void)setAdContentItem:(YSAdContentItem *)adContentItem {
    _adContentItem = adContentItem;
    
    CGFloat adContentViewY = 83.0;
    if ([YSLoginManager isCNAccount]) {
        adContentViewY = 83.0;
    }
    //添加广告位
     @weakify(self);
    CGRect adContentRect = CGRectMake(0, adContentViewY, self.width, _adContentItem.adTotleHeight);
    if (!self.adContentView) {
        YSAdContentView *adContentView = [[YSAdContentView alloc] initWithFrame:adContentRect clickItem:^(YSNearAdContent *adContentModel) {
            @strongify(self);
            BLOCK_EXEC(self.selectHeaderViewAdContentItemBlock,adContentModel);
        }];
                adContentView.backgroundColor = UIColorFromRGB(0xf7f7f7);
        [self addSubview:adContentView];
        self.adContentView = adContentView;
    }else {
        self.adContentView.frame = adContentRect;
    }
    self.adContentView.adContentItem = adContentItem;
    if (!adContentItem) {
        self.adContentView.hidden = YES;
    }
    if (self.adContentItem.adTotleHeight <= 0) {
        self.adContentView.hidden = YES;
    }else {
        self.adContentView.hidden = NO;
    }
}

- (void)initUI{
    //用户头像
    UIImageView *imageViewHeadIcon = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 53, 53)];
    imageViewHeadIcon.layer.cornerRadius = imageViewHeadIcon.height/2;
    imageViewHeadIcon.clipsToBounds = YES;
    imageViewHeadIcon.image = kDefaultUserIcon;
    self.imageViewHeadIcon = imageViewHeadIcon;
    [self addSubview:imageViewHeadIcon];
    
    //用户名
    CGFloat nickNameX = CGRectGetMaxX(imageViewHeadIcon.frame) + 11;
    UILabel *labelUserNickName = [[UILabel alloc]initWithFrame:CGRectMake(nickNameX, 15, 50, 18)];
    labelUserNickName.text = @"";
//    labelUserNickName.centerY = imageViewHeadIcon.centerY;
    labelUserNickName.font = [UIFont systemFontOfSize:16];
    labelUserNickName.textColor = UIColorFromRGB(0x4a4a4a);
    self.labelUserNickName = labelUserNickName;
    [self addSubview:labelUserNickName];
    
     CGFloat labelUserNickX = CGRectGetMaxX(labelUserNickName.frame) + 10;
    UIImageView *seximage = [[UIImageView alloc]initWithFrame:CGRectMake(labelUserNickX , 15, 15, 15)];

    
    self.seximage = seximage;
    [self addSubview:seximage];
    
    //用户积分标题
//    CGFloat IntergralX = CGRectGetMaxX(labelUserNickName.frame) + 11;
    UILabel *labelUserIntergralTitle  = [[UILabel alloc]initWithFrame:CGRectMake(nickNameX, 40, 50, 17)];
//    labelUserIntergralTitle.centerY   = labelUserNickName.centerY;
    labelUserIntergralTitle.text      = @"我的积分";
    labelUserIntergralTitle.textColor = UIColorFromRGB(0x9b9b9b);
    labelUserIntergralTitle.font      = [UIFont systemFontOfSize:12.0];
    self.labelUserIntegralTitel       = labelUserIntergralTitle;
    [self addSubview:labelUserIntergralTitle];
    
    //用户的积分
    CGFloat labelUserIntergalX = CGRectGetMaxX(labelUserIntergralTitle.frame) + 5;
    UILabel *labelUserIntergal = [[UILabel alloc]initWithFrame:CGRectMake(labelUserIntergalX, 40, 50, 17)];
//    labelUserIntergal.centerY = labelUserNickName.centerY;
    labelUserIntergal.text = @"0";
    labelUserIntergal.font = [UIFont systemFontOfSize:12];
    labelUserIntergal.layer.cornerRadius = 7.5;
    labelUserIntergal.textAlignment = NSTextAlignmentCenter;
    labelUserIntergal.layer.borderWidth  = 0.5;
    labelUserIntergal.layer.borderColor  = [YSThemeManager buttonBgColor].CGColor;
    labelUserIntergal.textColor          = [YSThemeManager buttonBgColor];
    self.labelUserIntegral = labelUserIntergal;
    [self addSubview:labelUserIntergal];
    
    //右边的小箭头
    UIImageView *imageViewRightArr = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"FineZone_Header_RightArr"]];
    imageViewRightArr.frame        = CGRectMake(kScreenWidth - 25, 0, 7, 12);
    imageViewRightArr.centerY      = imageViewHeadIcon.centerY;
    [self addSubview:imageViewRightArr];
    
    UIView *viewBottom = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 7, kScreenWidth, 7)];
    viewBottom.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [self addSubview:viewBottom];
    
    //添加点击跳转按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(68, 0, kScreenWidth - 68, 83);
    [button addTarget:self action:@selector(headerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    
    
//
//
//    if ([YSLoginManager isCNAccount]) {
//        //如果是CN账号，执行下面代码
////        [self initCNAccountUserInfoUI];
//         CGFloat labelUserIntergalX = CGRectGetMaxX(labelUserIntergal.frame) +30;
//        UILabel *labelTitle      = [[UILabel alloc]initWithFrame:CGRectMake(labelUserIntergalX,  40, 50, 17)];
////        labelTitle.y             = CGRectGetMaxY(labelChange.frame);
//        labelTitle.text          = @"购物积分";
//        labelTitle.textAlignment = NSTextAlignmentCenter;
//        labelTitle.textColor     = UIColorFromRGB(0x9b9b9b);
//        labelTitle.font          = [UIFont systemFontOfSize:12];
//        [self addSubview:labelTitle];
//
//       CGFloat labelTitleX = CGRectGetMaxX(labelTitle.frame) +10;
//        UILabel *labelChange      = [[UILabel alloc]init];
//        labelChange.frame         = CGRectMake(labelTitleX, 40, 50, 17);
//        labelChange.text          = @"0";
//        labelChange.font = [UIFont systemFontOfSize:12];
//        labelChange.layer.cornerRadius = 7.5;
//        labelChange.textAlignment = NSTextAlignmentCenter;
//        labelChange.layer.borderWidth  = 0.5;
//        labelChange.layer.borderColor  = [YSThemeManager buttonBgColor].CGColor;
//        labelChange.textColor          = [YSThemeManager buttonBgColor];
//        self.labelCNShoppingIntegral = labelChange;
//
//        [self addSubview:labelChange];
//
//
//
//    }

    
}
//加载CN账号用户信息UI
- (void)initCNAccountUserInfoUI{
    UIView *viewCNAccountBg = [[UIView alloc]initWithFrame:CGRectMake(0, 83, kScreenWidth, self.height - 83 - 7)];
    viewCNAccountBg.backgroundColor = UIColorFromRGB(0xf0f0f0);
    [self addSubview:viewCNAccountBg];
    
    NSArray *arrayLabel = [NSArray arrayWithObjects:self.labelCNShoppingIntegral ,self.labelCNUserCXB, nil];
    NSArray *arrayTitle = [NSArray arrayWithObjects:@"购物积分",@"重消", nil];
    CGFloat viewWidth = kScreenWidth / 2 - 0.25;
    for (NSInteger i = 0; i < 2; i++) {
        UIView *viewCN = [[UIView alloc]initWithFrame:CGRectMake(i * (viewWidth + 0.5), 0.5, viewWidth,viewCNAccountBg.height)];
        viewCN.backgroundColor = [UIColor whiteColor];
        [viewCNAccountBg addSubview:viewCN];
        
        UILabel *labelChange      = arrayLabel[i];
        labelChange.frame         = CGRectMake(0, 10, viewWidth, 17);
        labelChange.text          = @"0";
        labelChange.textAlignment = NSTextAlignmentCenter;
        labelChange.font          = [UIFont boldSystemFontOfSize:16.0];
        labelChange.textColor     = UIColorFromRGB(0x4a4a4a);
        [viewCN addSubview:labelChange];
        
        UILabel *labelTitle      = [[UILabel alloc]initWithFrame:labelChange.frame];
        labelTitle.y             = CGRectGetMaxY(labelChange.frame);
        labelTitle.text          = arrayTitle[i];
        labelTitle.textAlignment = NSTextAlignmentCenter;
        labelTitle.textColor     = UIColorFromRGB(0x9b9b9b);
        labelTitle.font          = [UIFont systemFontOfSize:12];
        [viewCN addSubview:labelTitle];
    }
}

- (void)setDictUserInfo:(NSDictionary *)dictUserInfo{
    _dictUserInfo = dictUserInfo;
    

    //用户头像赋值
    NSString *strHeadIconUrl = [YSThumbnailManager personalCenterUserHeaderPhotoPicUrlString:[NSString stringWithFormat:@"%@",dictUserInfo[@"headImgPath"]]];
    [YSImageConfig yy_view:self.imageViewHeadIcon setImageWithURL:[NSURL URLWithString:strHeadIconUrl] placeholderImage:kDefaultUserIcon];
    
    //用户积分赋值
    NSString *strUserintegral = [NSString stringWithFormat:@"%@",dictUserInfo[@"integral"]];
    self.labelUserIntegral.text = strUserintegral;
    //重新设置积分label的x和宽度
    //计算出用户积分字符串的宽度
//    CGFloat userIntegralStringWidth = [strUserintegral sizeWithFont:[UIFont systemFontOfSize:12] maxH:18].width;
//    cc
//    self.labelUserIntegral.x        = kScreenWidth - 41 - userIntegralStringWidth;
    //我的积分标题的labelx也要重新设置一遍
//    self.labelUserIntegralTitel.x = kScreenWidth - 41 - userIntegralStringWidth - 1 - 50;
    
    //知道了用户积分字符串的宽度再设置用户昵称的宽度，避免昵称过长重叠在一起
    
    NSString *strUserName = [NSString stringWithFormat:@"%@",dictUserInfo[@"nickName"]];
    self.labelUserNickName.text = strUserName;
    
      CGFloat userIntegralStringWidth = [strUserName sizeWithFont:[UIFont systemFontOfSize:16] maxH:18].width;
        self.labelUserNickName.width    = userIntegralStringWidth;
//    self.labelUserNickName.width = kScreenWidth - self.labelUserNickName.x - (kScreenWidth - self.labelUserIntegralTitel.x);
    
    NSUserDefaults *defaults1 =[NSUserDefaults standardUserDefaults];
        int  sex = [[defaults1 objectForKey:@"sex"] intValue];
    
    NSLog(@"sex+++++++++%d",sex);

    if (sex==1) {
       self.seximage.image = [UIImage imageNamed:@"My_BoyIcon"];
    }else{
          self.seximage.image = [UIImage imageNamed:@"My_GirlsIcon"];
    }
    
//        if ([sex isEqualToString:@"1"]) {
    
//        }else{

//        }
    
        self.seximage.x =  CGRectGetMaxX(self.labelUserNickName.frame) +5;
    
    
    if ([YSLoginManager isCNAccount]) {
        
//        NSLog(@"%")
        self.labelCNShoppingIntegral.text = [NSString stringWithFormat:@"%@",dictUserInfo[@"cnIntegral"]];
        
//             self.labelCNShoppingIntegral.text = @"10000";
        self.labelCNUserCXB.text          = [NSString stringWithFormat:@"%@",dictUserInfo[@"bonusRepeat"]];
    }
}

- (void)headerButtonClick{
    BLOCK_EXEC(self.selectHeaderViewButtonClick);
}

- (UILabel *)labelCNShoppingIntegral{
    if (!_labelCNShoppingIntegral) {
        _labelCNShoppingIntegral = [[UILabel alloc]init];
    }
    return _labelCNShoppingIntegral;
}

- (UILabel *)labelCNUserCXB{
    if (!_labelCNUserCXB) {
        _labelCNUserCXB = [[UILabel alloc]init];
    }
    return _labelCNUserCXB;
}


@end
