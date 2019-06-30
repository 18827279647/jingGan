//
//  eyeTestViewController.m
//  jingGang
//
//  Created by thinker on 15/7/21.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "eyeTestView.h"
#import "PublicInfo.h"
#import "eyeTestModel.h"
#import "examineResultViewController.h"

#import "Unit.h"
#import "VApiManager.h"
#import "GlobeObject.h"
#import "RXWebViewController.h"

#define K_Heigth (__MainScreen_Height - 108)

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface eyeTestView ()<UIScrollViewDelegate>
{
    UIScrollView *_blueScrollView; //测试视力数据
    UILabel *_leftLabel;             //左边视力数据
    UILabel *_rightLabel;            //右边视力数据
    UIImageView *_centerImageView;    //视力图
    
    NSInteger _angle ;  //旋转角度
    
    UIButton *_selectBtn;  //选中视力数据的按钮
    
    NSInteger _num;  //计数，判断结果的总个数
    NSInteger _fitNum;  //答对个数
    NSInteger _errorNum;  //答错个数
}

@property (nonatomic, strong) NSMutableArray * dataSource;  //数据源Model

@property (nonatomic, strong) NSMutableArray * cacheData;  //缓存的对错按钮

@property (nonatomic, strong) NSMutableArray * cacheEyeButton;//缓存视力数按钮

@property (nonatomic, assign) NSInteger resultModel; //最终结果Model的下标

@end

@implementation eyeTestView

- (instancetype)init{
    self = [super init];
    if (self) {
        
        [self initData];
        
        //提示按钮UI
        [self initUIPrompt];
        
        //初始化内容UI
        [self initContent];
        
        //实例化选项按钮
        [self initUIButton];
    }
    return self;
}
#pragma mark - 获取数据
- (void) initData
{
    self.dataSource = [NSMutableArray array];
    self.cacheData = [NSMutableArray array];
    self.cacheEyeButton = [NSMutableArray array];
    for (NSInteger i = 30 ; i < 53 ; i++)
    {
        eyeTestModel *m = [[eyeTestModel alloc] init];
        m.rightLabel = [NSString stringWithFormat:@"%0.1f",i / 10.0];
        m.leftLabel = [NSString stringWithFormat:@"%0.2g", 1.0 / powf(10, 5.0 - [m.rightLabel floatValue])];
        m.width = .72722 * powf(10, 5.0 - [m.rightLabel floatValue]) * 2.5 + 0.8;
        [self.dataSource addObject:m];
    }
}
#pragma mark - 实例化提示UI
- (void) initUIPrompt
{
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width , 40)];
    backImageView.backgroundColor = JGWhiteColor;
    [self addSubview:backImageView];
    
    UIImageView *imageI = [[UIImageView alloc] initWithFrame:CGRectMake(28, 10, 12, 13)];
    imageI.image = [UIImage imageNamed:@"ys_combined shape"];
    [backImageView addSubview:imageI];
    
    UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 4, backImageView.frame.size.width - 30, 25)];
    promptLabel.textColor = [UIColor colorWithRed:60.78 / 255 green:33.63 / 255 blue:36.64 / 255 alpha:1];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.font = [UIFont systemFontOfSize:12];
    promptLabel.text = @"保持手机在眼前30厘米处，选择图片的朝向。";
    [backImageView addSubview:promptLabel];
}
#pragma mark - 实例化中间内容UI
- (void)initContent
{
    //左右两条竖线
    UIView *v1 =[[UIView alloc] initWithFrame:CGRectMake(20, 40, 1, K_Heigth / 3 * 2 - 65)];
    v1.backgroundColor = COMMONTOPICCOLOR;
    [self addSubview:v1];
    
    UIView *v2 =[[UIView alloc] initWithFrame:CGRectMake(__MainScreen_Width - 20 , 40, 1, K_Heigth / 3 * 2 - 65)];
    v2.backgroundColor = COMMONTOPICCOLOR;
    [self addSubview:v2];
    eyeTestModel *m = self.dataSource[10];
    //左右两个Label
    _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, K_Heigth / 3, 20, 30)];
    _leftLabel.text = m.leftLabel;
    _leftLabel.textColor = COMMONTOPICCOLOR;
    _leftLabel.textAlignment = NSTextAlignmentCenter;
    _leftLabel.font = [UIFont systemFontOfSize:9];
    _leftLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_leftLabel];
    

    _rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(__MainScreen_Width - 20, K_Heigth / 3, 20, 30)];
    _rightLabel.text = m.rightLabel;
    _rightLabel.textColor = COMMONTOPICCOLOR;
    _rightLabel.textAlignment = NSTextAlignmentCenter;
    _rightLabel.font = [UIFont systemFontOfSize:9];
    _rightLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_rightLabel];
    
    
    //视力图图片的实例化
    _centerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shili"]];
    _centerImageView.contentMode = UIViewContentModeScaleAspectFit;
    _centerImageView.center = CGPointMake(__MainScreen_Width / 2 , CGRectGetHeight(v1.frame) / 2 + CGRectGetMinY(v1.frame));
//    eyeTestModel *m = self.dataSource[10];
    _centerImageView.bounds = CGRectMake(0, 0, m.width, m.width);
    [self imageViewTransform];
    [self addSubview:_centerImageView];
    
    
    //视力检查数据表
    _blueScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, K_Heigth / 3 * 2 - 20, __MainScreen_Width, 50)];
    _blueScrollView.delegate = self;
    _blueScrollView.bounces = YES;
    _blueScrollView.showsHorizontalScrollIndicator = NO;
    _blueScrollView.backgroundColor = UIColorFromRGB(0x0099cc);
    [self addSubview:_blueScrollView];
    
    UIImageView *imageView;
    for (int i = 0 ; i < 6; i ++)
    {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(160 + i * 120, 0, 121, 50)];
        imageView.image = [UIImage imageNamed:@"Scale"];
        [_blueScrollView addSubview:imageView];
    }
    _blueScrollView.contentSize = CGSizeMake(CGRectGetMaxX(imageView.frame), 1);
    
    for (NSInteger i = 0 ; i < self.dataSource.count;  i++)
    {
        eyeTestModel *model = self.dataSource [i];
        if (i == 10)
        {
            UIButton *btn = [self createUIButtonWithBackgroundColor:[UIColor redColor] withIndex:i withLeft:model.leftLabel withRight:model.rightLabel];
            _blueScrollView.contentOffset = CGPointMake(btn.frame.origin.x - __MainScreen_Width / 2, 0);
        }
        else
        {
            [self createUIButtonWithBackgroundColor:[UIColor clearColor] withIndex:i withLeft:model.leftLabel withRight:model.rightLabel];
        }
    }
}

#pragma mark - 实例化上下左右四个按钮
- (void) initUIButton
{
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_blueScrollView.frame), __MainScreen_Width, K_Heigth / 3 - 30)];
    btnView.backgroundColor = [UIColor whiteColor];
    [self addSubview:btnView];
    
    NSInteger btnWidth = 52.0;
    
    UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [topBtn setImage:[UIImage imageNamed:@"ys_healthymanage_eyesight_up"] forState:UIControlStateNormal];
    topBtn.center = CGPointMake(__MainScreen_Width / 2,  CGRectGetHeight(btnView.frame) / 4);
    topBtn.bounds = CGRectMake(0, 0, btnWidth, btnWidth);
    topBtn.tag = 1;
    [topBtn addTarget:self action:@selector(directionAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:topBtn];
    
    UIButton *downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [downBtn setImage:[UIImage imageNamed:@"ys_healthymanage_eyesight_down"] forState:UIControlStateNormal];
    downBtn.center = CGPointMake(__MainScreen_Width / 2,  CGRectGetHeight(btnView.frame) / 4 * 3);
    downBtn.bounds = CGRectMake(0, 0, btnWidth, btnWidth);
    downBtn.tag = 3;
    [downBtn addTarget:self action:@selector(directionAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:downBtn];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"ys_healthymanage_eyesight_left"] forState:UIControlStateNormal];
    leftBtn.center = CGPointMake(__MainScreen_Width / 3,  CGRectGetHeight(btnView.frame) / 4 * 2);
    leftBtn.bounds = CGRectMake(0, 0, btnWidth, btnWidth);
    leftBtn.tag = 0;
    [leftBtn addTarget:self action:@selector(directionAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"ys_healthymanage_eyesight_right"] forState:UIControlStateNormal];
    rightBtn.center = CGPointMake(__MainScreen_Width / 3 * 2,  CGRectGetHeight(btnView.frame) / 4 * 2);
    rightBtn.bounds = CGRectMake(0, 0, btnWidth, btnWidth);
    rightBtn.tag = 2;
    [rightBtn addTarget:self action:@selector(directionAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:rightBtn];
    
    //重测
    UIButton *again = [UIButton buttonWithType:UIButtonTypeSystem];
    [again setTitle:@"重测" forState:UIControlStateNormal];
    [again setTitleColor:[YSThemeManager buttonBgColor] forState:UIControlStateNormal];
    again.bounds = CGRectMake(0, 0, 50, 50);
    again.titleLabel.font = JGFont(18);
    again.center = CGPointMake(__MainScreen_Width - 40 , CGRectGetHeight(btnView.frame) / 2);
    again.y += 12;
    [again addTarget:self action:@selector(againAction) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:again];
}
#pragma mark - 重测事件
- (void)againAction
{
    [self createButtonAction:self.cacheEyeButton[10]];
    self.resultModel = 0;
    for (UIView *v in self.cacheData)
    {
        [v removeFromSuperview];
    }
    _num = 0;
    _errorNum = 0;
    _fitNum = 0;
}
#pragma mark - 上下左右按钮触发事件
- (void) directionAction:(UIButton *)btn
{
    [self createUIButtonInterpretResult:(btn.tag == _angle) withIndex:btn.tag];
    [self imageViewTransform];
    
}

#pragma mark - 中心图片进行随机旋转
- (void) imageViewTransform
{
    _centerImageView.transform = CGAffineTransformIdentity;
    CGAffineTransform transform = _centerImageView.transform;
    NSInteger angleArc;
    //随机产生一个0~4数，不能与上个数雷同
    while (1)
    {
        angleArc = arc4random() % 4;
        if (angleArc != _angle)
        {
            _angle = angleArc;
            break;
        }
    }
    CGAffineTransform new = CGAffineTransformRotate(transform, _angle * 90 * M_PI / 180) ;
    _centerImageView.transform = new;
}
#pragma  mark -   ---------------自定义按钮-------------------------

//自定义√和×按钮
- (void) createUIButtonInterpretResult:(BOOL)b withIndex:(NSInteger)idx
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake( __MainScreen_Width - 40 - 40 * _num, _blueScrollView.frame.origin.y - 30 , 20, 20);
    if (b)
    {
        [btn setImage:[UIImage imageNamed:@"Correct"] forState:UIControlStateNormal];
        _fitNum ++;
    }
    else
    {
        [btn setImage:[UIImage imageNamed:@"Error"] forState:UIControlStateNormal];
        _errorNum ++;
    }
    _num ++;
    [self addSubview:btn];
    [self.cacheData addObject:btn];
#warning 判断是否可以跳转，答对3个跳到下一个
    //判断错误跳转下一个视力图
    if (_errorNum == 3)
    {
        if (_selectBtn.tag == 0)
        {
//            NSLog(@"你的眼力真差3.0");
            examineResultViewController *resultVC = [[examineResultViewController alloc] initWithNibName:@"examineResultViewController" bundle:nil];
            resultVC.eyeValue = @"3.0";
            resultVC.type = k_Eye;
            [self.VC.navigationController pushViewController:resultVC animated:YES];
        }
        else
        {
            UIButton *btn = self.cacheEyeButton[_selectBtn.tag - 1];
            [self createButtonAction:btn];
            if (self.resultModel)
            {
                
                eyeTestModel *model = self.dataSource[self.resultModel];
                
                NSMutableDictionary*paramJson=[[NSMutableDictionary alloc]init];
                [paramJson setObject:model.rightLabel forKey:@"inValue"];
                //上传接口
                [self getRuest:paramJson];
                
            }
        }
    }
    //判断正确的选项
    if (_fitNum == 3)
    {
        if (_selectBtn.tag +1 == self.dataSource.count)
        {
//            NSLog(@"你的实力真好5.0");
#warning 正确结果在这里，下标      模型在self.dataSource
            NSMutableDictionary*paramJson=[[NSMutableDictionary alloc]init];
            [paramJson setObject:@"5.2" forKey:@"inValue"];
            //上传接口
            [self getRuest:paramJson];
        }
        else
        {
            self.resultModel = _selectBtn.tag;//标记当前正确的位置
            UIButton *btn = self.cacheEyeButton[_selectBtn.tag + 1];
            [self createButtonAction:btn];
        }
    }
}
-(void)getRuest:(NSMutableDictionary*)paramJson;{
    
    [paramJson setObject:@"3" forKey:@"type"];
    [self showHUD];
    //提交数据
    RXSubmitDataRequest*request=[[RXSubmitDataRequest alloc]init:GetToken];
    request.paramCode=15;
    request.paramJson=[self dictionaryToJson:paramJson];
    VApiManager *manager = [[VApiManager alloc]init];
    [manager RXSubmitDataRequest:request success:^(AFHTTPRequestOperation *operation, RXSubmitDataResponse *response) {
        [self hideAllHUD];
        if ([response.msg isEqualToString:@"success"]) {
            [self showStringHUD:@"提交成功" second:0];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"manualTestNotification" object:nil];
                self.resultModel = _selectBtn.tag;//标记当前正确的位置
                examineResultViewController *resultVC = [[examineResultViewController alloc] initWithNibName:@"examineResultViewController" bundle:nil];
                resultVC.eyeValue = [Unit JSONString:paramJson key:@"inValue"];
                resultVC.type = k_Eye;
                [self.VC.navigationController pushViewController:resultVC animated:YES];
            });
        }else{
            [self showStringHUD:@"提交失败" second:0];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideAllHUD];
        [self showStringHUD:@"网络错误" second:0];
    }];
}
#pragma mark 字典转化字符串
-(NSString*)dictionaryToJson:(NSMutableDictionary *)dic
{
    NSString *jsonString = nil;
    NSError *error;
    if (dic == nil) {
        return jsonString;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}






- (void)showHUD{
    
    [MBProgressHUD showHUDAddedTo:self animated:YES];
}
/**
 *  功能:显示字符串hud
 */
- (void)showHUD:(NSString *)aMessage
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = aMessage;
}
- (void)showHUD:(NSString *)aMessage animated:(BOOL)animated
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:animated];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = aMessage;
}
/**
 *  功能:显示字符串hud几秒钟时间
 */
- (void)showStringHUD:(NSString *)aMessage second:(int)aSecond{
    
    [self hideAllHUD];
    if(aSecond==0){
        aSecond = 2;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = aMessage;
    [self performSelector:@selector(hideHUD) withObject:nil afterDelay:aSecond];
}


/**
 *  功能:隐藏hud
 */
- (void)hideHUD
{
    [MBProgressHUD hideHUDForView:self animated:YES];
}

/**
 *  功能:隐藏所有hud
 */
- (void)hideAllHUD
{
    
    [MBProgressHUD hideAllHUDsForView:self animated:YES];
}

/**
 *  功能:隐藏hud
 */
- (void)hideHUD:(BOOL)animated
{
    [MBProgressHUD hideHUDForView:self animated:animated];
}
//创建视力数按钮
- (UIButton *) createUIButtonWithBackgroundColor:(UIColor *)color withIndex:(NSInteger)idx withLeft:(NSString *)left withRight:(NSString *)right
{
    UIButton *btn = [UIButton buttonWithType: UIButtonTypeCustom];
    btn.backgroundColor = color;
    btn.tag = idx;
    btn.frame = CGRectMake(180 + 30 * idx, 16, 20, 18);
    [btn addTarget:self action:@selector(createButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_blueScrollView addSubview:btn];
    
    UILabel *topLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 9)];
    topLB.textAlignment = NSTextAlignmentCenter;
    topLB.font = [UIFont systemFontOfSize:8];
    topLB.text = right;
    topLB.textColor = [UIColor whiteColor];
    [btn addSubview:topLB];
    
    UILabel *downLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 9, 20, 9)];
    downLB.textAlignment = NSTextAlignmentCenter;
    downLB.font = [UIFont systemFontOfSize:8];
    downLB.text = left;
    downLB.adjustsFontSizeToFitWidth = YES;
    downLB.textColor = [UIColor whiteColor];
    [btn addSubview:downLB];
    
    [self.cacheEyeButton addObject:btn];
    
    if (idx == 10)
    {
        _selectBtn = btn;
    }
    return btn;
}
//点击视力数按钮
- (void) createButtonAction:(UIButton *)btn
{
    eyeTestModel *model = self.dataSource[btn.tag];
    _leftLabel.text = model.leftLabel;
    _rightLabel.text = model.rightLabel;
    _centerImageView.bounds = CGRectMake(0, 0, model.width, model.width);
    [self imageViewTransform];
    
    
    _selectBtn.backgroundColor = [UIColor clearColor];
    btn.backgroundColor = [UIColor redColor];
    _selectBtn = btn;
    
    
    //清除所有的判断√ 和 × 的结果
    for (UIButton *b  in self.cacheData)
    {
        [b removeFromSuperview];
    }
    _num = 0;
    _fitNum = 0;
    _errorNum = 0;
    [UIView animateWithDuration:1 animations:^{
        _blueScrollView.contentOffset = CGPointMake(btn.frame.origin.x - __MainScreen_Width / 2, 0);
    }];
    
}
#pragma mark - UIScrollViewDelegate
//控制上一层scrollView什么时候可以滑动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.VC performSelector:@selector(isScrollEnabled:) withObject:@"0"];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.VC performSelector:@selector(isScrollEnabled:) withObject:@"1"];
}
@end
