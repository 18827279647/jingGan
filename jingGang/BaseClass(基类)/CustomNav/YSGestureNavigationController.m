//
//  Nav.m
//  CustomPopAnimation
//
//  Created by Jazys on 15/3/30.
//  Copyright (c) 2015年 Jazys. All rights reserved.
//

#import "YSGestureNavigationController.h"
#import "NavigationInteractiveTransition.h"
#import "GlobeObject.h"
@interface YSGestureNavigationController () <UIGestureRecognizerDelegate>
@property (nonatomic, weak) UIPanGestureRecognizer *popRecognizer;
/**
 *  方案一不需要的变量
 */
@property (nonatomic, strong) NavigationInteractiveTransition *navT;
@end


@implementation YSGestureNavigationController

+ (void)initialize
{
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundColor:[YSThemeManager themeColor]];
    [bar setTintColor:[YSThemeManager themeColor]];
    [bar setBarTintColor:[YSThemeManager themeColor]];
    [bar setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]}];
    
    // 设置item
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    // UIControlStateNormal
    NSMutableDictionary *itemAttrs = [NSMutableDictionary dictionary];
    itemAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    itemAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    [item setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
    // UIControlStateDisabled
    NSMutableDictionary *itemDisabledAttrs = [NSMutableDictionary dictionary];
    itemDisabledAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [item setTitleTextAttributes:itemDisabledAttrs forState:UIControlStateDisabled];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].keyWindow.rootViewController.navigationController.navigationBar.hidden=YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIGestureRecognizer *gesture = self.interactivePopGestureRecognizer;
    gesture.enabled = NO;
    UIView *gestureView = gesture.view;
    
    UIPanGestureRecognizer *popRecognizer = [[UIPanGestureRecognizer alloc] init];
    popRecognizer.delegate = self;
    popRecognizer.maximumNumberOfTouches = 1;
    [gestureView addGestureRecognizer:popRecognizer];
    
//#if USE_方案一
//    _navT = [[NavigationInteractiveTransition alloc] initWithViewController:self];
//    [popRecognizer addTarget:_navT action:@selector(handleControllerPop:)];
//    
//#elif USE_方案二
    /**
     *  获取系统手势的target数组
     */
    NSMutableArray *_targets = [gesture valueForKey:@"_targets"];
    /**
     *  获取它的唯一对象，我们知道它是一个叫UIGestureRecognizerTarget的私有类，它有一个属性叫_target
     */
    id gestureRecognizerTarget = [_targets firstObject];
    /**
     *  获取_target:_UINavigationInteractiveTransition，它有一个方法叫handleNavigationTransition:
     */
    id navigationInteractiveTransition = [gestureRecognizerTarget valueForKey:@"_target"];
    /**
     *  通过前面的打印，我们从控制台获取出来它的方法签名。
     */
    SEL handleTransition = NSSelectorFromString(@"handleNavigationTransition:");
    /**
     *  创建一个与系统一模一样的手势，我们只把它的类改为UIPanGestureRecognizer
     */
    [popRecognizer addTarget:navigationInteractiveTransition action:handleTransition];
//#endif
}

static NSArray *_limitGestureCtrls;
- (NSArray *)limitGestureCtrls
{
    if (!_limitGestureCtrls) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"comitGestureCtrlList.plist" ofType:nil];
        _limitGestureCtrls = [NSArray arrayWithContentsOfFile:path];
    }
    return _limitGestureCtrls;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    /**
     *  这里有两个条件不允许手势执行，1、当前控制器为根控制器；2、如果这个push、pop动画正在执行（私有属性）
     */
    // WSJShopCategoryViewController
    return NO;
    if (self.viewControllers.count) {
        UIViewController *controller = [self.viewControllers lastObject];
        NSString *controllerClassName = NSStringFromClass([controller class]);
        if ([[self limitGestureCtrls] containsObject:controllerClassName]) {
            return NO;
        }
    }
    return self.viewControllers.count != 1 && ![[self valueForKey:@"_isTransitioning"] boolValue];
}



/**
 * 可以在这个方法中拦截所有push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) { // 如果push进来的不是第一个控制器
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0, 0, 60, 44);
        [leftButton setTitleColor:[UIColor whiteColor]
                         forState:UIControlStateNormal];
        [leftButton setImage:[UIImage imageNamed:@"navigationBarBack"]
                    forState:UIControlStateNormal];
        leftButton.titleLabel.font = JGFont(15);
        [leftButton setAdjustsImageWhenHighlighted:NO];
        [leftButton addTarget:self action:@selector(backLastViewController) forControlEvents:UIControlEventTouchUpInside];
        // 修改导航栏左边的item
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
       //  隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    // 这句super的push要放在后面, 让viewController可以覆盖上面设置的leftBarButtonItem
    [super pushViewController:viewController animated:animated];
    
}
//初步解决无法返回bug
- (void)backLastViewController {
    [self popViewControllerAnimated:YES];
}
@end
