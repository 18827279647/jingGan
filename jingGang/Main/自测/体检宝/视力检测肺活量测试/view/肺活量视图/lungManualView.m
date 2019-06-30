//
//  lungManualView.m
//  jingGang
//
//  Created by thinker on 15/7/27.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "lungManualView.h"
#import "PublicInfo.h"
#import "WSJLungResultViewController.h"
#import "MJRefresh.h"
#import "WSJHeartRateResultViewController.h"

#import "Unit.h"
#import "VApiManager.h"
#import "RXSubmitDataRequest.h"
#import "RXSubmitDataResponse.h"
#import "GlobeObject.h"
#import "RXWebViewController.h"

@implementation lungManualView
{
    UITextField *_lungValueTextField;
}


-(instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}
- (void) keyboardWillShow:(NSNotification *)show
{
    if ([_lungValueTextField isFirstResponder])
    {
        CGRect frame = self.frame;
        frame.origin.y = -50;
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = frame;
        }];
    }
}
- (void) initUI
{
    //设置背景颜色
    self.backgroundColor = [UIColor colorWithRed:232.0 /255 green:232.0 /255 blue:232.0 /255 alpha:1];
    
    //提示视图View
    UIView *promptView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 40)];
    promptView.backgroundColor = [UIColor colorWithRed:217.0 / 255 green:217.0 / 255 blue:217.0 / 255 alpha:1];
    [self addSubview:promptView];
    
    UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, promptView.frame.size.width, promptView.frame.size.height)];
    promptLabel.text = @"请输入您的肺活量值";
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.font = [UIFont systemFontOfSize:16];
    [promptView addSubview:promptLabel];
    
    UIImageView *promptImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-tishi_看图王"]];
    promptImageView.bounds = CGRectMake(0, 0, 25, 25);
    promptImageView.center = CGPointMake(__MainScreen_Width / 2 - 100,20);
    [promptView addSubview:promptImageView];
    
    UILabel *lungLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 70, 100 , 50)];
    lungLabel.text = @"肺活量值:";
    lungLabel.font = [UIFont systemFontOfSize:20];
    [self addSubview:lungLabel];
    
    _lungValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(140, 70, __MainScreen_Width - 80 - 100, 50)];
    _lungValueTextField.placeholder = @"0~10000";
    _lungValueTextField.borderStyle = UITextBorderStyleRoundedRect;
    _lungValueTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:_lungValueTextField];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHiddenKey)];
    [self addGestureRecognizer:tap];
    
    UIButton *certain = [UIButton buttonWithType:UIButtonTypeSystem];
    certain.frame = CGRectMake(40, 150 , __MainScreen_Width - 80 , 50);
    certain.layer.cornerRadius = 5;
    certain.backgroundColor = [UIColor colorWithRed:4.0 / 255 green:145.0 / 255 blue:203.0 / 255 alpha:1];
    [certain setTitle:@"确认输入" forState:UIControlStateNormal];
    [certain setBackgroundImage:[UIImage imageNamed:@"button222"] forState:UIControlStateNormal];

    [certain setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [certain addTarget:self action:@selector(certainAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:certain];
    
    
   
    //监听键盘状态
    [self monitorKey];
}
#pragma mark - 监听键盘状态
- (void) monitorKey
{
    //键盘抬起通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //界面切换时隐藏键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapHiddenKey) name:@"changeMenu" object:nil];
}
- (void) certainAction
{
    if ([_lungValueTextField.text integerValue] > 0 && [_lungValueTextField.text integerValue] < 10000 )
    {
        NSMutableDictionary*paramJson=[[NSMutableDictionary alloc]init];
        [paramJson setObject:_lungValueTextField.text forKey:@"inValue"];
        //上传接口
        [self getRuest:paramJson];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"肺活量输入不合理，请重新输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        _lungValueTextField.text = @"";
    }
}
-(void)getRuest:(NSMutableDictionary*)paramJson;{
    
    [paramJson setObject:@"3" forKey:@"type"];
    [self showHUD];
    //提交数据
    RXSubmitDataRequest*request=[[RXSubmitDataRequest alloc]init:GetToken];
    request.paramCode=8;
    request.paramJson=[self dictionaryToJson:paramJson];
    VApiManager *manager = [[VApiManager alloc]init];
    [manager RXSubmitDataRequest:request success:^(AFHTTPRequestOperation *operation, RXSubmitDataResponse *response) {
        [self hideAllHUD];
        if ([response.msg isEqualToString:@"success"]) {
            [self showStringHUD:@"提交成功" second:0];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"manualTestNotification" object:nil];
                WSJLungResultViewController *lungResultVC = [[WSJLungResultViewController alloc] initWithNibName:@"WSJLungResultViewController" bundle:nil];
                lungResultVC.type = lungCapacityType;
                lungResultVC.lungValue = [_lungValueTextField.text integerValue];
                [self.VC.navigationController pushViewController:lungResultVC animated:YES];
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

- (void) tapHiddenKey
{
    [self endEditing:YES];
    CGRect frame = self.frame;
    frame.origin.y = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = frame;
    }];
}
- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end
