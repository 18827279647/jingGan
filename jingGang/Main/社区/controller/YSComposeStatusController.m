//
//  YSComposeStatusController.m
//  jingGang
//
//  Created by dengxf on 16/8/2.
//  Copyright © 2016年 Dengxf_Dev. All rights reserved.
//

#import "YSComposeStatusController.h"
#import "UIColor+YYAdd.h"
#import "YYTextKeyboardManager.h"
#import "YYKit.h"
#import "YSStatusComposeTextParser.h"
#import "YSFriendCircleRequestManager.h"
#import "YSHealthyCircleAddImageView.h"
#import "YSTopicSearchController.h"
#import "AFHTTPRequestOperationManager.h"
#import "YSFriendCircleLocationController.h"
#import "YSCirclePositionButton.h"
#import "UIImage+SizeAndTintColor.h"
#import "LxGridViewFlowLayout.h"
#import "TZTestCell.h"
#import "TZImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZVideoPlayerController.h"
#import "TZImageManager.h"
#import "UIAlertView+Extension.h"
#import "YSImageUploadManage.h"
#import "YSLoginManager.h"

#define kToolbarHeight (35 + 46)

@interface YSComposeStatusController ()<YYTextKeyboardObserver,YYTextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) YYTextView *textView;
@property (nonatomic, strong) UIView *toolbar;
@property (nonatomic, strong) UIView *toolbarBackground;
@property (nonatomic, strong) UIButton *toolbarPOIButton;
@property (nonatomic, strong) UIButton *toolbarPictureButton;
@property (nonatomic, strong) UIButton *toolbarTopicButton;

/**
 *  addimage */
@property (assign, nonatomic) NSInteger imagesCount;
/**
 *  当前已选图片 */
@property (strong,nonatomic) UIImage *currentSelectedImage;

/**
 *  已上传成功的图片 */
@property (strong,nonatomic) UIImage *didSuccessUploadImage;

@property (strong,nonatomic) UIImageView *addImageView;

@property (strong,nonatomic) UIView *imageBackgroundView;

@property (strong,nonatomic) NSMutableArray *imagesPathArray;

@property (assign, nonatomic) YSComposeImageType imageType;

@property (strong,nonatomic) YSCirclePositionButton *positionButton;

@property (copy , nonatomic) NSString *composePosition;

/**
 *  添加标签的集合 */
@property (strong,nonatomic) NSMutableArray *labels;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (assign, nonatomic) CGFloat cellItemWidth;

@property (strong,nonatomic)  LxGridViewFlowLayout *layout;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@property (assign,nonatomic) CGFloat margin;

#define MagrinX  15.0f
#define MagrinImageWidth 12
#define SelectedImageHW (ScreenWidth - MagrinX * 2 - MagrinImageWidth * 2) / 3


@end

@implementation YSComposeStatusController

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

- (NSMutableArray *)imagesPathArray {
    if (!_imagesPathArray) {
        _imagesPathArray = [NSMutableArray array];
    }
    return _imagesPathArray;
}

- (NSMutableArray *)labels {
    if (!_labels) {
        _labels = [NSMutableArray array];
    }
    return _labels;
}

- (instancetype)initWithImageType:(YSComposeImageType)imageType
{
    self = [super init];
    if (self) {
        self.imageType = imageType;
        [[YYTextKeyboardManager defaultManager] addObserver:self];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[YYTextKeyboardManager defaultManager] addObserver:self];
    }
    return self;
}

- (instancetype)initWithPhotos:(NSArray *)photos assets:(NSArray *)assets
{
    self = [super init];
    if (self) {
        self.selectedPhotos = [NSMutableArray arrayWithArray:photos];
        self.selectedAssets = [NSMutableArray arrayWithArray:assets];
        [[YYTextKeyboardManager defaultManager] addObserver:self];
    }
    return self;
}

- (void)setSelectedAssets:(NSMutableArray *)selectedAssets {
    _selectedAssets = selectedAssets;

}

- (void)setSelectedPhotos:(NSMutableArray *)selectedPhotos {
    _selectedPhotos = selectedPhotos;
}

- (void)dealloc {
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setup];
}

- (void)setup {
    self.view.backgroundColor = JGBaseColor;
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    [self _initNavBar];
    [self _initTextView];
    [self buildTextViewSubviews];
    [self buildAddImageView];
    [self _initToolbar];
}

- (void)buildTextViewSubviews {
    UIView *addImageView = [UIView new];
    addImageView.x = 0;
    addImageView.y = 120;
    addImageView.width = ScreenWidth;
    addImageView.height = SelectedImageHW * 3 + 2 * MagrinImageWidth;
    addImageView.backgroundColor = JGClearColor;
    [_textView addSubview:addImageView];
    self.imageBackgroundView = addImageView;
}

- (void)buildAddImageView {
    self.layout = [[LxGridViewFlowLayout alloc] init];
    self.margin = 4;
    self.cellItemWidth = (self.view.width - 2 * self.margin - 4) / 3 - self.margin;
    self.layout.itemSize = CGSizeMake(self.cellItemWidth, self.cellItemWidth);
    self.layout.minimumInteritemSpacing = self.margin;
    self.layout.minimumLineSpacing = self.margin;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.imageBackgroundView.height) collectionViewLayout:self.layout];
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.backgroundColor = JGWhiteColor;
    self.collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.imageBackgroundView addSubview:self.collectionView];
    [self.collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];

    return;
    UIImageView *addImageView = [[UIImageView alloc] init];
    addImageView.x = MagrinX ;
    addImageView.y = 0;
    addImageView.width = SelectedImageHW;
    addImageView.height = addImageView.width;
    addImageView.userInteractionEnabled = YES;
    addImageView.image = [UIImage imageNamed:@"ys_healthymanage_addimage"];
    [self.imageBackgroundView addSubview:addImageView];
    self.addImageView = addImageView;
    
    @weakify(self);
    [addImageView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        @strongify(self);
        switch (self.imageType) {
            case YSComposeImageWithCameraType:
                [self modifyHeadByCamera];
                break;
            case YSComposeImageWithPictureType:
                [self modifyHeadByChoose];
                break;
            default:
                break;
        }
    }];
}

/**
 *   使用手机拍照 */
- (void)modifyHeadByCamera
{
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
            if(iOS8Later) {
                _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self presentViewController:_imagePickerVc animated:YES completion:nil];
        } else {
            JGLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
   
}

/**
 *  从相册中选择图片 */
- (void) modifyHeadByChoose
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    
    // 1.如果你需要将拍照按钮放在外面，不要传这个参数
    imagePickerVc.selectedAssets = _selectedAssets; // optional, 可选的
//    imagePickerVc.allowTakePicture = self.showTakePhotoBtnSwitch.isOn; // 在内部显示拍照按钮
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    
    // 4. 照片排列按修改时间升序
//    imagePickerVc.sortAscendingByModificationDate = self.sortAscendingSwitch.isOn;
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)_initTextView {
    if (_textView) return;
    _textView = [YYTextView new];
    if (kSystemVersion < 7) _textView.top = -76;
    _textView.top = 12;
    _textView.canCancelContentTouches = NO;
    _textView.size = CGSizeMake(self.view.width, self.view.height);
    _textView.textContainerInset = UIEdgeInsetsMake(0, 16, 12, 6);
    _textView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _textView.extraAccessoryViewHeight = 0;
    _textView.showsVerticalScrollIndicator = NO;
    _textView.alwaysBounceVertical = YES;
    _textView.allowsCopyAttributedString = NO;
    _textView.font = JGFont(16);
    _textView.textParser = [YSStatusComposeTextParser new];
    _textView.delegate = self;
    _textView.inputAccessoryView = [UIView new];
    _textView.backgroundColor = JGWhiteColor;
    
    NSString *placeholderPlainText = nil;
    placeholderPlainText = @"这一刻的想法...";
    
    if (placeholderPlainText) {
        NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:placeholderPlainText];
        atr.color = UIColorHex(b4b4b4);
        atr.font = [UIFont systemFontOfSize:17];
        _textView.placeholderAttributedText = atr;
    }
    
    [self.view addSubview:_textView];
//    [_textView becomeFirstResponder];
}

- (void)_initNavBar {
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(_cancel)];
    [button setTitleTextAttributes:@{NSFontAttributeName : JGFont(16),
                                     NSForegroundColorAttributeName : JGWhiteColor } forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = button;
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(pushlish)];
    [rightButton setTitleTextAttributes:@{NSFontAttributeName : JGFont(16),
                                          NSForegroundColorAttributeName : JGWhiteColor} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightButton;
    self.navigationController.navigationBar.backgroundColor=  [YSThemeManager themeColor];
}

- (void)_initToolbar {
    if (_toolbar) return;
    _toolbar = [UIView new];
    _toolbar.backgroundColor = [UIColor whiteColor];
    _toolbar.size = CGSizeMake(self.view.width, kToolbarHeight);
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    _toolbarBackground = [UIView new];
    _toolbarBackground.backgroundColor = UIColorHex(F9F9F9);
    _toolbarBackground.size = CGSizeMake(_toolbar.width, 46);
    _toolbarBackground.bottom = _toolbar.height;
    _toolbarBackground.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [_toolbar addSubview:_toolbarBackground];
    
    _toolbarBackground.height = 100; // extend
    
    UIView *line = [UIView new];
    line.backgroundColor = UIColorHex(BFBFBF);
    line.width = _toolbarBackground.width;
    line.height = CGFloatFromPixel(1);
    line.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_toolbarBackground addSubview:line];
    
    @weakify(self);
    YSCirclePositionButton *positionButton = [[YSCirclePositionButton alloc] initWithFrame:(CGRect){{5,4},{88,26} } showCloseButton:NO selecte:^{
        @strongify(self);
        [self findLocation];
    } close:^{
        
        @strongify(self);
        self.positionButton.width = 88;
        [self.positionButton revert];
        self.composePosition = @"";
    }];
    positionButton.backgroundColor = JGClearColor;
    [_toolbar addSubview:positionButton];
    self.positionButton = positionButton;
    
//    _toolbarPictureButton = [self _toolbarButtonWithImage:@"compose_toolbar_picture"
//                                                highlight:@"compose_toolbar_picture_highlighted"];
    _toolbarTopicButton = [self _toolbarButtonWithImage:@"compose_trendbutton_background"
                                              highlight:@"compose_trendbutton_background_highlighted"];

    
    CGFloat one = _toolbar.width / 5;
//    _toolbarPictureButton.centerX = one * 0.5;
    _toolbarTopicButton.centerX = one * 0.5;
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.width = 100;
    doneButton.height = 46;
    doneButton.x = _toolbarBackground.width - doneButton.width;
    doneButton.y = 0;
    [doneButton setTitle:@"   完成" forState:UIControlStateNormal];
    doneButton.titleLabel.font = JGFont(16);
    [doneButton setTitleColor:JGBlackColor forState:UIControlStateNormal];
    doneButton.backgroundColor = JGClearColor;
    [doneButton addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    [_toolbarBackground  addSubview:doneButton];
    _toolbar.bottom = self.view.height;
    [self.view addSubview:_toolbar];
}

- (void)doneAction:(UIButton *)button {
    [self.view endEditing:YES];
}

- (UIButton *)_toolbarButtonWithImage:(NSString *)imageName highlight:(NSString *)highlightImageName {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.exclusiveTouch = YES;
    button.size = CGSizeMake(46, 46);
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
    button.centerY = 46 / 2;
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [button addTarget:self action:@selector(_buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_toolbarBackground addSubview:button];
    return button;
}

/**
 *  取消发布 */
- (void)_cancel {
    [self.view endEditing:YES];
    BLOCK_EXEC(self.cancelCallback);
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark 发布帖子-------
/**
 *  发布 */
- (void)pushlish {
    [self.view endEditing:YES];
    
    NSString *pushText = _textView.attributedText.string;
    NSString *spaceKeyHandlePushText = [[pushText componentsSeparatedByString:@" "] componentsJoinedByString:@""];
    if (!pushText.length || !spaceKeyHandlePushText.length) {
        [UIAlertView xf_showWithTitle:@"发布失败!" message:@"请为帖子添加内容" delay:1.8 onDismiss:NULL];
        return;
    }
    
    if (!self.selectedPhotos.count) {
        [UIAlertView xf_showWithTitle:@"发布失败!" message:@"请为帖子添加图片" delay:1.8 onDismiss:NULL];
        return;
    }
    
    @weakify(self);
    [self showHud];
    [YSImageUploadManage uploadImagesShouldClips:YES targetImageSize:CGSizeMake(1280, 1280) images:self.selectedPhotos attrText:_textView.attributedText labels:self.labels composePosition:self.composePosition imagePathDividKeyword:@"|"];
    
    BLOCK_EXEC(self.composeCallback);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.42 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        [self hiddenHud];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    });
}



/**
 *  我的位置 */
- (void)findLocation{
    @weakify(self);
    YSFriendCircleLocationController *locationController = [[YSFriendCircleLocationController alloc] initWithSelectedPosition:^(NSString *position) {
        @strongify(self);
        CGFloat width = [position sizeWithFont:JGFont(13) maxH:26].width + 17 + 30;
        CGFloat maxWidth = ScreenWidth - 105;
        width =  (width < maxWidth)? width : maxWidth;
        self.positionButton.width = width;
        [self.positionButton setButtonTitle:position];
        self.composePosition = position;
    }];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:locationController];
    [self presentViewController:nav animated:YES completion:NULL];
}

/**
 *  标签 */
- (void)_buttonClicked:(UIButton *)button {
//    if (button == _toolbarTopicButton) {
//        NSArray *topic = @[@"#冰雪奇缘# ", @"#Let It Go# ", @"#纸牌屋# ", @"#北京·理想国际大厦# " , @"#腾讯控股 kh00700# ", @"#WWDC# "];
//        NSString *topicString = [topic randomObject];
//        [_textView replaceRange:_textView.selectedTextRange withText:topicString];
//    }
    
    if (button == _toolbarTopicButton) {
        @weakify(self);
        YSTopicSearchController *topicController = [[YSTopicSearchController alloc] initWithSelectedTopicCallback:^(CircleLabel *label) {
            @strongify(self);
            [self.textView becomeFirstResponder];
            if ([label.labelName containsString:@"#"]) {
                [self.textView replaceRange:self.textView.selectedTextRange withText:label.labelName];
            }else {
                [self.textView replaceRange:self.textView.selectedTextRange withText:[NSString stringWithFormat:@"#%@#",label.labelName]];
            }
            
            [self.labels xf_safeAddObject:label];
            JGLog(@"%@",label);
            
        }];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:topicController];
        [self presentViewController:nav animated:YES completion:NULL];
    }
}

#pragma mark @protocol YYTextViewDelegate
- (void)textViewDidChange:(YYTextView *)textView {
}



- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    CGSize textSize = [textView.text sizeWithFont:JGFont(16) maxW:ScreenWidth - 16 * 2];
    
    if (textSize.height <= 100) {
        self.imageBackgroundView.y = 120;
    }else {
        self.imageBackgroundView.y = textSize.height + 50;
        
    }
    JGLog(@"%f",textSize.height);
    JGLog(@"\n%@",textView.text);
    
    if ([text isEqualToString:@"#"]) {
        [self _buttonClicked:_toolbarTopicButton];
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark @protocol YYTextKeyboardObserver
- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition {
    CGRect toFrame = [[YYTextKeyboardManager defaultManager] convertRect:transition.toFrame toView:self.view];
    if (transition.animationDuration == 0) {
        _toolbar.bottom = CGRectGetMinY(toFrame);
    } else {
        [UIView animateWithDuration:transition.animationDuration delay:0 options:transition.animationOption | UIViewAnimationOptionBeginFromCurrentState animations:^{
            _toolbar.bottom = CGRectGetMinY(toFrame);
        } completion:NULL];
    }
}

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"ys_healthymanage_addimage"];
        cell.deleteBtn.hidden = YES;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.asset = _selectedAssets[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedPhotos.count) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
#pragma clang diagnostic pop
        [sheet showInView:self.view];

    } else { // preview photos or video / 预览照片或者视频
        id asset = _selectedAssets[indexPath.row];
        BOOL isVideo = NO;
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = asset;
            isVideo = phAsset.mediaType == PHAssetMediaTypeVideo;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = asset;
            isVideo = [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
#pragma clang diagnostic pop
        }
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            _selectedPhotos = [NSMutableArray arrayWithArray:photos];
            _selectedAssets = [NSMutableArray arrayWithArray:assets];
            _layout.itemCount = _selectedPhotos.count;
            [_collectionView reloadData];
            _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + self.cellItemWidth));
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    if (sourceIndexPath.item >= _selectedPhotos.count || destinationIndexPath.item >= _selectedPhotos.count) return;
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    if (image) {
        [_selectedPhotos exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
        [_selectedAssets exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
        [_collectionView reloadData];
    }
}

#pragma mark - UIActionSheetDelegate

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
#pragma clang diagnostic pop
    if (buttonIndex == 0) { // take photo / 去拍照
        
        if (self.selectedPhotos.count == 9) {
            [UIAlertView xf_showWithTitle:@"你最多选择9张照片" message:nil delay:1.2 onDismiss:NULL];
        }else {
            [self modifyHeadByCamera];
        }
    } else if (buttonIndex == 1) {
        [self modifyHeadByChoose];
    }
}

#pragma mark -- UIImagePickerControllerDelegate --

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _layout.itemCount = _selectedPhotos.count;
    [_collectionView reloadData];
    NSLog(@"11111111111111111");
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

// If user picking a video, this callback will be called.
// If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    _layout.itemCount = _selectedPhotos.count;
    // open this code to send video / 打开这段代码发送视频
    // [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
    // NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
    // Export completed, send video here, send by outputPath or NSData
    // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
    
    // }];
    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^{
            [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                    [tzImagePickerVc hideProgressHUD];
                    TZAssetModel *assetModel = [models firstObject];
                    if (tzImagePickerVc.sortAscendingByModificationDate) {
                        assetModel = [models lastObject];
                    }
                    [_selectedAssets addObject:assetModel.asset];
                    [_selectedPhotos addObject:image];
                    [_collectionView reloadData];
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

/**
 *  更新图片位置布局 */
- (void)updateImageViews {
    NSInteger imageCount = self.imagesCount;
    UIImageView *selectedImageView = [[UIImageView alloc] initWithImage:self.didSuccessUploadImage];
    NSInteger row = imageCount % 3;
    
    if (imageCount > 1) {
        imageCount -= 1;
    }
    NSInteger col = imageCount / 3;
    
    selectedImageView.width = SelectedImageHW ;
    selectedImageView.height = SelectedImageHW;
    if (row == 0) {
        selectedImageView.x = MagrinX + 2 * SelectedImageHW + 2 * MagrinImageWidth;
    }else if (row == 1) {
        selectedImageView.x = MagrinX;
    }else if (row == 2) {
        selectedImageView.x = MagrinX + 1 * SelectedImageHW + 1 * MagrinImageWidth;
    }
    
    if (col == 0) {
        selectedImageView.y = 0;
    }else if(col == 1) {
        selectedImageView.y = SelectedImageHW + MagrinImageWidth;
    }else if(col == 2) {
        selectedImageView.y = SelectedImageHW * 2 + MagrinImageWidth * 2;
    }
    
    [self.imageBackgroundView addSubview:selectedImageView];
    
    if (imageCount != 8) {
        if (row == 0) {
            /**
             *  往下移 */
            self.addImageView.x = MagrinX;
            self.addImageView.y = MaxY(selectedImageView) + MagrinImageWidth;
            
        }else {
            self.addImageView.x = MaxX(selectedImageView) + MagrinImageWidth;
            self.addImageView.y = selectedImageView.y;
        }
        //        self.scrollView.contentSize = CGSizeMake(self.width, MaxY(self.addImageView) + 40);
        
    }else {
        [self.addImageView setHidden:YES];
    }
}

- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    _layout.itemCount = _selectedPhotos.count;
    
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return YES;
}

@end
