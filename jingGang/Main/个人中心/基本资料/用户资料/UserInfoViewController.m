//
//  UserInfoViewController.m
//  jingGang
//
//  Created by ray on 15/11/24.
//  Copyright © 2015年 yi jiehuang. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoViewModel.h"
#import "UIImage+SizeAndTintColor.h"
#import "CalenderView.h"
#import "YSBindIdentityCardController.h"
#import "YSLoginManager.h"
#import "YSAchiveAIOInfoDataManager.h"
#import "YSUserAIOInfoItem.h"
#import "YSImageConfig.h"
#import "TakePhotoUpdateImg.h"

@interface UserInfoViewController () <UIActionSheetDelegate,UITextViewDelegate,UITextFieldDelegate,YSAPICallbackProtocol,YSAPIManagerParamSource>
@property (nonatomic,strong) TakePhotoUpdateImg *takePhotoUpdateImg;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) UserInfoViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UITextField *invitCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *mobilTF;
@property (weak, nonatomic) IBOutlet UITextField *mailTF;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTF;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *sexTF;
@property (weak, nonatomic) IBOutlet UITextField *heightTF;
@property (weak, nonatomic) IBOutlet UITextField *weightTF;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTF;
@property (weak, nonatomic) IBOutlet UITextField *xuexinTF;
@property (weak, nonatomic) IBOutlet UITextField *invitPerson;
@property (weak, nonatomic) IBOutlet UITextField *belongMerchantTF;
@property (weak, nonatomic) IBOutlet UITextField *transHistoryTF;
@property (weak, nonatomic) IBOutlet UITextField *transGeneticTF;
@property (weak, nonatomic) IBOutlet UITextField *allergicHistoryTF;
@property (weak, nonatomic) IBOutlet UIImageView *markImage;
@property (nonatomic) CalenderView *calenderView;
@property (nonatomic) UIView *dateBackView;
@property (weak, nonatomic) IBOutlet UIView *bloodView;
@property (weak, nonatomic) IBOutlet UIView *sexView;
@property (nonatomic) UIButton *confirmButton;
/**
 *  地区textField
 */
@property (weak, nonatomic) IBOutlet UIImageView *touxiangImage;
@property (weak, nonatomic) IBOutlet UITextField *textFieldArea;
/**
 *  个性签名
 */
@property (weak, nonatomic) IBOutlet UITextView *textViewBardianAutograph;
/**
 *  个性签名输入框Placeholder
 */
@property (weak, nonatomic) IBOutlet UILabel *labelBardianAutographPlaceholder;
/**
 *  个性签名背景View的高度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BardianAutographViewHeight;
/**
 *  身份证号码label
 */
@property (weak, nonatomic) IBOutlet UILabel *idCardNumLabel;
/**
 *  身份证号码向右箭头，有身份证号时候要隐藏
 */
@property (weak, nonatomic) IBOutlet UIImageView *idCardRightArrImageView;
/**
 *  身份证号码的点击按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *idCardButton;

@property (strong,nonatomic) YSAchiveAIOInfoDataManager *achiveAIOInfoDataManager;


/*
 过会需要替换的页面
 */

/**
 *  临时存储上传头像图片
 */
@property (nonatomic,strong) UIImage *imageHeaderTemp;




@end

@implementation UserInfoViewController

- (YSAchiveAIOInfoDataManager *)achiveAIOInfoDataManager {
    if (!_achiveAIOInfoDataManager) {
        _achiveAIOInfoDataManager = [[YSAchiveAIOInfoDataManager alloc] init];
        _achiveAIOInfoDataManager.delegate = self;
        _achiveAIOInfoDataManager.paramSource = self;
    }
    return _achiveAIOInfoDataManager;
}

- (NSDictionary *)paramsForApi:(YSAPIBaseManager *)manager {
    if ([manager isKindOfClass:[YSAchiveAIOInfoDataManager class]]) {
        return @{};
    }
    return @{};
}

- (void)managerCallBackDidSuccess:(YSAPIBaseManager *)manager {
    [self hiddenHud];
    YSResponseDataReformer *reformer = [[YSResponseDataReformer alloc] init];
    if ([manager isKindOfClass:[YSAchiveAIOInfoDataManager class]]) {
        YSUserAIOInfoItem *item = [reformer reformDataWithAPIManager:manager];
        if (!item.m_status) {
            if (item.aioBinding.updateNum >= 3) {
                [self showToastIndicatorWithText:@"身份证只能修改三次，您已超过次数！" dismiss:2];
            }else {
                // 用户可修改
                YSBindIdentityCardController *bindController = [[YSBindIdentityCardController alloc] init];
                bindController.sourceType = YSIdentityContollerSourceModifyType;
                bindController.infoItem = item;
                @weakify(self);
                bindController.bindIdentityCardSucceedCallback = ^(YSIdentityControllerSourceType sourceType,NSString *idCard,NSInteger updateNum) {
                    @strongify(self);
                    [self setIdCardInfoWithIdCardNum:idCard];
                };
                [self.navigationController pushViewController:bindController animated:YES];
            }
        }else {
            [UIAlertView xf_showWithTitle:@"提示" message:item.m_errorMsg delay:2.0 onDismiss:NULL];
        }
    }
}
//修改头像
- (IBAction)xiugaitouxiag:(id)sender {
    [self imageAction];
}
//头像点击操作
- (void)imageAction{
    //访问摄像头，添加照片
    @weakify(self);
    [self.takePhotoUpdateImg showInVC:[self getCurrentVC] getPhoto:^(UIImagePickerController *picker, UIImage *image, NSDictionary *editingDic) {
        @strongify(self);
        self.imageHeaderTemp = image;
        [[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO];
        
    } upDateImg:^(NSString *updateImgUrl, NSError *updateImgError) {
        @strongify(self);
        
        
        NSLog(@"updateImgUrl%@",updateImgUrl);
        
         MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
       
        
        if(updateImgUrl.length == 0 || [updateImgUrl isEqualToString:@"null"]){
            hub.labelText = @"上传头像失败";
            [hub hide:YES afterDelay:1.0f];
            return ;
        }else {
            [hub hide:NO afterDelay:0.0f];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserHeadImgChangedNotification" object:updateImgUrl];
            [self _uploadUserHeaderImgUrl:updateImgUrl];
        }
        
      
    }];
}
- (TakePhotoUpdateImg *)takePhotoUpdateImg {
    if (_takePhotoUpdateImg == nil) {
        _takePhotoUpdateImg = [[TakePhotoUpdateImg alloc] init];
    }
    return _takePhotoUpdateImg;
}

-(void)_uploadUserHeaderImgUrl:(NSString *)userHeaderUrl {
    
    UsersCustomerUpdateImgRequest *request = [[UsersCustomerUpdateImgRequest alloc] init:GetToken];
    NSLog(@"request.api_headImgPath:%@",request.api_headImgPath);
    request.api_headImgPath = userHeaderUrl;
    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hub.labelText = @"正在上传用户头像....";
    @weakify(self);
    [self.vapiManager usersCustomerUpdateImg:request success:^(AFHTTPRequestOperation *operation, UsersCustomerUpdateImgResponse *response) {
        @strongify(self);
        //上传头像成功后需要修改本地存储的url
        NSDictionary *dictUserInfo = [kUserDefaults objectForKey:kUserCustomerKey];
        NSMutableDictionary *dictMutableUserInfo = [NSMutableDictionary dictionaryWithDictionary:dictUserInfo];
        [dictMutableUserInfo setValue:userHeaderUrl forKey:@"headImgPath"];
        dictUserInfo = [NSDictionary dictionaryWithDictionary:dictMutableUserInfo];
        [kUserDefaults setObject:dictUserInfo forKey:kUserCustomerKey];
        [kUserDefaults synchronize];
        
            hub.labelText = @"上传头像成功";
            [hub hide:YES afterDelay:1.0f];
             self.touxiangImage.image = self.imageHeaderTemp;


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hub.labelText = @"上传头像失败";
        [hub hide:YES afterDelay:1.0f];
        
    }];
}


- (UIViewController *)getCurrentVC{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

#pragma mark --- 请求报错返回
- (void)managerCallBackDidFailed:(YSAPIBaseManager *)manager {
    [self hiddenHud];
    [UIAlertView xf_showWithTitle:@"提示" message:@"网络错误，重新再试!" delay:2.0 onDismiss:NULL];
}

- (void)bindTeleSucceccAction:(NSNotification *)noti {
    // 绑定手机成功
    YSBindIdentityCardController *bindController = [[YSBindIdentityCardController alloc] init];
    bindController.sourceType = YSIdentityControllerSourceAddType;
    @weakify(self);
    bindController.bindIdentityCardSucceedCallback = ^(YSIdentityControllerSourceType sourceType,NSString *idCard,NSInteger updateNum) {
        @strongify(self);
        [self setIdCardInfoWithIdCardNum:idCard];
    };
    [self.navigationController pushViewController:bindController animated:YES];
}

- (void)bindTeleFailAction:(NSNotification *)noti {
    // 绑定失败 不操作
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getUserInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindTeleSucceccAction:) name:kUserBindTeleSuccessKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindTeleFailAction:) name:kUserBindTeleFailKey object:nil];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.confirmButton];
    [YSThemeManager setNavigationTitle:@"个人信息" andViewController:self];

    self.textViewBardianAutograph.delegate = self;
    self.nickNameTF.delegate  = self;
    [self.nickNameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UITapGestureRecognizer *changeSexTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeSexAction)];
    [self.sexView addGestureRecognizer:changeSexTap];
    
    NSDictionary *dic = [kUserDefaults objectForKey:userInfoKey];

    [YSImageConfig sd_view:self.touxiangImage setimageWithURL:[NSURL URLWithString:dic[@"headImgPath"]] placeholderImage:kDefaultUserIcon];
    
}



-(void)getUserInfo
{
    
    NSString *accessToken = [userDefaultManager GetLocalDataString:@"Token"];
    UsersCustomerSearchRequest * usersCustomerSearchRequest = [[UsersCustomerSearchRequest alloc]init:accessToken];
    
    [self.vapiManager usersCustomerSearch:usersCustomerSearchRequest success:^(AFHTTPRequestOperation *operation, UsersCustomerSearchResponse *response) {
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:nil];
        NSDictionary   *dictUserList = [dict objectForKey:@"customer"];
        
        NSLog(@"2222221232%@",dictUserList[@"headImgPath"]);
        
  
        //
        [YSImageConfig sd_view:self.touxiangImage setimageWithURL:[NSURL URLWithString:dictUserList[@"headImgPath"]] placeholderImage:kDefaultUserIcon];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserHeadImgChangedNotification" object:[dictUserList objectForKey:@"headImgPath"]];
        
        [[NSUserDefaults standardUserDefaults]setObject:dictUserList forKey:kUserCustomerKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showSuccess:@"网络错误，请检查网络" toView:self.view delay:1];
    }
     ];
    
}


- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self)
    [[[self.viewModel.getUserInfoCommand executionSignals] switchToLatest] subscribeNext:^(id x) {
        @strongify(self)
        
        
        __weak MyUserCustomer *userInfo = self.viewModel.userInfo;
        
        NSLog(@"%@",userInfo);
        self.invitCodeTF.text = userInfo.invitationCode;
        self.invitPerson.text = userInfo.referee;
        self.belongMerchantTF.text = userInfo.merchant;
        
        self.mobilTF.text = userInfo.mobile;

        self.mailTF.text = userInfo.email;

        self.nickNameTF.text = userInfo.nickName;

        self.nameTF.text = userInfo.name;

        RAC(self.sexTF, text) = RACObserve(userInfo, sexStr);

        self.heightTF.text = userInfo.heightStr;

        self.weightTF.text = userInfo.weightStr;

        self.textFieldArea.text = userInfo.address;

        RAC(self.birthdayTF, text) = RACObserve(userInfo, birthdate);
        RAC(self.xuexinTF, text) = RACObserve(userInfo, blood);
        self.allergicHistoryTF.text = userInfo.allergicHistory;

        self.transGeneticTF.text = userInfo.transGenetic;

        self.transHistoryTF.text = userInfo.transHistory;
  
        
        self.textViewBardianAutograph.text = userInfo.userSignature;
        [self calculateTextViewHeightWith:self.textViewBardianAutograph.text];
        //设置头像
        //设置身份证信息
        [self setIdCardInfoWithIdCardNum:userInfo.idCard];
    }];
    [[[self.viewModel.updateUserInfoCommand executionSignals] switchToLatest] subscribeNext:^(id x) {
        @strongify(self)
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改信息成功" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }];
    
    
    [self.viewModel.getUserInfoCommand execute:nil];
}

- (void)setIdCardInfoWithIdCardNum:(NSString *)idCardNumString{
    if (idCardNumString.length > 0) {
        //有身份证数据
        self.idCardNumLabel.text = [self dealUserIdCard:idCardNumString];
        self.idCardRightArrImageView.hidden = YES;
    }else{
        //没身份证数据
        self.idCardRightArrImageView.hidden = NO;
    }
}

- (NSString *)dealUserIdCard:(NSString *)idCard {
    if (idCard.length != 18) {
        return idCard;
    }
    NSMutableString *mutableIdCard = [NSMutableString stringWithString:idCard];
    [mutableIdCard replaceCharactersInRange:NSMakeRange(4, 10) withString:@"**********"];
    return [mutableIdCard copy];
}

//身份证号码按钮点击
- (IBAction)idCardButtonClick:(id)sender {
    if (self.idCardNumLabel.text.length) {
        // 修改身份证号码 查询修改次数
        [self showHud];
        [self.achiveAIOInfoDataManager requestData];
    }else {
        // 判断是否绑定过手机
        [self checkUserIsBindTele:^(BOOL result) {
            if (result) {
                // 已经绑定过手机 -- 添加身份证信息
                YSBindIdentityCardController *bindController = [[YSBindIdentityCardController alloc] init];
                bindController.sourceType = YSIdentityControllerSourceAddType;
                @weakify(self);
                bindController.bindIdentityCardSucceedCallback = ^(YSIdentityControllerSourceType sourceType,NSString *idCard,NSInteger updateNum) {
                    @strongify(self);
                    [self setIdCardInfoWithIdCardNum:idCard];
                };
                [self.navigationController pushViewController:bindController animated:YES];
            }else {
                // 未绑定过手机号码 提示用户绑定手机号码
                [UIAlertView xf_shoeWithTitle:nil message:@"为了您的身份信息安全，请先绑定手机号码哦！" buttonsAndOnDismiss:@"取消",@"去绑定",^(UIAlertView *alert,NSUInteger index) {
                    if (index == 0) {
                        // 取消
                    }else {
                        // 检测用户是否绑定过手机号码 没有去绑定手机号码页面
                        [self checkUserIsBindTele:^(BOOL result) {
                            
                        } isRemind:NO];
                    }
                }];

            }
        } isRemind:YES];
    }
}

- (void)checkUserIsBindTele:(bool_block_t)bindResult isRemind:(BOOL)isRemind {
    [YSLoginManager thirdPlatformUserBindingCheckSuccess:^(BOOL isBinding, UIViewController *controller) {
        BLOCK_EXEC(bindResult,isBinding);
    } fail:^{
        [UIAlertView xf_showWithTitle:@"网络错误或数据出错!" message:nil delay:1.2 onDismiss:NULL];
    } controller:self unbindTelphoneSource:YSUserBindTelephoneSourecHealthRecordType isRemind:isRemind];
}

- (UserInfoViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[UserInfoViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex)   return;
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if (actionSheet.tag == 10) {
        self.viewModel.userInfo.sexStr = title;
    } else
    if (actionSheet.tag == 11) {
        self.viewModel.userInfo.blood = title;
    }
}

#pragma  mark - ---UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.nickNameTF) {
        if (range.location >= TextFieldNickNameStringLength) {
            return NO;
        }else{
            return YES;
        }
    }
    return YES;
}

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


#pragma mark - event response
- (void)changeAction {
    [self.view endEditing:YES];
    [self assignViewModelData];
    [self.viewModel.changeActionCommand execute:nil];
}


-(void)assignViewModelData {
    self.viewModel.userInfo.email = self.mailTF.text;
    self.viewModel.userInfo.nickName = self.nickNameTF.text;
    self.viewModel.userInfo.name = self.nameTF.text;
    self.viewModel.userInfo.heightStr = self.heightTF.text;
    self.viewModel.userInfo.weightStr = self.weightTF.text;
    self.viewModel.userInfo.allergicHistory = self.allergicHistoryTF.text;
    self.viewModel.userInfo.transGenetic = self.transGeneticTF.text;
    self.viewModel.userInfo.transHistory = self.transHistoryTF.text;
    self.viewModel.userInfo.userSignature = self.textViewBardianAutograph.text;
    

    
}

- (IBAction)changeDateAction {
    NSString *birthday = self.viewModel.userInfo.birthdate;
    if (!IsEmpty(birthday)) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:[NSString stringWithFormat:@"yyyy-MM-dd"]];
        [self.calenderView setCurrentDate:[formatter dateFromString:birthday]];
    }
    [self.view endEditing:YES];
    self.dateBackView.frame = self.view.bounds;
    [self.view addSubview:self.dateBackView];
}

- (void)disappearAction {
    @weakify(self)
    [UIView animateWithDuration:0.5 animations:^{
        @strongify(self)
        self.dateBackView.frame = CGRectMake(0,self.view.frame.size.height,
                                            __MainScreen_Width, self.view.frame.size.height);
        [self.dateBackView removeFromSuperview];
    }];
}

- (void)changeSexAction {
    [self.view endEditing:YES];
    UIActionSheet *sexSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女",nil];
    sexSheet.tag = 10;
    [sexSheet showInView:self.view];
        
}

#pragma mark ---UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location >= 30) {
        return NO;
    }else{
        return YES;
    }
    
}
- (void)textViewDidChange:(UITextView *)textView
{

    NSString *toBeString = textView.text;
    
    if (toBeString.length != 0) {
        self.labelBardianAutographPlaceholder.hidden = YES;
    }else{
        self.labelBardianAutographPlaceholder.hidden = NO;
    }
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 30) {
                textView.text = [toBeString substringToIndex:30];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > 30) {
            textView.text = [toBeString substringToIndex:30];
        }
    }
        //更新textView背景的整体高度
    [self calculateTextViewHeightWith:toBeString];
}

- (void)calculateTextViewHeightWith:(NSString *)text
{
    if (text.length > 0) {
        self.labelBardianAutographPlaceholder.hidden = YES;
    }else{
        self.labelBardianAutographPlaceholder.hidden = NO;
    }
   
    CGSize sizeText = CGSizeMake((kScreenWidth - 96.5- 49),MAXFLOAT );
    NSDictionary *dicText = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
    
    CGSize ssizeConsigneeName = [text boundingRectWithSize:sizeText
                                                           options:NSStringDrawingUsesLineFragmentOrigin attributes:dicText
                                                           context:nil].size;
    
    
    
    ssizeConsigneeName.height = ssizeConsigneeName.height + 29.0;
    if (ssizeConsigneeName.height < 44) {
        self.BardianAutographViewHeight.constant = 44;
    }else{
        self.BardianAutographViewHeight.constant = ssizeConsigneeName.height;
    }
}

- (void)changeBloodAction {
    [self.view endEditing:YES];
    UIActionSheet *sexSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"A",@"B",@"AB",@"O",@"其他",nil];
    sexSheet.tag = 11;
    [sexSheet showInView:self.view];
}

#pragma mark - private methods


- (void)setUIAppearance {
    [super setUIAppearance];
    self.heightTF.keyboardType = UIKeyboardTypeNumberPad;
    self.weightTF.keyboardType = UIKeyboardTypeNumberPad;
    self.markImage.image = [self.markImage.image imageWithColor:UIColorFromRGB(0x999999)];
    
//    UITapGestureRecognizer *changeSexTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeSexAction)];
//    [self.sexView addGestureRecognizer:changeSexTap];
    UITapGestureRecognizer *changeBloodTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeBloodAction)];
    [self.bloodView addGestureRecognizer:changeBloodTap];
}


#pragma mark - getters and settters

- (UIView *)dateBackView {
    if (_dateBackView == nil) {
        UIView *blackView = [[UIView alloc] initWithFrame:self.view.bounds];
        blackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        [blackView addSubview:self.calenderView];
        UITapGestureRecognizer *disappearTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappearAction)];
        [blackView addGestureRecognizer:disappearTap];
        _dateBackView = blackView;
    }
    return _dateBackView;
}

- (CalenderView *)calenderView {
    if (_calenderView == nil) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"CalenderView" owner:nil options:nil];
        _calenderView = (CalenderView *)[nibs lastObject];
        _calenderView.frame = CGRectMake(0,self.view.bounds.size.height - 292,
                                         __MainScreen_Width, 292);
        NSDate *date = [NSDate date];
        _calenderView.MaxDate = date;
        [_calenderView setCurrentDate:[date dateBySubtractingDays:100*365]];
        @weakify(self)
        _calenderView.selectBirthBlock = ^(NSString *year,NSString *month,NSString *day){
            @strongify(self)
            self.viewModel.userInfo.birthdate = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
            [self disappearAction];
        };
    }
    return _calenderView;
}

- (UIButton *)confirmButton {
    if (_confirmButton == nil) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.frame = CGRectMake(0, 0, 40, 35);
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(changeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
