//
//  RXIntelligentEquipmentViewController.m
//  jingGang
//
//  Created by 荣旭 on 2019/6/22.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
//

#import "RXIntelligentEquipmentViewController.h"
#import "RXShowIntelligentEquipmentView.h"

@interface RXIntelligentEquipmentViewController ()

@property(nonatomic,strong)RXShowIntelligentEquipmentView*headView;
@end

@implementation RXIntelligentEquipmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = JGBaseColor;
    if (!_headView) {
        self.headView=[[[NSBundle mainBundle]loadNibNamed:@"RXShowIntelligentEquipmentView" owner:self options:nil]firstObject];
        self.headView.frame=self.view.frame;
        self.headView.backgroundColor = [UIColor whiteColor];
    }
    [self.view addSubview:self.headView];
}

@end
