//
//  JGCustomTestFaceController.m
//  jingGang
//
//  Created by dengxf on 16/1/28.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "JGCustomTestFaceController.h"
#import "DLTabedSlideView.h"
#import "GlobeObject.h"
#import "JGCustomTestFaceWithManController.h"
#import "JGCustomTestFaceWithWomanController.h"
#import "LeftRightView.h"

@interface JGCustomTestFaceController ()<DLTabedSlideViewDelegate>

@property (strong,nonatomic)  DLTabedSlideView * slideView;
@property (strong,nonatomic) LeftRightView *listView;
@property (nonatomic,assign)ListType listType;
@property (assign, nonatomic) BOOL _showList;
@property (strong,nonatomic)  DLTabedSlideView * slideView1;


@end

@implementation JGCustomTestFaceController

-(LeftRightView *)listView {
    
    if (!_listView) {
        _listView = [[LeftRightView alloc] initWithFenlieID:5 frame:CGRectMake(0, NavBarHeight, kScreenWidth, kScreenHeight-NavBarHeight)];
        _listView.listType = FigureType;
        

        [self.view addSubview:_listView];
    }
    return _listView;
}

- (void)backToLastController {
    if (self._showList) {
        self.listView.hidden = YES;
        self._showList = NO;
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [YSUMMobClickManager endLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(backToLastController) target:self];
//    self.view.backgroundColor = [UIColor whiteColor];
    [YSThemeManager setNavigationTitle:@"医疗美容" andViewController:self];
    
    if(iPhoneX_X){
         _slideView1 = [[DLTabedSlideView alloc] initWithFrame:CGRectMake(0, NavBarHeight+22, ScreenWidth, ScreenHeight - NavBarHeight)];
    }else{
         _slideView1 = [[DLTabedSlideView alloc] initWithFrame:CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight - NavBarHeight)];
    }
    
    
    
    
    _slideView1.delegate = self;
    _slideView1.tabbarHeight = 42.0;
    _slideView1.baseViewController = self;
    _slideView1.tabItemNormalColor = UIColorFromRGB(0x9b9b9b);
    _slideView1.tabItemSelectedColor = UIColorFromRGB(0x4a4a4a);
    _slideView1.tabbarTrackColor = [YSThemeManager buttonBgColor];
    _slideView1.tabbarBackgroundImage = [self imageWithCustomColor:[UIColor whiteColor]];
    _slideView1.tabbarBottomSpacing = 0;
    

    DLTabedbarItem *operateItem = [DLTabedbarItem itemWithTitle:@"女生" image:nil selectedImage:nil];
    
    DLTabedbarItem *platformItem = [DLTabedbarItem itemWithTitle:@"男生" image:nil selectedImage:nil];
    
    _slideView1.tabbarItems = @[operateItem, platformItem];
    self.slideView = _slideView1;
    [self.slideView buildTabbar];
    self.slideView.selectedIndex = 0;
    [self.view addSubview:_slideView1];
    
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem initWithTitle:@"列表" titleColor:[UIColor whiteColor] target:self action:@selector(qiehuan)];
}

- (void)qiehuan {
    
    if (!self._showList) {//点之前显示的是model,隐藏模型,显示list
        if (!self.listView.hasShow) {
            [self.listView show];
        }else {
            self.listView.hidden = NO;
            
        }
//        [self showHiddenModelSubViewIsHidden:YES];
        
    }else {//和上相反,显示模型,隐藏list
        self.listView.hidden = YES;
//        [self showHiddenModelSubViewIsHidden:NO];
//        //当前状态，隐藏相应模型
//        [self hiddenTheWebAccordingTheState];
    }
    self._showList = !self._showList;
}
- (UIImage *)imageWithCustomColor:(UIColor *)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark -- DLTabedSlideViewDelegate ----
- (NSInteger)numberOfTabsInDLTabedSlideView:(DLTabedSlideView *)sender{
    return self.slideView.tabbarItems.count;
}

- (UIViewController *)DLTabedSlideView:(DLTabedSlideView *)sender controllerAt:(NSInteger)index{
    switch (index) {
        case 0:
        {
            JGCustomTestFaceWithWomanController *operatorController = [[JGCustomTestFaceWithWomanController alloc] init];
            return operatorController;
        }
            break;
        case 1:
        {
            JGCustomTestFaceWithManController *platformController = [[JGCustomTestFaceWithManController alloc] init];
            return platformController;
        }
            break;
        default:
            return nil;
    }
}


@end
