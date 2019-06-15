//
//  foodViewController.m
//  jingGang
//
//  Created by yi jiehuang on 15/5/30.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "foodViewController.h"
#import "PublicInfo.h"
#import "foodChildViewController.h"
#import "GlobeObject.h"
#import "JGBlueToothManager.h"
#import "JGDropdownMenu.h"
#import "YSLabourStrengthSelectedController.h"
#import "FFRulerControl.h"
@interface foodViewController ()
{
    BOOL             btn_touch;
    UIScrollView    *_myscrollview;
    UITextField     *_height_tf,*_weight_tf;
    UIView          *_Bomb_box_view;
    UIButton        *_midel_btn;
    NSArray         *_name_array;
    UILabel *weightLabel;
    UILabel *heightLabel;
    float           content_x,content_y;//scrollView的滑动范围
    NSDictionary    *userDic;
    JGBlueToothManager *_jgBlueManager;
}

@end

@implementation foodViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [YSUMMobClickManager endLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [super viewWillAppear:animated];
}

- (void)dealloc {

}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    userDic = [kUserDefaults objectForKey:userInfoKey] ;
    _jgBlueManager = [JGBlueToothManager shareInstances] ;
    [YSThemeManager setNavigationTitle:@"膳食指南" andViewController:self];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
       UIButton *rightBtn =[[UIButton alloc]initWithFrame:CGRectMake(0.0f, 16.0f, 40.0f, 25.0f)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightButton;
    self.navigationController.navigationBar.tintColor = COMMONTOPICCOLOR;
    [self greatUI];
}



- (void)greatUI
{
    _myscrollview = [[UIScrollView alloc]initWithFrame:self.view.frame];
    _myscrollview.backgroundColor = JGWhiteColor;
    [self.view addSubview:_myscrollview];
    UILabel * top_lab = [[UILabel alloc]init];
    top_lab.frame = CGRectMake(0, 35, __MainScreen_Width, 20);
    top_lab.text = @"每日摄取能量计算";
    top_lab.textAlignment = NSTextAlignmentCenter;
    top_lab.font = [UIFont systemFontOfSize:16];
    top_lab.textColor = JGBlackColor;
    [_myscrollview addSubview:top_lab];

    UIButton * sex_btn = [[UIButton alloc]init];
    sex_btn.frame = CGRectMake(0, 0, 175, 45);
    
    //确认男女
//    NSInteger sex = [userDic[@"sex"] integerValue];
    NSString *sexImgName = nil;
    if (_jgBlueManager.userBodyModel.genderType == GenderTypeWoman) {//男
        sexImgName = @"life_boy";
    }else{//
        sexImgName = @"life_girl";
    }
    
    [sex_btn setBackgroundImage:[UIImage imageNamed:sexImgName] forState:UIControlStateNormal];
    NSNumber *weight = @(_jgBlueManager.userBodyModel.weight) ;
    NSNumber *height = @(_jgBlueManager.userBodyModel.height) ;
    NSArray *valueArr = nil;
    if (weight!= nil && height != nil) {
        
        valueArr = @[weight,height];
        
    }else{
        
        valueArr = @[@120,@170];
    }

//    [sex_btn setBackgroundImage:[UIImage imageNamed:@"life_boy"] forState:UIControlStateNormal];
    sex_btn.tag = 1;
    btn_touch = YES;
    [sex_btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    sex_btn.center = CGPointMake(__MainScreen_Width/2, top_lab.frame.origin.y+top_lab.frame.size.height+68/2);
    [_myscrollview addSubview:sex_btn];
    
    UIView *continer=[UIView new];
    continer.frame=CGRectMake(0, (__MainScreen_Width - 119)/2,119, 15);
    UIImageView * img = [[UIImageView alloc]init];//劳动强度图标
    UILabel * img_lab = [[UILabel alloc]init];//劳动强度
    img.image = [UIImage imageNamed:@"life_labor"];
    img.frame = CGRectMake(10, 0, 14, 13);
    [continer addSubview:img];
    img_lab.frame = CGRectMake(img.frame.size.width+img.frame.origin.x+5, img.frame.origin.y+3, 100, 10);
    img_lab.text = @"劳动强度";
//    img_lab.textAlignment = NSTextAlignmentCenter;

    img_lab.textColor = [UIColor lightGrayColor];
    img_lab.font = [UIFont systemFontOfSize:13];
    [continer addSubview:img_lab];
    continer.centerX=_myscrollview.centerX;
    [_myscrollview addSubview:continer];
    
    _midel_btn = [[UIButton alloc]init];
    _midel_btn.frame = CGRectMake(0, CGRectGetMaxY(continer.frame)+8, _myscrollview.width - img.frame.origin.x - 140, 84/2);
    _midel_btn.backgroundColor = JGColor(238, 238, 238, 1);
    _midel_btn.layer.cornerRadius = 20;
    _midel_btn.clipsToBounds = YES;
    _midel_btn.tag = 2;
    _midel_btn.titleLabel.numberOfLines = 0;
    _midel_btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _midel_btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_midel_btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_midel_btn setTitleColor:JGBlackColor forState:UIControlStateNormal];
    [_midel_btn setTitle:@"轻体力劳动(白领 老师 售票员 学生)" forState:UIControlStateNormal];
    _midel_btn.centerX=_myscrollview.centerX;
    [_myscrollview addSubview:_midel_btn];
   
    weightLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_midel_btn.frame)+20, 150, 30)];
    weightLabel.centerX=_myscrollview.centerX;
    weightLabel.textAlignment=NSTextAlignmentCenter;
    weightLabel.text=@"体重:127KG";
     [_myscrollview addSubview:weightLabel];
    FFRulerControl *ruler = [FFRulerControl new];
    ruler.frame=CGRectMake(0, CGRectGetMaxY(weightLabel.frame)+10, 300, 120);
    ruler.centerX = _myscrollview.centerX;
    [_myscrollview addSubview:ruler];
    ruler.backgroundColor =[UIColor whiteColor];
     ruler.minValue = 30;
    ruler.maxValue = 500;
    ruler.valueStep = 10;
    ruler.indicatorColor = rgb(101, 187, 177, 1);

    ruler.selectedValue = 90;
    [ruler addTarget:self action:@selector(weightChanged:) forControlEvents:UIControlEventValueChanged];
    
    heightLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(ruler.frame)+20, 150, 30)];
    heightLabel.centerX=_myscrollview.centerX;
    heightLabel.textAlignment=NSTextAlignmentCenter;
    heightLabel.text=@"身高:127CM";
     [_myscrollview addSubview:heightLabel];
    FFRulerControl *heightRuler = [FFRulerControl new] ;
    heightRuler.frame=CGRectMake(0, CGRectGetMaxY(heightLabel.frame)+10, 300, 120);
    heightRuler.centerX = _myscrollview.centerX;
    [_myscrollview addSubview:heightRuler];
    heightRuler.backgroundColor = [UIColor whiteColor];
    heightRuler.minValue = 80;
    heightRuler.maxValue = 300;
    heightRuler.valueStep = 10;
    heightRuler.indicatorColor = rgb(101, 187, 177, 1);

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
    btn2.width = _myscrollview.width - btn2.x * 2;
    btn2.height = 44.;
//    btn2.backgroundColor =[UIColor colorWithHexString:@"65BBB1"];// [YSThemeManager buttonBgColor];
    btn2.layer.cornerRadius = 4;
    btn2.clipsToBounds = YES;
    btn2.tag = 3;
    [btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn2.titleLabel.font = YSPingFangRegular(16);
    [btn2 setTintColor:[UIColor whiteColor]];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"button222"] forState:UIControlStateNormal];

    [btn2 setTitle:@"开始计算" forState:UIControlStateNormal];
    [_myscrollview addSubview:btn2];

    _myscrollview.contentSize = CGSizeMake(__MainScreen_Width, btn2.frame.size.height+btn2.frame.origin.y+100);
    content_x = __MainScreen_Width;
    content_y = btn2.frame.size.height+btn2.frame.origin.y+100;
    UITapGestureRecognizer * sideslipTapGes= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handeTap)];
//    [sideslipTapGes setNumberOfTapsRequired:1];
    
    [_myscrollview addGestureRecognizer:sideslipTapGes];
    
    _Bomb_box_view = [[UIView alloc]init];
    _Bomb_box_view.layer.cornerRadius = 4;
    _Bomb_box_view.clipsToBounds = YES;
    _Bomb_box_view.frame = CGRectMake(0, 0, 540/2, 540/2);
    _Bomb_box_view.center = CGPointMake(self.view.centerX, ScreenHeight);
    _Bomb_box_view.backgroundColor = [UIColor whiteColor];
    float spase_one = 49;
    float spase_two = 42;
    _name_array = [NSArray arrayWithObjects:@"请选择",@"卧床",@"轻体力劳动(白领 老师 售票员 学生)",@"中体力劳动(工人 司机 快递员 清洁工 IT人士)",@"重体力劳动(农民 建筑工 搬运工 舞蹈员)", nil] ;
    for (int i = 0; i < 5; i ++) {
        UILabel * line_lab = [[UILabel alloc]init];
        line_lab.frame = CGRectMake(0, spase_one+i*spase_two, 540/2, 0.5);
        line_lab.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [_Bomb_box_view addSubview:line_lab];

        UIButton * line_btn = [[UIButton alloc]init];
        line_btn.frame = CGRectMake(0, 7+i*spase_two, 540/2, spase_two);
        [line_btn setTitle:[_name_array objectAtIndex:i] forState:UIControlStateNormal];
        [line_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        line_btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [line_btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        line_btn.tag = i + 500;
        if (i == 0) {
            line_btn.titleLabel.font = [UIFont systemFontOfSize:17];
        }
        [_Bomb_box_view addSubview:line_btn];

        if (i == 4) {
            UIButton * line_btn2 = [[UIButton alloc]init];
            line_btn2.frame = CGRectMake(0, 10+5*spase_two, 540/2, spase_two);
            [line_btn2 setTitle:@"取消" forState:UIControlStateNormal];
            [line_btn2 setTitleColor:[UIColor colorWithRed:74.0/255 green:182.0/255 blue:236.0/255 alpha:1] forState:UIControlStateNormal];
            line_btn2.tag = 505;
            [line_btn2 setTitleColor:[YSThemeManager buttonBgColor] forState:UIControlStateNormal];
            line_btn2.titleLabel.font = [UIFont systemFontOfSize:17];
            [line_btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_Bomb_box_view addSubview:line_btn2];

        }
    }
    [_myscrollview addSubview:_Bomb_box_view];
    _Bomb_box_view.hidden = YES;
//    _Bomb_box_view.frame = CGRectMake(0, 0, 1, 1);
//    _Bomb_box_view.center = CGPointMake(self.view.center.x, 240);
    
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
    
    _myscrollview.contentSize = CGSizeMake(content_x,content_y);
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [_myscrollview setContentOffset:CGPointMake(0, upDeta)];
    }];
    
}


//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    
    _myscrollview.contentSize = CGSizeMake(content_x, __MainScreen_Height);
    [UIView animateWithDuration:0.2 animations:^{
        
        [_myscrollview setContentOffset:CGPointMake(0, 0)];
    }];
    
}




- (void)btnClick:(UIButton *)btn
{
    if (btn.tag == 1) {
        btn_touch = !btn_touch;
        if (btn_touch) {
            [btn setBackgroundImage:[UIImage imageNamed:@"life_boy"] forState:UIControlStateNormal];
        }else{
            [btn setBackgroundImage:[UIImage imageNamed:@"life_girl"] forState:UIControlStateNormal];
        }
    }else if (btn.tag == 2){
        // 点击选择劳动强度
        JGDropdownMenu *menu = [JGDropdownMenu menu];
        [menu configTouchViewDidDismissController:NO];
        [menu configBgShowMengban];
        @weakify(menu);
        YSLabourStrengthSelectedController *controllerView = [[YSLabourStrengthSelectedController alloc] initWithSelecteRow:^(NSString *msg) {
            @strongify(menu);
            [menu dismiss];
            [_midel_btn setTitle:msg forState:UIControlStateNormal];
        } cancel:^{
            @strongify(menu);
            [menu dismiss];
        }];;
        controllerView.view.width = ScreenWidth;
        controllerView.view.height = ScreenHeight;
        menu.contentController = controllerView;
        [menu showWithFrameWithDuration:0.32];
//        _Bomb_box_view.hidden = NO;
//        [UIView animateWithDuration:0.5 animations:^{
////            _Bomb_box_view.frame = CGRectMake(0, 0, 540/2, 540/2);
//            _Bomb_box_view.center = CGPointMake(__MainScreen_Width / 2, 240);
//        }];
    }else if (btn.tag == 3){
//        NSLog(@"height = %@,weight = %@",_height_tf.text,_weight_tf.text);
        if (_weight_tf.text.length > 0 && _height_tf.text.length >0 ) {
            
            float weight = [_weight_tf.text floatValue];
            float height = [_height_tf.text floatValue];
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
                
                [self calculate];
            }
            
        }else{
            [Util ShowAlertWithOutCancelWithTitle:@"提示" message:@"资料未填写完整，请补充完整"];
            
        }
        
    }else if (btn.tag>500&&btn.tag<505 ){
        [_midel_btn setTitle:[_name_array objectAtIndex:btn.tag-500] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5 animations:^{
//            _Bomb_box_view.frame = CGRectMake(0, 0, 1, 1);
            _Bomb_box_view.center = CGPointMake(self.view.center.x,240);
        } completion:^(BOOL finished) {
            _Bomb_box_view.hidden = YES;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
//            _Bomb_box_view.frame = CGRectMake(0, 0, 1, 1);
            _Bomb_box_view.center = CGPointMake(self.view.centerX, ScreenHeight);//CGPointMake(self.view.center.x, 240);
        } completion:^(BOOL finished) {
            _Bomb_box_view.hidden = YES;
        }];
    }
}

- (void)handeTap
{
    CGSize myScrollViewSize = _myscrollview.contentSize;
    [self.view endEditing:YES];
    _myscrollview.contentSize = myScrollViewSize;
}


- (void)calculate{
    float tiZhong = [_weight_tf.text integerValue];
    float shengaGao = [_height_tf.text integerValue];
    float biaoZhunTiZhong = shengaGao - 105;//标准体重
    float tiZhongZhiShu =  tiZhong/(shengaGao/100)/(shengaGao/100);//体重指数
    TiZhongDengJi tiZhongDengJi = TiZhongDengJiZhengChang;//体重等级
    if(btn_touch){
        if (tiZhongZhiShu < 20) {
            tiZhongDengJi = TiZhongDengJiPianShou;
        }else if (tiZhongZhiShu < 25 && tiZhongZhiShu >= 20){
            tiZhongDengJi = TiZhongDengJiZhengChang;
        }else if (tiZhongZhiShu < 30 && tiZhongZhiShu >= 25){
            tiZhongDengJi = TiZhongDengJiPianPang;
        }else if (tiZhongZhiShu < 35 && tiZhongZhiShu >= 30){
            tiZhongDengJi = TiZhongDengJiQingDuFeiPang;
        }else if (tiZhongZhiShu > 35){
            tiZhongDengJi = TiZhongDengJiZhongDuFeiPang;
        }
    }else{
        if (tiZhongZhiShu < 19) {
            tiZhongDengJi = TiZhongDengJiPianShou;
        }else if (tiZhongZhiShu < 24 && tiZhongZhiShu >= 19){
            tiZhongDengJi = TiZhongDengJiZhengChang;
        }else if (tiZhongZhiShu < 29 && tiZhongZhiShu >= 24){
            tiZhongDengJi = TiZhongDengJiPianPang;
        }else if (tiZhongZhiShu < 34 && tiZhongZhiShu >= 29){
            tiZhongDengJi = TiZhongDengJiQingDuFeiPang;
        }else if (tiZhongZhiShu > 34){
            tiZhongDengJi = TiZhongDengJiZhongDuFeiPang;
        }
    }
    NSInteger danWeiTiZhongSuoXuReLiang = 0;
    NSInteger selectNum = [_name_array indexOfObject:_midel_btn.titleLabel.text];
    switch (selectNum) {
        case 1:
        {
            switch (tiZhongDengJi) {
                case TiZhongDengJiPianShou:
                    danWeiTiZhongSuoXuReLiang = 25;
                    break;
                case TiZhongDengJiZhengChang:
                case TiZhongDengJiPianPang:
                    danWeiTiZhongSuoXuReLiang = 20;
                    break;
                case TiZhongDengJiQingDuFeiPang:
                case TiZhongDengJiZhongDuFeiPang:
                    danWeiTiZhongSuoXuReLiang = 15;
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:
            switch (tiZhongDengJi) {
                case TiZhongDengJiPianShou:
                    danWeiTiZhongSuoXuReLiang = 35;
                    break;
                case TiZhongDengJiZhengChang:
                case TiZhongDengJiPianPang:
                    danWeiTiZhongSuoXuReLiang = 30;
                    break;
                case TiZhongDengJiQingDuFeiPang:
                case TiZhongDengJiZhongDuFeiPang:
                    danWeiTiZhongSuoXuReLiang = 25;
                    break;
                default:
                    break;
            }
            break;
        case 3:
            switch (tiZhongDengJi) {
                case TiZhongDengJiPianShou:
                    danWeiTiZhongSuoXuReLiang = 40;
                    break;
                case TiZhongDengJiZhengChang:
                case TiZhongDengJiPianPang:
                    danWeiTiZhongSuoXuReLiang = 35;
                    break;
                case TiZhongDengJiQingDuFeiPang:
                case TiZhongDengJiZhongDuFeiPang:
                    danWeiTiZhongSuoXuReLiang = 30;
                    break;
                default:
                    break;
            }
            break;
        case 4:
            switch (tiZhongDengJi) {
                case TiZhongDengJiPianShou:
                    danWeiTiZhongSuoXuReLiang = 50;
                    break;
                case TiZhongDengJiZhengChang:
                case TiZhongDengJiPianPang:
                    danWeiTiZhongSuoXuReLiang = 40;
                    break;
                case TiZhongDengJiQingDuFeiPang:
                case TiZhongDengJiZhongDuFeiPang:
                    danWeiTiZhongSuoXuReLiang = 35;
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    float kaluliStr = danWeiTiZhongSuoXuReLiang * biaoZhunTiZhong;
    foodChildViewController * foodChildVc = [[foodChildViewController alloc]init];
    foodChildVc.kaluliStr = [NSString stringWithFormat:@"%ld卡",(long)kaluliStr];
    [self.navigationController pushViewController:foodChildVc animated:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
