//
//  ZFPasswordViewController.m
//  Operator_JingGang
//
//  Created by whlx on 2019/4/15.
//  Copyright © 2019年 Dengxf. All rights reserved.
//

#import "ZFPasswordViewController.h"

#import "IQKeyboardManager.h"
#import "GroupMoneyCashRequest.h"

#import "RACSignal.h"
#import "RACSubscriber.h"
#import "GlobeObject.h"
#import "VApiManager.h"
#import "JGCloudAndValueManager.h"
#import "JGPayResultController.h"
#import "JGSettingPayPasswordController.h"
@interface ZFPasswordViewController ()<UITextFieldDelegate>

@end

@implementation ZFPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     // 添加通知监听见键盘弹出/退出
     self.PassWordTextField.delegate = self;
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillShowNotification object:nil];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillHideNotification object:nil];
    
    _PassWordTextField.secureTextEntry = YES;

 }

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
    manager.shouldResignOnTouchOutside = NO;
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.enableAutoToolbar = NO;

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ) {
        
        UITextInputAssistantItem* item = [self.PassWordTextField inputAssistantItem];
        item.leadingBarButtonGroups = @[];
        item.trailingBarButtonGroups = @[];
    }
    [self.PassWordTextField becomeFirstResponder];
    self.PassWordTextField.keyboardType  = UIKeyboardTypeNumberPad;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;
    [[IQKeyboardManager sharedManager] setEnable:YES];
     [self.navigationController setNavigationBarHidden:NO animated:YES];
   
}
- (IBAction)back:(id)sender {
    
      [self dismissViewControllerAnimated:YES completion:nil];
    
}
// 点击键盘Return键取消第一响应者
 - (BOOL)textFieldShouldReturn:(UITextField *)textField{
        [self.PassWordTextField resignFirstResponder];
        return  YES;
 }



 // 键盘监听事件
 - (void)keyboardAction:(NSNotification*)sender{
     // 通过通知对象获取键盘frame: [value CGRectValue]
     NSDictionary *useInfo = [sender userInfo];
     NSValue *value = [useInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
 
         // <注意>具有约束的控件通过改变约束值进行frame的改变处理
  
     if([sender.name isEqualToString:UIKeyboardWillShowNotification]){
                  self.Viewjd.constant = [value CGRectValue].size.height;
              }else{
                  self.Viewjd.constant = 0;
                  }
 }



- (IBAction)requestData:(id)sender {
         CGFloat cashUserId = 0;
   MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    if ([_takeWayTapy isEqualToString:@"支付宝"]){
        NSLog(@"idCard,_bankAccton%@,%@",_idCard,_bankAccton);
        
        [JGCloudAndValueManager callCashWithCashPayment:CashPayAliType cashAmount:[_menoy floatValue] cashUserName:_Name cashBank:@"" cashAccount:_idCard cashPassword:_PassWordTextField.text cashInfo:_beizhu cashSubbranch:@"" needCashId:nil cashId:cashUserId cashType:@"user_app" accountType:@"personalAccounts" idCard:_bankAccton
            success:^(CloudBuyerCashSaveResponse *response) {
            
            [hub hide:YES afterDelay:1.0f];
            if([response.subMsg isEqualToString: @"提现申请成功!"]){
             
                JGPayResultController *resultController = [[JGPayResultController alloc] initWithResposeObj:response];
                [_nav pushViewController:resultController animated:YES];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
        } fail:^(NSString *failMsg) {
            [hub hide:YES afterDelay:1.0f];
            if([failMsg isEqualToString:@"对不起，提现密码不正确!"]){
                  UIAlertView  * alertView = [[UIAlertView alloc] initWithTitle:@"支付密码输入有误" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"忘记密码", nil];
                     [alertView show];
            }else{
                [UIAlertView xf_showWithTitle:failMsg message:nil onDismiss:^{
                    
                }];
            }
            
 
        } error:^(NSError *error) {
            [hub hide:YES afterDelay:1.0f];
            [UIAlertView xf_showWithTitle:@"网络错误,请重新再试!" message:nil onDismiss:^{
                
            }];
        }];
    }else if ([_takeWayTapy isEqualToString:@"网银支付"]){
        
        [JGCloudAndValueManager callCashWithCashPayment:CashPayBankType cashAmount:[_menoy floatValue] cashUserName:_Name cashBank:_bank cashAccount:_bankAccton cashPassword:_PassWordTextField.text cashInfo:_beizhu cashSubbranch:_Zbankname needCashId:nil cashId:cashUserId cashType:@"user_app" accountType:@"personalAccounts" idCard:_idCard
            success:^(CloudBuyerCashSaveResponse *response) {
            
            [hub hide:YES afterDelay:1.0f];
            if([response.subMsg isEqualToString: @"提现申请成功!"]){
                NSLog(@"self.navigationController.viewControllers:%@",self.navigationController.viewControllers);
                JGPayResultController *resultController = [[JGPayResultController alloc] initWithResposeObj:response];
                [_nav pushViewController:resultController animated:YES];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
        } fail:^(NSString *failMsg) {
            [hub hide:YES afterDelay:1.0f];
            [UIAlertView xf_showWithTitle:failMsg message:nil onDismiss:^{
                
            }];
        } error:^(NSError *error) {
            [hub hide:YES afterDelay:1.0f];
            [UIAlertView xf_showWithTitle:@"网络错误,请重新再试!" message:nil onDismiss:^{
                
            }];
        }];
    }
    

    
    
    
    
    
    
    
    
}




#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        JGLog(@"0");
        // 取消
    }else {
        JGLog(@"1");
        // 忘记密码
        JGSettingPayPasswordController *settingPasswordController = [[JGSettingPayPasswordController alloc] initWithTitile:@"重新设置密码"];
        [self.navigationController pushViewController:settingPasswordController animated:YES];
    }
}






 - (void)didReceiveMemoryWarning {
      [super didReceiveMemoryWarning];
 }










/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
