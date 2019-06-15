//
//  testchildViewController.m
//  jingGang
//
//  Created by yi jiehuang on 15/6/2.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "testchildViewController.h"
#import "PublicInfo.h"
#import "AppDelegate.h"
#import "bodyresultViewController.h"
#import "GlobeObject.h"
#import "JGBlueToothManager.h"
#import "UIViewExt.h"
#import "Util.h"
#import "FFRulerControl.h"


@interface testchildViewController ()
{
    UIScrollView    *_myScrollView;
    UITextField     *_height_tf,*_weight_tf;
    float           content_x,content_y;//scrollView的滑动范围
    
    NSDictionary    *userDic;//用户信息字典
    
    UILabel *weightLabel;
    UILabel *heightLabel;
    JGBlueToothManager *_jgManager;
}

/**
 *  0: 男
    1: 女*/
@property (assign, nonatomic) NSInteger sexTag;

@end

@implementation testchildViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [YSUMMobClickManager endLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userDic = [kUserDefaults objectForKey:userInfoKey] ;
    _jgManager = [JGBlueToothManager shareInstances] ;
    
    self.navigationController.navigationBar.barTintColor = COMMONTOPICCOLOR;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"home_title"] forBarMetrics:UIBarMetricsDefault];
    [YSThemeManager setNavigationTitle:@"身体质量指数" andViewController:self];

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];

    UIButton *rightBtn =[[UIButton alloc]initWithFrame:CGRectMake(0.0f, 16.0f, 40.0f, 25.0f)];
    //    [rightBtn setTitle:@"新增" forState:UIControlStateNormal];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightButton;
    RELEASE(rightBtn);
    RELEASE(rightButton);
    
    [self greatUI];
}

- (void)greatUI
{
    _myScrollView = [[UIScrollView alloc]init];
    _myScrollView.frame = self.view.frame;
    _myScrollView.backgroundColor =JGWhiteColor;
    [self.view addSubview:_myScrollView];
    
    UILabel *bg = [[UILabel alloc]init];
    bg.frame = CGRectMake(20, 15, 4, 20);
    bg.backgroundColor=[UIColor colorWithHexString:@"65BBB1"];
    [_myScrollView addSubview:bg];
    
    UILabel * top_lab = [[UILabel alloc]init];
    top_lab.frame = CGRectMake(30, 15, __MainScreen_Width, 20);
    top_lab.text = @"身体质量指数";
    top_lab.textAlignment = NSTextAlignmentLeft;
    top_lab.font = JGRegularFont(17);
    top_lab.textColor = JGBlackColor;
    [_myScrollView addSubview:top_lab];
    
    UILabel * content = [[UILabel alloc]init];
    content.frame = CGRectMake(20, 45, __MainScreen_Width-40, 60);
    content.text = @"以身体公斤数除以身高米数平方得出的数字，是目前国际上常用的衡量人体胖瘦程度是否健康的一个标准。";
    content.textAlignment = NSTextAlignmentLeft;
    content.font = JGRegularFont(15);
    content.numberOfLines=3;
    content.textColor = [UIColor grayColor];
    [_myScrollView addSubview:content];

    UIButton * sex_btn = [[UIButton alloc]init];
    sex_btn.frame = CGRectMake(0, CGRectGetMaxY(content.frame)+10, 175, 45);
    
    //确认男女
//    NSInteger sex = [userDic[@"sex"] integerValue];
    NSString *sexImgName = nil;
    if (_jgManager.userBodyModel.genderType == GenderTypeWoman) {//男
        sexImgName = @"life_boy";
        self.sexTag = 0;
    }else{//
        sexImgName = @"life_girl";
        self.sexTag = 1;
    }
    [sex_btn setBackgroundImage:[UIImage imageNamed:sexImgName] forState:UIControlStateNormal];
    NSNumber *weight =  @(_jgManager.userBodyModel.weight);
    NSNumber *height = @(_jgManager.userBodyModel.height);
    NSArray *valueArr = nil;
    if (weight!= nil && height != nil) {
        
        valueArr = @[weight,height];

    }else{
    
        valueArr = @[@120,@170];
    }
    
    
    //    [sex_btn setBackgroundImage:[UIImage imageNamed:@"life_boy"] forState:UIControlStateNormal];
    sex_btn.tag = 1;
    [sex_btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    sex_btn.center = CGPointMake(__MainScreen_Width/2, content.frame.origin.y+content.frame.size.height+22+68/2);
    [_myScrollView addSubview:sex_btn];
    
    
    weightLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(sex_btn.frame)+20, 150, 30)];
    weightLabel.centerX=_myScrollView.centerX;
    weightLabel.textAlignment=NSTextAlignmentCenter;
    weightLabel.text=@"体重:127KG";
    [_myScrollView addSubview:weightLabel];
    FFRulerControl *ruler = [FFRulerControl new];
    ruler.frame=CGRectMake(0, CGRectGetMaxY(weightLabel.frame)+10, __MainScreen_Width, 90);
    ruler.centerX = _myScrollView.centerX;
    [_myScrollView addSubview:ruler];
    ruler.backgroundColor =[UIColor whiteColor];
    ruler.indicatorColor = rgb(101, 187, 177, 1);
    ruler.minValue = 30;
    ruler.maxValue = 500;
    ruler.valueStep = 10;
    ruler.selectedValue = 90;
    [ruler addTarget:self action:@selector(weightChanged:) forControlEvents:UIControlEventValueChanged];
    
    heightLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(ruler.frame)+20, 150, 30)];
    heightLabel.centerX=_myScrollView.centerX;
    heightLabel.textAlignment=NSTextAlignmentCenter;
    heightLabel.text=@"身高:127CM";
    [_myScrollView addSubview:heightLabel];
    FFRulerControl *heightRuler = [FFRulerControl new] ;
    heightRuler.frame=CGRectMake(0, CGRectGetMaxY(heightLabel.frame)+10, __MainScreen_Width, 90);
    heightRuler.centerX = _myScrollView.centerX;
    [_myScrollView addSubview:heightRuler];
    heightRuler.backgroundColor = [UIColor whiteColor];
    heightRuler.indicatorColor = rgb(101, 187, 177, 1);
    heightRuler.minValue = 80;
    heightRuler.maxValue = 300;
    heightRuler.valueStep = 10;
    heightRuler.selectedValue = 170;
    [heightRuler addTarget:self action:@selector(heightChanged:) forControlEvents:UIControlEventValueChanged];
    
    _weight_tf=[UILabel new];
    _weight_tf.text=@"90";
    _height_tf=[UILabel new];
    _height_tf.text=@"170";

    UIButton * btn2 = [[UIButton alloc]init];
    //    btn2.frame = CGRectMake(img.frame.origin.x, _midel_btn.frame.origin.y+_midel_btn.frame.size.height+35, 504/2, 84/2);
    btn2.x = 57.0 / 2;
    btn2.y = CGRectGetMaxY(heightRuler.frame) + 35;
    btn2.width = _myScrollView.width - btn2.x * 2;
    btn2.height = 44.;
//    btn2.backgroundColor =[UIColor colorWithHexString:@"65BBB1"];// [YSThemeManager buttonBgColor];
    btn2.layer.cornerRadius = 4;
    btn2.clipsToBounds = YES;
    btn2.tag = 2;
    [btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn2.titleLabel.font = YSPingFangRegular(16);
    [btn2 setTintColor:[UIColor whiteColor]];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"button222"] forState:UIControlStateNormal];
    [btn2 setTitle:@"开始计算" forState:UIControlStateNormal];
    [_myScrollView addSubview:btn2];

    _myScrollView.contentSize = CGSizeMake(__MainScreen_Width, btn2.frame.size.height+btn2.frame.origin.y+100);
    content_x = __MainScreen_Width;
    content_y = __MainScreen_Height+50;
    UITapGestureRecognizer * sideslipTapGes= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handeTap)];
    //    [sideslipTapGes setNumberOfTapsRequired:1];
    
    [_myScrollView addGestureRecognizer:sideslipTapGes];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


//键盘出现
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    CGFloat upDeta = 0;
    [Util setValueIndiffScreensWithVarary:&upDeta in4s:120 in5s:110 in6s:100 plus:90];
    
    _myScrollView.contentSize = CGSizeMake(content_x,content_y);
    
   [UIView animateWithDuration:0.2 animations:^{
       
       [_myScrollView setContentOffset:CGPointMake(0, upDeta)];
   }];
    
}


//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    
    _myScrollView.contentSize = CGSizeMake(content_x, __MainScreen_Height);
    [UIView animateWithDuration:0.2 animations:^{
        
        [_myScrollView setContentOffset:CGPointMake(0, 0)];
    }];
    
}


- (void)btnClick:(UIButton *)btn
{
    [self.view endEditing:YES];
    if (btn.tag == 1) {
        if (self.sexTag) {
            [btn setBackgroundImage:[UIImage imageNamed:@"life_boy"] forState:UIControlStateNormal];
            self.sexTag = 0;

        }else {
            [btn setBackgroundImage:[UIImage imageNamed:@"life_girl"] forState:UIControlStateNormal];
            self.sexTag = 1;

        }
    }else if (btn.tag == 2){
        if (_weight_tf.text.length!=0&&_height_tf.text.length != 0) {
            float weight = [_weight_tf.text floatValue];
            float height = [_height_tf.text floatValue];
            float bodyResult = weight/(height/100)/(height/100);
            JGLog(@"bodyresult = %.2f",bodyResult);
            BOOL _inputValide = YES;
            if (height < 100 || height > 400 ) {
                _inputValide = NO;
                [Util ShowAlertWithOutCancelWithTitle:@"提示" message:@"身高填写不合理,请重新填写"];
            }
            
            if (weight < 10 || weight > 300 ) {
                _inputValide = NO;
                [Util ShowAlertWithOutCancelWithTitle:@"提示" message:@"体重填写不合理,请重新填写"];
            }
            if (_inputValide) {
                
                bodyresultViewController * bodyVc = [[bodyresultViewController alloc]init];
                bodyVc.bodyResult = bodyResult;
                if (self.sexTag) {
                    bodyVc.sex = @"women";
                }else{
                    bodyVc.sex = @"man";
                }
                [self.navigationController pushViewController:bodyVc animated:YES];
            }

        }else{
             UIAlertView * alertVc = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请完整输入个人身高体重信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];[alertVc show];

        }
    }
}

- (void)handeTap
{
    [self.view endEditing:YES];
}

- (void)weightChanged:(FFRulerControl *)ruler {
    weightLabel.text = [NSString stringWithFormat:@"体重: %lu kg", (unsigned long)roundf(ruler.selectedValue)];
    _weight_tf.text=[NSString stringWithFormat:@"%lu", (unsigned long)roundf(ruler.selectedValue)];
}
- (void)heightChanged:(FFRulerControl *)ruler {
    heightLabel.text = [NSString stringWithFormat:@"身高: %lu CM",(unsigned long)ruler.selectedValue];
    _height_tf.text=[NSString stringWithFormat:@"%lu", (unsigned long)roundf(ruler.selectedValue)];
}

@end
