//
//  MySegementView.m
//  demo
//
//  Created by whlx on 2019/5/22.
//  Copyright © 2019年 whlx. All rights reserved.
//

#import "MySegementView.h"
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#import "GlobeObject.h"
#define titleWidth 100
@interface MySegementView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray * ButtonArray;

@property (nonatomic, strong) UIButton * SelectButton;

@property (nonatomic, strong) UIView * LineView;

@property (nonatomic, strong) UIScrollView * ScrollView;

@property (nonatomic, assign) CGFloat TitleWidth;

//@property (nonatomic, assign) CGFloat TempWidth;


@end

@implementation MySegementView


- (void)setTitleArray:(NSArray *)TitleArray{
    _TitleArray = TitleArray;
    self.TitleWidth = 0;
    [self.LineView removeFromSuperview];
    self.ButtonArray = [NSMutableArray array];
    [self.ScrollView removeFromSuperview];
    [self initWithTitleButton];
}

#pragma 初始化按钮文字
- (void)initWithTitleButton{
    
    self.ScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    self.ScrollView.delegate = self;
    self.ScrollView.scrollEnabled = YES;
    self.ScrollView.bounces = NO;
    self.ScrollView.showsHorizontalScrollIndicator = NO;
    [self.ScrollView flashScrollIndicators];
    [self addSubview:self.ScrollView];
    
    CGFloat margin = 15;
    [self.TitleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton * TitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [TitleButton setTitle:obj forState:UIControlStateNormal];
        [TitleButton setTitleColor:[UIColor colorWithHexString:self.NormalColorString] forState:UIControlStateNormal];
        
        if (self.Type == Multiple) {
            TitleButton.titleLabel.numberOfLines = 0;
            NSString * titleString = obj;
            
            [TitleButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
            if (titleString.length > 4) {
                NSMutableAttributedString *String = [[NSMutableAttributedString alloc] initWithString:titleString];
                [String setFont:kPingFang_Semibold(18)];
                [String addAttribute:NSFontAttributeName value:kPingFang_Regular(10) range:NSMakeRange(5,titleString.length - 5)];
                [String addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"959595"] range:NSMakeRange(5,titleString.length - 5)];
                
                [TitleButton.titleLabel setAttributedText:String];
            }else {
                TitleButton.titleLabel.font = [UIFont systemFontOfSize:14];
            }
        }
        
        TitleButton.tag = idx;
        [TitleButton addTarget:self action:@selector(SelectClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.ScrollView addSubview:TitleButton];
        
        CGFloat width = [TitleButton.currentTitle widthForFont:TitleButton.titleLabel.font];
        UIButton *lastBtn = self.ButtonArray.lastObject;
        CGFloat btnX = margin;
        if (lastBtn) {
           btnX = lastBtn.right + margin;
        }
        [self.ButtonArray addObject:TitleButton];
        TitleButton.frame = CGRectMake(btnX, 0,width, self.height);
        self.ScrollView.contentSize = CGSizeMake(TitleButton.right + margin,0);
    }];

    
    UIButton * button = self.ButtonArray.firstObject;
    
    self.LineView = [[UIView alloc]initWithFrame:CGRectMake(0,self.height - K_ScaleWidth(4), button.titleLabel.width, K_ScaleWidth(4))];
    self.LineView.backgroundColor = [UIColor colorWithHexString:self.SelectColorString];
    [self.ScrollView addSubview:self.LineView];
    
}


#pragma 按钮文字点击事件
- (void)SelectClick:(UIButton *)sender{
   
    [self SelectButton:sender.tag];
    
    [self.delegate MySegementView:self AndIndex:sender.tag];
}

#pragma 选择某个标题
- (void)SelectButton:(NSInteger)Index
{
    [self.SelectButton setTitleColor:[UIColor colorWithHexString:self.NormalColorString] forState:UIControlStateNormal];
    self.SelectButton = self.ButtonArray[Index];
    [self.SelectButton setTitleColor:[UIColor colorWithHexString:self.SelectColorString] forState:UIControlStateNormal];
//    CGRect Rect = [self.SelectButton.superview convertRect:self.SelectButton.frame toView:self];
//    [UIView animateWithDuration:0.2 animations:^{
//        //计算偏移量
//        CGPoint contentOffset = self.ScrollView.contentOffset;
//        self.LineView.frame = CGRectMake(self.SelectButton.x, self.height - K_ScaleWidth(4), self.SelectButton.width, K_ScaleWidth(4));
//
//        if (contentOffset.x - (SCREEN_WIDTH / 2 - Rect.origin.x - (self.SelectButton.titleLabel.width / 2)) <= 0) {
//            [self.ScrollView setContentOffset:CGPointMake(0, contentOffset.y) animated:YES];
//        } else if (contentOffset.x - (SCREEN_WIDTH / 2 - Rect.origin.x - (self.SelectButton.titleLabel.width / 2)) + SCREEN_WIDTH >= self.TitleWidth) {
//            [self.ScrollView setContentOffset:CGPointMake(self.TitleWidth - SCREEN_WIDTH, contentOffset.y) animated:YES];
//        } else {
//            [self.ScrollView setContentOffset:CGPointMake(contentOffset.x - (SCREEN_WIDTH / 2 - Rect.origin.x - (self.SelectButton.titleLabel.width / 2)), contentOffset.y) animated:YES];
//        }
//    }];
    
    
    CGFloat offsetX = self.SelectButton.centerX - self.ScrollView.width * 0.5;
    if (offsetX < 0)
    {
        offsetX = 0;
    }
    CGFloat maxOffsetX = self.ScrollView.contentSize.width - self.ScrollView.width;
    if (maxOffsetX > 0)//contentSize 必须大于 scroolView.height (屏幕显示不下)
    {
        if (offsetX > maxOffsetX)
        {
            offsetX = maxOffsetX;
        }
    }
    else//屏幕能显示完
    {
        offsetX = 0;
    }
    
    [self.ScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}


#pragma 计算字符串宽度
-(CGFloat)widthForString:(NSString *)value fontSize:(CGFloat)fontSize andHeight:(CGFloat)height
{
    UIFont *font=[UIFont boldSystemFontOfSize:fontSize];
    CGRect sizeToFit = [value boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{                                                                                                                                    NSFontAttributeName:font} context:nil];
    
    return sizeToFit.size.width + 11;
}

@end
