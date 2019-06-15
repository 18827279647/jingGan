//
//  PhysicalReportDetailTopView.m
//  jingGang
//
//  Created by HanZhongchou on 15/10/27.
//  Copyright © 2015年 yi jiehuang. All rights reserved.
//

#import "PhysicalReportDetailTopView.h"
#import "PublicInfo.h"

@implementation PhysicalReportDetailTopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
     Drawing code
}
*/


- (void)editButtonClick
{
    if([self.delegate respondsToSelector:@selector(editButtonClickNofitication)]){
        [self.delegate editButtonClickNofitication];
    }
}



- (UIView *)loadDataWithDic:(NSDictionary *)dic
{
    
    UIView *viewBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 160)];
    viewBg.backgroundColor = [UIColor whiteColor];
    
    //报告标题图片
//    UIImageView *imageReportBook = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Physical_Report_Book"]];
//    imageReportBook.frame = CGRectMake(0, 38, 64, 69);
//    CGPoint pointImageReportBook = imageReportBook.center;
//    pointImageReportBook.x = self.viewPoint.x;
//    imageReportBook.center = pointImageReportBook;
//    [viewBg addSubview:imageReportBook];
    
    
        UIImageView * imageView =[[UIImageView alloc]initWithFrame:CGRectMake(10, 0 , 25 , 25)];
        [imageView setImage:[UIImage imageNamed:@"mingcheng111"]];
        [viewBg addSubview:imageView];
//        UIImageView *imageReportBook = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mingcheng222"]];
//        imageReportBook.frame = CGRectMake(10, 10 , 25, 25);
//        [viewBg addSubview:imageReportBook];
    
    //体检标题
    CGFloat labelReportTitleY = 0;
    UILabel *labelReportTitle = [[UILabel alloc]initWithFrame:CGRectMake(45, labelReportTitleY, viewBg.width - 20, 18)];
    labelReportTitle.textAlignment = NSTextAlignmentLeft;

    labelReportTitle.font = [UIFont systemFontOfSize:18.0];
    
    NSString *strDate;
    NSString *strYear;
    NSString *strMonth;
    NSString *strDay;
    
    if (dic.count > 0) {
        strDate = [NSString stringWithFormat:@"%@",dic[@"createtime"]];
        strYear  = [strDate substringWithRange:NSMakeRange(0,4)];
        strMonth = [strDate substringWithRange:NSMakeRange(5, 2)];
        strDay   = [strDate substringWithRange:NSMakeRange(8, 2)];
        labelReportTitle.text = [NSString stringWithFormat:@"%@",dic[@"resultname"]];
    }else{
        labelReportTitle.text = [NSString stringWithFormat:@""];
    }

    labelReportTitle.textColor = UIColorFromRGB(0x4a4a4a);
    [viewBg addSubview:labelReportTitle];
    
    
    

    //检查日期
    CGFloat labelCheckDateY = CGRectGetMaxY(labelReportTitle.frame) + 25;
    UILabel *labelCheckDateTrs = [[UILabel alloc]initWithFrame:CGRectMake(50, labelCheckDateY, __MainScreen_Width - 35 - 30, 21)];
    labelCheckDateTrs.textColor = UIColorFromRGB(0x9b9b9b);
    labelCheckDateTrs.font = [UIFont systemFontOfSize:15.0];
    if (dic) {
        labelCheckDateTrs.text = [NSString stringWithFormat:@"检查日期：%@-%@-%@",strYear,strMonth,strDay];
    }

    [viewBg addSubview:labelCheckDateTrs];
    
    UIImageView * imageView1 =[[UIImageView alloc]initWithFrame:CGRectMake(10, labelCheckDateY-5 , 25 , 25)];
    [imageView1 setImage:[UIImage imageNamed:@"renwu222"]];
    [viewBg addSubview:imageView1];
    //体检医院/机构
    CGFloat labelCheckHospitalY = CGRectGetMaxY(labelCheckDateTrs.frame) + 15;
    UILabel *labelCheckHospital = [[UILabel alloc]initWithFrame:CGRectMake(50, labelCheckHospitalY, 101, 21)];
    labelCheckHospital.textColor = UIColorFromRGB(0x9b9b9b);
    labelCheckHospital.font = [UIFont systemFontOfSize:15.0];
    labelCheckHospital.text = @"体检医院/机构:";
    [viewBg addSubview:labelCheckHospital];
    
    UIImageView * imageView2=[[UIImageView alloc]initWithFrame:CGRectMake(10, labelCheckHospitalY-5 , 25 , 25)];
    [imageView2 setImage:[UIImage imageNamed:@"yiyuan"]];
    [viewBg addSubview:imageView2];
    //体检医院/机构 变量
    CGFloat labelCheckHospitalTrsX = CGRectGetMaxX(labelCheckHospital.frame) + 3;
    UILabel *labelCheckHospitalTrs = [[UILabel alloc]initWithFrame:CGRectMake(labelCheckHospitalTrsX, labelCheckHospitalY, __MainScreen_Width - labelCheckHospitalTrsX - 35, 21)];
    labelCheckHospitalTrs.textColor = UIColorFromRGB(0x9b9b9b);
    labelCheckHospitalTrs.font = [UIFont systemFontOfSize:15.0];
    labelCheckHospitalTrs.text = [NSString stringWithFormat:@"%@",dic[@"hospital"]];
    [viewBg addSubview:labelCheckHospitalTrs];
    
    //检查项背景View
    CGFloat viewCheckItemBgY = CGRectGetMaxY(labelCheckHospitalTrs.frame) + 15;
    UIView *viewCheckItemBg = [[UIView alloc]initWithFrame:CGRectMake(28, viewCheckItemBgY, __MainScreen_Width - 53, 26)];
    viewCheckItemBg.backgroundColor = UIColorFromRGB(0xf3f3f3);
    viewCheckItemBg.layer.cornerRadius = 13;
    [viewBg addSubview:viewCheckItemBg];
    
    //右上角编辑按钮
    
    //体检报告状态：1未提交、2待处理、3已处理
    //    status;1、3状态显示编辑按钮，检查项背景View加背景色        2则不用背景色，需要隐藏编辑按钮
    NSString *status = [NSString stringWithFormat:@"%@",dic[@"status"]];
    if ([status isEqualToString:@"1"] || [status isEqualToString:@"3"]) {
        UIButton *buttonEdit = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonEdit.frame = CGRectMake(viewBg.frame.size.width - 21 - 50, 0, 50, 20);
//        [buttonEdit setBackgroundImage:[UIImage imageNamed:@"MER_bianji"] forState:UIControlStateNormal];
        [buttonEdit setTitle:@"编辑" forState:UIControlStateNormal];
        buttonEdit.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        [buttonEdit setTitleColor:JGColor(96, 177, 187, 1) forState:UIControlStateNormal];
//        [buttonEdit setFont: [UIFont systemFontSize: 14.0]];
        [buttonEdit addTarget:self action:@selector(editButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [viewBg addSubview:buttonEdit];
        viewCheckItemBg.backgroundColor = UIColorFromRGB(0xf3f3f3);
    }else{
        viewCheckItemBg.backgroundColor = [UIColor clearColor];
    }
    
    
    
    NSString *strRightCount = [NSString stringWithFormat:@"%@",dic[@"rightCount"]];
    NSString *strWrongCount = [NSString stringWithFormat:@"%@",dic[@"wrongCount"]];
    NSInteger rightCount = [strRightCount integerValue];
    NSInteger wrongCount = [strWrongCount integerValue];
    //总检查项
    UILabel *labelAllCheckItem = [[UILabel alloc]initWithFrame:CGRectMake(6, 3, 55, 20)];
    labelAllCheckItem.font = [UIFont systemFontOfSize:14.0];
    labelAllCheckItem.text = [NSString stringWithFormat:@"共:%ld项",rightCount + wrongCount];
    labelAllCheckItem.textColor = UIColorFromRGB(0x4a4a4a);
    [viewCheckItemBg addSubview:labelAllCheckItem];
    
    //正常项
    
    UILabel *labelCheckNormalItem = [[UILabel alloc]initWithFrame:CGRectMake(0, labelAllCheckItem.y, 90, 20)];
    labelCheckNormalItem.textColor = UIColorFromRGB(0x4a4a4a);
    CGPoint pointLebelCheckNormalItem = labelCheckNormalItem.center;
    pointLebelCheckNormalItem.x = self.viewPoint.x - 22;
    labelCheckNormalItem.center = pointLebelCheckNormalItem;
    if([strRightCount isEqualToString:@"(null)"]){
        strRightCount = @"0";
    }
    labelCheckNormalItem.text = [NSString stringWithFormat:@"正常:%@项",strRightCount];
    labelCheckNormalItem.textAlignment = NSTextAlignmentCenter;
    labelCheckNormalItem.font = [UIFont systemFontOfSize:14.0];
    labelCheckNormalItem.textColor = UIColorFromRGB(0x4a4a4a);
    [viewCheckItemBg addSubview:labelCheckNormalItem];
    
    //异常项
    //
    NSString *strWrongCountTemp = [NSString stringWithFormat:@"超标:%@项",strWrongCount];

    if([strWrongCount isEqualToString:@"(null)"]){
        strWrongCount = @"0";
    }
    CGSize size = CGSizeMake(MAXFLOAT, 17);
    NSDictionary *dicStrWrongCountTempSize = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
    
    CGSize strWrongCountTempSize = [strWrongCountTemp boundingRectWithSize:size
                                                 options:NSStringDrawingUsesLineFragmentOrigin attributes:dicStrWrongCountTempSize
                                                 context:nil].size;

    UILabel *labelLunusualItem = [[UILabel alloc]initWithFrame:CGRectMake(viewCheckItemBg.frame.size.width - strWrongCountTempSize.width - 8 , labelAllCheckItem.y, strWrongCountTempSize.width, 20)];

    
    labelLunusualItem.textColor = UIColorFromRGB(0x4a4a4a);
    labelLunusualItem.text = strWrongCountTemp;
    labelLunusualItem.font = [UIFont systemFontOfSize:14.0];
    [viewCheckItemBg addSubview:labelLunusualItem];
    
    if (dic.count <= 1) {
        labelCheckHospitalTrs.text = @"";
        labelAllCheckItem.text = @"共:0项";
        labelCheckNormalItem.text = @"正常:0项";
        labelLunusualItem.text = @"超标:0项";
    }
    

    
    
    return viewBg;

}

/**
 *  把字符串中的数字变颜色
 *
 *  @param startRange 字符串从哪里变颜色的起始长度
 *  @param strColor   需要变颜色的字符串
 *  @param rangeColor 需要变成什么颜色
 */
- (NSMutableAttributedString *)stringTrsColorForNumberWithStartRange:(NSInteger)startRange str:(NSString *)strColor color:(UIColor *)rangeColor{
    
    NSMutableString *strippedString = [NSMutableString
                                       stringWithCapacity:strColor.length];
    
    NSScanner *scanner = [NSScanner scannerWithString:strColor];
    NSCharacterSet *numbers = [NSCharacterSet
                               characterSetWithCharactersInString:@"0123456789"];
    
    while ([scanner isAtEnd] == NO) {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
            [strippedString appendString:buffer];
            
        } else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }

    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strColor];
    
    [str addAttribute:NSForegroundColorAttributeName value:rangeColor range:NSMakeRange(startRange,strippedString.length)];
    
    
    return str;
}


@end
