//
//  ImageViewController.m
//  Operator_JingGang
//
//  Created by whlx on 2019/4/16.
//  Copyright © 2019年 Dengxf. All rights reserved.
//

#import "ImageViewController.h"
#import "YYKit.h"
#import "GlobeObject.h"

#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define __MainScreenFrame               [[UIScreen mainScreen] bounds]
#define __MainScreen_Height             __MainScreenFrame.size.height

#define __MainScreen_Width              __MainScreenFrame.size.width
@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [YSThemeManager setNavigationTitle:@"代扣代缴个税公告" andViewController:self];
    
    self.navigationController.navigationBar.barTintColor = COMMONTOPICCOLOR;
    //返回
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
    UIScrollView * crollView1  = [[UIScrollView alloc] init];
    crollView1.frame = CGRectMake(0, 0,__MainScreen_Width ,__MainScreen_Height);
    crollView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:crollView1];
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 600)];
  
    image.imageURL = [NSURL URLWithString:@"http://f2.bhesky.com/geshui01.jpg"];
    


    [crollView1 addSubview:image];
    
    UIImageView * image1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 600, __MainScreen_Width, 600)];
  
    
    image1.imageURL = [NSURL URLWithString:@"http://f2.bhesky.com/geshui02.jpg"];
    
    
    
    [crollView1 addSubview:image1];
    
     crollView1.contentSize = CGSizeMake(self.view.width, image.height*2+20);
    // Do any additional setup after loading the view.
}
- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
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
