//
//  NewTakeMoneyViewController.m
//  Operator_JingGang
//
//  Created by whlx on 2019/4/11.
//  Copyright © 2019年 Dengxf. All rights reserved.
//

#import "NewTakeMoneyViewController.h"

#import "BankTableViewCell.h"
#import "ZFPasswordViewController.h"
#import "VApiManager.h"
#import "GlobeObject.h"
#import "PoundageAndTaxRequest.h"
#import "ImageViewController.h"
#import "IQKeyboardManager.h"
#import "AboutYunEs.h"
#import "YSGestureNavigationController.h"
#define TNSString(obj)  [NSString stringWithFormat:@"%@",obj]
@interface NewTakeMoneyViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *txZhifubao;
@property (weak, nonatomic) IBOutlet UIButton *txWangyin;
@property (weak, nonatomic) IBOutlet UITextField *meonyTextFied;
@property (weak, nonatomic) IBOutlet UITextField *nameTestField;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UIButton *XuanZeButton;
@property (weak, nonatomic) IBOutlet UITableView *MyTabView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myTabViewHight;
@property (weak, nonatomic) IBOutlet UITextField *BankAccount;//收款账号
@property (weak, nonatomic) IBOutlet UITextField *bankZhihang;
@property (weak, nonatomic) IBOutlet UITextField *idAcction;//身份账号
@property (weak, nonatomic) IBOutlet UITextField *beizhuTextfield;
@property (weak, nonatomic) IBOutlet UILabel *txMeony;
@property (weak, nonatomic) IBOutlet UILabel *geshuiMeony;
@property (weak, nonatomic) IBOutlet UILabel *yujiMeony;
@property (weak, nonatomic) IBOutlet UIButton *NextButto;
@property (weak, nonatomic) IBOutlet UIView *lineVIew;
@property (weak, nonatomic) IBOutlet UIView *line2View;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (strong,nonatomic) NSArray *imgArray;
@property (strong,nonatomic) NSDictionary *bankInfoDictionary;
@property (strong,nonatomic) NSString *takeWay;

@property (weak, nonatomic) IBOutlet UILabel *shoukuan;
@property (weak, nonatomic) IBOutlet UILabel *SFZlabel;

@property (weak, nonatomic) IBOutlet UIView *bankView;

@property (weak, nonatomic) IBOutlet UIView *zBankVIew;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bankVIewHig;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zhangBankHig;


@property (weak, nonatomic) IBOutlet UIImageView *JImageVIew;



@end

@implementation NewTakeMoneyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }  

    // 添加返回键
    [self setupNavBarPopButton];
    
    [YSThemeManager setNavigationTitle:@"健康豆提现" andViewController:self];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提现规则" style:UIBarButtonItemStylePlain target:self action:@selector(cashComplainAction)];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    NSLog(@"_qMeony%@",_qMeony);
    _MyTabView.delegate = self;
    _MyTabView.dataSource =self;
    
    self.BankAccount.delegate = self;
    
    self.myTabViewHight.constant = 0 ;
    self.bankVIewHig.constant = 0;
    self.zhangBankHig.constant = 0;
    
    self.bankView.hidden = YES;
    self.zBankVIew.hidden = YES;
    _MyTabView.separatorStyle = UITableViewCellSelectionStyleNone;
      self.BankAccount.keyboardType  = UIKeyboardTypeDefault;
    self.meonyTextFied.keyboardType  = UIKeyboardTypeNumberPad;
    self.meonyTextFied.placeholder = [NSString stringWithFormat: @"可提现%@元",_qMeony];
    self.idAcction.keyboardType  = UIKeyboardTypeASCIICapable;
    self.txZhifubao.tag = 100;
    self.txWangyin.tag = 101;
   // self.txZhifubao.selected = YES;
    self.takeWay = @"支付宝";
    self.line2View.hidden = YES;
   // _myScrollView.hidden = YES;
    _BankAccount.placeholder= @"请输入您的身份证号";
    _nameTestField.placeholder= @"请输入您的支付宝账号姓名";
    _shoukuan.text = @"身份账号";
    _SFZlabel.text = @"收款账号";
     _idAcction.placeholder = @"请输入您的支付宝账号";
    [_meonyTextFied addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    
    [_idAcction addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    
    _meonyTextFied.delegate = self;
    _idAcction.delegate = self;
}
-(void)cashComplainAction{
    AboutYunEs *about = [[AboutYunEs alloc]initWithType:YSHtmlControllerWithCashRule];
    [self.navigationController pushViewController:about animated:YES];
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}
//事实监控textField值
-(void)changedTextField:(UITextField *)textField
{
    if(textField == _meonyTextFied){
        if (([self.meonyTextFied.text integerValue]) > [self.qMeony integerValue]) {
            [UIAlertView xf_showWithTitle:@"输入金额已超出可提现余额" message:nil delay:1.2 onDismiss:^{
                
            }];
            return;
           
        }
    }

}


-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(textField == _meonyTextFied){
       if ([self.meonyTextFied.text intValue]>=100&&[self.meonyTextFied.text intValue]%100 == 0){
           _txMeony.text = [NSString stringWithFormat:@"%.f元", [textField.text floatValue]];

           [self requstdata:_meonyTextFied.text];
        }
   }
//
    if (textField == _idAcction){
       if(_idAcction.text.length != 0){
          
             [_NextButto setBackgroundImage:[UIImage imageNamed:@"BJ_One"] forState:UIControlStateNormal];
           [_NextButto setTitle:@"下一步" forState:UIControlStateNormal];
       }else{
           [_NextButto setBackgroundImage:[UIImage imageNamed:@"huisexia"] forState:UIControlStateNormal];
           // [_NextButto setBackgroundColor:rgb(101, 187, 177, 1)];
       }
   }
    return YES;
}




- (IBAction)pushShuoming:(id)sender {
    
    ImageViewController * image = [[ImageViewController alloc] init];
    [self.navigationController pushViewController:image animated:YES];
    
}

-(void)requstdata:(NSString *)string{
    
    
    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    VApiManager *manager = [[VApiManager alloc] init];
    PoundageAndTaxRequest *request = [[PoundageAndTaxRequest alloc]init:GetToken];

    request.cashAmount = string;
    @weakify(self);

    
    [manager PoundageAndTax:request success:^(AFHTTPRequestOperation *operation, PoundageAndTaxResponse *response) {
        @strongify(self);
        
        NSLog(@"response.taxAmount%@",response.taxAmount);
        
        _geshuiMeony.text = [NSString stringWithFormat:@"-%.2f元",[response.taxAmount floatValue]];
        
        float  taxAmout = [response.taxAmount floatValue];
        float  money = [string floatValue];
        float  newMoney = money - taxAmout - [response.poundage floatValue];
        
        _yujiMeony.text = [NSString stringWithFormat:@"%.2f元",newMoney];
        
        [hub hide:YES afterDelay:1.0f];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    

}

- (IBAction)quanbu:(id)sender {
    
    int meony = [_qMeony intValue];
    NSString *  moeny1 = [NSString stringWithFormat:@"%d", meony/100];
    
    NSLog(@"moeny1%@",moeny1);
  //  NSString * str = ;
    
    self.meonyTextFied.text = [NSString stringWithFormat:@"%d.00",[moeny1 intValue]*100];
    
    [UIAlertView xf_showWithTitle:@"已为您做取整百处理" message:nil delay:1.2 onDismiss:^{
        
    }];
    [self textFieldShouldEndEditing:_meonyTextFied];
}




- (void)viewWillAppear:(BOOL)animated{
    
    
    [super viewWillAppear:YES];
    
     [self.navigationController setNavigationBarHidden:NO animated:YES];
 
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
    
    self.imgArray = [self plistArray];
    if (self.imgArray.count) {
        self.bankInfoDictionary = [self.imgArray firstObject];
    }
}
- (NSArray *)imgArray {
    if (!_imgArray) {
        _imgArray = [[NSArray alloc] init];
    }
    return _imgArray;
}

- (NSArray *)plistArray {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"bankinfo" ofType:@"plist"];
    NSArray *data = [[NSArray alloc] initWithContentsOfFile:plistPath];
    return data;
}
- (IBAction)yemianqiehuan:(UIButton *)sender {
    
    _meonyTextFied.text = nil;
    _nameTestField.text= nil;
    
    // NSLog(@"%@",xVC.Name);
    
    _BankAccount.text= nil;
    _bankZhihang.text= nil;
    _idAcction.text= nil;
    _beizhuTextfield.text= nil;
    
    _txMeony.text = @"0.00";
  _geshuiMeony.text = @"0.00";
  _yujiMeony.text = @"0.00";
    if (sender.tag == 101) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"为了保证及时到账,请优先选择四大行提现:\n中国银行,工商银行,建设银行,农业银行!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        
        [alertView show];
       // self.txWangyin.selected = YES;
        self.lineVIew.hidden = YES;
         self.line2View.hidden = NO;
        self.bankVIewHig.constant = 50;
        self.zhangBankHig.constant = 50;
        self.bankView.hidden = NO;
        self.zBankVIew.hidden = NO;
        _bankName.text= @"请选择收款银行";
        _BankAccount.placeholder= @"请输入您的银行卡号";
          _nameTestField.placeholder= @"请输入持卡人本人姓名";
         _idAcction.placeholder = @"请输入您的身份证账号";
        _shoukuan.text = @"收款账号";
        _SFZlabel.text = @"身份证号";
        self.BankAccount.keyboardType  = UIKeyboardTypeNumberPad;
        [_txWangyin setTitleColor:kGetColor(101, 187, 177)  forState:UIControlStateNormal];
        [_txZhifubao setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
         self.takeWay = @"网银支付";
        
    }else{
        
        [_txWangyin setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
        [_txZhifubao setTitleColor:kGetColor(101, 187, 177)  forState:UIControlStateNormal];
        self.bankVIewHig.constant = 0;
        self.zhangBankHig.constant = 0;
          self.myTabViewHight.constant = 0 ;
        self.lineVIew.hidden = NO;
        self.line2View.hidden = YES;
        self.bankView.hidden = YES;
        self.zBankVIew.hidden = YES;
        self.BankAccount.keyboardType  = UIKeyboardTypeASCIICapable;
        _bankName.text= nil;
        _BankAccount.placeholder= @"请输入您的身份证号";
        _nameTestField.placeholder= @"请输入您的支付宝账号姓名";
        _shoukuan.text = @"身份账号";
        _SFZlabel.text = @"收款账号";
        _idAcction.placeholder = @"请输入您的支付宝账号";
        self.takeWay = @"支付宝";
    }

}

- (IBAction)xinshiyinghang:(id)sender {
    
    if(self.myTabViewHight.constant == 200){
        self.myTabViewHight.constant = 0;
        _myScrollView.scrollEnabled = YES;
        _JImageVIew.image =[UIImage imageNamed:@"xiangqian"];
    }else if (self.myTabViewHight.constant == 0){
        _myScrollView.scrollEnabled = NO;
        _JImageVIew.image =[UIImage imageNamed:@"xiangxia"];
        self.myTabViewHight.constant = 200 ;
    }
    
}


- (IBAction)next:(UIButton *)sender {
    
    if (_idAcction.text.length == 0){
        return;
    }
    
    if (([self.meonyTextFied.text integerValue]) > [self.qMeony integerValue]) {
        [UIAlertView xf_showWithTitle:@"输入金额已超出可提现余额" message:nil delay:1.2 onDismiss:^{
            
        }];
        return;
        
    }
    
    if ([self.meonyTextFied.text intValue]>=100&&[self.meonyTextFied.text intValue]%100 == 0){
        
    }else{
        [UIAlertView xf_showWithTitle:@"请输入100的整数倍提现" message:nil delay:1.2 onDismiss:^{
            
        }];
        return;
    }
    
    if([self.takeWay isEqualToString:@"支付宝"]){
        if (![self validateIdNumberLength:_BankAccount.text]) {
            [UIAlertView xf_showWithTitle:@"您输入的身份证号码有误!" message:nil delay:1.2 onDismiss:^{
                
            }];
            return;
        }
    }else if([self.takeWay isEqualToString:@"网银支付"]){
        if (![self validateIdNumberLength:_idAcction.text]) {
            [UIAlertView xf_showWithTitle:@"您输入的身份证号码有误!" message:nil delay:1.2 onDismiss:^{
                
            }];
            return;
        }
    }
    
  
    
    if( [self.takeWay isEqualToString:@"支付宝"]){
         if ([Util isValidateMobile:self.idAcction.text] || [Util isValidateEmail:self.idAcction.text]) {
   
         }else {
             [UIAlertView xf_showWithTitle:@"输入正确的支付宝账号" message:nil delay:1.2 onDismiss:^{
                 
             }];
             return;
         }
    }
        
    if ([self.takeWay isEqualToString:@"网银支付"]){
        if (self.BankAccount.text.length <16||self.BankAccount.text.length >20) {
            [UIAlertView xf_showWithTitle:@"您输入的银行卡号有误!" message:nil delay:1.2 onDismiss:^{
                
            }];
            return;
        }
       
    }

    
     
    ZFPasswordViewController *xVC = [[ZFPasswordViewController alloc] init];
    
    xVC.menoy = _meonyTextFied.text;
    xVC.Name= _nameTestField.text;
    xVC.bank =  _bankName.text;
   // NSLog(@"%@",xVC.Name);
    
    xVC.bankAccton = _BankAccount.text;
    xVC.Zbankname =  _bankZhihang.text;
    xVC.idCard =  _idAcction.text;
    xVC.beizhu =  _beizhuTextfield.text;
    xVC.takeWayTapy = _takeWay;
    
    
    xVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    //设置NavigationController根视图
    
    UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:xVC];
    //设置NavigationController的模态模式，即NavigationController的显示方式
    
    navigation.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    //加载模态视图
    [self presentViewController:navigation animated:YES completion:^{
        
        xVC.nav = self.navigationController;
        
    }];
 
}


#pragma mark  --- TableViewDelegate --
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 17;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BankTableViewCell *cell   = [tableView dequeueReusableCellWithIdentifier: @"BankTableViewCell"];
    if (!cell) {
        cell = [[BankTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"BankTableViewCell"];
    }


    NSDictionary *imgDic = self.imgArray[indexPath.row];
    NSArray *array = [imgDic allKeys];
        if (array.count > 0) {
            NSString *img = [array lastObject];
            NSString *imgName = TNSString(imgDic[img]);
            cell.bankImage.image = [UIImage imageNamed:img];
            cell.bankName.text = imgName;
        }
    return cell;


}
    
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //设置 取消点击后选中cell
    self.myTabViewHight.constant = 0;
      _myScrollView.scrollEnabled = YES;
    _JImageVIew.image =[UIImage imageNamed:@"xiangqian"];
    NSDictionary *imgDic = self.imgArray[indexPath.row];
    NSArray *array = [imgDic allKeys];
    NSString *img = [array lastObject];
    NSString *imgName = TNSString(imgDic[img]);
    NSLog(@"imgName%@",imgName);
    _bankName.text =imgName;
    NSLog(@"点击了吗?");
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (BOOL)validateIdNumberLength:(NSString *)idNumber {//idNumber为传入的身份证号
    NSString *idNumberRegex = @"^(\\d{17})(\\d|[xX])$";//正则判断idNumber是17位数字加1位数字校验码或大小写xX
    NSPredicate *idNumberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",idNumberRegex];
    
    return [idNumberPredicate evaluateWithObject:idNumber];
    
    
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
    
