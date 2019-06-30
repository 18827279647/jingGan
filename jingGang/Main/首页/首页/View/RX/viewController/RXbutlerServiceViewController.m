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

#import "RXbutlerServiceResponse.h"

#import "RXbuyHealthGoodsResponse.h"

#import "PayOrderViewController.h"

#define colorSelect [UIColor colorWithRed:228/255.0 green:46/255.0 blue:114/255.0 alpha:1.0]
#define colorNoSelect [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]

#define colorboardSelect [UIColor colorWithRed:228/255.0 green:46/255.0 blue:114/255.0 alpha:1.0].CGColor;
#define colorboardNOSelect JGColor(194, 194, 194, 0.5).CGColor;

#define colorBackSelect [UIColor colorWithRed:252/255.0 green:238/255.0 blue:233/255.0 alpha:1.0].CGColor
#define colorBackNoSelect [UIColor colorWithRed:252/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;

@interface RXbutlerServiceViewController ()

@property(nonatomic,strong)RXShowButlerServiceView*butlerServiceView;

//时间
@property(nonatomic,strong)NSString*myTimelabel;

//金额
@property(nonatomic,strong)NSString*myMoneylabel;
//数量
@property(nonatomic,strong)NSString*myNumlabel;

@property(nonatomic,strong)RXbutlerServiceResponse*response;

@property(nonatomic,strong)RXbuyHealthGoodsResponse*healthGoodsResponse;

@end

@implementation RXbutlerServiceViewController

//视图将要显示时隐藏
- (void)viewWillAppear:(BOOL)animated;
{
    [YSThemeManager settingAppThemeType:YSAppThemeNewYearType];
    self.navigationController.navigationBar.barTintColor = [YSThemeManager themeColor];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlack;
    self.navigationController.navigationBar.translucent=NO;
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = COMMONTOPICCOLOR;
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    self.navigationController.navigationBar.barTintColor = COMMONTOPICCOLOR;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [YSThemeManager setNavigationTitle:@"健康管家服务" andViewController:self];
    self.myNumlabel=@"1";
    self.myMoneylabel=@"5";
    [self setUI];
    [self request];
}
//固定ID:16000
-(void)request;{
    self.response=[[RXbutlerServiceResponse alloc]init];
    [self showHUD];
    RXbutlerServiceRequest *request=[[RXbutlerServiceRequest alloc]init:GetToken];
    request.goodsId=@"16000";
    VApiManager *manager = [[VApiManager alloc]init];
    [manager RXButlerServiceRequest:request success:^(AFHTTPRequestOperation *operation, RXbutlerServiceResponse *response) {
      
        [self hideAllHUD];

        self.response=response;
    
        NSMutableDictionary*dic=[[NSMutableDictionary alloc]initWithDictionary:self.response.goodsDetails];
        self.butlerServiceView.titlelabel.text=[Unit JSONString:dic key:@"goodsName"];
        
        NSMutableArray*detail=dic[@"detail"];
        NSMutableArray*cationList=dic[@"cationList"];
        
        NSMutableArray*properties=cationList[0][@"properties"];
        self.butlerServiceView.showTimelabel.text=properties[0][@"value"];
        NSMutableDictionary*price=detail[0];
        self.butlerServiceView.showMoneylabel.text=[NSString stringWithFormat:@"¥%.2f",[Unit JSONDouble:price key:@"price"]];
        
        self.myMoneylabel=[NSString stringWithFormat:@"%f",[Unit JSONDouble:price key:@"price"]];
        self.butlerServiceView.helabel.text=[NSString stringWithFormat:@"¥%.2f",[self.myMoneylabel floatValue]];
        
        self.butlerServiceView.helabel.textColor=JGColor(239, 82, 80, 1);
        self.butlerServiceView.helabel.font=JGFont(15);
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideAllHUD];
        [self showStringHUD:@"网络错误" second:0];
    }];
}
-(void)setUI;{
    if (!self.butlerServiceView) {
        self.butlerServiceView=[[[NSBundle mainBundle]loadNibNamed:@"RXShowButlerServiceView" owner:self options:nil]firstObject];
        self.butlerServiceView.userInteractionEnabled=YES;
        self.butlerServiceView.frame=CGRectMake(0,0,kScreenWidth,kScreenHeight);
        self.butlerServiceView.backgroundColor=[UIColor whiteColor];
        self.butlerServiceView.backImage.layer.masksToBounds=YES;
        self.butlerServiceView.backImage.layer.cornerRadius=25;
//        self.butlerServiceView.timelabel.textColor=JGColor(51, 51, 51, 1);
//        [self.butlerServiceView.timelabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
        
        self.butlerServiceView.titleNamelabel.font=JGFont(16);
        self.butlerServiceView.titleNamelabel.textColor=JGColor(51, 51, 51, 1);
        self.butlerServiceView.showTimelabel.textColor=JGColor(228, 46, 114, 1);
        [self.butlerServiceView.showTimelabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
    
        self.butlerServiceView.showMoneylabel.textColor=JGColor(228, 46, 114, 1);
        //第一个
        self.butlerServiceView.oneImage.layer.masksToBounds=YES;
        self.butlerServiceView.oneImage.layer.cornerRadius = 10;

        //不一样的4个地方
        self.butlerServiceView.oneImage.layer.backgroundColor =colorBackSelect;
        self.butlerServiceView.oneImage.layer.borderWidth = 1;
        self.butlerServiceView.oneImage.layer.borderColor = colorboardSelect;
        self.butlerServiceView.oneSelectImage.hidden=NO;
        self.butlerServiceView.oneImage.tag=1;
        //合计
        self.butlerServiceView.helabel.textColor=JGColor(239, 82, 80, 1);
        //数量加减
        [self.butlerServiceView.jianButton addTarget:self action:@selector(editButtonFouction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.butlerServiceView.addButton addTarget:self action:@selector(editButtonFouction:) forControlEvents:UIControlEventTouchUpInside];

         [self.butlerServiceView.lijiButton addTarget:self action:@selector(lijiButtonFountion) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:self.butlerServiceView];
}

-(void)lijiButtonFountion;{
    self.healthGoodsResponse=[[RXbuyHealthGoodsResponse alloc]init];
    [self showHUD];
    RXbuyHealthGoodsRequest *request=[[RXbuyHealthGoodsRequest alloc]init:GetToken];
    request.goodsId=@"16000";
    request.count=self.butlerServiceView.shuNumberlabel.text;
    request.areaId=@"";
    NSMutableDictionary*dic=[[NSMutableDictionary alloc]initWithDictionary:self.response.goodsDetails];
    NSMutableArray*cationList=dic[@"cationList"];
    request.gsp=cationList[0][@"id"];
    VApiManager *manager = [[VApiManager alloc]init];
    [manager RXBuyHealthGoodsRequest:request success:^(AFHTTPRequestOperation *operation, RXbuyHealthGoodsResponse *response) {
        [self hideAllHUD];
        self.healthGoodsResponse=response;
        PayOrderViewController *payOrderVC = [[PayOrderViewController alloc] init];
        payOrderVC.orderID = (NSNumber *)self.healthGoodsResponse.order[@"id"];
        payOrderVC.orderNumber =self.healthGoodsResponse.order[@"orderId"];
        payOrderVC.jingGangPay =  ShoppingPay;
        payOrderVC.totalPrice = [self.healthGoodsResponse.order[@"totalPrice"] floatValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 回到主线程,执⾏UI刷新操作
            [self.navigationController pushViewController:payOrderVC animated:YES];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideAllHUD];
        [self showStringHUD:@"网络错误" second:0];
    }];
}
-(void)editButtonFouction:(UIButton*)button;{
    NSInteger index=[self.butlerServiceView.shuNumberlabel.text integerValue];
    
    if (button.tag==1) {
        if (index==1) {
            [self.butlerServiceView.jianButton setImage:[UIImage imageNamed:@"zhifu_jianN_image"] forState:UIControlStateNormal];
            [self.butlerServiceView.jianButton setImage:[UIImage imageNamed:@"zhifu_jianN_image"] forState:UIControlStateSelected];
            return;
        }
        [self.butlerServiceView.jianButton setImage:[UIImage imageNamed:@"zhifu_jianY_image"] forState:UIControlStateNormal];
        [self.butlerServiceView.jianButton setImage:[UIImage imageNamed:@"zhifu_jianY_image"] forState:UIControlStateSelected];
        index--;
    }else{
        [self.butlerServiceView.jianButton setImage:[UIImage imageNamed:@"zhifu_jianY_image"] forState:UIControlStateNormal];
        [self.butlerServiceView.jianButton setImage:[UIImage imageNamed:@"zhifu_jianY_image"] forState:UIControlStateSelected];
        if (index>=20) {
            return;
        }
        index++;
    }
    self.butlerServiceView.shuNumberlabel.text=[NSString stringWithFormat:@"%ld",index];
    //数量
    self.myNumlabel=[NSString stringWithFormat:@"%ld",index];
    self.butlerServiceView.helabel.text=[NSString stringWithFormat:@"¥%.2f",[self.myMoneylabel floatValue]*index];
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
