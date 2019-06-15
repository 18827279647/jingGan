//
//  YSLoginFirstUpdateUserInfoController.m
//  jingGang
//
//  Created by HanZhongchou on 16/8/23.
//  Copyright © 2016年 dengxf_dev. All rights reserved.
//

#import "YSLoginFirstUpdateUserInfoController.h"
#import "TakePhotoUpdateImg.h"
#import "GlobeObject.h"
#import "YSHealthyManageWebController.h"
#import "AppDelegate.h"
#import "JGActivityHelper.h"
#import "AppDelegate+JGActivity.h"

@interface YSLoginFirstUpdateUserInfoController ()<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
/**
 *  头像按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonHeaderIcon;
/**
 *  男性选择按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonSexMan;
/**
 *  女性选择按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonSexWomen;
/**
 *  昵称输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *textFieldNickName;
/**
 *  生日输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *textFieldBirthday;
/**
 *  地区输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *textFieldArea;
/**
 *  身高输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *textFieldHeight;
/**
 *  体重输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *textFiledWeight;
/**
 *  图片上传
 */
@property (nonatomic,strong) TakePhotoUpdateImg *takePhotoUpdateImg;
/**
 *  临时存储上传头像图片
 */
@property (nonatomic,strong) UIImage *imageHeaderTemp;
/**
 *  性别   1、男  2、女
 */
@property (nonatomic,strong)   NSNumber *numSex;
/**
 *  省份
 */
@property (nonatomic,copy) NSString *strProvinceName;
/**
 *  城市名
 */
@property (nonatomic,copy) NSString *strCityName;


@property (strong, nonatomic)  UIPickerView *pickView;
//区域 数组
@property (strong, nonatomic) NSArray *regionArr;
//省 数组
@property (strong, nonatomic) NSMutableArray *provinceArr;
//城市 数组
@property (strong, nonatomic) NSMutableArray *cityArr;
//区县 数组
@property (strong, nonatomic) NSMutableArray *areaArr;
//picker字典
@property (strong, nonatomic)NSDictionary *pickerDic;
//picker数组
@property (strong, nonatomic)NSArray *pickerArr;
//保存选中省
@property (assign,nonatomic)NSInteger tagF;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *buttonSave;

@end

@implementation YSLoginFirstUpdateUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark --- Action
/**
 *  上传头像
 */
- (IBAction)uploadHeaderIcon:(id)sender {
    //访问摄像头，添加照片
    @weakify(self);
    [self.takePhotoUpdateImg showInVC:self getPhoto:^(UIImagePickerController *picker, UIImage *image, NSDictionary *editingDic) {
        @strongify(self);
        self.imageHeaderTemp = image;
        
        
    } upDateImg:^(NSString *updateImgUrl, NSError *updateImgError) {
        @strongify(self);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserHeadImgChangedNotification" object:updateImgUrl];
        [self uploadUserHeaderImgUrl:updateImgUrl];
    }];
}
/**
 *  选择男性
 */
- (IBAction)sexManSelectButtonClick:(id)sender {
    [self.buttonSexMan setBackgroundImage:[UIImage imageNamed:@"Consummate_Man_Select"] forState:UIControlStateNormal];
    [self.buttonSexWomen setBackgroundImage:[UIImage imageNamed:@"Consummate_Women_Normal"] forState:UIControlStateNormal];
    self.numSex = @1;
}
/**
 *   选择女性
 */
- (IBAction)sexWomenSelectButtonClick:(id)sender {
    [self.buttonSexWomen setBackgroundImage:[UIImage imageNamed:@"Consummate_Women_Select"] forState:UIControlStateNormal];
    [self.buttonSexMan setBackgroundImage:[UIImage imageNamed:@"Consummate_Man_Normal"] forState:UIControlStateNormal];
    self.numSex = @2;
}


- (IBAction)save:(id)sender {
    //判断是否全都填写了，不然提交提交失败
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textfield = (UITextField *)view;
            if (([textfield.text isEqualToString:@""])) {
                [MBProgressHUD showSuccess:@"还没填完呢~~" toView:self.view delay:1];
                return;
            }
        }
    }
    
    if ([self.textFieldHeight.text integerValue] <= 120|| [self.textFieldHeight.text integerValue] >= 229) {
        [MBProgressHUD showSuccess:@"身高数据不在合理范围，少侠请重新来过" toView:self.view delay:1];
        return;
    }
    if ([self.textFiledWeight.text integerValue] <= 30|| [self.textFiledWeight.text integerValue] >= 120) {
        [MBProgressHUD showSuccess:@"体重数据不在合理范围，少侠请重新来过" toView:self.view delay:1];
        return;
    }
    
    //上述条件都符合了就开始上传服务器
    [self updateUserInfo];
}


- (void)rightButtonClick
{
    if ([YSLaunchManager isFirstLauchMode]) {
        [YSLaunchManager setFirstLaunchMode:NO];
    }else {

    }
    // postNotificationName:@"kUserThirdLoginSuccessNotiKey
    switch (self.comeFromContrllerType) {
        case YSUpdatePersonalInfoComeFromTelphoneRegister:
        {
            // 手机注册过来，需要dismiss
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserThirdLoginSuccessNotiKey" object:nil];
            [self dismissViewControllerAnimated:YES completion:^{
                AppDelegate *appdelegate = kAppDelegate;
                [appdelegate queryUserDidCheckWithState:NULL];
            }];
        }
            break;
        case YSUpdatePersonalInfoComeFromThirdLoginRegiter:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserThirdLoginSuccessNotiKey" object:nil];
            [self dismissViewControllerAnimated:YES completion:^{
                AppDelegate *appdelegate = kAppDelegate;
                [appdelegate queryUserDidCheckWithState:NULL];
            }];
        }
            break;
        default:
            break;
    }
}

- (void)updateUserInfo
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UserCustomerSavefirstRequest *request = [[UserCustomerSavefirstRequest alloc] init:GetToken];
    request.api_height = [NSNumber numberWithInteger:[self.textFieldHeight.text integerValue]];
    request.api_weight = [NSNumber numberWithInteger:[self.textFiledWeight.text integerValue]];
    request.api_birthDate = self.textFieldBirthday.text;
    request.api_sex = self.numSex;
    request.api_nickname = self.textFieldNickName.text;
    if (!self.strCityName) {
       self.strCityName = @"北京市";
    }
    request.api_paddress = self.strCityName;
    @weakify(self);
    // 调用个人信息完善接口
    [self.vapiManager userCustomerSavefirst:request success:^(AFHTTPRequestOperation *operation, UserCustomerSavefirstResponse *response) {
        // 保存个人信息完成
        @strongify(self);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showSuccess:@"保存成功" toView:self.view delay:1];
        //延迟执行
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //延迟执行函数
            //保存成功后跳转健康测试
            if ([YSLaunchManager isFirstLauchMode]) {
                [YSLaunchManager setFirstLaunchMode:NO];
            }else {
            }
            switch (self.comeFromContrllerType) {
                case YSUpdatePersonalInfoComeFromTelphoneRegister:
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserThirdLoginSuccessNotiKey" object:nil];
                    [self dismissViewControllerAnimated:YES completion:^{
                        AppDelegate *appdelegate = kAppDelegate;
                        [appdelegate queryUserDidCheckWithState:NULL];
                    }];
                }
                    break;
                case YSUpdatePersonalInfoComeFromThirdLoginRegiter:
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserThirdLoginSuccessNotiKey" object:nil];
                    [self dismissViewControllerAnimated:YES completion:^{
                        AppDelegate *appdelegate = kAppDelegate;
                        [appdelegate queryUserDidCheckWithState:NULL];
                    }];
                }
                default:
                    break;
            }
            
            //延迟2秒执行，如果出现版本更新就在这边调用自动签到系统
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                AppDelegate *appdelegate = kAppDelegate;
                [appdelegate queryUserDidCheckWithState:NULL];
            });
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // 保存个人信息失败
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showSuccess:@"网络错误，请检查网络" toView:self.view delay:1];
    }];

}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark --- private
- (void)setupUI
{
    [YSThemeManager setNavigationTitle:@"完善个人资料" andViewController:self];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.buttonSave.backgroundColor = [YSThemeManager buttonBgColor];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
    self.buttonHeaderIcon.layer.cornerRadius = self.buttonHeaderIcon.height/ 2.0;
    self.buttonHeaderIcon.clipsToBounds = YES;
    [self initRightButton];
    
    [self.textFieldNickName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    //设置textField代理
    for (UIView *view in self.bgView.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            textField.delegate = self;
            textField.layer.borderColor = [YSThemeManager buttonBgColor].CGColor;
            textField.layer.borderWidth = 0.5;
            textField.layer.cornerRadius = 6.0;
        }
    }
    

    //默认一进来是选择男性
    self.numSex = @1;
    
    [self loadJSONWithArea];
    [self setInputViewToTextFieldBirthday];

}

//加载JSON数据里的地址数据
- (void)loadJSONWithArea
{
    self.provinceArr = [NSMutableArray array];
    self.cityArr = [NSMutableArray array];
    self.areaArr = [NSMutableArray array];
    
    //        [self.pickView selectedRowInComponent:2];
    //        NSString *path = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"city2" ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:path];
    NSError *error ;
    self.pickerArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if(error||!self.pickerArr){
        NSLog(@"json解析失败");
    }
    for(int i=0;i<self.pickerArr.count;i++){
        NSDictionary *dic = [self.pickerArr objectAtIndex:i];
        NSString *str = [dic objectForKey:@"areaName"];
        [self.provinceArr addObject:str];
        
    }
    NSArray *cityArray = [[self.pickerArr objectAtIndex:0] objectForKey:@"cities"];
    for(int j=0;j<cityArray.count;j++){
        NSString *str = cityArray[j][@"areaName"];
        [self.cityArr addObject:str];
    }
    //城市区域数据
//    NSArray *areaArray = cityArray[0][@"counties"];
//    for(int flag=0;flag<areaArray.count;flag++){
//        NSString *str = areaArray[flag][@"areaName"];
//        [self.areaArr addObject:str];
//    }
    self.tagF = 0;
    
    
    self.textFieldArea.inputView = self.pickView;
}


#pragma mark - 上传头像给服务器
-(void)uploadUserHeaderImgUrl:(NSString *)userHeaderUrl {
    
    UsersCustomerUpdateImgRequest *request = [[UsersCustomerUpdateImgRequest alloc] init:GetToken];
    request.api_headImgPath = userHeaderUrl;
    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hub.labelText = @"正在上传用户头像....";
    WEAK_SELF
    [self.vapiManager usersCustomerUpdateImg:request success:^(AFHTTPRequestOperation *operation, UsersCustomerUpdateImgResponse *response) {
        
        hub.labelText = @"上传头像成功";
        [hub hide:YES afterDelay:1.0f];
        
        [weak_self.buttonHeaderIcon setBackgroundImage:weak_self.imageHeaderTemp forState:UIControlStateNormal];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hub.labelText = @"上传头像失败";
        [hub hide:YES afterDelay:1.0f];
        
    }];
}

/**
 *  设置生日的inputView
 */
- (void)setInputViewToTextFieldBirthday
{
    UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 216)];
    datePicker.date = [NSDate date];
    datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GTM+8"]; // 设置时区，中国在东八区
    datePicker.maximumDate = [NSDate date]; // 设置最大时间
    datePicker.backgroundColor = [UIColor whiteColor];
//    datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:24 * 60 * 60 * 365 * 100 * -1]; // 设置最小时间
    datePicker.datePickerMode = UIDatePickerModeDate;
//    datePicker.minimumDate= [NSDate dateWithTimeInterval:-6*24*60*60 sinceDate:[NSDate date]];//七天前的那天
//    
//    datePicker.maximumDate= [NSDate date];//今天
    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.textFieldBirthday.inputView = datePicker;
}

/**
 *  日期选择器滚动监听
 */
- (void)datePickerValueChanged:(UIDatePicker *)datePicke
{
    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
    selectDateFormatter.dateFormat = @"yyyy-MM-dd"; // 设置时间和日期的格式
    NSString *dateAndTime = [selectDateFormatter stringFromDate:datePicke.date]; // 把date类型转为设置好格式的string类型
    self.textFieldBirthday.text = dateAndTime;
}


#pragma  mark ---UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //开始编辑的时候如果输入框是空的默认输入当前日期
    if (textField == self.textFieldBirthday && [textField.text isEqualToString:@""]) {
        NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
        selectDateFormatter.dateFormat = @"yyyy-MM-dd"; // 设置时间和日期的格式
        NSString *dateAndTime = [selectDateFormatter stringFromDate:[NSDate date]]; // 把date类型转为设置好格式的string类型
        self.textFieldBirthday.text = dateAndTime;
    }else if (textField == self.textFieldArea && [textField.text isEqualToString:@""]){
        //选择地址开始编辑的时候如果输入框是空的默认输入选择器第一个城市地区
        NSString *strProvince = [self.provinceArr objectAtIndex:[self.pickView selectedRowInComponent:0]];
        NSString *strCity = [self.cityArr objectAtIndex:[self.pickView selectedRowInComponent:1]];
        self.textFieldArea.text = [NSString stringWithFormat:@"%@-%@",strProvince,strCity];
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //身高体重不让输入超过三位数
    if(textField == self.textFieldHeight && range.location >= 3){
        return NO;
    }else if (textField == self.textFiledWeight && range.location >=3){
        return NO;
    }else if(textField == self.textFieldNickName){
    
        if (textField == self.textFieldNickName) {
            if (range.location >= TextFieldNickNameStringLength) {
                return NO;
            }else{
                return YES;
            }
        }
    }
    
    return YES;
}


#pragma mark - UIPickerViewDataSource
//需要城市地区的话把下面的pickerView代理方法和数据源方法注释打开即可
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return self.provinceArr.count;
            break;
        case 1:
            return self.cityArr.count;
            break;
//        case 2:
//            if (self.areaArr.count) {
//                return self.areaArr.count;
//                break;
//            }
        default:
            return 0;
            break;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {
        case 0:
            
            
            return [self.provinceArr objectAtIndex:row];
            break;
        case 1:
            
            return [self.cityArr objectAtIndex:row];
            break;
//        case 2:
//            if (self.areaArr.count) {
//                return [self.areaArr objectAtIndex:row];
//                break;
//            }
        default:
            return  @"";
            break;
    }
}
#pragma mark - UIPickerViewDelegate

//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
//    UILabel* pickerLabel = (UILabel*)view;
//    if (!pickerLabel){
//        pickerLabel = [[UILabel alloc] init];
//        pickerLabel.minimumScaleFactor = 8.0;
//        pickerLabel.adjustsFontSizeToFitWidth = YES;
//        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
//        [pickerLabel setBackgroundColor:[UIColor clearColor]];
//        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
//    }
//    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
//    
//    return pickerLabel;
//}

//
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(component == 0){
        [self.cityArr removeAllObjects];
        [self.areaArr removeAllObjects];
        for(int f = 0;f<self.provinceArr.count;f++){
            if([self.provinceArr[f] isEqualToString:self.provinceArr[row]]){
                self.tagF = row;
                break;
            }
        }
        NSArray *cityArray = self.pickerArr[row][@"cities"];
        for(int i=0;i<cityArray.count;i++){
            NSString *str = cityArray[i][@"areaName"];
            [self.cityArr addObject:str];
        }
        NSArray *areaArray  = cityArray[0][@"counties"];
        for(int j=0;j<areaArray.count;j++){
            NSString *str = areaArray[j][@"areaName"];
            [self.areaArr addObject:str];
        }
        
    }
    [pickerView selectedRowInComponent:1];
    [pickerView reloadComponent:1];
//    [pickerView selectedRowInComponent:2];
    
    if(component == 1) {
        [self.areaArr removeAllObjects];
        NSInteger tagA = 0;
        NSArray *arr = self.pickerArr[self.tagF][@"cities"];
        for(int i=0;i<arr.count;i++){
            if([arr[i][@"areaName"]isEqualToString:self.cityArr[row]]){
                tagA = row;
                break;
            }
        }
        NSArray *arrayArea = arr[tagA][@"counties"];
        for(int flag=0;flag<arrayArea.count;flag++){
            NSString *str = arrayArea[flag][@"areaName"];
            
            [self.areaArr addObject:str];
        }
//        [pickerView selectRow:1 inComponent:2 animated:YES];
        
    }
//    [pickerView reloadComponent:2];
    
    
    self.strProvinceName = [self.provinceArr objectAtIndex:[pickerView selectedRowInComponent:0]];
    self.strCityName = [self.cityArr objectAtIndex:[pickerView selectedRowInComponent:1]];
    
    self.textFieldArea.text = [NSString stringWithFormat:@"%@-%@",self.strProvinceName,self.strCityName];
//    self.locate.area = [self.areaArr objectAtIndex:[self.pickView selectedRowInComponent:2]];
}

#pragma  mark - ---UITextFieldDelegate

- (void) textFieldDidChange:(id) sender {
    UITextField *_field = (UITextField *)sender;
    NSString *toBeString = _field.text;
    
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [_field markedTextRange];
        //获取高亮部分
        UITextPosition *position = [_field positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > TextFieldNickNameStringLength) {
                _field.text = [toBeString substringToIndex:TextFieldNickNameStringLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > TextFieldNickNameStringLength) {
            _field.text = [toBeString substringToIndex:TextFieldNickNameStringLength];
        }
    }
}
#pragma mark --- getter
- (TakePhotoUpdateImg *)takePhotoUpdateImg {
    if (_takePhotoUpdateImg == nil) {
        _takePhotoUpdateImg = [[TakePhotoUpdateImg alloc] init];
    }
    return _takePhotoUpdateImg;
}

- (UIPickerView *)pickView
{
    if (!_pickView) {
        _pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth, 216)];
        _pickView.delegate = self;
        _pickView.dataSource = self;
        _pickView.backgroundColor = [UIColor whiteColor];
    }
    return _pickView;
}

//右侧按钮
- (void)initRightButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame= CGRectMake(0, 0, 40, 30);
    [button addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"跳过" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
}


@end
