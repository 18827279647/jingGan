//
//  WSJShoppingCartTableViewCell.m
//  jingGang
//
//  Created by thinker on 15/8/7.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//购物车cell

#import "WSJShoppingCartTableViewCell.h"
#import "GlobeObject.h"
#import "YSLoginManager.h"
#import "YSImageConfig.h"
#import "YSThumbnailManager.h"
@interface WSJShoppingCartTableViewCell ()
{
    WSJShoppingCartInfoModel *_model;
}

//选中按钮
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
//标题图片
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
//重消
@property (weak, nonatomic) IBOutlet UILabel *labelCxbValue;
//标题名称
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//商品规格
@property (weak, nonatomic) IBOutlet UILabel *specInfo;
//物件价格
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
//积分+现金
@property (weak, nonatomic) IBOutlet UILabel *labelIntegralAppendCash;
//积分logo
@property (weak, nonatomic) IBOutlet UILabel *labelIntegralLogo;
//商品个数
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
//只支持购物积分支付提示语label
@property (weak, nonatomic) IBOutlet UILabel *labelJustIntegralPayNotice;
//只支持重消支付提示语label
@property (weak, nonatomic) IBOutlet UILabel *labelJustCxbPayNotice;

@property (weak, nonatomic) IBOutlet UILabel *BenginTimeLabel;
@property (strong, nonatomic)  YYTimer *SMStimer;
@property (assign, nonatomic)  NSInteger totalMilliseconds;

@property (weak, nonatomic) IBOutlet UILabel *lblYugao;
@property (weak, nonatomic) IBOutlet UILabel *lblyuGaoTitle;

@end

@implementation WSJShoppingCartTableViewCell
- (void)willCellWith:(WSJShoppingCartInfoModel *)model
{
    _model = model;
    self.selectBtn.selected = model.isSelect;
    
    NSString *strGoodImageUrl = [YSThumbnailManager shopShoppingCartGoodsPicUrlString:model.imageURL];
    [YSImageConfig yy_view:self.titleImageView setImageWithURL:[NSURL URLWithString:strGoodImageUrl]  placeholderImage:DEFAULTIMG];
    self.titleLabel.text = model.name;
    if (model.specInfo.length > 0 && model.specInfo) {
        self.specInfo.text = model.specInfo;
    }else{
        self.specInfo.text = @"规格：暂无";
    }
    NSLog(@"%@",model.data);
    //self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[model.goodsCurrentPrice floatValue]];
    
     self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[model.data[@"goods"][@"goodsShowPrice"]floatValue]];
    
    NSLog(@"[model.goodsCurrentPrice[model.goodsCurrentPrice%@",model.goodsCurrentPrice);
    self.countLabel.text = [NSString stringWithFormat:@"X%@",model.count];
    
    self.BenginTimeLabel.hidden = YES;
    self.totalMilliseconds = [model.lastTime integerValue] / 1000;
    self.selectBtn.hidden = NO;
    
    self.lblYugao.hidden = self.lblyuGaoTitle.hidden = YES;
    if (model.isSpike ) {
        if(!model.isCanBuy) {
            self.selectBtn.hidden = YES;
        }
        self.BenginTimeLabel.hidden = NO;
        self.lblYugao.hidden = self.lblyuGaoTitle.hidden = CRIsNullOrEmpty(model.noticeText);
        self.lblYugao.text = model.noticeDetail;
        self.lblyuGaoTitle.text = model.noticeText;
        if (self.totalMilliseconds > 0) {
            [self startTimer];
        }
    }
    else
    {
        [self.SMStimer invalidate];
    }
    
    NSDictionary *dictData  = [NSDictionary dictionaryWithDictionary:model.data];
    NSNumber *isYgb         = dictData[@"isYgb"];

    
    
    if (isYgb.boolValue) {
        
        self.labelCxbValue.hidden           = YES;
        self.labelIntegralAppendCash.hidden = NO;
        self.labelIntegralLogo.hidden       = NO;
        //精品专区商品只显示一行标题名称
        self.titleLabel.numberOfLines = 1;
        //是精品专区商品
        NSDictionary *dictGoods = [NSDictionary dictionaryWithDictionary:dictData[@"goods"]];
        NSNumber *cxbValue      = dictGoods[@"yunGouBi"];
        NSNumber *needMoney     = dictGoods[@"needMoney"];
        NSString *needIntegral  = [NSString stringWithFormat:@"%@",dictGoods[@"needIntegral"]];
        NSInteger proType       = [dictGoods[@"proType"] integerValue];
        
        
        if (![YSLoginManager isCNAccount]) {
            //不是CN账号展示精品专区商品
            //积分+现金
            NSString *strIntegralAppendCash = [NSString stringWithFormat:@"%@ + %.2f元",needIntegral,[needMoney floatValue]];
//            NSMutableAttributedString *attrStrIntegralAppendCash = [[NSMutableAttributedString alloc]initWithString:strIntegralAppendCash];
//            [attrStrIntegralAppendCash addAttribute:NSForegroundColorAttributeName value:[YSThemeManager buttonBgColor] range:NSMakeRange(0, needIntegral.length)];
//            self.labelIntegralAppendCash.attributedText = attrStrIntegralAppendCash;
             self.labelIntegralAppendCash.text = strIntegralAppendCash;
            self.labelIntegralAppendCash.hidden = NO;
            self.labelIntegralLogo.hidden = NO;
            self.labelJustCxbPayNotice.hidden = YES;
            self.labelCxbValue.hidden = YES;
            return;
        }
        
        
        //重消
        if (proType == 1) {
            self.labelCxbValue.text = [NSString stringWithFormat:@"  重消 %.0f  ",[cxbValue floatValue]];
            self.labelCxbValue.hidden = YES;
            self.labelJustIntegralPayNotice.hidden = YES;
        }else{
            self.labelCxbValue.hidden = YES;
            self.labelJustIntegralPayNotice.hidden = NO;
        }
        
        if (proType == 2) {
            //积分+现金
            NSString *strIntegralAppendCash = [NSString stringWithFormat:@"%@ + %.2f元",needIntegral,[needMoney floatValue]];
//            NSMutableAttributedString *attrStrIntegralAppendCash = [[NSMutableAttributedString alloc]initWithString:strIntegralAppendCash];
//            [attrStrIntegralAppendCash addAttribute:NSForegroundColorAttributeName value:[YSThemeManager buttonBgColor] range:NSMakeRange(0, needIntegral.length)];
//            self.labelIntegralAppendCash.attributedText = attrStrIntegralAppendCash;
            self.labelIntegralAppendCash.text = strIntegralAppendCash;

            self.labelIntegralAppendCash.hidden = NO;
            self.labelIntegralLogo.hidden = NO;
            self.labelJustCxbPayNotice.hidden = YES;
        }else{
            self.labelIntegralAppendCash.hidden = YES;
            self.labelIntegralLogo.hidden = YES;
            self.labelJustCxbPayNotice.hidden = NO;
        }
        
        if (proType == 3) {
            self.labelCxbValue.text = [NSString stringWithFormat:@"  重消 %.0f  ",[cxbValue floatValue]];
            self.labelCxbValue.hidden = YES;
            self.labelJustIntegralPayNotice.hidden = YES;

            //积分+现金
            NSString *strIntegralAppendCash = [NSString stringWithFormat:@"%@ + %.2f元",needIntegral,[needMoney floatValue]];
//            NSMutableAttributedString *attrStrIntegralAppendCash = [[NSMutableAttributedString alloc]initWithString:strIntegralAppendCash];
//            [attrStrIntegralAppendCash addAttribute:NSForegroundColorAttributeName value:[YSThemeManager buttonBgColor] range:NSMakeRange(0, needIntegral.length)];
//            self.labelIntegralAppendCash.attributedText = attrStrIntegralAppendCash;
            self.labelIntegralAppendCash.text = strIntegralAppendCash;

            self.labelIntegralAppendCash.hidden = NO;
            self.labelIntegralLogo.hidden = NO;
            self.labelJustCxbPayNotice.hidden = YES;
        }
        
    }else{
        self.titleLabel.numberOfLines = 2;
        self.labelCxbValue.hidden           = YES;
        self.labelIntegralAppendCash.hidden = YES;
        self.labelIntegralLogo.hidden       = YES;
        self.labelJustCxbPayNotice.hidden = YES;
        self.labelJustIntegralPayNotice.hidden = YES;
    }
    
    
}

- (void)startTimer
{
    if ([self.SMStimer isValid] ) {
        [self.SMStimer invalidate];
    }
    self.SMStimer = [YYTimer timerWithTimeInterval:1 target:self selector:@selector(handleTimerOnEnd:) repeats:YES];
    [self.SMStimer fire];
}
#pragma 倒计时计时器
- (void)handleTimerOnEnd:(NSTimer *)timer
{
    NSInteger totalIntervale = self.totalMilliseconds;
    NSInteger seconds = totalIntervale % 60;
    NSInteger minutes = totalIntervale / 60 % 60;
    NSInteger hours = totalIntervale / 3600;

    NSString *string = CRString(@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds);
    if (_model.isStarted) {
        self.BenginTimeLabel.text = [NSString stringWithFormat:@"距结束%@", string];
    } else {
        self.BenginTimeLabel.text = [NSString stringWithFormat:@"距开始%@", string];
    }
    self.totalMilliseconds--;
    if (self.totalMilliseconds <= 0) {
        [self.SMStimer invalidate];
        self.SMStimer = nil;
        self.BenginTimeLabel.hidden = YES;
    }
}

- (IBAction)selectAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    _model.isSelect = sender.selected;
    if (self.selectShopping)
    {
        self.selectShopping([_model.ID stringValue],sender.selected,self.indexPathSelect);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.priceLabel.textColor = [YSThemeManager priceColor];
    self.labelCxbValue.layer.borderWidth = 0.5;
//    self.labelIntegralLogo.backgroundColor = [YSThemeManager buttonBgColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)btnAction:(id)sender {
    if (_model.isSpike) {
        if (!_model.isCanBuy) {
            [CRMainWindow() makeToast:@"该商品不能购买"];
            return;
        }
    }
    [self selectAction:self.selectBtn];
}

- (void)setIndexPathSelect:(NSIndexPath *)indexPathSelect{
    _indexPathSelect = indexPathSelect;
}

@end
