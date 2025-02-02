//  好用请star：https://github.com/AllLuckly/LBLaunchImageAd
//  LBLaunchImageAdView.m
//  LBLaunchImageAd
//  技术交流群：534926022（免费） 511040024(0.8元/人付费)
//  Created by gold on 16/6/8.
//  Copyright © 2016年 Bison. All rights reserved.
//  iOS开发学习app下载https://itunes.apple.com/cn/app/it-blog-for-ios-developers/id1067787090?mt=8

#import "LBLaunchImageAdView.h"
//#import "UIImageView+WebCache.h"
#import "YSImageConfig.h"
#import "YSConfigAdRequestManager.h"

#define mainHeight      [[UIScreen mainScreen] bounds].size.height
#define mainWidth       [[UIScreen mainScreen] bounds].size.width

@interface LBLaunchImageAdView()
{
    NSTimer *countDownTimer;
}

@property (strong, nonatomic) NSString *isClick;

@end

@implementation LBLaunchImageAdView

#pragma mark - 获取广告类型
- (void (^)(AdType adType))getLBlaunchImageAdViewType{
    __weak typeof(self) weakSelf = self;
    return ^(AdType adType){
        [weakSelf addLBlaunchImageAdView:adType];
    };
}

#pragma mark - 点击广告
- (void)activiTap:(UITapGestureRecognizer*)recognizer{
    if (![[YSConfigAdRequestManager sharedInstance] screenLanuchAdIsClick]) {
        JGLog(@"设置点击了");
        [[YSConfigAdRequestManager sharedInstance] configClickedScreenLanuchAd];
    }else {
        JGLog(@"已经点击了");
        return;
    }
    _isClick = @"1";
    [self startcloseAnimation];
}

#pragma mark - 开启关闭动画
- (void)startcloseAnimation{
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = 0.28;
    opacityAnimation.fromValue = [NSNumber numberWithFloat:0.9];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.2];
    opacityAnimation.removedOnCompletion = NO;
    opacityAnimation.fillMode = kCAFillModeForwards;
    
    [self.aDImgView.layer addAnimation:opacityAnimation forKey:@"animateOpacity"];
    [NSTimer scheduledTimerWithTimeInterval:opacityAnimation.duration
                                     target:self
                                   selector:@selector(closeAddImgAnimation)
                                   userInfo:nil
                                    repeats:NO];    
}

- (void)skipBtnClick{
    _isClick = @"2";
    [self startcloseAnimation];
}

#pragma mark - 关闭动画完成时处理事件
-(void)closeAddImgAnimation
{
    [countDownTimer invalidate];
    countDownTimer = nil;
    self.hidden = YES;
    self.aDImgView.hidden = YES;
    [self removeFromSuperview];
    if ([_isClick integerValue] == 1) {
        if (self.clickBlock) {//点击广告
            self.clickBlock(clickAdType,self);
        }
    }else if([_isClick integerValue] == 2){
        if (self.clickBlock) {//点击跳过
            self.clickBlock(skipAdType,self);
        }
    }else{
        if (self.clickBlock) {
            self.clickBlock(overtimeAdType,self);
        }
    }
}

- (void)onTimer {
    if (_adTime == 0) {
        [countDownTimer invalidate];
        countDownTimer = nil;
        [self startcloseAnimation];
    }else{
        [self.skipBtn setTitle:[NSString stringWithFormat:@"%@ | 跳过",@(_adTime--)] forState:UIControlStateNormal];
    }
}

#pragma mark - 指定宽度按比例缩放
- (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    //    UIGraphicsBeginImageContext(size);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)setLocalAdImgName:(NSString *)localAdImgName{
    _localAdImgName = localAdImgName;
    if (_localAdImgName.length > 0) {
        if ([_localAdImgName rangeOfString:@".gif"].location  != NSNotFound ) {
            _localAdImgName  = [_localAdImgName stringByReplacingOccurrencesOfString:@".gif" withString:@""];
            
            
            NSData *gifData = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:_localAdImgName ofType:@"gif"]];
            UIWebView *webView = [[UIWebView alloc] initWithFrame:self.aDImgView.frame];
            webView.backgroundColor = [UIColor clearColor];
            webView.scalesPageToFit = YES;
            webView.scrollView.scrollEnabled = NO;
            [webView loadData:gifData MIMEType:@"image/gif" textEncodingName:@"" baseURL:[NSURL URLWithString:@""]];
            [webView setUserInteractionEnabled:NO];
            UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            clearBtn.frame = webView.frame;
            clearBtn.backgroundColor = [UIColor clearColor];
            [clearBtn addTarget:self action:@selector(activiTap:) forControlEvents:UIControlEventTouchUpInside];
            [webView addSubview:clearBtn];
            [self.aDImgView addSubview:webView];
            [self.aDImgView bringSubviewToFront:_skipBtn];
        }else{
            self.aDImgView.image = [UIImage imageNamed:_localAdImgName];
        }
    }
}

#pragma mark - pod 'SDWebImage','~> 4.0.0' 更新
//-(void)setImgUrl:(NSString *)imgUrl{
//    _imgUrl = imgUrl;
//    [_aDImgView sd_setImageWithURL:[NSURL URLWithString:_imgUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        if(image){
//            [self.aDImgView setImage:[self imageCompressForWidth:image targetWidth:mainWidth]];
//        }
//    }];
//}
- (void)setAdItem:(YSSLAdItem *)adItem {
    _adItem = adItem;
//     本地存储
//    [[YSConfigAdRequestManager sharedInstance] saveScreenLauchCacheWithAdItem:adItem];
    [YSImageConfig yy_requestImageWithURL:[NSURL URLWithString:adItem.adImgPath] options:YYWebImageOptionAllowBackgroundTask progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
        return image;
    } completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (image) {
            [self.aDImgView setImage:[self imageCompressForWidth:image targetWidth:mainWidth]];
        }
    }];
}


- (void)addLBlaunchImageAdView:(AdType)adType{
    #pragma mark - iOS开发 强制竖屏。系统KVO 强制竖屏—>适用于支持各种方向屏幕启动时，竖屏展示广告 by:nixs
    NSNumber * orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    //倒计时时间
    _adTime = 3;
    [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
    NSString *launchImageName = [self getLaunchImage:@"Portrait"];
    UIImage * launchImage = [UIImage imageNamed:launchImageName];
    self.backgroundColor = [UIColor colorWithPatternImage:launchImage];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.backgroundColor = [UIColor clearColor];
    });
    self.frame = CGRectMake(0, 0, mainWidth, mainHeight);
    if (adType == FullScreenAdType) {
        self.aDImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mainWidth, mainHeight)];
    }else{
        self.aDImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mainWidth, mainHeight - mainWidth/3)];
    }
    self.aDImgView.backgroundColor = [UIColor whiteColor];
    self.skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.skipBtn.frame = CGRectMake(mainWidth - 88, 30, 68, 28);
    self.skipBtn.backgroundColor = [UIColor blackColor];
    self.skipBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.skipBtn.alpha = 0.56;
    [self.skipBtn addTarget:self action:@selector(skipBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.aDImgView addSubview:self.skipBtn];
    self.skipBtn.layer.cornerRadius = 14.0;
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.skipBtn.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = self.skipBtn.bounds;
//    maskLayer.path = maskPath.CGPath;
//    self.skipBtn.layer.mask = maskLayer;
    self.aDImgView.tag = 1101;
    [self addSubview:self.aDImgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(activiTap:)];
    // 允许用户交互
    self.aDImgView.userInteractionEnabled = YES;
    [self.aDImgView addGestureRecognizer:tap];
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = 0.8;
    opacityAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.8];
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.aDImgView.layer addAnimation:opacityAnimation forKey:@"animateOpacity"];
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    // 开始进入启动广告页
    [[YSConfigAdRequestManager sharedInstance] startLaunchScreenAdPage];
    [[UIApplication sharedApplication].delegate.window addSubview:self];
}

/*
 *viewOrientation 屏幕方向
 */
- (NSString *)getLaunchImage:(NSString *)viewOrientation{
    //获取启动图片
    CGSize viewSize = [UIApplication sharedApplication].delegate.window.bounds.size;
    //横屏请设置成 @"Landscape"|Portrait
//    NSString *viewOrientation = @"Portrait";
    __block NSString *launchImageName = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    [imagesDict enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGSize imageSize = CGSizeFromString(obj[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:obj[@"UILaunchImageOrientation"]])
        {
            launchImageName = obj[@"UILaunchImageName"];
        }
    }];
    return launchImageName;
}



@end
