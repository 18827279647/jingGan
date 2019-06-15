//
//  QuickBodyTestHomeController.m
//  jingGang
//
//  Created by 张康健 on 15/11/24.
//  Copyright © 2015年 yi jiehuang. All rights reserved.
//

#import "QuickBodyTestHomeController.h"
#import "QuickTestController.h"
#import "Util.h"

@interface QuickBodyTestHomeController ()

@property (weak, nonatomic) IBOutlet UIButton *beginTestButton;

@end

@implementation QuickBodyTestHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [YSThemeManager setNavigationTitle:@"快速体检" andViewController:self];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
    self.beginTestButton.titleLabel.font = YSPingFangRegular(16);
    self.view.backgroundColor = [UIColor whiteColor];
}




- (IBAction)beginQuickTestAction:(id)sender {
    
    QuickTestController *quickTestVC = [[QuickTestController alloc] init];
    [self.navigationController pushViewController:quickTestVC animated:YES];
    
}

@end
