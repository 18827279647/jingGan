 //
//  YSHealthySeleTestWebController.m
//  jingGang
//
//  Created by dengxf on 16/8/14.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSHealthyManageWebController.h"
#import "GlobeObject.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "UINavigationBar+Awesome.h"
#import "AppDelegate.h"

@interface YSHealthyManageWebController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *web;
@property (assign, nonatomic) YSHealthyManageWebType webType;
@property (copy , nonatomic) NSString *uid;
@property (strong,nonatomic) UIImageView *navBarHairlineImageView;
@property (strong,nonatomic) JSContext *context;
@property (strong,nonatomic)UIView *viewTop;
@end

@implementation YSHealthyManageWebController

- (instancetype)initWithWebType:(YSHealthyManageWebType)webType uid:(NSString *)uid
{
    self = [super init];
    if (self) {
        self.webType = webType;
        self.uid = uid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    UINavigationBar *navigationBar = self.navigationController.navigationBar;
//    self.navBarHairlineImageView = [self findHairlineImageViewUnder:navigationBar];
    
//    if (self.webType == YSHealthyManageCompleteTaskType || self.webType == YSHealthyManageAddTaskType) {
////        [self setNavigationBarTransformProgress:1];
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
//        [self hiddenNavBarPopButton];
//    }else {
        [super basicBuild];
//    }
    self.view.backgroundColor = JGBaseColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setup];
}

- (void)backToLastController {
    if (self.isComeForUpdateUserInfoVC) {
        //从完善个人信息页面过来的返回方式要用dismiss返回到首页
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{

        [self.navigationController popViewControllerAnimated:YES];

    }
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)setNavigationBarTransformProgress:(CGFloat)progress
{
    [self.navigationController.navigationBar lt_setTranslationY:(-44 * progress)];
    [self.navigationController.navigationBar lt_setElementsAlpha:(1-progress)];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    
    if (self.webType == YSHealthyManageAddTaskType || self.webType == YSHealthyManageCompleteTaskType || self.webType ==YSHealthyManageHealthySuggestType || self.webType == YSHealthyManageCompleteYinDaoUrlTaskDoneType) {
        if (self.yinDaoURL.length == 0) {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
            }

//    if (self.webType == YSHealthyManageCompleteTaskType || self.webType == YSHealthyManageAddTaskType) {
//        self.navBarHairlineImageView.hidden = YES;
//    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    if (self.webType == YSHealthyManageCompleteTaskType || self.webType == YSHealthyManageAddTaskType) {
//        self.navBarHairlineImageView.hidden = NO;
//        [self.navigationController.navigationBar lt_reset];
//        [self.navigationController.navigationBar lt_setTranslationY:(-44 * 0)];
//        [self.navigationController.navigationBar lt_setElementsAlpha:(1)];
//    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [YSUMMobClickManager endLogPageWithKey:[NSString stringWithFormat:@"%@%@",@"um_",NSStringFromClass([self class])]];
    self.navigationController.navigationBar.backgroundColor=[UIColor grayColor];
}


- (void)setup {
    if(iPhoneX_X){
        _viewTop = [[UIView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, 44)];
    }else{
        _viewTop = [[UIView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, 20)];

    }
    _viewTop.backgroundColor = COMMONTOPICCOLOR;
    [self.view addSubview:_viewTop];

    UIWebView *web = [[UIWebView alloc] init];
    web.delegate = self;
    web.x = 0;
    web.scalesPageToFit = YES;
    web.width = ScreenWidth;
    NSString *adUrl;
    web.y = 0;
//    web.scrollView.scrollEnabled = NO;
    switch (self.webType) {
        case YSHealthyManageHealthyTestType:
        {
            [YSThemeManager setNavigationTitle:@"健康基本预测" andViewController:self];
            adUrl = [NSString stringWithFormat:@"%@/%@%@",Base_URL,@"v1/wenjuan/questionnaire?userID=",self.uid];
            web.height = ScreenHeight - NavBarHeight;
            web.scrollView.scrollEnabled = YES;
        }
            break;
        case YSHealthyManageHealthySuggestType:
        {
            
            [YSThemeManager setNavigationTitle:@"健康建议" andViewController:self];
            web.y = 19;
            adUrl = [NSString stringWithFormat:@"%@/v1/wenjuan/proposalDetai?proposalID=%@&userID=%@",Base_URL,self.proposalID,self.uid];
            web.height = ScreenHeight - web.y;
            NSLog(@"......%@",adUrl);
            web.scrollView.scrollEnabled = YES;


        }
            break;
        case YSHealthyManageAddTaskType:
        {
//            [self setNavBarTitle:@"添加健康任务"];
            adUrl = [NSString stringWithFormat:@"%@/v1/ht/index?userID=%@",Base_URL,self.uid];
            if(iPhoneX_X){
                 web.y = 44;
            }else{
                 web.y = 20;
            }
           
            web.height = ScreenHeight - web.y;
//            web.scrollView.scrollEnabled = NO;
        }
            break;
        case YSHealthyManageCompleteTaskType:
        {
//            [self setNavBarTitle:@"去完成健康任务"];
            
            switch (self.taskProcess) {
                case YSHealthyTaskUnCompleted:
                {
                    if (self.yinDaoURL.length > 0) {//如果有引导完成任务
                        adUrl = [NSString stringWithFormat:@"%@%@?userID=%@&taskID=%@",StaticBase_Url,self.yinDaoURL,self.uid,self.taskId];
                        web.y = 0;
                        _viewTop.height = 0;
                        web.height = ScreenHeight - 64;
                        [YSThemeManager setNavigationTitle:self.strNavYinDaoTitle andViewController:self];
                        [self.navigationController setNavigationBarHidden:NO animated:YES];
                    }else{//没有引导完成任务
                        adUrl = [NSString stringWithFormat:@"%@/v1/ht/sign?userID=%@&taskID=%@",Base_URL,self.uid,self.taskId];
                        web.y = 19;
                        web.scrollView.scrollEnabled = NO;
                        web.height = ScreenHeight - web.y;
                    }
                }
                    
                    break;
                case YSHealthyTaskCompleted:
                {
                    adUrl = self.completedTaskUrl;
                    web.y = 19;
                    web.scrollView.scrollEnabled = NO;
                    web.height = ScreenHeight - web.y;
                }
                    
                    break;
                default:
                    break;
            }
    
        }
            break;
        case YSHealthyManageCompleteYinDaoUrlTaskDoneType:
        {
            //引导完成健康任务URL完成后跳转
            adUrl = [NSString stringWithFormat:@"%@/v1/ht/sign?userID=%@&taskID=%@&taskDone=taskDone",Base_URL,self.uid,self.taskId];
            web.y = 19;
            web.height = ScreenHeight - web.y;
        }
            break;
        case YSHealthyManageIllnessTestType:
        {
            [YSThemeManager setNavigationTitle:@"疾病风险评估" andViewController:self];
            web.height = ScreenHeight - NavBarHeight;
            web.scrollView.scrollEnabled = YES;
            adUrl = self.linkConfig;
        }
            break;
            
        case YSZhongYiManageIllnessTestTy:
        {
            
            [YSThemeManager setNavigationTitle:@"中医体质检测" andViewController:self];
            web.height = ScreenHeight - NavBarHeight;
            web.scrollView.scrollEnabled = YES;
            adUrl = self.linkConfig;
            
            NSLog(@"adUrl...........%@",adUrl);
        }
            break;
        default:
            break;
    }
    
    NSURL *url = [NSURL URLWithString:adUrl];
    NSURLRequest *reqest = [NSURLRequest requestWithURL:url];
    [web loadRequest:reqest];
    web.backgroundColor = JGBaseColor;
    [self.view addSubview:web];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.web = web;
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (!self.context) {
        JSContext *context = [self.web valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        self.context = context;
    }
    
    @weakify(self);
    self.context[@"queResultSub"] = ^() {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    };
    
    self.context[@"requestCheck"] = ^(NSString *str) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    };
    
    self.context[@"requestBack"] = ^(NSString *str) {
        @strongify(self);
        if (self.webType == YSHealthyManageCompleteYinDaoUrlTaskDoneType) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    };
    self.context[@"requestTaskDone"] = ^(NSString *taskID,NSString *userID,NSString *taskDone) {
        @strongify(self);
        JGLog(@"%@---%@---%@",taskID,userID,taskDone);
        
        YSHealthyManageWebController *healthyManageWebController = [[YSHealthyManageWebController alloc]initWithWebType:YSHealthyManageCompleteYinDaoUrlTaskDoneType uid:userID];
        healthyManageWebController.taskId = taskID;
        [self.navigationController pushViewController:healthyManageWebController animated:YES];
        
    };
}


-(void)dealloc {
    JGLog(@"----YSHealthyManageWebController---dealloc");
}
@end
