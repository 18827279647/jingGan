//
//  communityViewController.m
//  jingGang
//
//  Created by yi jiehuang on 15/5/21.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "XK_ViewController.h"

#import "communityViewController.h"
#import "PublicInfo.h"
#import "VTMagic.h"
#import "YSFriendCircleController.h"
#import "HealthyManageData.h"
#import "YSFriendCircleModel.h"
#import "YSFriendCircleDetailController.h"
#import "YSPublishMenuButton.h"
#import "YSComposeStatusController.h"
#import "YSFriendCircleRequestManager.h"
#import "JGDESUtils.h"
#import "TZImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZVideoPlayerController.h"
#import "TZImageManager.h"
#import "YSFriendCircleFrame.h"
#import "YSImageUploadManage.h"
#import "YSNotificationConfig.h"
#import "AboutYunEs.h"
#import "YSLoginManager.h"
#import "JGActivityHelper.h"
#import "AppDelegate+JGActivity.h"
#import "YSActivityController.h"
#import "YSConfigAdRequestManager.h"
#import "YSCommunityHeaderView.h"
#import "YSLiquorDomainWebController.h"
#import "YSJuanPiWebViewController.h"
#import "YSLocationManager.h"
#import "YSLinkElongHotelWebController.h"
#import "KJGoodsDetailViewController.h"
#import "WSJMerchantDetailViewController.h"
#import "ServiceDetailController.h"
#import "YSSurroundAreaCityInfo.h"
#import "YSHealthAIOController.h"
#import "YSHealthyMessageDatas.h"
#import "YSThumbnailManager.h"
#import "VApiManager.h"
#import "YSImageConfig.h"
#import "YSLinkCYDoctorWebController.h"

#import "guizeViewController.h"
@interface communityViewController ()<VTMagicViewDataSource, VTMagicViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,strong) UIImageView *imageViewHead;

@property (nonatomic, strong)  NSArray *menuLists;

@property (nonatomic, strong) VTMagicController *controllers;
@property (nonatomic, strong) VApiManager *vapiManager;

/**
 *  发布按钮展开状态 */
@property (assign, nonatomic) BOOL menuExpandStatus;

@property (strong,nonatomic) UIButton *cameraButton;

@property (strong,nonatomic) UIButton *pictureButton;


@property (strong,nonatomic) UIView * bjview;


@property (strong,nonatomic) UIButton *menuButton;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@property (strong,nonatomic) NSMutableArray *selectedPhotos;
@property (strong,nonatomic) NSMutableArray *selectedAssets;
@property (strong,nonatomic) YSFriendCircleController *currentController;
@property (strong,nonatomic) UIImageView *floatImageView;
@property (strong,nonatomic) YSActivitiesInfoItem *actInfoItem;
// 头部视图
@property (strong,nonatomic) YSCommunityHeaderView *headerView;
@property (nonatomic,copy) NSString *strHeadImageUrl;


//一会回来
@end

NSString *const communityTableViewCell = @"mainPublicTableViewCell";
NSString *const communityUserTableViewCell = @"communitCardTableViewCell";

#define PublishCenterButtonRect   CGRectMake(ScreenWidth - 62, ScreenHeight - 60 - 2 * NavBarHeight, 50, 50)
#define PublishCameraButtonRect   CGRectMake(self.menuButton.x - 40, self.menuButton.y + 6, 40, 40)
#define PublishPictureButtonRect  CGRectMake(self.menuButton.x + 6, self.menuButton.y - 38, 40, 40)


@implementation communityViewController

#pragma mark - accessor methods
- (VTMagicController *)controllers {
    if (!_controllers) {
        _controllers = [[VTMagicController alloc] init];
//        _controllers.magicView.headerView.backgroundColor = JGRandomColor;
        _controllers.magicView.headerHeight = 0.;
        _controllers.view.translatesAutoresizingMaskIntoConstraints = NO;
        _controllers.magicView.navigationColor = [UIColor whiteColor];
        _controllers.magicView.sliderColor =rgb(0, 0, 0, 0);
        _controllers.magicView.switchStyle = VTSwitchStyleDefault;
        _controllers.magicView.layoutStyle = VTLayoutStyleCenter;
        _controllers.magicView.navigationHeight = 40.f;
        _controllers.magicView.sliderExtension = 10.f;
        _controllers.magicView.itemSpacing = ScreenWidth / 4;
        _controllers.magicView.dataSource = self;
        _controllers.magicView.delegate = self;
        
//        UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
//
//        if(iPhoneX){
//            menuButton.frame = CGRectMake(ScreenWidth - 62, ScreenHeight - 90 - 2 * NavBarHeight, 50, 50);
//        }else{
//           menuButton.frame = PublishCenterButtonRect;
//        }
//
//        [menuButton setImage:[UIImage imageNamed:@"ys_healthyCircle_camera"] forState:UIControlStateNormal];
//        [menuButton addTarget:self action:@selector(publishAction:) forControlEvents:UIControlEventTouchUpInside];
//        menuButton.acceptEventInterval = 0.32;
//        self.menuButton = menuButton;
//        @weakify(self);
//        [self.menuButton addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
//            UNLOGIN_HANDLE
//            @strongify(self);
//            if (self.menuExpandStatus) {
//                /**
//                 *  菜单展开 */
                [self shrink:NULL];
//
//            }else {
//                /**
//                 *  菜单收缩 */
//                [self expend];
//            }
//
//        }];
        
        self.bjview = [[UIView alloc] init];
        if(iPhoneX_X){
          self.bjview.frame = CGRectMake(20, ScreenHeight - 120 - 2 * NavBarHeight,ScreenWidth - 40, 60);
        }else{
         self.bjview.frame = CGRectMake(20, ScreenHeight - 70 - 2 * NavBarHeight,ScreenWidth - 40, 60);

        }
        
//      self.bjview = [[UIView alloc] initWithFrame:CGRectMake(20, ScreenHeight - 90 - 2 * NavBarHeight,ScreenWidth - 40, 60)];
        self.bjview .backgroundColor = JGColor(104,127,124,1);
        self.bjview.layer.cornerRadius = 10;
        
        self.bjview.layer.masksToBounds = YES;
        
        UILabel * textLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.imageViewHead.frame.size.width+20, 7.5, 120, 45)];
        textLabel.text = @"分享点滴生活...";
        textLabel.textColor = [UIColor whiteColor];
        [self.bjview addSubview:textLabel];
        UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cameraButton setImage:[UIImage imageNamed:@"ys_healthycircle_menucamera"] forState:UIControlStateNormal];
//        cameraButton.origin = PublishCameraButtonRect.origin;
        cameraButton.frame = CGRectMake(self.bjview.frame.size.width-110, 7.5, 45, 45);

        [cameraButton addTarget:self action:@selector(cameraPublishAction) forControlEvents:UIControlEventTouchUpInside];
        self.cameraButton = cameraButton;
        
        UIButton *pictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [pictureButton setImage:[UIImage imageNamed:@"ys_healthycircle_menupicture"] forState:UIControlStateNormal];
//        pictureButton.origin = PublishPictureButtonRect.origin ;
        pictureButton.frame = CGRectMake(self.bjview.frame.size.width-55, 7.5, 45, 45);
        [pictureButton addTarget:self action:@selector(picturePublishAction) forControlEvents:UIControlEventTouchUpInside];
        self.pictureButton = pictureButton;
        [self.bjview  addSubview:cameraButton];
        [self.bjview  addSubview:pictureButton];
        [self.bjview  addSubview:self.imageViewHead];
        [_controllers.view addSubview:self.bjview];
    }
    return _controllers;
}
- (void)setStrHeadImageUrl:(NSString *)strHeadImageUrl{
    _strHeadImageUrl = strHeadImageUrl;
    [YSImageConfig sd_view:self.imageViewHead setImageWithURL:[NSURL URLWithString:strHeadImageUrl] placeholderImage:kDefaultUserIcon options:SDWebImageRefreshCached];
}
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
#pragma clang diagnostic pop
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

- (NSMutableArray *)selectedAssets {
    if (!_selectedAssets) {
        _selectedAssets = [[NSMutableArray alloc] init];
    }
    return _selectedAssets;
}

- (NSMutableArray *)selectedPhotos {
    if (!_selectedPhotos) {
        _selectedPhotos = [[NSMutableArray alloc] init];
    }
    return _selectedPhotos;
}

//- (void)publishAction:(UIButton *)button {
//    UNLOGIN_HANDLE
//    if (self.menuExpandStatus) {
//        /**
//         *  菜单展开 */
//        [self shrink:NULL];
//    }else {
//        /**
//         *  菜单收缩 */
//        [self expend];
//    }
//}

#pragma mark - UIImagePickerController
- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS8Later) {
        // 无权限 做一个友好的提示
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
#define push @#clang diagnostic pop
    } else { // 调用相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVc.sourceType = sourceType;
//            if(iOS8Later) {
//                _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//            }
            [self presentViewController:_imagePickerVc animated:YES completion:nil];
        } else {
            JGLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
}

- (void)pushImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePickerVc.allowTakePicture = NO;
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
#pragma mark - 到这里为止
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

/**
 *   使用手机拍照 */
- (void)cameraPublishAction {
    @weakify(self);
    [self showHud];
    [self toCheckUserIsBindTel:^(BOOL result) {
        @strongify(self);
        [self hiddenHud];
        if (result) {
            // 已绑定去拍照
//            [self shrink:^{
//                @strongify(self);
                [self takePhoto];
//            }];
        }else {
            // 未绑定，收缩
//            [self shrink:NULL];
        }
    }];
    
}

/**
 *  去图片库去选择图片 */
- (void)picturePublishAction {
    @weakify(self);
    [self showHud];
    [self toCheckUserIsBindTel:^(BOOL result) {
        @strongify(self);
        [self hiddenHud];
        if (result) {
//            // 已绑定去图片库选择照片
//            [self shrink:^{
                [self pushImagePickerController];
//            }];
        }else {
//            // 未绑定，收缩
//            [self shrink:NULL];
        }
    }];
}

/**
 *  去检查用户是否绑定过手机 */
- (void)toCheckUserIsBindTel:(bool_block_t)bindResult {
    [YSLoginManager thirdPlatformUserBindingCheckSuccess:^(BOOL isBinding, UIViewController *controller) {
        BLOCK_EXEC(bindResult,isBinding);
    } fail:^{
        [UIAlertView xf_showWithTitle:@"网络错误或数据出错!" message:nil delay:1.2 onDismiss:NULL];
    } controller:self unbindTelphoneSource:YSUserBindTelephoneSourceHealthyComposeStatusType isRemind:NO];
}

- (void)shrink:(voidCallback)completed {
    POPSpringAnimation *basicAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSize];
    basicAnimation.fromValue= [NSValue valueWithCGSize:CGSizeMake(40, 40)];
    basicAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(.001, .001)];
    [self.pictureButton.layer pop_addAnimation:basicAnimation forKey:@"picButtonshrink"];
    [self.cameraButton.layer pop_addAnimation:basicAnimation forKey:@"cameraButtonshrink"];
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    scaleAnimation.fromValue = @1;
    scaleAnimation.toValue = @0;
    scaleAnimation.springBounciness = 10.f;
    [self.pictureButton.layer pop_addAnimation:scaleAnimation forKey:@"picscaleShrinkAnimation"];
    [self.cameraButton.layer pop_addAnimation:scaleAnimation forKey:@"camerascaleShrinkAnimation"];
    
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    springAnimation.fromValue = [NSValue valueWithCGPoint:PublishPictureButtonRect.origin];
    springAnimation.toValue = [NSValue valueWithCGPoint:self.menuButton.center];
    [self.pictureButton pop_addAnimation:springAnimation forKey:@"picButtonShrinkSpring"];
    
    POPSpringAnimation *caremaSpringAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    caremaSpringAnimation.fromValue = [NSValue valueWithCGPoint:PublishCameraButtonRect.origin];
    caremaSpringAnimation.toValue = [NSValue valueWithCGPoint:self.menuButton.center];
    [self.cameraButton pop_addAnimation:caremaSpringAnimation forKey:@"shrinkCameraButtonSpring"];
    self.menuExpandStatus = NO;
    BLOCK_EXEC(completed);
}

- (void)expend {
    POPSpringAnimation *basicAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSize];
    basicAnimation.fromValue= [NSValue valueWithCGSize:CGSizeMake(0, 0)];
    basicAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(40, 40)];
    [self.pictureButton.layer pop_addAnimation:basicAnimation forKey:@"expendPicButtonExpand"];
    [self.cameraButton.layer pop_addAnimation:basicAnimation forKey:@"expendCameraButtonExpand"];
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    scaleAnimation.fromValue = @0;
    scaleAnimation.toValue = @1;
    scaleAnimation.springBounciness = 10.f;
    [self.pictureButton.layer pop_addAnimation:scaleAnimation forKey:@"expendPicturescaleAnimation"];
    [self.cameraButton.layer pop_addAnimation:scaleAnimation forKey:@"expendCamerascaleAnimation"];
    
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    springAnimation.fromValue = [NSValue valueWithCGPoint: PublishCenterButtonRect.origin];
    springAnimation.toValue = [NSValue valueWithCGPoint:PublishPictureButtonRect.origin];
    [self.pictureButton pop_addAnimation:springAnimation forKey:@"expendPicButtonSpring"];
    
    POPSpringAnimation *caremaSpringAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    caremaSpringAnimation.fromValue = [NSValue valueWithCGPoint:PublishCenterButtonRect.origin];
    caremaSpringAnimation.toValue = [NSValue valueWithCGPoint:PublishCameraButtonRect.origin];
    [self.cameraButton pop_addAnimation:caremaSpringAnimation forKey:@"expendCameraButtonSpring"];
    
    self.menuExpandStatus = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    @weakify(self);
    [YSImageUploadManage sharedInstance].composeResultCallback = ^(BOOL ret, NSString *extMsg) {
        if (ret) {
            JGLog(@"上传成功");
            @strongify(self);
            [YSNotificationConfig showIdentifyName:@"CircleComposeKey" barColor:JGBlackColor text:@"您的圈子发布成功!" duration:1.8];
            [self showHud];
            [YSFriendCircleRequestManager checkLoginStatus:^(BOOL loginStatus) {
                [self hiddenHud];
                [self showHud];
                [HealthyManageData circleDatasWithType:YSCircleDataWithAllType pageNumber:1 pageSize:10 success:^(NSArray *datas,YSLoginRequestStatus loginStatus) {
                    [self hiddenHud];
                    [self.currentController hiddenHud];
                    self.currentController.datas  = datas;
                    [self.currentController.tableView.mj_header endRefreshing];
                    
                } fail:^{
                    [self hiddenHud];
                    [self.currentController hiddenHud];
                    [self.currentController.tableView.mj_header endRefreshing];
                } loginStatus:loginStatus];
            }];
            
        }else {
            JGLog(@"上传失败");
//            NSString *text = [NSString stringWithFormat:@"发布失败!%@",extMsg];
//            [YSNotificationConfig showIdentifyName:@"CircleComposeKey" barColor:[UIColor redColor] text:text duration:2.4];
            NSTimeInterval delay = 0;
            delay = 2.4;
            if ([extMsg containsString:@"色情"]) {
                delay = 3.2;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIAlertView xf_showWithTitle:@"发布失败!" message:extMsg delay:delay onDismiss:NULL];
            });
        }
    };
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.barTintColor = [YSThemeManager themeColor];
    // 健康圈广告位信息请求
    [self requestHealthyCircleAdContent];
    // 弹框活动请求
    @weakify(self);
    [JGActivityHelper controllerDidAppear:@"healthcircle.com" requestStatus:^(YSActivityInfoRequestStatus status) {
        switch (status) {
            case YSActivityInfoRequestIdleStatus:
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [JGActivityHelper controllerDidAppear:@"healthcircle.com" requestStatus:NULL];
                });
            }
                break;
            default:
                break;
        }
    }];
    // 活动浮窗信息请求
    [JGActivityHelper controllerFloatImageDidAppear:@"healthcircle.com" result:^(BOOL ret, UIImage *floatImge, YSActivitiesInfoItem *actInfoItem,YSActivityInfoRequestStatus status) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.floatImageView.hidden = !ret;
            if (ret) {
                self.floatImageView.image = floatImge;
                self.actInfoItem = actInfoItem;
            }else {
                switch (status) {
                    case YSActivityInfoRequestIdleStatus:
                    {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [JGActivityHelper controllerFloatImageDidAppear:@"healthcircle.com" result:^(BOOL ret, UIImage *floatImge, YSActivitiesInfoItem *actInfoItem, YSActivityInfoRequestStatus status) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    self.floatImageView.hidden = !ret;
                                    if (ret) {
                                        self.actInfoItem = actInfoItem;
                                        self.floatImageView.image = floatImge;
                                    }
                                });
                            }];
                        });
                    }
                        break;
                    default:
                        break;
                }
            }
        });
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        AppDelegate *appDelegate = kAppDelegate;
        [appDelegate loadActivityNeedPop:NO];
    });
}

- (void)ruleItemAction {
    AboutYunEs *about = [[AboutYunEs alloc]initWithType:YSHtmlControllerWithFriendCircleRule];
    about.strUrl = [NSString stringWithFormat:@"%@/static/app/healthCirRules.html",StaticBase_Url];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:about];
    [self presentViewController:nav animated:YES completion:NULL];
}

- (void)viewWillDisappear:(BOOL)animated
{
     [self getUserInfo]; 
    [super viewWillDisappear:animated];
    // 友盟统计
    [YSUMMobClickManager endLogPageWithKey:kCommunityViewController];
    self.navigationController.navigationBar.barTintColor = COMMONTOPICCOLOR;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    self.navigationController.navigationBar.barTintColor = COMMONTOPICCOLOR;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    [self setup];
//    _sliderView
}

- (void)setup {
    [YSThemeManager setNavigationTitle:@"健康圈" andViewController:self];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = JGBaseColor;
    self.menuExpandStatus = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self addChildViewController:self.controllers];
    [self.view addSubview:self.controllers.view];
    [self.view setNeedsUpdateConstraints];
    self.menuLists = @[@"最新动态", @"热门动态"];
    [self.controllers.magicView reloadData];
    
    JGTouchEdgeInsetsButton *ruleButton = [JGTouchEdgeInsetsButton buttonWithType:UIButtonTypeCustom];
    ruleButton.width = 19.;
    ruleButton.height = 19.;
    ruleButton.touchEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
    [ruleButton addTarget:self action:@selector(ruleItemAction) forControlEvents:UIControlEventTouchUpInside];
    [ruleButton setImage:[UIImage imageNamed:@"ys_friendcircle_rule"] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:ruleButton];
    self.navigationItem.rightBarButtonItem = item;
    
    UIImageView *floatImageView = [UIImageView new];
    floatImageView.width = 90;
    floatImageView.height = 90;
    floatImageView.x = ScreenWidth - floatImageView.width - 12.;
    floatImageView.y = ScreenHeight - NavBarHeight * 2 - floatImageView.height - 6 - 112;
    floatImageView.userInteractionEnabled = YES;
    floatImageView.contentMode = UIViewContentModeScaleAspectFit;
    @weakify(self);
    [floatImageView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        @strongify(self);
        [self enterActivityH5Controller];
    }];
    floatImageView.hidden = YES;
    self.floatImageView = floatImageView;
    [self.view addSubview:self.floatImageView];
}

#pragma mark  健康圈广告位信息请求
- (void)requestHealthyCircleAdContent {
    @weakify(self);
    [[YSConfigAdRequestManager sharedInstance] requestAdContent:YSAdContentWithHealthyCircleType cacheItem:^(YSAdContentItem *cacheItem) {
        return;
        @strongify(self);
        [self handleAdContentItem:cacheItem];
    } result:^(YSAdContentItem *adContentItem) {
        @strongify(self);
        if (!adContentItem) {
            [self handleAdContentItem:adContentItem];

        }else {
            if ([adContentItem.receiveCode isEqualToString:[[YSConfigAdRequestManager sharedInstance] requestAdContentCodeWithRequestType:YSAdContentWithHealthyCircleType]]) {
                [self handleAdContentItem:adContentItem];
            }
        }
    }];
    
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *name = [defaults objectForKey:@"guize"];
    
  if (name.length==0) {
        [self inttguize];
     }
    
}

- (void)handleAdContentItem:(YSAdContentItem *)adContentItem {
    if (adContentItem) {
        JGLog(@"存在");
    }else {
        JGLog(@"不存在");
    }
    if (!adContentItem) {
        _controllers.magicView.headerHeight = 0;
        [_controllers.magicView setHeaderHidden:YES duration:0.];
        return;
    }
    if (!self.headerView) {
         @weakify(self);
        YSCommunityHeaderView *headerView = [[YSCommunityHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, adContentItem.adTotleHeight) clickHeaderViewAdContentItem:^(YSNearAdContent *adContentModel) {
            @strongify(self);
            [self clickAdvertItem:adContentModel];
        }];
        [self.controllers.magicView.headerView addSubview:headerView];
        self.headerView = headerView;
    }
    self.headerView.height = adContentItem.adTotleHeight;
    self.headerView.adContentItem = adContentItem;
    [self configMagicViewHeaderHeight:adContentItem.adTotleHeight];
}

- (void)configMagicViewHeaderHeight:(CGFloat)height {
    if (height == _controllers.magicView.headerHeight) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _controllers.magicView.headerHeight = height;
            [_controllers.magicView setHeaderHidden:NO duration:0.12];
        });
    }else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.08 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _controllers.magicView.headerHeight = height;
            [_controllers.magicView setHeaderHidden:NO duration:0.23];
        });
    }
}

- (void)enterActivityH5Controller {
    YSActivityController *activityH5Controller = [[YSActivityController alloc] init];
    activityH5Controller.activityInfoItem = self.actInfoItem;
    [self.navigationController pushViewController:activityH5Controller animated:YES];
}

- (void)publishButtonAction {
    
}

- (void)updateViewConstraints {
    UIView *magicView = self.controllers.view;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[magicView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(magicView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[magicView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(magicView)]];
    
    [super updateViewConstraints];
}

#pragma mark - VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    return self.menuLists;
}


- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:[UIColor colorWithHexString:@"#9b9b9b"] forState:UIControlStateNormal];
        [menuItem setTitleColor:rgb(96, 187, 177, 1) forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.f];
    }
    return menuItem;
}
- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    static NSString *gridId = @"relate.identifier";
    YSFriendCircleController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
    if (!viewController) {
        viewController = [[YSFriendCircleController alloc] init];
        viewController.bjview = _bjview;
//         self.currentController.tableView.delegate = self;
    }
    return viewController;
}

- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof YSFriendCircleController *)viewController atPage:(NSUInteger)pageIndex
{
    if (!viewController) {
        return;
    }
    if (pageIndex == 0) {
        self.currentController = viewController;
//        self.currentController.tableView.delegate = self;
        
        self.currentController.bjview = _bjview;
        
        
    }
    @weakify(self);
    [YSFriendCircleRequestManager checkLoginStatus:^(BOOL loginStatus) {
        @strongify(self);
        [self controller:viewController atPage:pageIndex loginStatus:loginStatus];
    }];
}


- (void)controller:(YSFriendCircleController *)viewController atPage:(NSUInteger)pageIndex loginStatus:(BOOL)loginStatus{
    YSCircleDataType type;
    if (pageIndex == 0) {
        type = YSCircleDataWithAllType;
    }else {
        type = YSCircleDataWithHotType;
    }
    
    @weakify(self);
    if (viewController.datas) {
        // 有数据时，但不操作
    }else {
        [self showHud];
        [HealthyManageData circleDatasWithType:type pageNumber:1 pageSize:10 success:^(NSArray *datas,YSLoginRequestStatus loginStatus) {
            @strongify(self);
            [self hiddenHud];
            viewController.datas  = datas;
            
        } fail:^{
            @strongify(self);
            [self hiddenHud];
            JGLog(@"fail");
        } loginStatus:loginStatus];
        
    }
    
    @weakify(viewController);
    [viewController configTableViewHeaderRefresh];
    [viewController configTableViewFooterFefresh];
    viewController.headerCallback = ^(){
        @strongify(viewController);
        [viewController showHud];
        [self requestHealthyCircleAdContent];
        @weakify(viewController);
        [YSFriendCircleRequestManager checkLoginStatus:^(BOOL headerLoginStatusStatus) {
            /**
             *  全部 */
            JGLog(@"全部----刷新");
            @strongify(viewController);
            [HealthyManageData circleDatasWithType:type pageNumber:1 pageSize:10 success:^(NSArray *datas,YSLoginRequestStatus loginStatus) {
                [viewController hiddenHud];
                viewController.datas  = datas;
                [viewController.tableView.mj_header endRefreshing];
                
            } fail:^{
                [viewController hiddenHud];
                [viewController.tableView.mj_header endRefreshing];
            } loginStatus:headerLoginStatusStatus];

        }];
    };
    
    viewController.footerCallback = ^(){
        @strongify(viewController);
        [viewController showHud];
        [YSFriendCircleRequestManager checkLoginStatus:^(BOOL footerLoginStatus) {
            /**
             *  全部 */
            if (viewController.currentRequestPage == 1) {
                viewController.currentRequestPage = 2;
            }
            JGLog(@"全部----加载更多 page:%zd",viewController.currentRequestPage);
            [HealthyManageData circleDatasWithType:type pageNumber:viewController.currentRequestPage pageSize:10 success:^(NSArray *datas,YSLoginRequestStatus loginStatus) {
                [viewController hiddenHud];
                viewController.moreDatas  = datas;
                [viewController.tableView.mj_footer endRefreshing];
            } fail:^{
                [viewController hiddenHud];
                [viewController.tableView.mj_footer endRefreshing];
            } loginStatus:footerLoginStatus];
 
        }];
    };
    
    viewController.didSelectedRowCallback = ^(NSInteger indexPathRow) {
        @strongify(self);
        if (self.menuExpandStatus) {
            [self shrink:NULL];
        }
    };
 
    viewController.shrinkMenuCallback = ^(){
        @strongify(self);
        if (self.menuExpandStatus) {
            [self shrink:NULL];
        }
    };
}

#pragma mark -- UIImagePickerControllerDelegate --
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    [self dismissViewControllerAnimated:NO completion:^{

    }];
    [self.selectedPhotos removeAllObjects];
    [self.selectedAssets removeAllObjects];
    [self.selectedPhotos xf_safeAddObjectsFromArray:photos];
    [self.selectedAssets  xf_safeAddObjectsFromArray:assets];
    if (photos.count) {
        [self presentControllerWithPhotos:[self.selectedPhotos copy] assets:[self.selectedAssets copy]];
    }
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    self.selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    self.selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        @weakify(self);
        [[TZImageManager manager] savePhotoWithImage:image completion:^{
            @strongify(self);
            [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                    [tzImagePickerVc hideProgressHUD];
                    TZAssetModel *assetModel = [models lastObject];
                    [self.selectedAssets removeAllObjects];
                    [self.selectedPhotos removeAllObjects];
                    [self.selectedAssets xf_safeAddObject:assetModel.asset];
                    [self.selectedPhotos  xf_safeAddObject:image];
                    if (image && assetModel) {
                        [self presentControllerWithPhotos:[self.selectedPhotos copy] assets:[self.selectedAssets copy]];
                    }
                    /**
                     *  拍摄时一张图片 */
                }];
            }];
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

// _selectedPhotos _selectedAssets
- (void)presentControllerWithPhotos:(NSArray *)photos assets:(NSArray *)assets {
    YSComposeStatusController *composeStatusController = [[YSComposeStatusController alloc] init];
    composeStatusController.selectedPhotos = [NSMutableArray arrayWithArray:photos];
    composeStatusController.selectedAssets = [NSMutableArray arrayWithArray:assets];
    @weakify(self);
    @weakify(composeStatusController);
    
    composeStatusController.composeCallback = ^(){
        
        JGLog(@"composed");
    };
    
    composeStatusController.cancelCallback = ^(){
        @strongify(self);
        @strongify(composeStatusController);
        [composeStatusController.selectedAssets removeAllObjects];
        [composeStatusController.selectedPhotos removeAllObjects];
        [self.selectedPhotos removeAllObjects];
        [self.selectedAssets removeAllObjects];
    };
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:composeStatusController];
    [self presentViewController:nav animated:NO completion:NULL];
}
#pragma mark --- 积分商城首页广告模板点击事件处理
- (void)clickAdvertItem:(YSNearAdContent *)adItem {
    if ([adItem.needLogin integerValue]) {
        // 需要登录
        BOOL ret = CheckLoginState(YES);
        if (!ret) {
            // 没登录 直接返回
            return;
        }
    }
    [YSUMMobClickManager beginLogPageWithKey:[NSString stringWithFormat:@"%@%@%@%ld",@"um_",@"Shop_",@"adItemIndex_",adItem.type]];
    switch (adItem.type) {
        case 1:
        {
            if ([adItem.link containsString:@"ys.zjtech.cc"]) {
                //是酒业
                YSLiquorDomainWebController *liquorDomainWebVC = [[YSLiquorDomainWebController alloc]initWithUrlType:YSLiquorDomainZoneType];
                liquorDomainWebVC.strUrl = adItem.link;
                [self.navigationController pushViewController:liquorDomainWebVC animated:YES];
            }else if ([adItem.link containsString:@"union.juanpi.com"]){
                //卷皮商品
                YSJuanPiWebViewController *juanPiVC = [[YSJuanPiWebViewController alloc]initWithUrlType:YSGoodsDetileType];
                juanPiVC.goodsID  = [juanPiVC getJuanPiGoodsIdWithJuanPiGoodsUrl:adItem.link];
                juanPiVC.strWebUrl = adItem.link;
                [self.navigationController pushViewController:juanPiVC animated:YES];
            }else{
                //其他链接
                NSString *appendUrlString;
                if([adItem.link rangeOfString:@"?"].location !=NSNotFound)//_roaldSearchText
                {
                    appendUrlString = [NSString stringWithFormat:@"%@&cityName=%@",adItem.link,[YSLocationManager currentCityName]];
                }else{
                    appendUrlString = [NSString stringWithFormat:@"%@?cityName=%@",adItem.link,[YSLocationManager currentCityName]];
                }
                appendUrlString = [appendUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                // 链接
                YSLinkElongHotelWebController *elongHotelWebController = [[YSLinkElongHotelWebController alloc] initWithWebUrl:appendUrlString];
                elongHotelWebController.hidesBottomBarWhenPushed = YES;
                elongHotelWebController.navTitle = adItem.name;
                [self.navigationController pushViewController:elongHotelWebController animated:YES];
            }
        }
            break;
        case 2:
        {
            //  商品
            KJGoodsDetailViewController *goodsDetailVC = [[KJGoodsDetailViewController alloc] init];
            goodsDetailVC.goodsID = [NSNumber numberWithInteger:[adItem.link integerValue]];
            goodsDetailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:goodsDetailVC animated:YES];
        }
            break;
        case 5:
        {
            // 商户详情
            WSJMerchantDetailViewController *goodStoreVC = [[WSJMerchantDetailViewController alloc] init];
            goodStoreVC.api_classId = [NSNumber numberWithInteger:[adItem.link integerValue]];
            goodStoreVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:goodStoreVC animated:YES];
        }
            break;
        case 6:
        {
            //服务详情
            ServiceDetailController *serviceDetailVC = [[ServiceDetailController alloc] init];
            serviceDetailVC.serviceID = [NSNumber numberWithInteger:[adItem.link integerValue]];
            serviceDetailVC.hidesBottomBarWhenPushed = YES;
            if ([YSSurroundAreaCityInfo isElseCity]) {
                serviceDetailVC.api_areaId = [YSSurroundAreaCityInfo achieveElseSelectedAreaInfo].areaId;
            }else {
                YSLocationManager *locationManager = [YSLocationManager sharedInstance];
                serviceDetailVC.api_areaId = locationManager.cityID;
            }
            [self.navigationController pushViewController:serviceDetailVC animated:YES];
        }
            break;
        case 7:
        {
            // 原生类别区分 link
            if ([adItem.link isEqualToString:YSAdvertOriginalTypeAIO]) {
                YSHealthAIOController *healthAIOController = [[YSHealthAIOController alloc] init];
                healthAIOController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:healthAIOController animated:YES];
            }else if ([adItem.link isEqualToString:YSAdvertOriginalTypeCYDoctor]) {
                // 春雨医生
                [self showHud];
                @weakify(self);
                @weakify(adItem);
                [YSHealthyMessageDatas  chunYuDoctorUrlRequestWithResult:^(BOOL ret, NSString *msg) {
                    @strongify(self);
                    @strongify(adItem);
                    [self hiddenHud];
                    if (ret) {
                        YSLinkCYDoctorWebController *cyDoctorController = [[YSLinkCYDoctorWebController alloc] initWithWebUrl:msg];
                        cyDoctorController.navTitle = adItem.name;
                        cyDoctorController.tag = 100;
                        cyDoctorController.controllerPushType = YSControllerPushFromHealthyManagerType;
                        [self.navigationController pushViewController:cyDoctorController animated:YES];
                    }else {
                        [UIAlertView xf_showWithTitle:msg message:nil delay:2.0 onDismiss:NULL];
                    }
                }];
            }
        }
            break;
        default:
            break;
    }
    
    
    
    
}
- (UIImageView *)imageViewHead {
    if (!_imageViewHead) {
   
        
        _imageViewHead = [[UIImageView alloc] init];
        _imageViewHead.userInteractionEnabled = YES;
        NSDictionary *dic = [kUserDefaults objectForKey:userInfoKey];
        
        [YSImageConfig sd_view:_imageViewHead setimageWithURL:[NSURL URLWithString:dic[@"headImgPath"]] placeholderImage:kDefaultUserIcon];
        _imageViewHead.contentMode = UIViewContentModeScaleAspectFill;
        _imageViewHead.frame = CGRectMake(15,7.5,45,45);
        _imageViewHead.layer.cornerRadius = 45 / 2.0;
        _imageViewHead.clipsToBounds = YES;
    }
    return _imageViewHead;
}
//获取用户信息
-(void)getUserInfo
{

    NSString *accessToken = [userDefaultManager GetLocalDataString:@"Token"];
    UsersCustomerSearchRequest * usersCustomerSearchRequest = [[UsersCustomerSearchRequest alloc]init:accessToken];

    [self.vapiManager usersCustomerSearch:usersCustomerSearchRequest success:^(AFHTTPRequestOperation *operation, UsersCustomerSearchResponse *response) {
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:nil];
        NSDictionary   *dictUserList = [dict objectForKey:@"customer"];

        NSLog(@"2222221232%@",dictUserList[@"headImgPath"]);

//        头像url
        self.strHeadImageUrl = [YSThumbnailManager personalCenterUserHeaderPhotoPicUrlString:[NSString stringWithFormat:@"%@",dictUserList[@"headImgPath"]]];
//






        [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserHeadImgChangedNotification" object:[dictUserList objectForKey:@"headImgPath"]];

        [[NSUserDefaults standardUserDefaults]setObject:dictUserList forKey:kUserCustomerKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showSuccess:@"网络错误，请检查网络" toView:self.view delay:1];
    }
        ];

}

- (VApiManager *)vapiManager
{
    if (_vapiManager == nil) {
        _vapiManager = [[VApiManager alloc ]init];
    }
    return _vapiManager;
}

-(void)inttguize{
    guizeViewController *gVC = [[guizeViewController alloc] init];
    //设置ViewController的背景颜色及透明度

    gVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
  //  gVC.view.window.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    gVC.modalPresentationStyle = UIModalPresentationCustom;
    //设置NavigationController根视图
//    UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:gVC];
//    //设置NavigationController的模态模式，即NavigationController的显示方式
//   navigation.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.modalPresentationStyle = UIModalPresentationCustom;
    //加载模态视图
    [self presentModalViewController:gVC animated:YES];
}


@end
