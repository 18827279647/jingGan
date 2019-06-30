//
//  SDViewController.m
//  jingGang
//
//  Created by whlx on 2018/12/12.
//  Copyright © 2018年 dengxf_dev. All rights reserved.
//

#import "SDViewController.h"
#import "YSThemeManager.h"
#import <Speech/Speech.h>

@interface SDViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic) UIButton *confirmButton;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (nonatomic,strong)NSMutableArray *nameArray;
@property (strong,nonatomic) UILabel * sdbsLabel;
@end

@implementation SDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.confirmButton];
    [YSThemeManager setNavigationTitle:@"设定目标" andViewController:self];

    UILabel *  sd = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, __MainScreen_Width, 30)];
    sd.text = @"每日步数目标";
    sd.textAlignment = NSTextAlignmentCenter;
    sd.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
    [self.view addSubview:sd];
    
    _sdbsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, __MainScreen_Width, 50)];

    _sdbsLabel.textAlignment = NSTextAlignmentCenter;
    _sdbsLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:30];
    [self.view addSubview:_sdbsLabel];
    UIImage *image = [UIImage imageNamed:@"sdbs"];
    CGFloat imageWidth = image.imageWidth;
    CGFloat imageHeight = image.imageHeight;
    
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.height = imageHeight;
    imageView.width =  imageWidth;
    imageView.y = 150;
    imageView.x = 70;
    imageView.image = image;
    [self.view addSubview:imageView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(imageWidth+50, 65, 180, 550)];
    
    self.pickerView.backgroundColor = [UIColor clearColor];
    
    self.pickerView.delegate = self;
    
    self.pickerView.dataSource = self;
    
    [self.view addSubview:self.pickerView];
    
    [self.pickerView reloadAllComponents];//刷新UIPickerView
    //
    
    
    self.nameArray = [NSMutableArray arrayWithCapacity:10];
    for (int i = 1000; i <100000; i+=1000) {
        
//        NSLog(@"%d",i);
        [self.nameArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    [self.pickerView selectRow:6 inComponent:0 animated:NO];
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:@"sdbs"];
    if(string.length == 0){
         _sdbsLabel.text = [self.nameArray objectAtIndex:6];
    }else{
         _sdbsLabel.text = string;
    }

    // Do any additional setup after loading the view from its nib.
}
- (UIButton *)confirmButton {
    if (_confirmButton == nil) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.frame = CGRectMake(0, 0, 40, 35);
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(changeActions) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _confirmButton;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
//    [self.pickerView selectedRowInComponent:10];
   
}

-(void)changeActions{

    [[NSUserDefaults standardUserDefaults] setObject:_sdbsLabel.text forKey:@"sdbs"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SDViewControllerNotification" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


//返回有几列

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView

{
    
    return 1;
    
}

//返回指定列的行数

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component

{
    
    return self.nameArray.count;
    
    
    
}

//返回指定列，行的高度，就是自定义行的高度

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 40.0f;
    
}

//返回指定列的宽度

- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    if (component==0) {//iOS6边框占10+10
        
        return  self.view.frame.size.width/3;
        
    } else if(component==1){
        
        return  self.view.frame.size.width/3;
        
    }
    
    return  self.view.frame.size.width/3;
    
}



// 自定义指定列的每行的视图，即指定列的每行的视图行为一致

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    if (!view){
        
        view = [[UIView alloc]init];
        
    }
    
    UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/3, 20)];
    
    text.textAlignment = NSTextAlignmentCenter;
    
    text.text = [self.nameArray objectAtIndex:row];
    
    [view addSubview:text];
    
    //隐藏上下直线
    
    　　[self.pickerView.subviews objectAtIndex:1].backgroundColor = [UIColor clearColor];
    
    [self.pickerView.subviews objectAtIndex:2].backgroundColor = [UIColor clearColor];
    
    return view;
    
}

//显示的标题

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    //    NSString *str = [_nameArray objectAtIndex:row];
    
    NSString *str = [self.nameArray objectAtIndex:row];
    return str;
    
}

//显示的标题字体、颜色等属性

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    
    
    NSString *str = [self.nameArray objectAtIndex:row];
    
    NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc]initWithString:str];
    
    [AttributedString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, [AttributedString  length])];
    
    
    
    return AttributedString;
    
}//NS_AVAILABLE_IOS(6_0);



//被选择的行

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
     _sdbsLabel.text = [self.nameArray objectAtIndex:row];
    
    NSLog(@"HANG%ld",component);
    
    
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
