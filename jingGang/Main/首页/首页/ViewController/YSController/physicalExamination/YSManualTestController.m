//
//  YSManualTestController.m
//  jingGang
//
//  Created by dengxf on 16/8/1.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSManualTestController.h"
#import "WSJBloodPressureViewController.h"
#import "WSJHeartRateResultViewController.h"
#import "WSJLungResultViewController.h"
#import "UIAlertView+Extension.h"
#import "Unit.h"
#import "VApiManager.h"
#import "RXSubmitDataRequest.h"
#import "RXSubmitDataResponse.h"
#import "GlobeObject.h"
#import "RXWebViewController.h"

@interface YSManualTestInputView ()<UITextFieldDelegate>

@property (copy , nonatomic) NSString *title;
@property (copy , nonatomic) NSString *placeHolder;
@property (assign, nonatomic) NSInteger limiteValue;


@end


@implementation YSManualTestInputView

- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
                  placeHolder:(NSString *)placeHolder
                  limiteValue:(NSInteger)limiteValue
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        _title = title;
        _placeHolder = placeHolder;
        _limiteValue = limiteValue;
        [self setup];
    }
    return self;
}

- (void)setup {
    UILabel *lab = [[UILabel alloc] init];
    lab.x = 0;
    lab.y = 4;
    lab.height = self.height - lab.y * 2;

    if ([self.title isEqualToString:@"TC-总胆固醇(mmoL/L):"]||[self.title isEqualToString:@"TG-甘油三酯(mmoL/L):"]||[self.title isEqualToString:@"HDLC-高密度脂蛋白胆固醇(mmoL/L):"]||[self.title isEqualToString:@"LDLC-低密度脂蛋白胆固醇(mmoL/L):"]) {
        lab.font = JGFont(12);
        lab.width=200;
    }else{
        lab.width = 150;
        lab.font = JGFont(13);
    }
    [self addSubview:lab];
    lab.textAlignment = NSTextAlignmentRight;
    lab.text = _title;
    
    UITextField *textField = [[UITextField alloc] init];
    textField.x = MaxX(lab) + 10;
    textField.y = 0;
    textField.width = self.width - textField.x - 20;
    textField.height = self.height - textField.y - 2;
    textField.placeholder = _placeHolder;
    if ([self.title isEqualToString:@"TC-总胆固醇(mmoL/L):"]||[self.title isEqualToString:@"TG-甘油三酯(mmoL/L):"]||[self.title isEqualToString:@"HDLC-高密度脂蛋白胆固醇(mmoL/L):"]||[self.title isEqualToString:@"LDLC-低密度脂蛋白胆固醇(mmoL/L):"]) {
        textField.font = JGFont(12);
    }else{
        textField.font = JGFont(13);
    }
    if ([self.title containsString:@"血糖"]||[self.title containsString:@"体重"]||[self.title containsString:@"体脂"]||[self.title containsString:@"血脂"]||[self.title containsString:@"体温"]||[self.title containsString:@"腰臀比"]) {
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }else{
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    textField.delegate = self;
    [self addSubview:textField];
    self.textFiled = textField;
    
    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.x = MaxX(lab);
    bottomLineView.y = MaxY(textField);
    bottomLineView.width = self.width - bottomLineView.x - 20;
    bottomLineView.height = 1;
    bottomLineView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.26];
    [self addSubview:bottomLineView];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEdit];
}
- (void)endEdit
{
    //关闭所有键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSLog(@"这里返回为NO。则为禁止编辑");
    if ([self.title isEqualToString:@"腰臀比:"]) {
        return NO;
    }
    if ([self.title isEqualToString:@"身高(cm):"]) {
        NSString*string =[[NSUserDefaults standardUserDefaults]objectForKey:@"_sbHeight"];
        if (string.length>0) {
            return NO;
        }
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([toBeString integerValue] > _limiteValue + 1) {
        return NO;
    }
    return YES;
}



@end

@interface YSManualTestController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic) UITableView *mtableview;

@property (assign, nonatomic) YSInputValueType testType;

@property (strong,nonatomic) YSManualTestInputView *firstInputView;
@property (strong,nonatomic) YSManualTestInputView *secondInputView;

@property (strong,nonatomic) YSManualTestInputView *freeInputView;
@property (strong,nonatomic) YSManualTestInputView *fourInputView;
@property (strong,nonatomic) YSManualTestInputView *fiveInputView;
@property (strong,nonatomic) YSManualTestInputView *sixInputView;
@property (strong,nonatomic) YSManualTestInputView *sevenInputView;
@property (strong,nonatomic) YSManualTestInputView *eightInputView;

@end

@implementation YSManualTestController

-(instancetype)initWithTestType:(YSInputValueType)testType {
    if (self = [super init]) {
        self.testType = testType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.navString isEqualToString:@"体脂"]) {
        [self setUI];
    }else{
        [self setupWithType:self.testType];
    }
}
-(void)setUI;{
    
    /*  血压测试 */
    UIImage *warnningImage = [UIImage imageNamed:@"ys_combined shape"];
    UIImageView *warnningImageView = [[UIImageView alloc] initWithImage:warnningImage];
    warnningImageView.y = 26;
    warnningImageView.width = warnningImage.imageWidth;
    warnningImageView.height = warnningImage.imageHeight;
    [self.view addSubview:warnningImageView];
    
    UILabel *warningLab = [[UILabel alloc] init];
    warningLab.y = warnningImageView.y - 13;
    warningLab.height = 40;
    warningLab.numberOfLines = 0;
    warningLab.font = JGFont(12);
    warningLab.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    [self.view addSubview:warningLab];
    
    NSString *warningText;
    warningText=@"请输入您的身体指数";
    CGSize textSize = [warningText sizeWithFont:JGFont(12) maxH:40];
    warningLab.width = textSize.width;
    warningLab.x = (ScreenWidth - warningLab.width) / 2;
    warnningImageView.x = warningLab.x - 10 - warnningImageView.width;
    warningLab.text=warningText;
    

    _mtableview=[[UITableView alloc]initWithFrame:CGRectMake(0,MaxY(warningLab) +10,kScreenWidth,ScreenHeight-100-MaxY(warningLab)-kNarbarH-44-10) style:UITableViewStyleGrouped];
    _mtableview.backgroundColor =[UIColor whiteColor];
    _mtableview.delegate = self;
    _mtableview.dataSource = self;
    _mtableview.sectionFooterHeight = 0;
    _mtableview.estimatedRowHeight = 0;
    _mtableview.estimatedSectionHeaderHeight = 0;
    _mtableview.estimatedSectionFooterHeight = 0;
    _mtableview.backgroundColor = [UIColor whiteColor];
    _mtableview.separatorColor =[UIColor whiteColor];
    _mtableview.delegate = self;
    _mtableview.dataSource = self;
    _mtableview.tableFooterView = [UIView new];
    [self.view addSubview:_mtableview];
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        /**
         * 体脂*/
        YSManualTestInputView *highPressureView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, 32) title:@"体脂率(%):" placeHolder:@"请输入体脂率数值" limiteValue:1000];
        highPressureView.textFiled.text= self.firstInputView.textFiled.text;
        self.firstInputView = highPressureView;
        return highPressureView;
      
    }else if(section==1){
        /**
         *  基础代谢率 */
        YSManualTestInputView *lowPressureView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, 32) title:@"基础代谢率(卡路里/天):" placeHolder:@"请输入基础代谢率数值" limiteValue:1000];
        lowPressureView.textFiled.text=self.secondInputView.textFiled.text;
        self.secondInputView = lowPressureView;
        
        return lowPressureView;
    }else if(section==2){
        /*皮下脂肪*/
        YSManualTestInputView *freeInputView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, 32) title:@"皮下脂肪(%):" placeHolder:@"请输入皮下脂肪数值" limiteValue:1000];
        freeInputView.textFiled.text=self.freeInputView.textFiled.text;
        self.freeInputView = freeInputView;
        return freeInputView;
    }else if(section==3){
        /*内脏脂肪*/
        YSManualTestInputView *fourInputView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, 32) title:@"内脏脂肪:" placeHolder:@"请输入内脏脂肪数值" limiteValue:1000];
        fourInputView.textFiled.text=self.fourInputView.textFiled.text;
        self.fourInputView = fourInputView;
        return fourInputView;
        
    }else if(section==4){
        //肌肉比例
        YSManualTestInputView *fiveInputView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, 32) title:@"肌肉比例(%):" placeHolder:@"请输入肌肉比例数值" limiteValue:1000];
        fiveInputView.textFiled.text=self.fiveInputView.textFiled.text;
        self.fiveInputView = fiveInputView;
        return fiveInputView;
        
    }else if(section==5){
    
        //基础代谢年龄
        YSManualTestInputView *sixInputView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, 32) title:@"基础代谢年龄(岁):" placeHolder:@"请输入基础代谢年龄数值" limiteValue:1000];
        sixInputView.textFiled.text=self.sixInputView.textFiled.text;
        self.sixInputView = sixInputView;
        return sixInputView;
        
    }else if(section==6){
        //身体水分率
        YSManualTestInputView *sevenInputView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, 32) title:@"身体水分率(%):" placeHolder:@"请输入身体水分率数值" limiteValue:1000];
        sevenInputView.textFiled.text=self.sevenInputView.textFiled.text;
        self.sevenInputView = sevenInputView;
        return sevenInputView;
        
    }else if(section==7){
        //骨量
        YSManualTestInputView *eightInputView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, 32) title:@"骨量(%):" placeHolder:@"请输入骨量数值" limiteValue:1000];
        eightInputView .textFiled.text=self.eightInputView.textFiled.text;
        self.eightInputView = eightInputView;
        return eightInputView;
    }else if(section==8){
        
        UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0,0,ScreenWidth,44)];
        
        view.backgroundColor=[UIColor whiteColor];
        
        UIButton *sureInputButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sureInputButton.frame=CGRectMake(57/2,0,ScreenWidth-57,44);
        sureInputButton.titleLabel.font = YSPingFangRegular(16);
        [sureInputButton setTitle:@"确认输入" forState:UIControlStateNormal];
        [sureInputButton setTitleColor:JGWhiteColor forState:UIControlStateNormal];
        sureInputButton.layer.cornerRadius = 6.0;
        [sureInputButton setBackgroundImage:[UIImage imageNamed:@"button222"] forState:UIControlStateNormal];
        sureInputButton.clipsToBounds = YES;
        
        [sureInputButton addTarget:self action:@selector(sureInputAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:sureInputButton];
        return view;
    }
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;{
    if (section==8) {
        return 44;
    }
    return 60;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 9;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
};
//设置分组间隔
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;{
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0,0,ScreenWidth,10)];
    view.backgroundColor=JGColor(250, 250, 250, 1);
    return view;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell*cell=[[UITableViewCell alloc]init];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0;
}


- (void)setupWithType:(YSInputValueType)testType {
    /**
     *  血压测试 */
    UIImage *warnningImage = [UIImage imageNamed:@"ys_combined shape"];
    UIImageView *warnningImageView = [[UIImageView alloc] initWithImage:warnningImage];
    warnningImageView.y = 26;
    warnningImageView.width = warnningImage.imageWidth;
    warnningImageView.height = warnningImage.imageHeight;
    [self.view addSubview:warnningImageView];
    
    UILabel *warningLab = [[UILabel alloc] init];
    warningLab.y = warnningImageView.y - 13;
    warningLab.height = 40;
    warningLab.numberOfLines = 0;
    warningLab.font = JGFont(12);
    warningLab.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    [self.view addSubview:warningLab];
    
    NSString *warningText;
    CGFloat currentY;
    if (self.navString.length>0) {
        if ([self.navString isEqualToString:@"血压"]) {
            warningText = @"请输入您的血压值";
            CGSize textSize = [warningText sizeWithFont:JGFont(12) maxH:40];
            warningLab.width = textSize.width;
            warningLab.x = (ScreenWidth - warningLab.width) / 2;
            warnningImageView.x = warningLab.x - 10 - warnningImageView.width;
            /**
             *  高压 */
            YSManualTestInputView *highPressureView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0, MaxY(warningLab) + 10, ScreenWidth, 32) title:@"高压(mmhg):" placeHolder:@"请输入高压数值" limiteValue:200];
            [self.view addSubview:highPressureView];
            self.firstInputView = highPressureView;
            
            /**
             *  低压 */
            YSManualTestInputView *lowPressureView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0, MaxY(highPressureView) + 26, ScreenWidth, 32) title:@"低压(mmhg):" placeHolder:@"请输入低压数值" limiteValue:200];
            [self.view addSubview:lowPressureView];
            self.secondInputView = lowPressureView;
            
            currentY = MaxY(lowPressureView);
        }else if([self.navString isEqualToString:@"血糖"]){
            
            warningText = @"请输入您的血糖值 (空腹)";
            CGSize textSize = [warningText sizeWithFont:JGFont(12) maxH:40];
            warningLab.width = textSize.width;
            warningLab.x = (ScreenWidth - warningLab.width) / 2;
            warnningImageView.x = warningLab.x - 10 - warnningImageView.width;
            /**
             *  血糖值 */
            YSManualTestInputView *highPressureView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0, MaxY(warningLab) + 10, ScreenWidth, 32) title:@"血糖值(mmoL/L):" placeHolder:@"请输入血糖数值" limiteValue:100];
            [self.view addSubview:highPressureView];
            self.firstInputView = highPressureView;

            currentY = MaxY(highPressureView);
            
        }else if([self.navString isEqualToString:@"体重"]){
            
            warningText = @"请输入您的体重值";
            CGSize textSize = [warningText sizeWithFont:JGFont(12) maxH:40];
            warningLab.width = textSize.width;
            warningLab.x = (ScreenWidth - warningLab.width) / 2;
            warnningImageView.x = warningLab.x - 10 - warnningImageView.width;
            /**
             *  体重 */
            YSManualTestInputView *highPressureView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0, MaxY(warningLab) + 10, ScreenWidth, 32) title:@"体重(kg):" placeHolder:@"请输入体重数值" limiteValue:100];
            [self.view addSubview:highPressureView];
            self.firstInputView = highPressureView;
            

            YSManualTestInputView *lowPressureView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0, MaxY(highPressureView) + 26, ScreenWidth, 32) title:@"身高(cm):" placeHolder:@"请输入身高数字" limiteValue:200];
            [self.view addSubview:lowPressureView];
             self.secondInputView = lowPressureView;
            NSString*string =[[NSUserDefaults standardUserDefaults]objectForKey:@"_sbHeight"];
            if (string.length>0) {
                self.secondInputView.textFiled.text=string;
            }
            self.secondInputView = lowPressureView;
            
            currentY = MaxY(lowPressureView);
            
        }else if([self.navString isEqualToString:@"血脂"]){
            
            warningText = @"请输入您的血脂四项";
            CGSize textSize = [warningText sizeWithFont:JGFont(12) maxH:40];
            warningLab.width = textSize.width;
            warningLab.x = (ScreenWidth - warningLab.width) / 2;
            warnningImageView.x = warningLab.x - 10 - warnningImageView.width;
            /**
             * 体脂*/
            YSManualTestInputView *highPressureView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0, MaxY(warningLab) + 10, ScreenWidth, 32) title:@"TC-总胆固醇(mmoL/L):" placeHolder:@"请输入TC数值" limiteValue:100];
            [self.view addSubview:highPressureView];
            self.firstInputView = highPressureView;
            
            /**
             *  基础代谢率 */
            YSManualTestInputView *lowPressureView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0, MaxY(highPressureView) + 26, ScreenWidth, 32) title:@"TG-甘油三酯(mmoL/L):" placeHolder:@"请输入TG数值" limiteValue:100];
            [self.view addSubview:lowPressureView];
            self.secondInputView = lowPressureView;
            
            /*皮下脂肪*/
            YSManualTestInputView *freeInputView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0, MaxY(lowPressureView) + 26, ScreenWidth, 32) title:@"HDLC-高密度脂蛋白胆固醇(mmoL/L):" placeHolder:@"请输入高密度胆固醇数值" limiteValue:100];
            [self.view addSubview:freeInputView];
            self.freeInputView = freeInputView;
            
            /*内脏脂肪*/
            YSManualTestInputView *fourInputView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0, MaxY(freeInputView ) + 26, ScreenWidth, 32) title:@"LDLC-低密度脂蛋白胆固醇(mmoL/L):" placeHolder:@"请输入低密度胆固醇数值" limiteValue:100];
            [self.view addSubview:fourInputView];
            self.fourInputView = fourInputView;
            
            currentY = MaxY(fourInputView);
            
        }else if([self.navString isEqualToString:@"尿酸"]){
            
            warningText = @"请输入您的尿酸值";
            CGSize textSize = [warningText sizeWithFont:JGFont(12) maxH:40];
            warningLab.width = textSize.width;
            warningLab.x = (ScreenWidth - warningLab.width) / 2;
            warnningImageView.x = warningLab.x - 10 - warnningImageView.width;
            /**
             * 体脂*/
            YSManualTestInputView *highPressureView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0, MaxY(warningLab) + 10, ScreenWidth, 32) title:@"血尿酸(umol/L):" placeHolder:@"请输入血尿酸数值" limiteValue:1000];
            [self.view addSubview:highPressureView];
            self.firstInputView = highPressureView;
            
            currentY = MaxY(highPressureView);
            
        }else if([self.navString isEqualToString:@"血氧"]){
            
            warningText = @"请输入您的血氧值";
            CGSize textSize = [warningText sizeWithFont:JGFont(12) maxH:40];
            warningLab.width = textSize.width;
            warningLab.x = (ScreenWidth - warningLab.width) / 2;
            warnningImageView.x = warningLab.x - 10 - warnningImageView.width;
            /**
             * 体脂*/
            YSManualTestInputView *highPressureView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0, MaxY(warningLab) + 10, ScreenWidth, 32) title:@"血氧值(%):" placeHolder:@"请输入血氧数值" limiteValue:100];
            [self.view addSubview:highPressureView];
            self.firstInputView = highPressureView;
            
            currentY = MaxY(highPressureView);
            
        }else if([self.navString isEqualToString:@"心率"]){
            
            warningText = @"请输入您的心率值";
            CGSize textSize = [warningText sizeWithFont:JGFont(12) maxH:40];
            warningLab.width = textSize.width;
            warningLab.x = (ScreenWidth - warningLab.width) / 2;
            warnningImageView.x = warningLab.x - 10 - warnningImageView.width;
            /**
             * 体脂*/
            YSManualTestInputView *highPressureView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0, MaxY(warningLab) + 10, ScreenWidth, 32) title:@"心率值(次/分):" placeHolder:@"请输入心率数值" limiteValue:1000];
            [self.view addSubview:highPressureView];
            self.firstInputView = highPressureView;
            
            currentY = MaxY(highPressureView);
            
        }else if([self.navString isEqualToString:@"体温"]){
            
            warningText = @"请输入您的体温值";
            CGSize textSize = [warningText sizeWithFont:JGFont(12) maxH:40];
            warningLab.width = textSize.width;
            warningLab.x = (ScreenWidth - warningLab.width) / 2;
            warnningImageView.x = warningLab.x - 10 - warnningImageView.width;
            /**
             * 体脂*/
            YSManualTestInputView *highPressureView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0, MaxY(warningLab) + 10, ScreenWidth, 32) title:@"体温值(℃):" placeHolder:@"请输入体温数值" limiteValue:100];
            [self.view addSubview:highPressureView];
            self.firstInputView = highPressureView;
            
            currentY = MaxY(highPressureView);
            
        }else if([self.navString isEqualToString:@"呼吸"]){
            
            warningText = @"请输入您的呼吸率值";
            CGSize textSize = [warningText sizeWithFont:JGFont(12) maxH:40];
            warningLab.width = textSize.width;
            warningLab.x = (ScreenWidth - warningLab.width) / 2;
            warnningImageView.x = warningLab.x - 10 - warnningImageView.width;
            /**
             * 体脂*/
            YSManualTestInputView *highPressureView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0, MaxY(warningLab) + 10, ScreenWidth, 32) title:@"呼吸率值(次/分):" placeHolder:@"请输入呼吸率值数值" limiteValue:100];
            [self.view addSubview:highPressureView];
            self.firstInputView = highPressureView;
            
            currentY = MaxY(highPressureView);
            
        }else if([self.navString isEqualToString:@"腰臀比"]){
            
            warningText = @"请输入您的腰臀比值";
            CGSize textSize = [warningText sizeWithFont:JGFont(12) maxH:40];
            warningLab.width = textSize.width;
            warningLab.x = (ScreenWidth - warningLab.width) / 2;
            warnningImageView.x = warningLab.x - 10 - warnningImageView.width;

            YSManualTestInputView *highPressureView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0, MaxY(warningLab) + 10, ScreenWidth, 32) title:@"腰围值(cm):" placeHolder:@"请输入腰围值数值" limiteValue:1000];
            [self.view addSubview:highPressureView];
            self.firstInputView = highPressureView;

            YSManualTestInputView *lowPressureView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0, MaxY(highPressureView) + 26, ScreenWidth, 32) title:@"臀围(cm):" placeHolder:@"请输入臀围数值" limiteValue:1000];
            [self.view addSubview:lowPressureView];
            self.secondInputView = lowPressureView;
            
            YSManualTestInputView *freeInputView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0, MaxY(lowPressureView) + 26, ScreenWidth, 32) title:@"腰臀比:" placeHolder:@"腰臀比数值" limiteValue:1000];
            
            [self.view addSubview:freeInputView];
            self.freeInputView = freeInputView;
            
            currentY = MaxY(freeInputView);
            
        }else if([self.navString isEqualToString:@"肺活量"]){
            
            warningText = @"请输入您的肺活量值";
            CGSize textSize = [warningText sizeWithFont:JGFont(12) maxH:40];
            warningLab.width = textSize.width;
            warningLab.x = (ScreenWidth - warningLab.width) / 2;
            warnningImageView.x = warningLab.x - 10 - warnningImageView.width;
            /**
             * 体脂*/
            YSManualTestInputView *highPressureView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0, MaxY(warningLab) + 10, ScreenWidth, 32) title:@"肺活量值(ml):" placeHolder:@"请输入肺活量数值" limiteValue:1000];
            [self.view addSubview:highPressureView];
            self.firstInputView = highPressureView;
            
            currentY = MaxY(highPressureView);
            
        }else if([self.navString isEqualToString:@"视力"]){
            
            warningText = @"请输入您的视力值";
            CGSize textSize = [warningText sizeWithFont:JGFont(12) maxH:40];
            warningLab.width = textSize.width;
            warningLab.x = (ScreenWidth - warningLab.width) / 2;
            warnningImageView.x = warningLab.x - 10 - warnningImageView.width;
            /**
             * 体脂*/
            YSManualTestInputView *highPressureView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0, MaxY(warningLab) + 10, ScreenWidth, 32) title:@"视力值:" placeHolder:@"请输入视力数值" limiteValue:1000];
            [self.view addSubview:highPressureView];
            self.firstInputView = highPressureView;
            
            currentY = MaxY(highPressureView);
            
        }else if([self.navString isEqualToString:@"听力"]){
            
            warningText = @"请输入您的听力值";
            CGSize textSize = [warningText sizeWithFont:JGFont(12) maxH:40];
            warningLab.width = textSize.width;
            warningLab.x = (ScreenWidth - warningLab.width) / 2;
            warnningImageView.x = warningLab.x - 10 - warnningImageView.width;
            /**
             * 体脂*/
            YSManualTestInputView *highPressureView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0, MaxY(warningLab) + 10, ScreenWidth, 32) title:@"听力值:" placeHolder:@"请输入听力数值" limiteValue:1000];
            [self.view addSubview:highPressureView];
            self.firstInputView = highPressureView;
            
            
            currentY = MaxY(highPressureView);
            
        }else{
            warningText = @"请输入您的血糖值 (单位mmhg)";
            CGSize textSize = [warningText sizeWithFont:JGFont(12) maxH:40];
            warningLab.width = textSize.width;
            warningLab.x = (ScreenWidth - warningLab.width) / 2;
            warnningImageView.x = warningLab.x - 10 - warnningImageView.width;
            /**
             *  高压 */
            YSManualTestInputView *highPressureView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0, MaxY(warningLab) + 10, ScreenWidth, 32) title:@"高压:" placeHolder:@"50-250以内的数字" limiteValue:1000];
            [self.view addSubview:highPressureView];
            self.firstInputView = highPressureView;
            
            /**
             *  低压 */
            YSManualTestInputView *lowPressureView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0, MaxY(highPressureView) + 26, ScreenWidth, 32) title:@"低压:" placeHolder:@"30-220以内的数字" limiteValue:1000];
            [self.view addSubview:lowPressureView];
            self.secondInputView = lowPressureView;
            
            currentY = MaxY(lowPressureView);
        }
       
    }else{
        switch (testType) {
            case YSInputValueWithBloodPressureType:
            {
                warningText = @"请输入您的血压值 (单位mmhg)";
                CGSize textSize = [warningText sizeWithFont:JGFont(12) maxH:40];
                warningLab.width = textSize.width;
                warningLab.x = (ScreenWidth - warningLab.width) / 2;
                warnningImageView.x = warningLab.x - 10 - warnningImageView.width;
                /**
                 *  高压 */
                YSManualTestInputView *highPressureView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0, MaxY(warningLab) + 10, ScreenWidth, 32) title:@"高压:" placeHolder:@"50-250以内的数字" limiteValue:1000];
                [self.view addSubview:highPressureView];
                self.firstInputView = highPressureView;
                
                /**
                 *  低压 */
                YSManualTestInputView *lowPressureView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0, MaxY(highPressureView) + 26, ScreenWidth, 32) title:@"低压:" placeHolder:@"30-220以内的数字" limiteValue:1000];
                [self.view addSubview:lowPressureView];
                self.secondInputView = lowPressureView;
                currentY = MaxY(lowPressureView);
            }
                break;
            case YSInputValueWithBloodOxygenType:
            {
                /**
                 *  血氧值 */
                warningText = @"请输入您的血氧值 (单位%)";
                CGSize textSize = [warningText sizeWithFont:JGFont(12) maxH:40];
                warningLab.width = textSize.width;
                warningLab.x = (ScreenWidth - warningLab.width) / 2;
                warnningImageView.x = warningLab.x - 10 - warnningImageView.width;
                YSManualTestInputView *bloodOxygenView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0, MaxY(warningLab) + 10, ScreenWidth, 32) title:@"血氧值:" placeHolder:@"60 - 100" limiteValue:1000];
                [self.view addSubview:bloodOxygenView];
                self.firstInputView = bloodOxygenView;
                
                currentY = MaxY(bloodOxygenView);
            }
                break;
            case YSInputValyeWithLungcapacityType:
            {
                /**
                 *  肺活量值 */
                warningText = @"请输入您的肺活量值";
                CGSize textSize = [warningText sizeWithFont:JGFont(12) maxH:40];
                warningLab.width = textSize.width;
                warningLab.x = (ScreenWidth - warningLab.width) / 2;
                warnningImageView.x = warningLab.x - 10 - warnningImageView.width;
                YSManualTestInputView *lungcapacityView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0, MaxY(warningLab) + 10, ScreenWidth, 32) title:@"肺活量值:" placeHolder:@"100-10000" limiteValue:10001];
                [self.view addSubview:lungcapacityView];
                self.firstInputView = lungcapacityView;
                
                currentY = MaxY(lungcapacityView);
            }
                break;
            case YSInputValyeWithHeartRateType:
            {
                warningText = @"请输入您的心率值";
                CGSize textSize = [warningText sizeWithFont:JGFont(12) maxH:40];
                warningLab.width = textSize.width;
                warningLab.x = (ScreenWidth - warningLab.width) / 2;
                warnningImageView.x = warningLab.x - 10 - warnningImageView.width;
                YSManualTestInputView *bloodRateView = [[YSManualTestInputView alloc] initWithFrame:CGRectMake(0, MaxY(warningLab) + 10, ScreenWidth, 32) title:@"心率值:" placeHolder:@"30-220以内的数值" limiteValue:1000];
                [self.view addSubview:bloodRateView];
                self.firstInputView = bloodRateView;
                currentY = MaxY(bloodRateView);
                
            }
                break;
            default:
                break;
        }
    }
    warningLab.text = warningText;
    UIButton *sureInputButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureInputButton.x = 57. / 2;
    sureInputButton.y = currentY + 20;
    sureInputButton.width = ScreenWidth - sureInputButton.x * 2;
    sureInputButton.height = 44.;
    [self.view addSubview:sureInputButton];
    sureInputButton.titleLabel.font = YSPingFangRegular(16);
    [sureInputButton setTitle:@"确认输入" forState:UIControlStateNormal];
    [sureInputButton setTitleColor:JGWhiteColor forState:UIControlStateNormal];
    sureInputButton.layer.cornerRadius = 6.0;
    [sureInputButton setBackgroundImage:[UIImage imageNamed:@"button222"] forState:UIControlStateNormal];

    sureInputButton.clipsToBounds = YES;
    
    [sureInputButton addTarget:self action:@selector(sureInputAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (BOOL)textLengthWithTextFiled:(UITextField *)textField {
    if (textField.text.length) {
        return YES;
    }
    return NO;
}

- (void)sureInputAction:(UIButton *)button {
    [self.view endEditing:YES];
    
    if (self.navString.length>0) {
        NSMutableDictionary*paramJson=[[NSMutableDictionary alloc]init];
        if ([self.navString isEqualToString:@"血压"]) {
            BOOL highRet = [self textLengthWithTextFiled:self.firstInputView.textFiled];
            if (highRet && [self.firstInputView.textFiled.text integerValue] >= 0 && [self.firstInputView.textFiled.text integerValue] <= 200) {
            }else {
                highRet = NO;
            }
            BOOL lowRet = [self textLengthWithTextFiled:self.secondInputView.textFiled];
            if (lowRet && [self.secondInputView.textFiled.text integerValue] >= 0 && [self.secondInputView.textFiled.text integerValue] <= 200) {
                
            }else {
                lowRet = NO;
            }
            if (highRet && lowRet) {
            
                [paramJson setObject:self.firstInputView.textFiled.text forKey:@"highValue"];
                [paramJson setObject:self.secondInputView.textFiled.text forKey:@"lowValue"];
                //上传接口
                [self getRuest:paramJson];

            }else {
                [UIAlertView xf_showWithTitle:@"请输入正确信息" message:nil delay:1.2 onDismiss:NULL];
            }
        }else if([self.navString isEqualToString:@"血糖"]){
            BOOL highRet = [self textLengthWithTextFiled:self.firstInputView.textFiled];
            if (highRet&&[self.firstInputView.textFiled.text integerValue]>=0&& [self.firstInputView.textFiled.text integerValue] <= 100) {
            
            }else{
                highRet=NO;
            }
            if (highRet) {
                float a=[self.firstInputView.textFiled.text floatValue];
                [paramJson setObject:[NSString stringWithFormat:@"%.1f",a] forKey:@"inValue"];
                [paramJson setObject:@"1" forKey:@"glucoseType"];
                 //上传接口
                [self getRuest:paramJson];
            }else{
                [UIAlertView xf_showWithTitle:@"请输入正确信息" message:nil delay:1.2 onDismiss:NULL];
            }
        }else if([self.navString isEqualToString:@"体重"]){
            BOOL highRet = [self textLengthWithTextFiled:self.firstInputView.textFiled];
            if (highRet&&[self.firstInputView.textFiled.text integerValue]>=0&& [self.firstInputView.textFiled.text integerValue] <= 100) {
                
            }else{
                highRet=NO;
            }
    
            BOOL secondhighRet = [self textLengthWithTextFiled: self.secondInputView.textFiled];
            if (secondhighRet&&[self.secondInputView.textFiled.text integerValue]>=0&& [self.secondInputView.textFiled.text integerValue] <= 200) {
                
            }else{
                secondhighRet=NO;
            }
            if (highRet&&secondhighRet) {
                float a=[self.firstInputView.textFiled.text floatValue];
                float b=[self.secondInputView.textFiled.text floatValue];
                [paramJson setObject:[NSString stringWithFormat:@"%.1f",a] forKey:@"inValue"];
                [paramJson setObject:[NSString stringWithFormat:@"%.0f",b] forKey:@"height"];
                [paramJson setObject:@"1" forKey:@"glucoseType"];
                //上传接口
                [self getRuest:paramJson];
            
            }else{
                [UIAlertView xf_showWithTitle:@"请输入正确信息" message:nil delay:1.2 onDismiss:NULL];
            }
        }else if([self.navString isEqualToString:@"血脂"]){
            BOOL highRet = [self textLengthWithTextFiled:self.firstInputView.textFiled];
            if (highRet&&[self.firstInputView.textFiled.text integerValue]>=0&& [self.firstInputView.textFiled.text integerValue] <= 100) {
                
            }else{
                highRet=NO;
            }
            
            BOOL secondhighRet = [self textLengthWithTextFiled: self.secondInputView.textFiled];
            if (secondhighRet&&[self.secondInputView.textFiled.text integerValue]>=0&& [self.secondInputView.textFiled.text integerValue] <= 100) {
                
            }else{
                secondhighRet=NO;
            }
            
            BOOL freehighRet = [self textLengthWithTextFiled: self.freeInputView.textFiled];
            if (freehighRet&&[self.freeInputView.textFiled.text integerValue]>=0&& [self.freeInputView.textFiled.text integerValue] <= 100) {
                
            }else{
                freehighRet=NO;
            }
            
            BOOL fourhighRet = [self textLengthWithTextFiled: self.fourInputView.textFiled];
            if (fourhighRet&&[self.fourInputView.textFiled.text integerValue]>=0&& [self.fourInputView.textFiled.text integerValue] <= 100) {
                
            }else{
                fourhighRet=NO;
            }
    
            if (highRet&&secondhighRet&&freehighRet&&fourhighRet) {

                
                float a=[self.firstInputView.textFiled.text floatValue];
                float b=[self.secondInputView.textFiled.text floatValue];
                float c=[self.freeInputView.textFiled.text floatValue];
                float d=[self.fourInputView.textFiled.text floatValue];
                
                [paramJson setObject:[NSString stringWithFormat:@"%.1f",a] forKey:@"tcValue"];
                [paramJson setObject:[NSString stringWithFormat:@"%.1f",b] forKey:@"tgValue"];
                [paramJson setObject:[NSString stringWithFormat:@"%.1f",c] forKey:@"hdlcValue"];
                [paramJson setObject:[NSString stringWithFormat:@"%.1f",d] forKey:@"ldlcValue"];
                
                [paramJson setObject:@"1" forKey:@"glucoseType"];
                
                //上传接口
                [self getRuest:paramJson];
            }else{
                [UIAlertView xf_showWithTitle:@"请输入正确信息" message:nil delay:1.2 onDismiss:NULL];
            }
        }else if([self.navString isEqualToString:@"尿酸"]){
            BOOL highRet = [self textLengthWithTextFiled:self.firstInputView.textFiled];
            if (highRet&&[self.firstInputView.textFiled.text integerValue]>=0&& [self.firstInputView.textFiled.text integerValue] <= 100) {
                
            }else{
                highRet=NO;
            }
            if (highRet) {
                [paramJson setObject:self.firstInputView.textFiled.text forKey:@"inValue"];
                //上传接口
                [self getRuest:paramJson];
                
            }else{
                [UIAlertView xf_showWithTitle:@"请输入正确信息" message:nil delay:1.2 onDismiss:NULL];
            }
        }else if([self.navString isEqualToString:@"血氧"]){
            BOOL highRet = [self textLengthWithTextFiled:self.firstInputView.textFiled];
            if (highRet&&[self.firstInputView.textFiled.text integerValue]>=0&& [self.firstInputView.textFiled.text integerValue] <= 100) {
                
            }else{
                highRet=NO;
            }
            if (highRet) {
                [paramJson setObject:self.firstInputView.textFiled.text forKey:@"inValue"];
                //上传接口
                [self getRuest:paramJson];
                
            }else{
                [UIAlertView xf_showWithTitle:@"请输入正确信息" message:nil delay:1.2 onDismiss:NULL];
            }
        }else if([self.navString isEqualToString:@"心率"]){
            BOOL highRet = [self textLengthWithTextFiled:self.firstInputView.textFiled];
            if (highRet&&[self.firstInputView.textFiled.text integerValue]>=0&& [self.firstInputView.textFiled.text integerValue] <= 100) {
                
            }else{
                highRet=NO;
            }
            if (highRet) {
                [paramJson setObject:self.firstInputView.textFiled.text forKey:@"inValue"];
                //上传接口
                [self getRuest:paramJson];
                
            }else{
                [UIAlertView xf_showWithTitle:@"请输入正确信息" message:nil delay:1.2 onDismiss:NULL];
            }
        }else if([self.navString isEqualToString:@"体温"]){
            BOOL highRet = [self textLengthWithTextFiled:self.firstInputView.textFiled];
            if (highRet&&[self.firstInputView.textFiled.text integerValue]>=0&& [self.firstInputView.textFiled.text integerValue] <= 100) {
                
            }else{
                highRet=NO;
            }
            if (highRet) {
                float a=[self.firstInputView.textFiled.text floatValue];
                [paramJson setObject:[NSString stringWithFormat:@"%.1f",a] forKey:@"inValue"];
                //上传接口
                [self getRuest:paramJson];
                
            }else{
                [UIAlertView xf_showWithTitle:@"请输入正确信息" message:nil delay:1.2 onDismiss:NULL];
            }
        }else if([self.navString isEqualToString:@"呼吸"]){
            BOOL highRet = [self textLengthWithTextFiled:self.firstInputView.textFiled];
            if (highRet&&[self.firstInputView.textFiled.text integerValue]>=0&& [self.firstInputView.textFiled.text integerValue] <= 100) {
                
            }else{
                highRet=NO;
            }
            if (highRet) {
                [paramJson setObject:self.firstInputView.textFiled.text forKey:@"inValue"];
                //上传接口
                [self getRuest:paramJson];
                
            }else{
                [UIAlertView xf_showWithTitle:@"请输入正确信息" message:nil delay:1.2 onDismiss:NULL];
            }
        }else if([self.navString isEqualToString:@"肺活量"]){
            BOOL highRet = [self textLengthWithTextFiled:self.firstInputView.textFiled];
            if (highRet&&[self.firstInputView.textFiled.text integerValue]>=0&& [self.firstInputView.textFiled.text integerValue] <= 100) {
                
            }else{
                highRet=NO;
            }
            if (highRet) {
                [paramJson setObject:self.firstInputView.textFiled.text forKey:@"inValue"];
                //上传接口
                [self getRuest:paramJson];
                
            }else{
                [UIAlertView xf_showWithTitle:@"请输入正确信息" message:nil delay:1.2 onDismiss:NULL];
            }
        }else if([self.navString isEqualToString:@"视力"]){
            BOOL highRet = [self textLengthWithTextFiled:self.firstInputView.textFiled];
            if (highRet&&[self.firstInputView.textFiled.text integerValue]>=0&& [self.firstInputView.textFiled.text integerValue] <= 100) {
                
            }else{
                highRet=NO;
            }
            if (highRet) {
                [paramJson setObject:self.firstInputView.textFiled.text forKey:@"inValue"];
                [paramJson setObject:@"1" forKey:@"type"];
                //上传接口
                [self getRuest:paramJson];
                
            }else{
                [UIAlertView xf_showWithTitle:@"请输入正确信息" message:nil delay:1.2 onDismiss:NULL];
            }
        }else if([self.navString isEqualToString:@"听力"]){
            BOOL highRet = [self textLengthWithTextFiled:self.firstInputView.textFiled];
            if (highRet&&[self.firstInputView.textFiled.text integerValue]>=0&& [self.firstInputView.textFiled.text integerValue] <= 100) {
                
            }else{
                highRet=NO;
            }
            if (highRet) {
                [paramJson setObject:self.firstInputView.textFiled.text forKey:@"inValue"];
                //上传接口
                [self getRuest:paramJson];
                
            }else{
                [UIAlertView xf_showWithTitle:@"请输入正确信息" message:nil delay:1.2 onDismiss:NULL];
            }
        }else if([self.navString isEqualToString:@"腰臀比"]){
            BOOL highRet = [self textLengthWithTextFiled:self.firstInputView.textFiled];
            if (highRet&&[self.firstInputView.textFiled.text integerValue]>=0&& [self.firstInputView.textFiled.text integerValue] <= 100) {
                
            }else{
                highRet=NO;
            }
            
            BOOL secondhighRet = [self textLengthWithTextFiled:self.secondInputView.textFiled];
            if (secondhighRet&&[self.secondInputView.textFiled.text integerValue]>=0&& [self.secondInputView.textFiled.text integerValue] <= 100) {
                
            }else{
                secondhighRet=NO;
            }
            if (highRet&&secondhighRet) {
                
                float a=[self.secondInputView.textFiled.text floatValue];
                float b=[self.firstInputView.textFiled.text floatValue];
                float c=a/b;
                self.freeInputView.textFiled.text=[NSString stringWithFormat:@"%.1f",c];
                [paramJson setObject:self.firstInputView.textFiled.text forKey:@"waistValue"];
                [paramJson setObject:self.secondInputView.textFiled.text forKey:@"hipValue"];
                [paramJson setObject:self.freeInputView.textFiled.text forKey:@"whrValue"];
                //上传接口
                [self getRuest:paramJson];
                
            }else{
                [UIAlertView xf_showWithTitle:@"请输入正确信息" message:nil delay:1.2 onDismiss:NULL];
            }
        }else if([self.navString isEqualToString:@"体脂"]){
            
            BOOL highRet = [self textLengthWithTextFiled:self.firstInputView.textFiled];
            if (highRet&&[self.firstInputView.textFiled.text integerValue]>=0&& [self.firstInputView.textFiled.text integerValue] <= 100) {
                
            }else{
                highRet=NO;
            }
            
            BOOL secondhighRet = [self textLengthWithTextFiled:self.secondInputView.textFiled];
            if (secondhighRet&&[self.secondInputView.textFiled.text integerValue]>=0&& [self.secondInputView.textFiled.text integerValue] <= 100) {
                
            }else{
                secondhighRet=NO;
            }
            
            BOOL freehighRet = [self textLengthWithTextFiled:self.freeInputView.textFiled];
            if (freehighRet&&[self.freeInputView.textFiled.text integerValue]>=0&& [self.freeInputView.textFiled.text integerValue] <= 100) {
            }else{
                freehighRet=NO;
            }
            
            BOOL fourhighRet = [self textLengthWithTextFiled:self.fourInputView.textFiled];
            if (fourhighRet&&[self.fourInputView.textFiled.text integerValue]>=0&& [self.fourInputView.textFiled.text integerValue] <= 100) {
            }else{
                fourhighRet=NO;
            }
            
            
            BOOL fivehighRet = [self textLengthWithTextFiled:self.fiveInputView.textFiled];
            if (fivehighRet&&[self.fiveInputView.textFiled.text integerValue]>=0&& [self.fiveInputView.textFiled.text integerValue] <= 100) {
            }else{
                fivehighRet=NO;
            }
            
            BOOL sixhighRet = [self textLengthWithTextFiled:self.sixInputView.textFiled];
            if (sixhighRet&&[self.sixInputView.textFiled.text integerValue]>=0&& [self.sixInputView.textFiled.text integerValue] <= 100) {
            }else{
                sixhighRet=NO;
            }
            
            BOOL sevenhighRet = [self textLengthWithTextFiled:self.sevenInputView.textFiled];
            if (sevenhighRet&&[self.sevenInputView.textFiled.text integerValue]>=0&& [self.sevenInputView.textFiled.text integerValue] <= 100) {
            }else{
                sevenhighRet=NO;
            }
            
            BOOL eighthighRet = [self textLengthWithTextFiled:self.eightInputView.textFiled];
            if (eighthighRet&&[self.eightInputView.textFiled.text integerValue]>=0&& [self.eightInputView.textFiled.text integerValue] <= 100) {
            }else{
                eighthighRet=NO;
            }
            
            if (highRet&&secondhighRet&&freehighRet&&eighthighRet&&sevenhighRet&&sixhighRet&&fivehighRet&&fourhighRet) {
                
                [paramJson setObject:[NSString stringWithFormat:@"%.1f",[self.firstInputView.textFiled.text floatValue]] forKey:@"inValue"];
                [paramJson setObject:[NSString stringWithFormat:@"%.1f",[self.firstInputView.textFiled.text floatValue]] forKey:@"bmaValue"];
                [paramJson setObject:[NSString stringWithFormat:@"%.1f",[self.secondInputView.textFiled.text floatValue]] forKey:@"pbmValue"];
                
                [paramJson setObject:[NSString stringWithFormat:@"%.1f",[self.freeInputView.textFiled.text floatValue]] forKey:@"bmrValue"];
 
                
                [paramJson setObject:[NSString stringWithFormat:@"%.1f",[self.fourInputView.textFiled.text floatValue]] forKey:@"bfaValue"];
                [paramJson setObject:[NSString stringWithFormat:@"%.1f",[self.fiveInputView.textFiled.text floatValue]] forKey:@"sfValue"];
                [paramJson setObject:[NSString stringWithFormat:@"%.1f",[self.sixInputView.textFiled.text floatValue]] forKey:@"vatValue"];
                
                [paramJson setObject:[NSString stringWithFormat:@"%.1f",[self.sevenInputView.textFiled.text floatValue]] forKey:@"sfValue"];
                [paramJson setObject:[NSString stringWithFormat:@"%.1f",[self.eightInputView.textFiled.text floatValue]] forKey:@"pbwValue"];
            
                //上传接口
                [self getRuest:paramJson];
                
            }else{
                [UIAlertView xf_showWithTitle:@"请输入正确信息" message:nil delay:1.2 onDismiss:NULL];
            }
        }
    }else{
        switch (self.testType) {
            case YSInputValueWithBloodPressureType:
            {
                BOOL highRet = [self textLengthWithTextFiled:self.firstInputView.textFiled];
                if (highRet && [self.firstInputView.textFiled.text integerValue] >= 50 && [self.firstInputView.textFiled.text integerValue] <= 250) {
                }else {
                    highRet = NO;
                }
                BOOL lowRet = [self textLengthWithTextFiled:self.secondInputView.textFiled];
                if (lowRet && [self.secondInputView.textFiled.text integerValue] >= 30 && [self.secondInputView.textFiled.text integerValue] <= 220) {
                    
                }else {
                    lowRet = NO;
                }
                
                if (highRet && lowRet) {
                    WSJBloodPressureViewController *bloodPrssureVc = [[WSJBloodPressureViewController alloc] initWithPop:^{
                    }];
                    bloodPrssureVc.lowPressure = [self.secondInputView.textFiled.text integerValue];
                    bloodPrssureVc.highPressure = [self.firstInputView.textFiled.text integerValue];
                    [self.navigationController pushViewController:bloodPrssureVc animated:YES];
                }else {
                    [UIAlertView xf_showWithTitle:@"请输入正确信息" message:nil delay:1.2 onDismiss:NULL];
                }
            }
                break;
            case YSInputValyeWithHeartRateType:
            {
                BOOL heartRateRet = [self textLengthWithTextFiled:self.firstInputView.textFiled];
                if (heartRateRet && [self.firstInputView.textFiled.text integerValue] >= 30 && [self.firstInputView.textFiled.text integerValue] <= 220) {
                    
                }else {
                    heartRateRet = NO;
                }
                if (heartRateRet) {
                    WSJHeartRateResultViewController *heartResult =[[WSJHeartRateResultViewController alloc] initWithNibName:@"WSJHeartRateResultViewController" bundle:nil];
                    heartResult.heartRateValue = [self.firstInputView.textFiled.text integerValue];
                    [self.navigationController pushViewController:heartResult animated:YES];
                }else {
                    [UIAlertView xf_showWithTitle:@"请输入正确信息" message:nil delay:1.2 onDismiss:NULL];
                }
            }
                break;
            case YSInputValueWithBloodOxygenType:
            {
                BOOL bloodOxgenRet = [self textLengthWithTextFiled:self.firstInputView.textFiled];
                if (bloodOxgenRet && [self.firstInputView.textFiled.text integerValue] >= 60 && [self.firstInputView.textFiled.text integerValue] <= 100) {
                    
                }else {
                    bloodOxgenRet = NO;
                }
                if (bloodOxgenRet) {
                    WSJLungResultViewController *lungResultVC = [[WSJLungResultViewController alloc] initWithNibName:@"WSJLungResultViewController" bundle:nil];
                    lungResultVC.type = bloodOxygenType;
                    lungResultVC.heartRateValue = [self.firstInputView.textFiled.text integerValue];
                    [self.navigationController pushViewController:lungResultVC animated:YES];
                }else {
                    [UIAlertView xf_showWithTitle:@"请输入正确信息" message:nil delay:1.2 onDismiss:NULL];
                }
                
            }
                break;
            case YSInputValyeWithLungcapacityType:
            {
                BOOL lungRet = [self textLengthWithTextFiled:self.firstInputView.textFiled];
                if (lungRet && [self.firstInputView.textFiled.text integerValue] >= 100 && [self.firstInputView.textFiled.text integerValue] <= 10000) {
                    
                }else {
                    lungRet = NO;
                }
                
                if (lungRet) {
                    WSJLungResultViewController *lungResultVC = [[WSJLungResultViewController alloc] initWithNibName:@"WSJLungResultViewController" bundle:nil];
                    //                lungResultVC.type = lungCapacityType;
                    lungResultVC.lungValue = [self.firstInputView.textFiled.text integerValue];
                    [self.navigationController pushViewController:lungResultVC animated:YES];
                }else {
                    [UIAlertView xf_showWithTitle:@"请输入正确信息" message:nil delay:1.2 onDismiss:NULL];
                }
            }
                break;
                
            default:
                break;
        }
    }
}


-(void)getRuest:(NSMutableDictionary*)paramJson;{

    [paramJson setObject:@"1" forKey:@"type"];
    [self showHUD];
    //提交数据
    RXSubmitDataRequest*request=[[RXSubmitDataRequest alloc]init:GetToken];
    request.paramCode=self.paramCode;
    request.paramJson=[self dictionaryToJson:paramJson];
    VApiManager *manager = [[VApiManager alloc]init];
    [manager RXSubmitDataRequest:request success:^(AFHTTPRequestOperation *operation, RXSubmitDataResponse *response) {
        [self hideAllHUD];
        if ([response.msg isEqualToString:@"success"]) {
            [self showStringHUD:@"提交成功" second:0];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"manualTestNotification" object:nil];
                RXWebViewController*web=[[RXWebViewController alloc]init];
//                web.urlstring=@"http://192.168.8.164:8082/carnation-apis-resource/resources/jkgl/result.html";
                web.urlstring=@"http://api.bhesky.com/resources/jkgl/result.html";
                web.titlestring=[NSString stringWithFormat:@"%@检测结果",self.navString];
                web.type=[NSString stringWithFormat:@"%d",self.paramCode];
                web.historyId=response.id;
                [self.navigationController pushViewController:web animated:NO];
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
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}






- (void)showHUD{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
/**
 *  功能:显示字符串hud
 */
- (void)showHUD:(NSString *)aMessage
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = aMessage;
}
- (void)showHUD:(NSString *)aMessage animated:(BOOL)animated
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:animated];
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
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = aMessage;
    [self performSelector:@selector(hideHUD) withObject:nil afterDelay:aSecond];
}


/**
 *  功能:隐藏hud
 */
- (void)hideHUD
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

/**
 *  功能:隐藏所有hud
 */
- (void)hideAllHUD
{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

/**
 *  功能:隐藏hud
 */
- (void)hideHUD:(BOOL)animated
{
    [MBProgressHUD hideHUDForView:self.view animated:animated];
}
@end
