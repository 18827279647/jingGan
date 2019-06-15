//
//  YSHotelOrderDetailController.m
//  jingGang
//
//  Created by HanZhongchou on 2017/6/13.
//  Copyright © 2017年 dengxf_dev. All rights reserved.
//

#import "YSHotelOrderDetailController.h"
#import <BaiduMapAPI/BMapKit.h>
#import <MapKit/MapKit.h>
#import "YSLocationManager.h"
#import "YSLocationTransformHelper.h"
#import "CLLocation+YSLocationTransform.h"
#import "YSHotelDetailRequstManager.h"
#import "YSHotelOrderDetailModel.h"
#import "YSHotelOrderCancelRequstManager.h"
#import "YSHotelOrderDeleteRequstManager.h"
#import "YSLinkElongHotelWebController.h"
@interface YSHotelOrderDetailController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,YSAPICallbackProtocol,YSAPIManagerParamSource>
/**
 *  再次预订///去支付按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonAgainPayOrder;
/**
 *  酒店导航按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonHotelLoction;
/**
 *  联系酒店按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonLiaisonHotel;
/**
 *  订单总金额label
 */
@property (weak, nonatomic) IBOutlet UILabel *labelHotelOrderTotalPrice;
/**
 *  顶部View的高度，已入驻，已付款状态下需要隐藏
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hotelPayStatusViewHeight;
/**
 *  删除订单或取消订单按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonCancelOrDelete;
/**
 *  地图显示View
 */
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
/**
 *  大头针
 */
@property (nonatomic, strong) BMKPointAnnotation *pointAnnotation;
@property (nonatomic,strong)  BMKMapPoi * mapPoi;
@property (nonatomic,strong)  BMKLocationService* locService;//定位
@property (nonatomic,strong)  BMKGeoCodeSearch  * geocodesearch;//编码
@property (nonatomic,strong) YSHotelDetailRequstManager *hotelDetailRequstManager;
@property (nonatomic,strong) YSHotelOrderCancelRequstManager *hotelOrderCancelManager;
@property (nonatomic,strong) YSHotelOrderDeleteRequstManager *hotelOrderDeleteManager;
@property (nonatomic,strong) YSHotelOrderDetailModel *orderDetailModel;
/**
 *  订单状态显示label
 */
@property (weak, nonatomic) IBOutlet UILabel *labelOrderStatusDisplay;
/**
 *  订单状态提示label
 */
@property (weak, nonatomic) IBOutlet UILabel *labelHotelOrderPrompting;
/**
 *  订单价格label
 */
@property (weak, nonatomic) IBOutlet UILabel *labelHotelOrderPrice;
/**
 *  酒店名称label
 */
@property (weak, nonatomic) IBOutlet UILabel *labelHotelName;
/**
 *  酒店所在地址label
 */
@property (weak, nonatomic) IBOutlet UILabel *labelHotelAddress;
/**
 *  酒店订单号label
 */
@property (weak, nonatomic) IBOutlet UILabel *labelHotelOrderNum;
/**
 *  酒店下单时间label
 */
@property (weak, nonatomic) IBOutlet UILabel *labelHotelAdvanceDate;
/**
 * 日期差值（单位：天） xx晚
 */
@property (weak, nonatomic) IBOutlet UILabel *labelIntervalDay;
/**
 * 入住时间label
 */
@property (weak, nonatomic) IBOutlet UILabel *labelCheckInDate;
/**
 * 离店时间label
 */
@property (weak, nonatomic) IBOutlet UILabel *labelCheckOutDate;
/**
 * 酒店房间信息label
 */
@property (weak, nonatomic) IBOutlet UILabel *labelHotelRoomInfo;
/**
 * 取消规则按钮对底部的距离
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelRuleButtonSpaceBottom;
/**
 * 取消规则按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonCancelRule;
/**
 * 预订酒店联系人名称label
 */
@property (weak, nonatomic) IBOutlet UILabel *labelUserName;
/**
 * 预订酒店联系人电话label
 */
@property (weak, nonatomic) IBOutlet UILabel *labelUserMobileNum;
/**
 * 需要支付金额标题label
 */
@property (weak, nonatomic) IBOutlet UILabel *labelNeedPayPriceTitel;
/**
 * 再次预订按钮距离需要支付的金额标题的距离
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *againButtonWithNeedPayLabelTitelSpace;
/**
 * 到店所需支付的金额
 */
@property (weak, nonatomic) IBOutlet UILabel *labelArriveHotelPayPrice;
/**
 * 到店支付标题label
 */
@property (weak, nonatomic) IBOutlet UILabel *labelArriveHotelPayTitel;
/**
 * 再次预订按钮与取消规则按钮的距离
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *againButtonWithRuleButtonSpace;

@end

@implementation YSHotelOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.hotelDetailRequstManager requestData];
}

- (void)initUI{
    [YSThemeManager setNavigationTitle:@"订单详情" andViewController:self];
    self.buttonAgainPayOrder.backgroundColor = [YSThemeManager buttonBgColor];
    [self.buttonHotelLoction setTitleColor:[YSThemeManager themeColor] forState:UIControlStateNormal];
    [self.buttonLiaisonHotel setTitleColor:[YSThemeManager themeColor] forState:UIControlStateNormal];
    self.labelHotelOrderTotalPrice.textColor = [YSThemeManager priceColor];
    //设定地图View能否支持用户多点缩放(双指)
    self.mapView.zoomEnabled        = NO;
    //设定地图View能否支持用户缩放(双击或双指单击)
    self.mapView.zoomEnabledWithTap = NO;
    //设定地图View能否支持用户移动地图
    self.mapView.scrollEnabled      = NO;
    //设定地图View能否支持俯仰角
    self.mapView.overlookEnabled    = NO;
    //设定地图View能否支持旋转
    self.mapView.rotateEnabled      = NO;
    self.geocodesearch = [[BMKGeoCodeSearch alloc]init];
    self.locService = [[BMKLocationService alloc]init];
    //显示大小级别3-19
    self.mapView.zoomLevel = 18;
}
#pragma mark --- 请求返回
- (void)managerCallBackDidSuccess:(YSAPIBaseManager *)manager{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSDictionary *dictResponseObject = [NSDictionary dictionaryWithDictionary:manager.response.responseObject];
    NSNumber *requstStatus = (NSNumber *)dictResponseObject[@"m_status"];
    if (requstStatus.integerValue > 0) {
        //异常
        [UIAlertView xf_showWithTitle:dictResponseObject[@"m_errorMsg"] message:nil delay:1.2 onDismiss:NULL];
        return;
    }
    
    if (manager == self.hotelDetailRequstManager) {
        NSDictionary *dictOrderDetail = [NSDictionary dictionaryWithDictionary:manager.response.responseObject[@"elongOrder"]];
        self.orderDetailModel = [YSHotelOrderDetailModel objectWithKeyValues:dictOrderDetail];
        [self setRequstAfterUI];
    }else if (manager == self.hotelOrderCancelManager){
        //取消完成
        [self.navigationController popViewControllerAnimated:YES];
    }else if(manager == self.hotelOrderDeleteManager){
        //删除成功
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark --- 请求报错返回
- (void)managerCallBackDidFailed:(YSAPIBaseManager *)manager{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [UIAlertView xf_showWithTitle:@"网络错误，请检查网络" message:nil delay:1.2 onDismiss:NULL];
}
#pragma mark --- 请求参数
- (NSDictionary *)paramsForApi:(YSAPIBaseManager *)manager{
    return @{@"orderId":self.orderID};
}

- (void)setRequstAfterUI{
    
    [self setUIDisplayWithOrderStatus:self.orderDetailModel.showStatus];
    //大头针的位置
    self.pointAnnotation.coordinate = CLLocationCoordinate2DMake(self.orderDetailModel.latitude, self.orderDetailModel.longitude);
    //地图显示的位置
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(self.orderDetailModel.latitude, self.orderDetailModel.longitude);
    //酒店地址
    self.labelHotelAddress.text           = self.orderDetailModel.address;
    //酒店名称
    self.labelHotelName.text              = self.orderDetailModel.hotelName;
    //酒店订单价格
    self.labelHotelOrderPrice.text        = [NSString stringWithFormat:@"¥%.2f",self.orderDetailModel.totalPrice];
    //酒店订单编号
    self.labelHotelOrderNum.text          = [NSString stringWithFormat:@"%ld",(long)[self.orderDetailModel.orderId integerValue]];
    //下单时间
    self.labelHotelAdvanceDate.text       = self.orderDetailModel.creationDate;
    //订单状态
    self.labelOrderStatusDisplay.text     = [self.orderDetailModel getOrderStatusString];
    //订单的提示信息
    self.labelHotelOrderPrompting.text    = [self.orderDetailModel getOrderStatusPromptingString];
    //住店时长---xx晚
    self.labelIntervalDay.text            = [NSString stringWithFormat:@"(共%ld晚)",self.orderDetailModel.intervalDay];
    //入店日期
    self.labelCheckInDate.attributedText  = [self.orderDetailModel getCheckInDate];
    //离店日期
    self.labelCheckOutDate.attributedText = [self.orderDetailModel getCheckOutDate];
    //酒店房间信息
    self.labelHotelRoomInfo.text          = [self.orderDetailModel getHotelRoomInfo];
    //联系人姓名
    self.labelUserName.text               = self.orderDetailModel.userName;
    //联系人电话
    self.labelUserMobileNum.text          = self.orderDetailModel.mobile;
    //担保金额
    self.labelArriveHotelPayPrice.text    = [NSString stringWithFormat:@"¥%.2f",self.orderDetailModel.guaranteeAmount];
}

- (void)setUIDisplayWithOrderStatus:(NSInteger)orderStatus{
    //更改显示状态前的一些显示还原
    self.labelArriveHotelPayTitel.hidden = YES;
    self.labelArriveHotelPayPrice.hidden = YES;
    self.buttonCancelRule.hidden = YES;
    self.buttonAgainPayOrder.hidden = NO;
    self.buttonCancelOrDelete.hidden = NO;
    [self.buttonAgainPayOrder setTitle:@"再次预订" forState:UIControlStateNormal];
    self.buttonAgainPayOrder.layer.borderWidth = 0.0;
    self.buttonAgainPayOrder.layer.borderColor = [UIColor clearColor].CGColor;
    self.buttonAgainPayOrder.backgroundColor = [YSThemeManager buttonBgColor];
    [self.buttonCancelOrDelete setTitle:@"删除订单" forState:UIControlStateNormal];
    self.buttonCancelOrDelete.backgroundColor = [UIColor whiteColor];
    self.againButtonWithNeedPayLabelTitelSpace.constant = 15;
    self.cancelRuleButtonSpaceBottom.constant = 37.0;
    self.againButtonWithRuleButtonSpace.constant = 16.0;
    switch (orderStatus) {
        case 1://担保失败
            [self setGuaranteeFailStatusUI];
            break;
        case 2://等待支付担保金
            [self setWiatPayGuaranteeMoneyStatusUI];
            break;
        case 4://等待酒店确认
            [self setWaitHotelConfirmStatusUI];
            break;
        case 8://等待付款
            [self setWaitPayMoneyStatusUI];
            break;
        case 32://酒店拒绝订单
            [self setHotelRejectOrderStatusUI];
            break;
        case 64://未入住
            [self setNoCheckInStatusUI];
            break;
        case 128://已离店
            [self setCheckOutDoneStatusUI];
            break;
        case 256://已取消
            [self setCancelOrderStatusUI];
            break;
        case 512://已确认，等待入住
            [self setAffirmCheckInHotelRoom];
            break;
        case 1024://已入住
            [self setAlreadyCheakInHotelRomm];
            break;
        case 8192://支付失败
            [self setPayOrderFailStatusUI];
            break;
        default:
            break;
    }
}
//担保失败状态UI设置
- (void)setGuaranteeFailStatusUI{
    self.labelOrderStatusDisplay.textColor = [YSThemeManager priceColor];
    self.labelArriveHotelPayTitel.hidden = NO;
    self.labelArriveHotelPayPrice.hidden = NO;
    self.labelNeedPayPriceTitel.text = @"需支付担保金";
    [self.buttonAgainPayOrder setTitle:@"重新预订" forState:UIControlStateNormal];
    [self.buttonCancelOrDelete setTitle:@"取消订单" forState:UIControlStateNormal];
    self.againButtonWithNeedPayLabelTitelSpace.constant = 45.0;
}

//等待支付担保金UI设置
- (void)setWiatPayGuaranteeMoneyStatusUI{
    self.labelArriveHotelPayTitel.hidden = NO;
    self.labelArriveHotelPayPrice.hidden = NO;
    self.labelNeedPayPriceTitel.text = @"需支付担保金";
    self.labelOrderStatusDisplay.textColor = [YSThemeManager buttonBgColor];
    self.againButtonWithNeedPayLabelTitelSpace.constant = 45.0;
    //当前手机时间小于最后支付时间，并且isPayable为YES的时候才显示支付按钮
    if ([self.orderDetailModel isDisplayGoUpPayButton]) {
        [self.buttonAgainPayOrder setTitle:@"去担保" forState:UIControlStateNormal];
        [self.buttonCancelOrDelete setTitle:@"取消订单" forState:UIControlStateNormal];
    }else{
        self.buttonAgainPayOrder.backgroundColor = [UIColor whiteColor];
        self.buttonAgainPayOrder.layer.borderColor = UIColorFromRGB(0xebebeb).CGColor;
        self.buttonAgainPayOrder.layer.borderWidth = 1.0;
        [self.buttonAgainPayOrder setTitle:@"取消订单" forState:UIControlStateNormal];
        [self.buttonAgainPayOrder setTitleColor:UIColorFromRGB(0x4a4a4a) forState:UIControlStateNormal];
        self.cancelRuleButtonSpaceBottom.constant = 15.0;
        self.againButtonWithRuleButtonSpace.constant = -17.0;
        self.buttonCancelOrDelete.hidden = YES;
    }
}
//等待酒店确认UI设置
- (void)setWaitHotelConfirmStatusUI{
    self.labelOrderStatusDisplay.textColor = [YSThemeManager buttonBgColor];
    self.labelArriveHotelPayTitel.hidden = NO;
    self.labelArriveHotelPayPrice.hidden = NO;
    self.buttonCancelRule.hidden = NO;
    self.buttonCancelOrDelete.hidden = YES;
    self.againButtonWithNeedPayLabelTitelSpace.constant = 45.0;
    self.cancelRuleButtonSpaceBottom.constant = 14;
    [self.buttonAgainPayOrder setTitle:@"取消订单" forState:UIControlStateNormal];
    self.againButtonWithRuleButtonSpace.constant = 15.0;
    self.buttonAgainPayOrder.backgroundColor = [UIColor whiteColor];
    self.buttonAgainPayOrder.layer.borderWidth = 1.0;
    self.buttonAgainPayOrder.layer.borderColor = UIColorFromRGB(0xebebeb).CGColor;
    [self.buttonAgainPayOrder setTitleColor:UIColorFromRGB(0x4a4a4a) forState:UIControlStateNormal];

}
//酒店拒绝订单UI设置
- (void)setHotelRejectOrderStatusUI{
    self.labelArriveHotelPayTitel.hidden = NO;
    self.labelArriveHotelPayPrice.hidden = NO;
    self.againButtonWithNeedPayLabelTitelSpace.constant = 45.0;
    self.labelOrderStatusDisplay.textColor = UIColorFromRGB(0xfe5c44);
    [self.buttonCancelOrDelete setTitle:@"取消订单" forState:UIControlStateNormal];
    self.buttonCancelRule.hidden = NO;
    self.againButtonWithRuleButtonSpace.constant = 71.0;
    self.cancelRuleButtonSpaceBottom.constant = 14.0;
}

//未入住状态UI设置
- (void)setNoCheckInStatusUI{
    self.labelOrderStatusDisplay.textColor = [YSThemeManager buttonBgColor];
    self.labelNeedPayPriceTitel.text = @"到店支付";
}

//已离店状态UI设置
- (void)setCheckOutDoneStatusUI{
    self.labelOrderStatusDisplay.textColor = [YSThemeManager buttonBgColor];
    
}
//已确认，等待入住状态显示设置
- (void)setAffirmCheckInHotelRoom{
    self.labelOrderStatusDisplay.textColor = [YSThemeManager themeColor];
    self.buttonCancelOrDelete.hidden = YES;
    self.buttonCancelRule.hidden = NO;
    self.cancelRuleButtonSpaceBottom.constant = 15.0;
    self.buttonAgainPayOrder.backgroundColor = [UIColor whiteColor];
    self.buttonAgainPayOrder.layer.borderColor = UIColorFromRGB(0xebebeb).CGColor;
    self.buttonAgainPayOrder.layer.borderWidth = 1.0;
    [self.buttonAgainPayOrder setTitle:@"取消订单" forState:UIControlStateNormal];
    [self.buttonAgainPayOrder setTitleColor:UIColorFromRGB(0x4a4a4a) forState:UIControlStateNormal];
}
//等待支付订单显示设置
- (void)setWaitPayMoneyStatusUI{
    self.labelOrderStatusDisplay.textColor = [YSThemeManager themeColor];
     //当前手机时间小于最后支付时间，并且isPayable为YES的时候才显示支付按钮
    if ([self.orderDetailModel isDisplayGoUpPayButton]) {
        [self.buttonAgainPayOrder setTitle:@"去支付" forState:UIControlStateNormal];
        [self.buttonCancelOrDelete setTitle:@"取消订单" forState:UIControlStateNormal];
    }else{
        self.buttonAgainPayOrder.backgroundColor = [UIColor whiteColor];
        self.buttonAgainPayOrder.layer.borderColor = UIColorFromRGB(0xebebeb).CGColor;
        self.buttonAgainPayOrder.layer.borderWidth = 1.0;
        [self.buttonAgainPayOrder setTitle:@"取消订单" forState:UIControlStateNormal];
        [self.buttonAgainPayOrder setTitleColor:UIColorFromRGB(0x4a4a4a) forState:UIControlStateNormal];
        self.cancelRuleButtonSpaceBottom.constant = 15.0;
        self.againButtonWithRuleButtonSpace.constant = -17.0;
        self.buttonCancelOrDelete.hidden = YES;
    }
    
}
//已取消订单显示设置
- (void)setCancelOrderStatusUI{
    [self.buttonAgainPayOrder setTitle:@"再次预订" forState:UIControlStateNormal];
    [self.buttonCancelOrDelete setTitle:@"删除订单" forState:UIControlStateNormal];
    self.labelOrderStatusDisplay.textColor = UIColorFromRGB(0x9b9b9b);
}
//已入住订单显示设置
- (void)setAlreadyCheakInHotelRomm{
    [self.buttonAgainPayOrder setTitle:@"再次预订" forState:UIControlStateNormal];
    self.buttonCancelOrDelete.hidden = YES;
    self.labelOrderStatusDisplay.textColor = [YSThemeManager themeColor];
    self.cancelRuleButtonSpaceBottom.constant = 15.0;
    self.againButtonWithRuleButtonSpace.constant = -17.0;
}
//支付失败状态UI设置
- (void)setPayOrderFailStatusUI{
    self.labelOrderStatusDisplay.textColor = [YSThemeManager priceColor];
    [self.buttonAgainPayOrder setTitle:@"重新预订" forState:UIControlStateNormal];
    [self.buttonCancelOrDelete setTitle:@"取消订单" forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.mapView viewWillAppear];
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.geocodesearch.delegate = self;
    [self.mapView addAnnotation:self.pointAnnotation];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
    self.geocodesearch.delegate = nil;
    self.locService.delegate = nil;
}
#pragma mark --- 取消订单
- (void)cancelOrder{
    
    if (self.orderDetailModel.showStatus == 512) {
        
        if (self.orderDetailModel.isCancelable.boolValue) {
            //已确认等待入住，不扣钱的订单取消
            [self orderMayCancel];
        }else{
            //已确认等待入住，需要扣一定手续费的订单取消
            [self orderNoMayCancel];
        }
        
    }else if(self.orderDetailModel.showStatus == 32){
        //酒店拒绝订单的取消
        [self cancelHotelRejectStatus];
    }else{//未付款的取消订单
        @weakify(self);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定要取消订单吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self);
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.hotelOrderCancelManager requestData];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
#pragma mark ---不扣款订单取消(可取消)
- (void)orderMayCancel{
    @weakify(self);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"亲, 您确定要取消吗？订单取消后，金额会原路退还到您支付账户！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.hotelOrderCancelManager requestData];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"点错了" style:UIAlertActionStyleCancel handler:nil];
     //修改按钮的颜色   此方法需要只有8.3包括之后的系统才有，所以要加个判断，不然会crash
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.floatValue >= 8.3) {
        [okAction setValue:UIColorFromRGB(0x9b9b9b) forKey:@"titleTextColor"];
    }
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark ---需要扣一定手续费的订单取消(不可取消)
- (void)orderNoMayCancel{
    @weakify(self);
    NSString *strTotalPrice = [NSString stringWithFormat:@"%.2f元",self.orderDetailModel.totalPrice];
    NSString *strMessage = [NSString stringWithFormat:@"此订单不可取消, 未如约入住将扣您全额房费%@支付酒店。",strTotalPrice];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:strMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.hotelOrderCancelManager requestData];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"点错了" style:UIAlertActionStyleCancel handler:nil];
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.floatValue >= 8.3) {
        //修改message   此方法需要只有8.3包括之后的系统才有，所以要加个判断，不然会crash
        NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:strMessage];
        [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[YSThemeManager priceColor] range:NSMakeRange(21, strTotalPrice.length)];
        [alert setValue:alertControllerMessageStr forKey:@"attributedMessage"];
        [okAction setValue:UIColorFromRGB(0x9b9b9b) forKey:@"titleTextColor"];
    }
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark ---酒店拒绝的订单取消
- (void)cancelHotelRejectStatus{
    @weakify(self);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"点击确定后会免费为您取消订单，所支付的金额将会原路退还到您原支付账户中！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.hotelOrderCancelManager requestData];
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark --- Action
#pragma mark ---取消规则按钮点击事件
- (IBAction)cancelRuleButtonClick:(id)sender {
    NSString *strDate = [self.orderDetailModel getCancelRuleDateSting];
    NSString *strPromptingMessage = [NSString stringWithFormat:@"您可在 %@ 前取消订单；在此之后取消或未能如约入住,酒店将扣取全部担保金额不予退还；如成功入住并付款离店，将立即操作解冻您的担保金，并根据各银行处理情况在1~3天内返还到您的账户。",strDate];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:strPromptingMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.floatValue >= 8.3) {
        //修改message   此方法需要只有8.3包括之后的系统才有，所以要加个判断，不然会crash
        NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:strPromptingMessage];
        [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[YSThemeManager priceColor] range:NSMakeRange(3, 17)];
        [alert setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    }
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark --- 再次预订，去支付按钮事件
- (IBAction)advanceAgainOrGoPayOrderButtonClick:(id)sender {
    
    NSInteger status = self.orderDetailModel.showStatus;
    
    if (status == 512 || status == 4) {
        [self cancelOrder];
    }else if (status == 1024 || status == 256 || status == 32 || status == 64 || status == 1 || status == 128 || status == 8192){
        //已入住、已取消、酒店拒绝订单、担保失败、支付失败---再次预订
        NSString *webUrl = [NSString stringWithFormat:@"%@/v1/elong_hotel_detail.htm?hotelId=%ld",MobileWeb_Url,[self.orderDetailModel.hotelId integerValue]];
        YSLinkElongHotelWebController *elongHotelWebController = [[YSLinkElongHotelWebController alloc] initWithWebUrl:webUrl];
        elongHotelWebController.navTitle = @"酒店住宿";
        [self.navigationController pushViewController:elongHotelWebController animated:YES];
    }else if(status == 2 || status == 8){
        if (![self.orderDetailModel isDisplayGoUpPayButton]) {
            //在等待支付、等到支付担保金的状态下，如果不需要去支付功能，此按钮变成取消按钮，点击事件是取消订单
            [self cancelOrder];
        }else{
            //去支付,支付金额、担保金
            NSString *webUrl = [NSString stringWithFormat:@"%@/v1/elong/order/toPay.htm?id=%ld",MobileWeb_Url,self.orderDetailModel.id.integerValue];
            YSLinkElongHotelWebController *elongHotelWebController = [[YSLinkElongHotelWebController alloc] initWithWebUrl:webUrl];
            elongHotelWebController.navTitle = @"支付订单";
            [self.navigationController pushViewController:elongHotelWebController animated:YES];
        }
        
    }
}
#pragma mark --- 取消订单，删除订单按钮事件
- (IBAction)cancelOrderOrDeleteOrderButtonClick:(id)sender {
    @weakify(self);
    NSInteger status = self.orderDetailModel.showStatus;
    if (status == 8 || status == 2 || status == 32 || status == 1 || status == 8192) {
        //待付款状态、待付担保金、酒店拒绝订单、担保失败、支付失败--取消订单
        [self cancelOrder];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除订单" message:@"订单删除后将无法恢复，确定删除？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self);
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.hotelOrderDeleteManager requestData];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
#pragma mark ---联系酒店按钮事件
- (IBAction)liaisonHotelButtonClick:(id)sender {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"酒店电话" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    @weakify(self);
    [alertController addAction:[UIAlertAction actionWithTitle:self.orderDetailModel.phone style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [YSThemeManager callPhone:self.orderDetailModel.phone];
    }]];
    //添加取消选项
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark ---酒店导航按钮事件
- (IBAction)hotelLocationButtonClick:(id)sender {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"请选择地图" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //自带地图
    @weakify(self);
    [alertController addAction:[UIAlertAction actionWithTitle:@"用iPhone自带地图导航" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //使用自带地图导航
        @strongify(self);
        [self navForIOSMap];
    }]];
    //判断是否安装了高德地图，如果安装了高德地图，则使用高德地图导航
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"用高德地图导航" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self);
            [self navForGDMap];
        }]];
    }
    //判断是否安装了百度地图，如果安装了百度地图，则使用百度地图导航
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"用百度地图导航" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self);
            [self navForBDMap];
        }]];
    }
    //添加取消选项
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }]];
    //显示alertController
    [self presentViewController:alertController animated:YES completion:nil];
}

/**
 *  系统自带地图导航 */
- (void)navForIOSMap {
    //起点
    MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc]  initWithCoordinate:[self transformGDMapFromBDMapWithLatitute:[YSLocationManager sharedInstance].coordinate.latitude longitude:[YSLocationManager sharedInstance].coordinate.longitude]  addressDictionary:nil]];
    currentLocation.name = @"我的位置";
    //目的地的位置
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:[self transformGDMapFromBDMapWithLatitute:self.orderDetailModel.latitude longitude:self.orderDetailModel.longitude] addressDictionary:nil]];
    toLocation.name = self.orderDetailModel.address;
    NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];
    NSString * mode = MKLaunchOptionsDirectionsModeDriving;
    NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:mode, MKLaunchOptionsMapTypeKey: [NSNumber                                 numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
    //打开苹果自身地图应用，并呈现特定的item
    [MKMapItem openMapsWithItems:items launchOptions:options];
}

/**
 *   高德地图导航*/
- (void)navForGDMap {
    NSString * t = @"0";
    CLLocationCoordinate2D originCoor = [self transformGDMapFromBDMapWithLatitute:[YSLocationManager sharedInstance].coordinate.latitude longitude:[YSLocationManager sharedInstance].coordinate.longitude];
    CLLocationCoordinate2D toCoor = [self transformGDMapFromBDMapWithLatitute:self.orderDetailModel.latitude longitude:self.orderDetailModel.longitude];
    NSString *url = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=%lf&slon=%lf&sname=我的位置&did=BGVIS2&dlat=%lf&dlon=%lf&dname=%@&dev=0&m=0&t=%@",originCoor.latitude,originCoor.longitude, toCoor.latitude,toCoor.longitude,self.orderDetailModel.address,t] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication  sharedApplication]openURL:[NSURL URLWithString:url]];
}
- (void)navForBDMap {
    CLLocationCoordinate2D toCoordinate = {self.orderDetailModel.latitude,self.orderDetailModel.longitude};
    NSString * modeBaiDu = @"driving";
    NSString *url = [[NSString stringWithFormat:@"baidumap://map/direction?origin=%lf,%lf&destination=%f,%f&mode=%@&src=%@",[YSLocationManager sharedInstance].coordinate.latitude,[YSLocationManager sharedInstance].coordinate.longitude,toCoordinate.latitude,toCoordinate.longitude,modeBaiDu,@"e生康缘"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}
// 百度地图坐标系转高德地图坐标系
- (CLLocationCoordinate2D)transformGDMapFromBDMapWithLatitute:(CGFloat)latitude longitude:(CGFloat)longitude
{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    return [location locationMarsFromBaidu].coordinate;
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [self.mapView updateLocationData:userLocation];
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.image = [UIImage imageNamed:@"Hotel_OrderDetail_Location"];
        return newAnnotationView;
    }
    return nil;
}


#pragma mark - 大头针实例化
- (BMKPointAnnotation *)pointAnnotation
{
    if (_pointAnnotation == nil)
    {
        _pointAnnotation = [[BMKPointAnnotation alloc] init];
    }
    return _pointAnnotation;
}

- (YSHotelDetailRequstManager *)hotelDetailRequstManager{
    if (!_hotelDetailRequstManager) {
        _hotelDetailRequstManager = [[YSHotelDetailRequstManager alloc]init];
        _hotelDetailRequstManager.delegate = self;
        _hotelDetailRequstManager.paramSource = self;
    }
    return _hotelDetailRequstManager;
}

- (YSHotelOrderCancelRequstManager *)hotelOrderCancelManager{
    if (!_hotelOrderCancelManager) {
        _hotelOrderCancelManager = [[YSHotelOrderCancelRequstManager alloc]init];
        _hotelOrderCancelManager.delegate = self;
        _hotelOrderCancelManager.paramSource = self;
    }
    return _hotelOrderCancelManager;
}
- (YSHotelOrderDeleteRequstManager *)hotelOrderDeleteManager{
    if (!_hotelOrderDeleteManager) {
        _hotelOrderDeleteManager = [[YSHotelOrderDeleteRequstManager alloc]init];
        _hotelOrderDeleteManager.delegate = self;
        _hotelOrderDeleteManager.paramSource = self;
    }
    return _hotelOrderDeleteManager;
}
- (void)dealloc{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
