//
//  RXbutlerServiceViewController.m
//  jingGang
//
//  Created by 荣旭 on 2019/6/20.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "RXbutlerServiceViewController.h"
#import "RXShowButlerServiceView.h"
#import "GlobeObject.h"
#import "Unit.h"
//#import "WRNavigationBar.h"
#define colorSelect [UIColor colorWithRed:228/255.0 green:46/255.0 blue:114/255.0 alpha:1.0]
#define colorNoSelect [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]

#define colorboardSelect [UIColor colorWithRed:252/255.0 green:238/255.0 blue:233/255.0 alpha:1.0].CGColor
#define colorboardNOSelect UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;


@interface RXbutlerServiceViewController ()

@property(nonatomic,strong)RXShowButlerServiceView*butlerServiceView;

@property (nonatomic, weak) UIImageView *lineView;

@end

@implementation RXbutlerServiceViewController

//视图将要显示时隐藏
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self wr_setNavBarBackgroundImage:[self buttonImageFromColor:JGColor(101, 187, 177, 1)]];
//    [self wr_setNavBarShadowImageHidden:true];
}
-(void)viewDidDisappear:(BOOL)animated;{
    [super viewDidDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [YSThemeManager setNavigationTitle:@"健康管家服务" andViewController:self];
    [self setUI];
}
-(void)setUI;{
    if (!self.butlerServiceView) {
       self.butlerServiceView=[[[NSBundle mainBundle]loadNibNamed:@"RXShowButlerServiceView" owner:self options:nil]firstObject];
        self.butlerServiceView.frame=CGRectMake(0,0,kScreenWidth,kScreenHeight);
        self.butlerServiceView.backgroundColor=[UIColor whiteColor];
        self.butlerServiceView.backImage.layer.masksToBounds=YES;
        self.butlerServiceView.backImage.layer.cornerRadius=25;
        self.butlerServiceView.timelabel.textColor=JGColor(51, 51, 51, 1);
        [self.butlerServiceView.timelabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        
        //第一个
        self.butlerServiceView.oneImage.layer.masksToBounds=YES;
        self.butlerServiceView.oneImage.layer.cornerRadius = 10;

    
        //不一样的4个地方
        self.butlerServiceView.oneImage.layer.backgroundColor = [UIColor colorWithRed:252/255.0 green:238/255.0 blue:233/255.0 alpha:1.0].CGColor;
        self.butlerServiceView.oneImage.layer.borderWidth = 2;
        self.butlerServiceView.oneImage.layer.borderColor = [UIColor colorWithRed:228/255.0 green:46/255.0 blue:114/255.0 alpha:1.0].CGColor;
        self.butlerServiceView.oneYlabel.textColor=colorSelect;
        self.butlerServiceView.oneTimelabel.textColor=colorSelect;
        self.butlerServiceView.oneDanLabel.textColor=colorSelect;
        self.butlerServiceView.oneSelectImage.hidden=NO;
    
        
        
        //第二个
        self.butlerServiceView.twoImage.layer.masksToBounds=YES;
        self.butlerServiceView.twoImage.layer.cornerRadius = 10;
        self.butlerServiceView.twoSelectImage.hidden=YES;
        self.butlerServiceView.twoImage.layer.borderWidth = 1;
        self.butlerServiceView.twoImage.layer.borderColor = JGColor(194, 194, 194, 0.5).CGColor;
        
        
        
        //第3个
        self.butlerServiceView.freeImage.layer.masksToBounds=YES;
        self.butlerServiceView.freeSelectImage.hidden=YES;
        self.butlerServiceView.freeImage.layer.cornerRadius = 10;

        
        self.butlerServiceView.freeImage.layer.borderWidth = 1;
        self.butlerServiceView.freeImage.layer.borderColor = JGColor(194, 194, 194, 0.5).CGColor;

        
        self.butlerServiceView.lijiButton.layer.masksToBounds=YES;
        self.butlerServiceView.lijiButton.layer.cornerRadius=22;
        
        [self.butlerServiceView.lijiButton.layer addSublayer:[self setGradualChangingColor:self.butlerServiceView.lijiButton fromColor:@"65BBB1" toColor:@"58D499"]];//渐变开始
    }
    [self.view addSubview:self.butlerServiceView];
}





//绘制渐变色颜色的方法
- (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr{
    
    //    CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    
    //  创建渐变色数组，需要转换为CGColor颜色 （因为这个按钮有三段变色，所以有三个元素）
    gradientLayer.colors = @[(__bridge id)[self colorWithHex:fromHexColorStr].CGColor,(__bridge id)[self colorWithHex:toHexColorStr].CGColor,
                             (__bridge id)[self colorWithHex:fromHexColorStr].CGColor];
    
    
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    
    //  设置颜色变化点，取值范围 0.0~1.0 （所以变化点有三个）
    gradientLayer.locations = @[@0,@0.5,@1];
    
    return gradientLayer;
}
//获取16进制颜色的方法
-(UIColor *)colorWithHex:(NSString *)hexColor {
    hexColor = [hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([hexColor length] < 6) {
        return nil;
    }
    if ([hexColor hasPrefix:@"#"]) {
        hexColor = [hexColor substringFromIndex:1];
    }
    NSRange range;
    range.length = 2;
    range.location = 0;
    NSString *rs = [hexColor substringWithRange:range];
    range.location = 2;
    NSString *gs = [hexColor substringWithRange:range];
    range.location = 4;
    NSString *bs = [hexColor substringWithRange:range];
    unsigned int r, g, b, a;
    [[NSScanner scannerWithString:rs] scanHexInt:&r];
    [[NSScanner scannerWithString:gs] scanHexInt:&g];
    [[NSScanner scannerWithString:bs] scanHexInt:&b];
    if ([hexColor length] == 8) {
        range.location = 4;
        NSString *as = [hexColor substringWithRange:range];
        [[NSScanner scannerWithString:as] scanHexInt:&a];
    } else {
        a = 255;
    }
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:((float)a / 255.0f)];
}
-(UIImage *)buttonImageFromColor:(UIColor *)color;{
    
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
@end
