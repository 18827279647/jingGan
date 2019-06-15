//
//  FoodCuculatorVC.m
//  jingGang
//
//  Created by 张康健 on 15/6/8.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "FoodCuculatorVC.h"
#import "UIButton+Block.h"
#import "GlobeObject.h"

@interface FoodCuculatorVC ()
@property (weak, nonatomic) IBOutlet UILabel *kaluoLiLabel;
@property (weak, nonatomic) IBOutlet UILabel *describLab;

@end

@implementation FoodCuculatorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self _init];
    
    [self _loadNavLeft];
    
    [self _loadTitleView];
    
}


#pragma mark - private Method
-(void)_init{
    
    //self.zhengzhuangAllTableWidthConstraint.constant = __MainScreen_Width * 0.32;
    self.navigationController.navigationBar.barTintColor = COMMONTOPICCOLOR;
    NSInteger kaluoLiValue = [self.foodDic[@"calories"] integerValue];
    self.kaluoLiLabel.text = [NSString stringWithFormat:@"%ld卡",kaluoLiValue];
    self.describLab.text = [NSString stringWithFormat:@"每100克%@热量",self.foodDic[@"name"]];
}




-(void)_loadNavLeft{
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];

}


-(void)_loadTitleView{
   
    
    [YSThemeManager setNavigationTitle:@"食物计算器" andViewController:self];
    
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                          NSFontAttributeName:[UIFont systemFontOfSize:18.0]}];
    
}




@end
