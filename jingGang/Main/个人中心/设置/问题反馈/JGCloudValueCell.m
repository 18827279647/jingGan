//
//  JGCloudValueCell.m
//  jingGang
//
//  Created by dengxf on 15/12/25.
//  Copyright © 2015年 yi jiehuang. All rights reserved.
//

#import "JGCloudValueCell.h"
#import "JGIntegralValueModel.h"
#import "GlobeObject.h"
@interface JGCloudValueCell ()

#pragma mark --- 积分明细控件
/**
 *  积分背景View
 */
@property (weak, nonatomic) IBOutlet UIView *viewIntegralBg;
/**
 *  积分变更类型
 */
@property (weak, nonatomic) IBOutlet UILabel *labelIntegralTypeName;
/**
 *  积分变更时间
 */
@property (weak, nonatomic) IBOutlet UILabel *labelIntegralAddTime;
/**
 *  积分变更数值
 */
@property (weak, nonatomic) IBOutlet UILabel *labelIntegralValue;
/**
 *  最新积分明细剩余余额
 */
@property (weak, nonatomic) IBOutlet UILabel *labelIntegralNewBalance;

#pragma mark --- 健康豆明细控件
/**
 *  健康豆背景view
 */
@property (weak, nonatomic) IBOutlet UIView *viewCloudValueBg;
/**
 *  日期标签
 */
//@property (weak, nonatomic) IBOutlet UILabel *DateLab;

/**
 *  时间标签
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

/**
 *  金额标签
 */
@property (weak, nonatomic) IBOutlet UILabel *valueLab;

/**
 *  明细标签
 */
@property (weak, nonatomic) IBOutlet UILabel *detailLab;

/**
 *  最新健康豆明细剩余余额
 */
@property (weak, nonatomic) IBOutlet UILabel *labelCloudValueNewBalance;



@end

@implementation JGCloudValueCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
    }
    return  self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

/**
 *  积分
 */
- (void)setIntegralModel:(JGIntegralValueModel *)integralModel
{
    _integralModel = integralModel;
//    if (self.valueType == IntegralCellType) {
        [self integarlModelSetWithModel];
//    }else if (self.valueType == CloudValueCellType){
//        [self cloudModelSetWithModel];
//    }
}

- (void)integarlModelSetWithModel
{
    self.viewIntegralBg.hidden = NO;
    self.viewCloudValueBg.hidden = YES;
    //    _model.addtime = [_model.addtime substringWithRange:NSMakeRange(0,10)];
    
    
    self.labelIntegralAddTime.text = _integralModel.addtime;
    
    
    self.labelIntegralNewBalance.text = [NSString stringWithFormat:@"余额:%.f",_integralModel.balance];
    
    //判断是消费还是新增，如果是消费扣除积分字体颜色要变成灰色，新增是蓝色
    NSRange range = [_integralModel.integral rangeOfString:@"-"];//判断字符串是否包含减号(是否是负数)
    
    if (range.length >0)//包含
    {
        self.labelIntegralValue.text = _integralModel.integral;
        self.labelIntegralValue.textColor = kGetColor(197, 202, 205);
    }
    else//不包含
    {
        self.labelIntegralValue.text = [NSString stringWithFormat:@"+%@.00",_integralModel.integral];
        self.labelIntegralValue.textColor = UIColorFromRGB(0x4a4a4a);
    }
    
    //根据后台的Type判断输出对应的积分变更文案
    if ([_integralModel.type isEqualToString:@"system"]) {
        self.labelIntegralTypeName.text = @"系统积分管理";
        
    }else if ([_integralModel.type isEqualToString:@"integral_order"]){
        self.labelIntegralTypeName.text = @"兑换商品";
    }else{
        if (_integralModel.typeName.length == 0) {
            self.labelIntegralTypeName.text = @"其他";
        }else{
            self.labelIntegralTypeName.text = _integralModel.typeName;
        }
    }
}


/**
 *  健康豆
 */
- (void)setCloudValuesModel:(JGIntegralValueModel *)cloudValuesModel
{
    _cloudValuesModel = cloudValuesModel;
    self.viewCloudValueBg.hidden = NO;
    self.viewIntegralBg.hidden = YES;
    //判断是消费还是新增
//    NSRange range = [_cloudValuesModel.pdLogAmount rangeOfString:@"-"];//判断字符串是否包含减号(是否是负数)
    
//    if (range.length >0)//包含
//    {
        self.valueLab.text = [NSString stringWithFormat:@"%.2f",[_cloudValuesModel.pdLogAmount floatValue]];
//        self.valueLab.textColor = UIColorFromRGB(0x4a4a4a);
//
//    }
//    else//不包含
//    {
//        self.valueLab.text = [NSString stringWithFormat:@"+%.2f",[_cloudValuesModel.pdLogAmount floatValue]];
//        self.valueLab.textColor = COMMONTOPICCOLOR;
//    }

//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *date = [dateFormatter dateFromString:_cloudValuesModel.addTime];
//    
//    self.DateLab.text = [self weekdayStringFromDate:date];

    self.timeLab.text = _cloudValuesModel.addTime;
    
    //健康豆变更详情
    self.detailLab.text = [NSString stringWithFormat:@"%@",_cloudValuesModel.pdOpType];
    //健康豆当前余额
    self.labelCloudValueNewBalance.text = [NSString stringWithFormat:@"余额:%.2f",_cloudValuesModel.balance];
    
}

//- (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
//    
//    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
//    
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    
//    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
//    
//    [calendar setTimeZone: timeZone];
//    
//    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
//    
//    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
//    
//    return [weekdays objectAtIndex:theComponents.weekday];
//    
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
