//
//  YSHotelOrderListCell.m
//  jingGang
//
//  Created by HanZhongchou on 2017/6/12.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSHotelOrderListCell.h"
#import "GlobeObject.h"
#import "YSHotelOrderListModel.h"
#import "YSImageConfig.h"
#import "NSString+Extension.h"
#import "GlobeObject.h"

@interface YSHotelOrderListCell()
/**
 *  酒店标题图片imageView
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageViewHotel;
/**
 *  酒店名称label
 */
@property (weak, nonatomic) IBOutlet UILabel *labelHotelName;
/**
 *  所订房间类型label
 */
@property (weak, nonatomic) IBOutlet UILabel *labelHotelRoomType;
/**
 *  酒店订单状态label
 */
@property (weak, nonatomic) IBOutlet UILabel *labelHotelOrederStatus;
/**
 *  酒店订单价格label
 */
@property (weak, nonatomic) IBOutlet UILabel *labelHotelOrderPrice;
/**
 *  酒店订未付款时的提示信息label
 */
@property (weak, nonatomic) IBOutlet UILabel *labelHotelOrderNoPayPrompting;
/**
 * 日期差值（单位：天） xx晚
 */
@property (weak, nonatomic) IBOutlet UILabel *labelIntervalDay;
/**
 * 入住时间 xx- xx   入: 04-28(周五） 离: 04-29(周六）
 */
@property (weak, nonatomic) IBOutlet UILabel *labelArrivalDateAndDepartureDate;
/**
 * 底部按钮背景view
 */
@property (weak, nonatomic) IBOutlet UIView *viewBottomBg;
/**
 * 底部按钮，由左至右，one 、two
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonThree;
/**
 * 入住时长与右边的距离
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *intervalDayLabelWithRightSpace;
/**
 * 房间类型与右边的距离
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hotelRoomTypeLabelWithRightSpace;

@end

@implementation YSHotelOrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.labelHotelOrderPrice.textColor = [YSThemeManager priceColor];
    if (iPhone5 || iPhone4) {
        self.labelHotelOrderNoPayPrompting.font = [UIFont systemFontOfSize:11.0];
        self.intervalDayLabelWithRightSpace.constant = 5;
    }
    // Initialization code
}

- (IBAction)buttonOneClick:(id)sender {
    if (self.model.showStatus == 512) {
        //已确认，等待入驻---取消订单
        BLOCK_EXEC(self.cancelHotelOrderBlcok,self.indexPath);
    }
}
- (IBAction)buttonTwoClick:(id)sender {
    if (self.model.showStatus == 8 || self.model.showStatus == 1 || self.model.showStatus == 8192) {
        //等待支付、担保失败、支付失败--取消订单
        BLOCK_EXEC(self.cancelHotelOrderBlcok,self.indexPath);
    }else if (self.model.showStatus == 256 || self.model.showStatus == 64 || self.model.showStatus == 128){
        //已取消、未入住、已经离店--删除订单
        BLOCK_EXEC(self.deleteHotelOrderBlcok,self.indexPath);
    }else if (self.model.showStatus == 512){
        //已确认，等待入驻---酒店导航
        BLOCK_EXEC(self.navigationToHotelBlcok,self.indexPath);
    }
}
- (IBAction)buttonThreeClick:(id)sender {
    if (self.model.showStatus == 8) {
        //等待支付
        if ([self.model isDisplayGoUpPayButton]) {
            //等待支付，并且能支付状态--去付款
            BLOCK_EXEC(self.goUpToPayHotelOrderBlcok,self.indexPath);
        }else{
            //等待支付，不能支付状态--取消订单
            BLOCK_EXEC(self.cancelHotelOrderBlcok,self.indexPath);
        }
        
    }else if (self.model.showStatus == 256 || self.model.showStatus == 64 || self.model.showStatus == 128){
        //已取消、未入住、已经离店--再次预订
        BLOCK_EXEC(self.againAdvanceHotelBlcok,self.indexPath);
    }else if (self.model.showStatus == 512){
        //已确认，等待入驻---联系酒店
        BLOCK_EXEC(self.liaisonHotelBlcok,self.indexPath);
    }else if (self.model.showStatus == 1 || self.model.showStatus == 8192){
        //担保失败、支付失败---删除订单
        BLOCK_EXEC(self.deleteHotelOrderBlcok,self.indexPath);
    }else if (self.model.showStatus == 32 || self.model.showStatus == 4){
        //酒店拒绝订单、等待酒店确认---取消订单
        BLOCK_EXEC(self.cancelHotelOrderBlcok,self.indexPath);
    }else if (self.model.showStatus == 2){
        //等待支付担保金---去担保
        BLOCK_EXEC(self.goGuaranteeHotelOrderBlock,self.indexPath);
        
    }
}



- (void)setModel:(YSHotelOrderListModel *)model{
    _model = model;
    [YSImageConfig yy_view:self.imageViewHotel setImageWithURL:[NSURL URLWithString:model.thumbnailUrl] placeholderImage:DEFAULTIMG];
    
    self.labelHotelName.text = model.hotelName;
    
    self.labelHotelRoomType.text = model.roomTypeName;
    
    self.labelIntervalDay.text = [NSString stringWithFormat:@"%ld晚",model.intervalDay];
    
    self.labelHotelOrderPrice.text = [NSString stringWithFormat:@"¥%.2f",model.totalPrice];
    
    [self setHotelOrderStatusWithModelStatus:model.showStatus];
    
    self.labelArrivalDateAndDepartureDate.attributedText = [self getArrivalDateWithArrivalDate:model.arrivalDate andDepartureDate:model.departureDate];
    CGSize size = [self.labelHotelOrderPrice.text sizeWithFont:[UIFont systemFontOfSize:14] maxH:17];
    self.hotelRoomTypeLabelWithRightSpace.constant = size.width + 25;
    
}

- (NSMutableAttributedString *)getArrivalDateWithArrivalDate:(NSString *)strArrivalDate andDepartureDate:(NSString *)strDepartureDate{
    //将字符串转换成NSDate
    NSDate *arrivalDate     = [self getDateWithStringDate:strArrivalDate];
    NSDate *departureDate   = [self getDateWithStringDate:strDepartureDate];
    //通过日期算出那天是星期几
    NSString *strArrivalDateWeek     = [NSString weekdayStringFromDate:arrivalDate];
    NSString *strDepartureDateWeek   = [NSString weekdayStringFromDate:departureDate];
    //裁剪日期字符串，只要月日，其他不要
    strArrivalDate   = [strArrivalDate substringWithRange:NSMakeRange(5, 5)];
    strDepartureDate = [strDepartureDate substringWithRange:NSMakeRange(5, 5)];
    //创建一个字符串
    NSString *strData = [NSString stringWithFormat:@"入：%@(%@） 离：%@(%@）",strArrivalDate,strArrivalDateWeek,strDepartureDate,strDepartureDateWeek];
    NSMutableAttributedString *strAttData = [[NSMutableAttributedString alloc]initWithString:strData];
    
    [strAttData addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x9b9b9b) range:NSMakeRange(7, 4)];
    [strAttData addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x9b9b9b) range:NSMakeRange(19, 4)];
    return strAttData;
}

- (NSDate *)getDateWithStringDate:(NSString *)strDate{
    
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* date = [formater dateFromString:strDate];
    return date;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHotelOrderStatusWithModelStatus:(NSInteger)status{
    
    self.labelHotelOrderNoPayPrompting.hidden = YES;
    self.labelHotelOrederStatus.textColor = UIColorFromRGB(0x4a4a4a);
    self.buttonOne.hidden = YES;
    self.buttonTwo.hidden = YES;
    self.buttonThree.hidden = YES;
    NSString *strOrderStatus = @"状态未知";
    NSString *strLatestArrivalTime = @"";
    
    switch (status) {
        case 1:
            strOrderStatus = @"担保失败";
            
            self.buttonTwo.hidden = NO;
            self.buttonTwo.layer.borderColor = UIColorFromRGB(0xdfdfdf).CGColor;
            [self.buttonTwo setTitle:@"取消订单" forState:UIControlStateNormal];
            [self.buttonTwo setTitleColor:UIColorFromRGB(0x4a4a4a) forState:UIControlStateNormal];
            
            self.buttonThree.hidden = NO;
            self.buttonThree.layer.borderColor = UIColorFromRGB(0xdfdfdf).CGColor;
            [self.buttonThree setTitle:@"删除订单" forState:UIControlStateNormal];
            [self.buttonThree setTitleColor:UIColorFromRGB(0x4a4a4a) forState:UIControlStateNormal];
            self.labelHotelOrederStatus.textColor = UIColorFromRGB(0x4a4a4a);
            
            self.labelHotelOrederStatus.textColor = [YSThemeManager priceColor];
            
            break;
        case 2:
            strOrderStatus = @"等待支付担保金";
            
            //当前手机时间小于最后支付时间，并且isPayable为YES的时候才显示支付按钮
            if ([self.model isDisplayGoUpPayButton]) {
                self.buttonThree.hidden = NO;
                self.buttonThree.layer.borderColor = [YSThemeManager buttonBgColor].CGColor;
                [self.buttonThree setTitle:@"去担保" forState:UIControlStateNormal];
                [self.buttonThree setTitleColor:[YSThemeManager buttonBgColor] forState:UIControlStateNormal];
                self.labelHotelOrederStatus.textColor = UIColorFromRGB(0x4a4a4a);
            }
            break;
        case 4:
            strOrderStatus = @"等待酒店确认";
            //等待确认
            self.buttonThree.hidden = NO;
            self.buttonThree.layer.borderColor = UIColorFromRGB(0xdfdfdf).CGColor;
            [self.buttonThree setTitle:@"取消订单" forState:UIControlStateNormal];
            [self.buttonThree setTitleColor:UIColorFromRGB(0x4a4a4a) forState:UIControlStateNormal];
            self.labelHotelOrederStatus.textColor = [YSThemeManager buttonBgColor];
            break;
        case 8:
            strOrderStatus = @"等待支付";
            
            //当前手机时间小于最后支付时间，并且isPayable为YES的时候才显示支付按钮
            if ([self.model isDisplayGoUpPayButton]) {
                //待付款
                self.buttonTwo.hidden = NO;
                self.buttonTwo.layer.borderColor = UIColorFromRGB(0xdfdfdf).CGColor;
                [self.buttonTwo setTitle:@"取消订单" forState:UIControlStateNormal];
                [self.buttonTwo setTitleColor:UIColorFromRGB(0x4a4a4a) forState:UIControlStateNormal];
                //去支付
                self.buttonThree.hidden = NO;
                self.buttonThree.layer.borderColor = [YSThemeManager themeColor].CGColor;
                [self.buttonThree setTitle:@"去付款" forState:UIControlStateNormal];
//                [self.buttonThree setBackgroundImage:[UIImage imageNamed:@"goumai"] forState:UIControlStateNormal];
                
            }else{
                //否则就只显示取消订单按钮
                self.buttonThree.hidden = NO;
                self.buttonThree.layer.borderColor = UIColorFromRGB(0xdfdfdf).CGColor;
                [self.buttonThree setTitle:@"取消订单" forState:UIControlStateNormal];
                [self.buttonThree setTitleColor:UIColorFromRGB(0x4a4a4a) forState:UIControlStateNormal];
            }
            self.labelHotelOrederStatus.textColor = [YSThemeManager themeColor];
            self.labelHotelOrderNoPayPrompting.hidden = NO;
            strLatestArrivalTime = [self.model.paymentDeadlineTime substringWithRange:NSMakeRange(11, 5)];
            if (self.model.paymentDeadlineTime == 0|| !self.model.paymentDeadlineTime) {
                strLatestArrivalTime = @"00:00";
            }
            self.labelHotelOrderNoPayPrompting.text = [NSString stringWithFormat:@"请于%@之前完成支付，过时订单将自动取消",strLatestArrivalTime];
            self.labelHotelOrderNoPayPrompting.textColor = [YSThemeManager priceColor];
            break;
        case 16:
            strOrderStatus = @"等待核实入住";
            self.labelHotelOrederStatus.textColor = [YSThemeManager buttonBgColor];
            break;
        case 32:
            strOrderStatus = @"酒店拒绝订单";
            self.buttonThree.hidden = NO;
            self.buttonThree.layer.borderColor = UIColorFromRGB(0xdfdfdf).CGColor;
            [self.buttonThree setTitle:@"取消订单" forState:UIControlStateNormal];
            [self.buttonThree setTitleColor:UIColorFromRGB(0x4a4a4a) forState:UIControlStateNormal];

            self.labelHotelOrederStatus.textColor = UIColorFromRGB(0xfe5c44);
            break;
        case 64:
            strOrderStatus = @"未入住";
            self.buttonTwo.hidden = NO;
            self.buttonTwo.layer.borderColor = UIColorFromRGB(0xdfdfdf).CGColor;
            [self.buttonTwo setTitle:@"删除订单" forState:UIControlStateNormal];
            [self.buttonTwo setTitleColor:UIColorFromRGB(0x4a4a4a) forState:UIControlStateNormal];
            
            self.buttonThree.hidden = NO;
            self.buttonThree.layer.borderColor = [YSThemeManager themeColor].CGColor;
            [self.buttonThree setTitle:@"再次预订" forState:UIControlStateNormal];
            [self.buttonThree setTitleColor:[YSThemeManager themeColor] forState:UIControlStateNormal];
            
            break;
        case 128:
            strOrderStatus = @"已经离店";
            self.buttonTwo.hidden = NO;
            self.buttonTwo.layer.borderColor = UIColorFromRGB(0xdfdfdf).CGColor;
            [self.buttonTwo setTitle:@"删除订单" forState:UIControlStateNormal];
            [self.buttonTwo setTitleColor:UIColorFromRGB(0x4a4a4a) forState:UIControlStateNormal];
            
            self.buttonThree.hidden = NO;
            self.buttonThree.layer.borderColor = [YSThemeManager themeColor].CGColor;
            [self.buttonThree setTitle:@"再次预订" forState:UIControlStateNormal];
            [self.buttonThree setTitleColor:[YSThemeManager themeColor] forState:UIControlStateNormal];
            
            self.labelHotelOrederStatus.textColor = UIColorFromRGB(0x4a4a4a);
            break;
        case 256:
            strOrderStatus = @"已取消";
            //已取消
            self.buttonTwo.hidden = NO;
            self.buttonTwo.layer.borderColor = UIColorFromRGB(0xdfdfdf).CGColor;
            [self.buttonTwo setTitle:@"删除订单" forState:UIControlStateNormal];
            [self.buttonTwo setTitleColor:UIColorFromRGB(0x4a4a4a) forState:UIControlStateNormal];
            
            self.buttonThree.hidden = NO;
            self.buttonThree.layer.borderColor = [YSThemeManager themeColor].CGColor;
            [self.buttonThree setTitle:@"再次预订" forState:UIControlStateNormal];
            [self.buttonThree setTitleColor:[YSThemeManager themeColor] forState:UIControlStateNormal];
            
            self.labelHotelOrederStatus.textColor = UIColorFromRGB(0x9b9b9b);
            break;
        case 512:
            strOrderStatus = @"已确认，等待入驻";
            //待入住
            self.buttonOne.hidden = NO;
            self.buttonOne.layer.borderColor = UIColorFromRGB(0xdfdfdf).CGColor;
            [self.buttonOne setTitle:@"取消订单" forState:UIControlStateNormal];
            [self.buttonOne setTitleColor:UIColorFromRGB(0x4a4a4a) forState:UIControlStateNormal];
            
            self.buttonTwo.hidden = NO;
            self.buttonTwo.layer.borderColor = UIColorFromRGB(0xdfdfdf).CGColor;
            [self.buttonTwo setTitle:@"酒店导航" forState:UIControlStateNormal];
            [self.buttonTwo setTitleColor:UIColorFromRGB(0x4a4a4a) forState:UIControlStateNormal];
            
            self.buttonThree.hidden = NO;
            self.buttonThree.layer.borderColor = UIColorFromRGB(0xdfdfdf).CGColor;
            [self.buttonThree setTitle:@"联系酒店" forState:UIControlStateNormal];
            [self.buttonThree setTitleColor:UIColorFromRGB(0x4a4a4a) forState:UIControlStateNormal];
            
            self.labelHotelOrederStatus.textColor = [YSThemeManager themeColor];
            self.labelHotelOrederStatus.textColor = UIColorFromRGB(0x4a4a4a);
            
            self.labelHotelOrderNoPayPrompting.hidden = NO;
            strLatestArrivalTime = [self.model.latestArrivalTime substringWithRange:NSMakeRange(11, 5)];
            self.labelHotelOrderNoPayPrompting.text = [NSString stringWithFormat:@"为您保留至%@",strLatestArrivalTime];
            self.labelHotelOrderNoPayPrompting.textColor = [YSThemeManager themeColor];
            break;
        case 1024:
            strOrderStatus = @"已入住";
            
            self.buttonThree.hidden = NO;
            self.buttonThree.layer.borderColor = UIColorFromRGB(0xdfdfdf).CGColor;
            [self.buttonThree setTitle:@"删除订单" forState:UIControlStateNormal];
            [self.buttonThree setTitleColor:UIColorFromRGB(0x4a4a4a) forState:UIControlStateNormal];
            self.labelHotelOrederStatus.textColor = UIColorFromRGB(0x4a4a4a);
            break;
        case 2048:
            strOrderStatus = @"正在担保-处理中";
            self.labelHotelOrederStatus.textColor = [YSThemeManager buttonBgColor];
            break;
        case 4096:
            strOrderStatus = @"正在支付-处理中";
            self.labelHotelOrederStatus.textColor = [YSThemeManager buttonBgColor];
            break;
        case 8192:
            strOrderStatus = @"支付失败";
            self.buttonTwo.hidden = NO;
            self.buttonTwo.layer.borderColor = UIColorFromRGB(0xdfdfdf).CGColor;
            [self.buttonTwo setTitle:@"取消订单" forState:UIControlStateNormal];
            [self.buttonTwo setTitleColor:UIColorFromRGB(0x4a4a4a) forState:UIControlStateNormal];
            
            self.buttonThree.hidden = NO;
            self.buttonThree.layer.borderColor = UIColorFromRGB(0xdfdfdf).CGColor;
            [self.buttonThree setTitle:@"删除订单" forState:UIControlStateNormal];
            [self.buttonThree setTitleColor:UIColorFromRGB(0x4a4a4a) forState:UIControlStateNormal];
            self.labelHotelOrederStatus.textColor = UIColorFromRGB(0x4a4a4a);
            
            self.labelHotelOrederStatus.textColor = [YSThemeManager priceColor];

            break;
        default:
            break;
    }
    
    self.labelHotelOrederStatus.text = strOrderStatus;
    
    if (status != 256 && status != 8 && status != 512 && status != 32 && status != 2 && status != 4 && status != 64 && status != 1 && status != 128 && status != 8192) {
        //不是已取消、待付款、已经确认、已入住这四种状态，隐藏cell的底部按钮
        self.viewBottomBg.hidden = YES;
    }else{
        
        if (![self.model isDisplayGoUpPayButton] && status == 2) {
            //因为等待支付担保只有一个按钮，如果此订单没法支付的支付按钮需要隐藏的时候底部也要隐藏
            self.viewBottomBg.hidden = YES;
        }else{
            self.viewBottomBg.hidden = NO;
        }
        
    }
}


- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
}


@end
