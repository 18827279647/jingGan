//
//  OrderDetailController.m
//  jingGang
//
//  Created by 张康健 on 15/8/12.
//  Copyright (c) 2015年 yi jiehuang. All rights reserved.
//

#import "OrderDetailController.h"
#import "KJOrderDetailGoodsTableView.h"
#import "GlobeObject.h"
#import "Util.h"
#import "VApiManager.h"
#import "OderDetailModel.h"
#import "GoodsInfoModel.h"
#import "ZkgLoadingHub.h"
#import "KJOrderDetailResultTableView.h"
#import "NodataShowView.h"
#import "KJGoodsDetailViewController.h"
#import "KJDarlingCommentVC.h"
#import "PayOrderViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "JGActivityHelper.h"
#import "YSYunGouBiPayController.h"
#import "YSYgbPayModel.h"
#import "QueryLogisticsViewController.h"
#import "YSDateConutDown.h"
#import "YSCommonAccountEliteZonePayController.h"
#import "HongBaoTCViewController.h"
#import "YSImageConfig.h"
#import "PTViewController.h"
#import "JGRedEnvelopeNewVC.h"
#import "JGOrderRedDetailRequest.h"
#import "JGRedEnvelopeVC.h"
#import "AnyiUI.h"
CGFloat const OrderDetailSectionHeaderHeight = 47.0f;
CGFloat const OrderDetailSectionFooterHeight = 43.0f;
CGFloat const OrderDetailCellHeight = 113.0f;
CGFloat const PayWayCellHeight = 43.0f;
CGFloat const OrtherPartHeight = 287.0f;
CGFloat const SecondTableCellHiehgt = 43.0f;
//商品订单详情页
@interface OrderDetailController (){

    VApiManager *_vapManager;
    JGOrderRedDetailSucResponse *_response;

}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollToBottonGap;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *bottomStateOneBtn;
@property (weak, nonatomic) IBOutlet UIButton *bottomStateTwoBtn;
@property (weak, nonatomic) IBOutlet KJOrderDetailGoodsTableView *orderDetailGoodsTableView;

@property (nonatomic,strong)OderDetailModel *orderDetailModel;
@property (nonatomic,copy)  NSArray *orderlist;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderDetailTableHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondTableHeightConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;

@property (nonatomic,strong) YSDateConutDown *dateConutDown;
@property (weak, nonatomic) IBOutlet UILabel *detailAdressLabel;
#pragma mark - UI Property
//订单编号label
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
//订单状态label
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;

@property (weak, nonatomic) IBOutlet UILabel *recievePersonNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *recievePersonPhoneNumLabel;
@property (weak, nonatomic) IBOutlet KJOrderDetailResultTableView *secondTableView;
@property (weak, nonatomic) IBOutlet UIView *orderNumberBgView;
@property (weak, nonatomic) IBOutlet UILabel *labelOrderAddTime;
@property (strong,nonatomic) NodataShowView *nodataView;
@property (nonatomic,strong) NSNumber *expressCompanyId;
@property (weak, nonatomic) IBOutlet UILabel *cancelOrderLabel;
@property (nonatomic,strong) NSNumber *shipCode;
@property (nonatomic,strong) NSNumber *istchongbao;
@property (weak, nonatomic) IBOutlet UILabel *dengdaiLabel;
@property (weak, nonatomic) IBOutlet UILabel *shifuLabel;

@property (weak, nonatomic) IBOutlet UILabel *pinzhuLabel;

@property (weak, nonatomic) IBOutlet UIImageView *oneImage;
@property (weak, nonatomic) IBOutlet UIImageView *twoImage;


//提示 弹窗
@property(nonatomic,strong)UIControl *BGcontrol;
@property(nonatomic,strong)UIView *sappointmentTipBgView,*sappointmentTipPopView;
@property(nonatomic,strong)UIView *sappointmentTipBgView2,*sappointmentTipPopView2;
@end

@implementation OrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self _init];

    
    _pinzhuLabel.hidden = YES;
    _oneImage.hidden = YES;
    _twoImage.hidden = YES;
//    [self _requestOrderDetailData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self _requestOrderDetailData];
    [self reqeustconfirmJiankangdouReadCount];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //离开当前页面需要取消掉倒计时
    [self.dateConutDown cancelConutDown];
}

#pragma mark - private Method
-(void)_init{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _vapManager = [[VApiManager alloc] init];
    [YSThemeManager setNavigationTitle:@"订单详情" andViewController:self];
//    //返回
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(back) target:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];

//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem initWithTitle:@"关闭" titleColor:[UIColor whiteColor] target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(back) target:self];
    [self.bottomStateOneBtn setTitleColor:[YSThemeManager buttonBgColor] forState:UIControlStateNormal];
    [self.bottomStateOneBtn addTarget:self action:@selector(bottomStateOneBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomStateTwoBtn addTarget:self action:@selector(bottomstateTwoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    WEAK_SELF;
    self.orderDetailGoodsTableView.clickOrderDetailBlock = ^(NSIndexPath *indexPath,NSNumber *goodsID){
        KJGoodsDetailViewController *goodsDetailVC = [[KJGoodsDetailViewController alloc] init];
        goodsDetailVC.goodsID = goodsID;
        switch ([JGActivityHelper enterIntoGoodsDetailState]) {
            case YSEnterIntoGoodsDetailWithComeFromShopHomePage:
            {
                goodsDetailVC.isComeFormActivityController = NO;
            }
                break;
            case YSEnterIntoGoodsDetailWithComeFromActivtyH5:
            {
                goodsDetailVC.isComeFormActivityController = YES;
            }
                break;
            default:
                break;
        }
        [weak_self.navigationController pushViewController:goodsDetailVC animated:YES];
    };
    
}

- (void)bottomStateOneBtnClick{
    switch (self.orderDetailModel.orderStatus.integerValue) {
        case 40:
            //立即评价
            [self _comminToCommentPage];
            break;
        case 10:
            //代付款，去付款
            [self _comminToPayPage];
            break;
        case 18:
            //代付款，去付款
            [self _comminToPayPage];
            break;
        case 30:
            //确认收货，调接口
            [self confirmRecieve:self.orderDetailModel.OderDetailModelID];
            break;
        case 20:
            //邀请好友拼单
            [self _comPushTDView];
            break;
        default:
            break;
    }
}

- (void)bottomstateTwoBtnClick{
    switch (self.orderDetailModel.orderStatus.integerValue) {
        case 10:
        {//待付款，取消
            [self back];
        }
            break;
        case 18:
        {//待付款，取消
            [self back];
        }
            break;
        case 40:
        {//删除订单
            [self deleteOrder];
        }
            break;
        case 30:
        {//查看物流，只限精选专区使用
            if (self.orderDetailModel.payTypeFlag.integerValue > 0) {
                [self checkExpressInfo];
            }
        }
            break;
        default:
            break;
    }
}

- (void)_setBottomStateButtonTitle {
    switch (self.orderDetailModel.orderStatus.integerValue) {
        case 40:
        {
            
            [self.bottomStateOneBtn setTitle:@"立即评价" forState:UIControlStateNormal];
            [self.bottomStateTwoBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            self.dengdaiLabel.text = @"订单已完成";
           
//            self.bottomStateOneBtn.layer.borderColor = [[YSThemeManager buttonBgColor] CGColor];
//            self.bottomStateOneBtn.layer.borderWidth = 0.5;
//            self.bottomStateOneBtn.backgroundColor = [UIColor clearColor];
        }
            break;
        case 10:
        {
            [self _oneBottomBtnDisplayConfigure];
//            [self.bottomStateTwoBtn setTitle:@"取消" forState:UIControlStateNormal];
            self.dengdaiLabel.text = @"等待买家付款";

            [self.bottomStateOneBtn setTitle:@"去付款" forState:UIControlStateNormal];
//            [self.bottomStateOneBtn setBackgroundImage:[UIImage imageNamed:@"goumai"] forState:UIControlStateNormal];
        }
            break;
        case 18:
        {
            [self _oneBottomBtnDisplayConfigure];
//            [self.bottomStateTwoBtn setTitle:@"取消" forState:UIControlStateNormal];
            self.dengdaiLabel.text = @"等待付款";

            [self.bottomStateOneBtn setTitle:@"去付款" forState:UIControlStateNormal];
//            [self.bottomStateOneBtn setBackgroundImage:[UIImage imageNamed:@"goumai"] forState:UIControlStateNormal];
        }
            break;
        case 30:
        {
            if (self.orderDetailModel.payTypeFlag.integerValue == 0) {
                [self _oneBottomBtnDisplayConfigure];
            }
            self.dengdaiLabel.text = @"已发货";

            [self.bottomStateTwoBtn setTitle:@"查看物流" forState:UIControlStateNormal];
            [self.bottomStateOneBtn setTitle:@"确认收货" forState:UIControlStateNormal];
//            self.bottomStateOneBtn.layer.borderColor = [[YSThemeManager buttonBgColor] CGColor];
//            self.bottomStateOneBtn.layer.borderWidth = 0.5;
//            self.bottomStateOneBtn.backgroundColor = [UIColor clearColor];
        }
            break;
            
        case 20:
        {
          
            if([self.orderDetailModel.isPindan intValue] == 1){
                if(self.orderDetailModel.userCustomer.count==1){
                    _pinzhuLabel.hidden = NO;
                    _oneImage.hidden = NO;
                    _twoImage.hidden = NO;
                    self.dengdaiLabel.text = @"等待拼单";
                //    self.dengdaiLabel.frame=CGRectMake((kScreenWidth-100)/2, 0, 100, 70);
                    self.bottomView.hidden = YES;
                    self.scrollToBottonGap.constant = 0;
                    NSString  * url = [NSString stringWithFormat:@"%@",self.orderDetailModel.userCustomer[0][@"headImgPath"]];
                    [YSImageConfig sd_view:_oneImage setimageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"moren"]];
                     [self _oneBottomBtnDisplayConfigure];
                    [self.bottomStateOneBtn setTitle:@"邀请好友" forState:UIControlStateNormal];
                    
                    
                }else{
                    _pinzhuLabel.hidden = NO;
                    _oneImage.hidden = NO;
                    _twoImage.hidden = NO;
                    self.dengdaiLabel.text = @"拼单成功";
                 ///   self.dengdaiLabel.frame=CGRectMake((kScreenWidth-100)/2, 0, 100, 70);
                    self.bottomView.hidden = YES;
                    self.scrollToBottonGap.constant = 0;
                    NSString  * url = [NSString stringWithFormat:@"%@",self.orderDetailModel.userCustomer[0][@"headImgPath"]];
                    [YSImageConfig sd_view:_oneImage setimageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"moren"]];
                    NSString  * url1 = [NSString stringWithFormat:@"%@",self.orderDetailModel.userCustomer[1][@"headImgPath"]];
                    [YSImageConfig sd_view:_twoImage setimageWithURL:[NSURL URLWithString:url1] placeholderImage:[UIImage imageNamed:@"moren"]];
                    
                    
                    VApiManager *vapiManager = [[VApiManager alloc]init];
                    JGOrderRedDetailRequest *request = [[JGOrderRedDetailRequest alloc] init:GetToken];
                    request.api_orderId = self.orderDetailModel.OderDetailModelID;
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    @weakify(self);
                    //isFirstShow：1表示是红包商品要弹窗，0不要弹
                    //isSecondShow：1表示获得红包，0未获得成功
                    [vapiManager JGOrderRedDetailRequest:request success:^(AFHTTPRequestOperation *operation, JGOrderRedDetailSucResponse *response) {
                        
                        
                        @strongify(self);
                        _response = response;
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        if ([response.isFirstShow integerValue] == 1) {//弹窗
                            if ([response.isSecondShow integerValue] == 1) {
                                [self changeThePasswordPop];
                            }else{
                                [self changeThePasswordPop2];
                            }
                        }
                        
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        @strongify(self);
                        [UIAlertView xf_showWithTitle:@"网络错误，请稍后再试 " message:nil delay:1.2 onDismiss:NULL];
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                    }];
                    
                }
          
            }else{
                self.dengdaiLabel.text = @"等待发货";
                self.dengdaiLabel.frame=CGRectMake((kScreenWidth-100)/2, 0, 100, 70);
                self.bottomView.hidden = YES;
                self.scrollToBottonGap.constant = 0;
                VApiManager *vapiManager = [[VApiManager alloc]init];
                JGOrderRedDetailRequest *request = [[JGOrderRedDetailRequest alloc] init:GetToken];
                request.api_orderId = self.orderDetailModel.OderDetailModelID;
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                @weakify(self);
                //isFirstShow：1表示是红包商品要弹窗，0不要弹
                //isSecondShow：1表示获得红包，0未获得成功
                [vapiManager JGOrderRedDetailRequest:request success:^(AFHTTPRequestOperation *operation, JGOrderRedDetailSucResponse *response) {
                    @strongify(self);
                    _response = response;
                    
                    NSLog(@"%@",response);
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                     NSLog(@"response.isFirstShow%@",response.isFirstShow);
                    
                        _istchongbao = response.isSecondShow;
                    if ([response.isFirstShow integerValue] == 1) {//弹窗
                        if ([response.isSecondShow integerValue] == 1) {
                            [self changeThePasswordPop];
                        }else{
                            [self changeThePasswordPop];
                            
                         
                        }
                    }
                    
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    @strongify(self);
                    [UIAlertView xf_showWithTitle:@"网络错误，请稍后再试 " message:nil delay:1.2 onDismiss:NULL];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }];
            }
       
            //            self.bottomStateOneBtn.layer.borderColor = [[YSThemeManager buttonBgColor] CGColor];
            //            self.bottomStateOneBtn.layer.borderWidth = 0.5;
            //            self.bottomStateOneBtn.backgroundColor = [UIColor clearColor];
            
#warning 检验红包
            //检验红包
            
         
        }
            break;
        case 0:
        {
            
            self.dengdaiLabel.text = @"订单已取消";
            self.dengdaiLabel.frame=CGRectMake((kScreenWidth-100)/2, 0, 100, 70);
            self.bottomView.hidden = YES;
            self.scrollToBottonGap.constant = 0;
            //            self.bottomStateOneBtn.layer.borderColor = [[YSThemeManager buttonBgColor] CGColor];
            //            self.bottomStateOneBtn.layer.borderWidth = 0.5;
            //            self.bottomStateOneBtn.backgroundColor = [UIColor clearColor];
        }
            break;
        case 50:
        {
            
            self.dengdaiLabel.text = @"订单已完成";
            self.dengdaiLabel.frame=CGRectMake((kScreenWidth-100)/2, 0, 100, 70);
            //            self.bottomStateOneBtn.layer.borderColor = [[YSThemeManager buttonBgColor] CGColor];
            //            self.bottomStateOneBtn.layer.borderWidth = 0.5;
            //            self.bottomStateOneBtn.backgroundColor = [UIColor clearColor];
             self.bottomView.hidden = YES;
             self.scrollToBottonGap.constant = 0;
        }
            break;
            
        default:
        {
            self.bottomView.hidden = YES;
            self.scrollToBottonGap.constant = 0;
        }
            break;
    }
}


- (void)changeThePasswordPop {//等待点开的红包
    self.sappointmentTipBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEMW, SCREEMH)];
    [self.sappointmentTipBgView addSubview:self.sappointmentTipPopView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.BGcontrol];
    [[UIApplication sharedApplication].keyWindow addSubview:self.sappointmentTipBgView];
    [UIView animateWithDuration:0.2 animations:^{
        self.sappointmentTipBgView.backgroundColor = [UIColor  colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.sappointmentTipPopView.top = SCREEMH / 2 - self.sappointmentTipPopView.height / 2;
        self.BGcontrol.alpha = 1.0;
    } completion:nil];
}

- (UIView *)sappointmentTipPopView {
    if (!_sappointmentTipPopView) {
        _sappointmentTipPopView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEMW, SCREEMH)];
        //        _sappointmentTipPopView.layer.masksToBounds=YES;
        //        _sappointmentTipPopView.layer.cornerRadius=5;
        _sappointmentTipPopView.backgroundColor= [UIColor clearColor];
        
        [AnyiUI AddImg:CGRectMake(0, 0, SCREEMW, SCREEMH) name:@"icon_redBgBig" in:_sappointmentTipPopView];
        
        UIImageView *imgBg = [AnyiUI CreateImg:CGRectMake(SCREEMW/2 - 325/2, SCREEMH/2 - 434/2, 325, 434) name:@"icon_redBgImg" ];
        [_sappointmentTipPopView addSubview:imgBg];
        
        
        [AnyiUI AddLabel:CGRectMake(imgBg.left, imgBg.top+135,imgBg.width, 67/2) font:PingFangRegularFont(24) color:UIColorFromRGB(0xFFCEA5) text:@"你被红包砸中啦" align:(NSTextAlignmentCenter) in:_sappointmentTipPopView];
        
        [AnyiUI AddLabel:CGRectMake(imgBg.left, imgBg.top+180,imgBg.width, 48/2) font:PingFangRegularFont(17) color:UIColorFromRGB(0xFFCEA5) text:@"快来瓜分现金" align:(NSTextAlignmentCenter) in:_sappointmentTipPopView];
        
        UIImageView *kaiImgBg = [AnyiUI CreateImg:CGRectMake(imgBg.left + 115, imgBg.top + 253, 100, 100) name:@"icon_kai" ];
        [_sappointmentTipPopView addSubview:kaiImgBg];
        kaiImgBg.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openRedEnvelope)];
        [kaiImgBg addGestureRecognizer:tap];
        
        
        UIImageView *guanbiImg = [AnyiUI CreateImg:CGRectMake(_sappointmentTipPopView.width/2-20,_sappointmentTipPopView.height/2 + 434/2 + 25, 40, 40) name:@"icon_guanbi" ];
        [_sappointmentTipPopView addSubview:guanbiImg];
        guanbiImg.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAppointmentTip)];
        [guanbiImg addGestureRecognizer:tap1];
        
        
        _sappointmentTipPopView.top=SCREEMH;
        
    }
    return _sappointmentTipPopView;
}




#pragma mark ---- 开红包
- (void)openRedEnvelope {
    
    if(_istchongbao.integerValue == 1){
        
        JGRedEnvelopeNewVC *vc = [JGRedEnvelopeNewVC new];
        vc.dictModel = _response.redList[0];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
        [self changeThePasswordPop2];
    }
    

    
    [self closeAppointmentTip];
}

-(void)closeAppointmentTip{
    [UIView animateWithDuration:0.3 animations:^{
        self.BGcontrol.alpha = 0.0;
        self.sappointmentTipPopView.hidden = YES;
        self.sappointmentTipBgView.backgroundColor = [UIColor clearColor];
    }completion:^(BOOL finished) {
        [self.BGcontrol removeFromSuperview];
        [self.sappointmentTipPopView removeFromSuperview];
        [self.sappointmentTipBgView removeFromSuperview];
        self.BGcontrol = nil;
        self.sappointmentTipBgView = nil;
        self.sappointmentTipPopView = nil;
    }];
    
    
    
}

- (void)changeThePasswordPop2 {//没抢到红包的弹窗
    self.sappointmentTipBgView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEMW, SCREEMH)];
    [self.sappointmentTipBgView2 addSubview:self.sappointmentTipPopView2];
    [[UIApplication sharedApplication].keyWindow addSubview:self.BGcontrol];
    [[UIApplication sharedApplication].keyWindow addSubview:self.sappointmentTipBgView2];
    [UIView animateWithDuration:0.2 animations:^{
        self.sappointmentTipBgView2.backgroundColor = [UIColor  colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.sappointmentTipPopView2.top = SCREEMH / 2 - self.sappointmentTipPopView2.height / 2;
        self.BGcontrol.alpha = 1.0;
    } completion:nil];
}

- (UIView *)sappointmentTipPopView2 {
    if (!_sappointmentTipPopView2) {
        _sappointmentTipPopView2=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEMW, SCREEMH)];
        //        _sappointmentTipPopView2.layer.masksToBounds=YES;
        //        _sappointmentTipPopView2.layer.cornerRadius=5;
        _sappointmentTipPopView2.backgroundColor= [UIColor clearColor];
        
        [AnyiUI AddImg:CGRectMake(0, 0, SCREEMW, SCREEMH) name:@"icon_redBgBig" in:_sappointmentTipPopView2];
        
        UIImageView *imgBg = [AnyiUI CreateImg:CGRectMake(SCREEMW/2 - 325/2, SCREEMH/2 - 434/2, 325, 434) name:@"icon_redBgImgShibai" ];
        [_sappointmentTipPopView2 addSubview:imgBg];
        
        
        [AnyiUI AddLabel:CGRectMake(imgBg.left, imgBg.top+318/2,imgBg.width, 67/2) font:PingFangRegularFont(24) color:UIColorFromRGB(0xFFCEA5) text:@"手气差了点，没领到哦～" align:(NSTextAlignmentCenter) in:_sappointmentTipPopView2];
        
        [AnyiUI AddLabel:CGRectMake(imgBg.left + 190/2, imgBg.top+425/2,210/2, 48/2) font:PingFangRegularFont(17) color:UIColorFromRGB(0xFFCEA5) text:@"再下一单试试" align:(NSTextAlignmentCenter) in:_sappointmentTipPopView2];
        
        UIImageView *kaiImgBg = [AnyiUI CreateImg:CGRectMake(imgBg.left + 407/2,  imgBg.top+429/2, 20, 20) name:@"icon_rightJiantou" ];
        [_sappointmentTipPopView2 addSubview:kaiImgBg];
        kaiImgBg.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(againTheNextSingle)];//再下一单试试
        [kaiImgBg addGestureRecognizer:tap];
        
        
        
        UILabel *jiluLab = [AnyiUI CreateLbl:CGRectMake(imgBg.left + 196/2, imgBg.top+759/2, 130, 21) font:PingFangLightFont(15) color:UIColorFromRGB(0xFFCEA5) text:@"查看我的领取记录" align:(NSTextAlignmentCenter)];
        jiluLab.userInteractionEnabled = YES;
        [_sappointmentTipPopView2 addSubview:jiluLab];
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getTheRecord)];//领取记录
        [jiluLab addGestureRecognizer:tap2];
        
        UIImageView *guanbiImg = [AnyiUI CreateImg:CGRectMake(_sappointmentTipPopView2.width/2-20,_sappointmentTipPopView2.height/2 + 434/2 + 25, 40, 40) name:@"icon_guanbi" ];
        [_sappointmentTipPopView2 addSubview:guanbiImg];
        guanbiImg.userInteractionEnabled = YES;
        
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAppointmentTip2)];
        [guanbiImg addGestureRecognizer:tap1];
        
        
        _sappointmentTipPopView2.top=SCREEMH;
        
    }
    return _sappointmentTipPopView2;
}

-(void)closeAppointmentTip2{
    [UIView animateWithDuration:0.3 animations:^{
        self.BGcontrol.alpha = 0.0;
        self.sappointmentTipPopView2.hidden = YES;
        self.sappointmentTipBgView2.backgroundColor = [UIColor clearColor];
    }completion:^(BOOL finished) {
        [self.BGcontrol removeFromSuperview];
        [self.sappointmentTipPopView2 removeFromSuperview];
        [self.sappointmentTipBgView2 removeFromSuperview];
        self.BGcontrol = nil;
        self.sappointmentTipBgView2 = nil;
        self.sappointmentTipPopView2 = nil;
    }];
    
    //    BYTabBarController *tabVC = (BYTabBarController *)self.window.rootViewController;
    //    UINavigationController *navVC = tabVC.selectedViewController;
    //    BYModifyPwdViewController *currentVC = [[BYModifyPwdViewController alloc] init];
    //    [navVC pushViewController:currentVC animated:YES];
    
}

#pragma mark ---- 再下一单
- (void)againTheNextSingle {
    self.tabBarController.selectedViewController = self.tabBarController.childViewControllers[1];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    NSLog(@"点击了吗");
    [self closeAppointmentTip2];
}
#pragma mark ---- 红包领取记录
- (void)getTheRecord {
    JGRedEnvelopeVC * jer = [[JGRedEnvelopeVC alloc] init];
    [self.navigationController pushViewController:jer animated:YES];
     NSLog(@"点击了吗");
    [self closeAppointmentTip2];
}


- (void)_oneBottomBtnDisplayConfigure {
    self.bottomView.hidden = NO;
    self.scrollToBottonGap.constant = 44;
    self.bottomStateOneBtn.hidden = NO;
    self.bottomStateTwoBtn.hidden = YES;
}

- (void)_twoBottomBtnDisplayConfigure {
    self.bottomView.hidden = NO;
    self.scrollToBottonGap.constant = 44;
    self.bottomStateOneBtn.hidden = NO;
    self.bottomStateTwoBtn.hidden = NO;
}

-(void)_comminToCommentPage {
    KJDarlingCommentVC *commentVC = [[KJDarlingCommentVC alloc] init];
    commentVC.goodsInfos = self.goodsInfo;
    commentVC.orderID = self.orderDetailModel.OderDetailModelID;
    [self.navigationController pushViewController:commentVC animated:YES];
}

-(void)_comPushTDView{
    PTViewController * ptview = [[PTViewController alloc] init];
    ptview.orderID = self.orderDetailModel.OderDetailModelID;
    ptview.pdorderID = self.orderDetailModel.orderId;
    [self.navigationController pushViewController:ptview animated:YES];
}


-(void)_comminToPayPage {
    VApiManager *vapiManager = [[VApiManager alloc]init];
    ShopTradePaymetViewRequest *request = [[ShopTradePaymetViewRequest alloc] init:GetToken];
    request.api_id = self.orderDetailModel.OderDetailModelID;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    @weakify(self);
    [vapiManager shopTradePaymetView:request success:^(AFHTTPRequestOperation *operation, ShopTradePaymetViewResponse *response) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (response.errorCode.integerValue > 0) {
            [UIAlertView xf_showWithTitle:response.subMsg message:nil delay:1.2 onDismiss:NULL];
            return ;
        }
        
        NSNumber *payTypeFlag = ((NSDictionary *)response.order)[@"payTypeFlag"];
        if ([payTypeFlag integerValue] == 1 || [payTypeFlag integerValue] == 2) {
            
            YSYunGouBiPayController *yunGouBiPayVC = [[YSYunGouBiPayController alloc]init];
            NSDictionary *dictYgbPay = [NSDictionary dictionaryWithDictionary:(NSDictionary *)response.ygPayMode];
            yunGouBiPayVC.ygbPayModel = [YSYgbPayModel objectWithKeyValues:dictYgbPay];
            yunGouBiPayVC.ygbPayModel.orderID = ((NSDictionary *)response.order)[@"id"];
            yunGouBiPayVC.ygbPayModel.orderNumber = ((NSDictionary *)response.order)[@"orderId"];
            yunGouBiPayVC.ygbPayModel.totalPrice  = [response.totalPrice floatValue];
            yunGouBiPayVC.ygbPayModel.orderStatus = ((NSDictionary *)response.order)[@"orderStatus"];
            if ([payTypeFlag integerValue] == 1) {
                //重消订单
                yunGouBiPayVC.ygbPayModel.res = @40;
            }
            [self.navigationController pushViewController:yunGouBiPayVC animated:YES];
        }else if ([payTypeFlag integerValue] == 3){
            //精品专区普通账号支付页面
            YSCommonAccountEliteZonePayController *eliteZonePayVC = [[YSCommonAccountEliteZonePayController alloc]init];
            NSDictionary *dictYgbPay = [NSDictionary dictionaryWithDictionary:(NSDictionary *)response.ygPayMode];
            eliteZonePayVC.ygbPayModel = [YSYgbPayModel objectWithKeyValues:dictYgbPay];
            eliteZonePayVC.ygbPayModel.orderID = ((NSDictionary *)response.order)[@"id"];
            eliteZonePayVC.ygbPayModel.orderNumber = ((NSDictionary *)response.order)[@"orderId"];
            eliteZonePayVC.ygbPayModel.totalPrice = [response.totalPrice floatValue];
            eliteZonePayVC.ygbPayModel.orderStatus = ((NSDictionary *)response.order)[@"orderStatus"];
            [self.navigationController pushViewController:eliteZonePayVC animated:YES];
        }else{
            PayOrderViewController *payOrderVC = [[PayOrderViewController alloc] init];
            payOrderVC.orderID = self.orderDetailModel.OderDetailModelID;
            payOrderVC.orderNumber = self.orderDetailModel.orderId;
           
            payOrderVC.jingGangPay = ShoppingPay;
            [self.navigationController pushViewController:payOrderVC animated:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        @strongify(self);
        [UIAlertView xf_showWithTitle:@"网络错误，请稍后再试 " message:nil delay:1.2 onDismiss:NULL];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


#pragma mark - 确认收货接口请求
- (void)confirmRecieve:(NSNumber *)orderID
{
    SelfGoodsConfirmRequest *request = [[SelfGoodsConfirmRequest alloc] init:GetToken];
    request.api_orderId = orderID;
    @weakify(self);
    [_vapManager selfGoodsConfirm:request success:^(AFHTTPRequestOperation *operation, SelfGoodsConfirmResponse *response) {
        @strongify(self);
        if (!response.errorCode) {
            //重新请求
            [self _requestOrderDetailData];
        }else {
            [Util ShowAlertWithOnlyMessage:response.subMsg];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [Util ShowAlertWithOnlyMessage:error.localizedDescription];
    }];
}



-(void)_requestOrderDetailData{
    ZkgLoadingHub *hub = [[ZkgLoadingHub alloc] initHubPartInView:self.view withTopgap:0 bottonGap:0 leftGap:0 rightGap:0 withLoadingType:LoadingSystemtype];
    
    SelfDetailRequest *request = [[SelfDetailRequest alloc] init:GetToken];
    request.api_id = self.orderID;
    if (self.nodataView) {
        [self.nodataView removeFromSuperview];
    }
    @weakify(self);
    [_vapManager selfDetail:request success:^(AFHTTPRequestOperation *operation, SelfDetailResponse *response) {
        @strongify(self);
        NSDictionary *responseDic = (NSDictionary *)response.selfOrder;
        self.orderlist = (NSArray *)responseDic[@"orderFormList"];
        self.orderDetailModel = [[OderDetailModel alloc] initWithJSONDic:(NSDictionary *)response.selfOrder];
        //添加订单时间，字符串
        self.labelOrderAddTime.text = [NSString stringWithFormat:@"创建时间：%@",self.orderDetailModel.addTime];
        NSMutableArray *orderArr = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dic in self.orderlist) {
            OderDetailModel *ordermodel = [[OderDetailModel alloc] initWithJSONDic:dic];
            [orderArr addObject:ordermodel];
            //每个模型里面又有一个商品list,给每个list里的商品变成模型
            NSMutableArray *goodInfosArr = [NSMutableArray arrayWithCapacity:ordermodel.goodsInfos.count];
            for (NSDictionary *dicGoodsInfo in ordermodel.goodsInfos) {
                GoodsInfoModel *goodsInfoModel = [[GoodsInfoModel alloc] initWithJSONDic:dicGoodsInfo];
                [goodInfosArr addObject:goodsInfoModel];
            }
            //重新给订单模型的商品列表赋值,保证它里面装的是商品模型
            ordermodel.goodsInfos = (NSArray *)goodInfosArr;
        }
        
        
        
      //刷新表
      self.orderDetailGoodsTableView.orderListArr = orderArr;
      if (orderArr.count >= 1) {
          OderDetailModel *model = orderArr[0];
          self.orderDetailGoodsTableView.orderDetailModel = self.orderDetailModel;
          self.orderDetailGoodsTableView.payWay = model.payWay;
          
          NSLog(@"==%zd \n",model.goodsInfos.count);
          
          self.orderDetailGoodsTableView.height = 43 + 47 + model.goodsInfos.count * 118;
          
          self.secondTableView.y = CGRectGetMaxY(self.orderDetailGoodsTableView.frame) + 10;
          self.secondTableView.backgroundColor = [UIColor redColor];
      }
    
        [self.orderDetailGoodsTableView reloadData];
        
        //给UI赋值数据，除表
        [self _assignDataToUI];
        //处理第二张表的数据
        NSArray *resultData = [self _dealWithTheSecondTableData];
        self.secondTableView.height = resultData.count * 43;
//        self.SecondTopConstraint.constant =  180;
        self.secondTableView.resultData = resultData;
        
        
        [self.secondTableView reloadData];
        
        self.ScrollView.contentSize  = CGSizeMake(0, kScreenHeight - 200 + self.orderDetailGoodsTableView.height + self.secondTableView.height);
        
        [hub endLoading];
        [self _setBottomStateButtonTitle];
        
        
        
        //待付款状态才显示加载倒计时label
        if (self.orderDetailModel.orderStatus.integerValue == 10 || self.orderDetailModel.orderStatus.integerValue == 18) {
            if ([self.orderDetailModel.leftTime integerValue] <= 0) {
                self.bottomView.hidden = YES;
                self.scrollToBottonGap.constant = 0;
            }else{
                [self setcountDownCancellabelWithSecond:[self.orderDetailModel.leftTime integerValue]];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       [hub endLoading];
        @strongify(self);
        self.nodataView = [NodataShowView showInContentView:self.view withReloadBlock:
                           ^{
                            [self _requestOrderDetailData];
                           }
                                          requestResultType:NetworkRequestFaildType];
    }];
}
#pragma mark - private Method 
#pragma mark - 给UI数据
-(void)_assignDataToUI{
    self.orderNumberLabel.text = [NSString stringWithFormat:@"订单编号:%@",self.orderDetailModel.orderId];
    self.orderStatusLabel.text = [NSString stringWithFormat:@"状态：%@",self.orderDetailModel.orderStatusStr];
    self.orderStatusLabel.hidden = YES;
    self.recievePersonNameLabel.text = [NSString stringWithFormat:@"%@",self.orderDetailModel.receiverName];
    self.recievePersonPhoneNumLabel.text = [NSString stringWithFormat:@"%@",self.orderDetailModel.receiverMobile];
    self.detailAdressLabel.text = [NSString stringWithFormat:@"%@ %@",self.orderDetailModel.receiverArea,self.orderDetailModel.receiverAreaInfo];
}

#pragma mark - 计算总组尾的高度，因为有的无法查看物流
-(CGFloat)_calculateSectionHeightWithArr:(NSArray *)orderArr{

    CGFloat totalFooterHeight = 0.0f;
    for (OderDetailModel *model in orderArr) {
        CGFloat footerHeiht = model.canLookGoodsDelivery ? OrderDetailSectionFooterHeight : 0;
        totalFooterHeight += footerHeiht;
    }
    CGFloat totalHeaterHeight = orderArr.count * OrderDetailSectionHeaderHeight;
    return totalFooterHeight + totalHeaterHeight;
}

#pragma mark - 计算表的高度
-(CGFloat)_calculateTableHeightWithOrderlistArr:(NSArray *)orderList{
    //计算tableview的高度,（组头+组尾）* 组数 + 支付方式高度 + 每组cell的总高度
//    CGFloat sectionHeaderHeight = OrderDetailSectionHeaderHeight * orderList.count;
    CGFloat cellTotalHeight = 0.0;
    for (NSDictionary *dic in orderList) {
        
        
        NSArray *goodsInfo = dic[@"goodsInfos"];
        cellTotalHeight += goodsInfo.count * OrderDetailCellHeight;
    }
   
    NSInteger orderStatus = self.orderDetailModel.orderStatus.integerValue;
    if (orderStatus == 10 || orderStatus == 0 || orderStatus == 18) {//不是待付款和取消状态
        if ([self.orderDetailModel.payTypeFlag integerValue] == 1 || [self.orderDetailModel.payTypeFlag integerValue] == 2) {
            return cellTotalHeight + PayWayCellHeight;
        }else{
            return cellTotalHeight;
        }
    }else {
        return cellTotalHeight + PayWayCellHeight;
    }
}

#pragma mark - 处理第二张表的数据
-(NSArray *)_dealWithTheSecondTableData{
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    
    if (self.orderDetailModel.totalPrice.integerValue >= 0) {
        NSString *strTotalPrice = [NSString stringWithFormat:@"¥%.2f",[self.orderDetailModel.totalPrice floatValue]];
        NSDictionary *dicGoodsPrice = @{@"商品金额":strTotalPrice};
        [arr addObject:dicGoodsPrice];
    }
    
    if (self.orderDetailModel.payTypeFlag.integerValue > 0) {
        
        NSDictionary *dictPayFineInfo = [NSDictionary dictionary];
        NSString *strPayFineInfo = @"";
        if (self.orderDetailModel.payTypeFlag.integerValue == 1) {
            strPayFineInfo = [NSString stringWithFormat:@"%ld",(long)[self.orderDetailModel.allygPrice integerValue]];
            dictPayFineInfo = @{@"重消":strPayFineInfo};
            
        }else if (self.orderDetailModel.payTypeFlag.integerValue == 2){
            strPayFineInfo = [NSString stringWithFormat:@"%ld + %.2f元",(long)[self.orderDetailModel.allIntegral integerValue],[self.orderDetailModel.allCashPrice floatValue]];
            dictPayFineInfo = @{@"购物积分＋现金":strPayFineInfo};
        }else if (self.orderDetailModel.payTypeFlag.integerValue == 3){
            strPayFineInfo = [NSString stringWithFormat:@"%ld + %.2f元",(long)[self.orderDetailModel.allIntegral integerValue],[self.orderDetailModel.allCashPrice floatValue]];
            dictPayFineInfo = @{@"积分＋现金":strPayFineInfo};
        }
        
        if (dictPayFineInfo.count > 0) {
            [arr addObject:dictPayFineInfo];
        }
    }

   
    if (self.orderDetailModel.shipPrice.floatValue >= 0) {
        NSString *strShipPrice = [NSString stringWithFormat:@"¥%.2f",[self.orderDetailModel.shipPrice floatValue]];
       NSDictionary *dicShipPrice = @{@"运费":strShipPrice};
       [arr addObject:dicShipPrice];
    }
    
    if (self.orderDetailModel.price.floatValue >= 0) {
        NSString *strPrice = [NSString stringWithFormat:@"¥%.2f",[self.orderDetailModel.price floatValue]];
        NSDictionary *dicTwo = @{@"实付金额":strPrice};
        self.shifuLabel.text = strPrice;
        [arr addObject:dicTwo];
    }

    //计算table的高度
    self.secondTableHeightConstraint.constant = arr.count * SecondTableCellHiehgt;
    return arr;
}

#pragma mark - action Method
-(void)back{
    switch ([JGActivityHelper enterIntoGoodsDetailState]) {
        case YSEnterIntoGoodsDetailWithComeFromShopHomePage:
        {
            if (self.comeFromPushType == comeFromOrderListType) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        }
            break;
        case YSEnterIntoGoodsDetailWithComeFromActivtyH5:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kDismissActivityMenuKey object:nil];
        }
            break;
        default:
            break;
    }
}


- (void)setcountDownCancellabelWithSecond:(NSInteger)second{

    self.dateConutDown = [[YSDateConutDown alloc]init];
    [self.dateConutDown beginCountdownWithTotle:second being:^(NSString *msg) {
        
        NSMutableAttributedString *attStrConutDown = [[NSMutableAttributedString alloc]initWithString:msg];
//        [attStrConutDown addAttribute:NSForegroundColorAttributeName value:[YSThemeManager buttonBgColor] range:NSMakeRange(0, 10)];
        self.cancelOrderLabel.attributedText = attStrConutDown;
        self.cancelOrderLabel.hidden = NO;
    } end:^{
        //刷新订单列表
        if (self.refreshOrderListNotice) {
            self.refreshOrderListNotice();
        }
        self.bottomView.hidden = YES;
        self.scrollToBottonGap.constant = 0;
    }];
}


- (void)checkExpressInfo{

    NSDictionary *dictOrderStoreInfo = [self.orderlist xf_safeObjectAtIndex:0];
    QueryLogisticsViewController *quertVC = [[QueryLogisticsViewController alloc] initWithNibName:@"QueryLogisticsViewController" bundle:nil];
    quertVC.expressCompanyId = (NSNumber *)dictOrderStoreInfo[@"expressCompanyId"];
    quertVC.expressCode = [NSString stringWithFormat:@"%@",dictOrderStoreInfo[@"shipCode"]];
    [self.navigationController pushViewController:quertVC animated:YES];
}

- (void)deleteOrder
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    SelfOrderDeleteRequest *request = [[SelfOrderDeleteRequest alloc] init:GetToken];
    request.api_orderId = self.orderID;
    request.api_isJuanpiOrder = @0;
    @weakify(self);
    VApiManager *vapiManager = [[VApiManager alloc]init];
    [vapiManager selfOrderDelete:request success:^(AFHTTPRequestOperation *operation, SelfOrderDeleteResponse *response) {
        @strongify(self);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (response.errorCode.integerValue > 0) {
            [Util ShowAlertWithOnlyMessage:response.subMsg];
            return ;
        }
        
        if (self.refreshOrderListNotice) {
            self.refreshOrderListNotice();
        }
        [UIAlertView xf_showWithTitle:@"删除成功" message:nil delay:0.5 onDismiss:^{
            @strongify(self);
            [self back];
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        @strongify(self);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}


- (void)dealloc {
    JGLog(@"---order detail Controller dealloc");
}

-(void)reqeustconfirmJiankangdouReadCount {
    if (GetToken) {
        VApiManager *manager = [[VApiManager alloc] init];
        ConfirmJiankangdouRequest *request = [[ConfirmJiankangdouRequest alloc]init:GetToken];
        @weakify(self);
        
        
        [manager ConfirmJiankangdou:request success:^(AFHTTPRequestOperation *operation, ConfirmJiankangdouResponse *response) {
            NSLog(@"%@",response);
            @strongify(self);
            if([response.show intValue] ==1){
                
                HongBaoTCViewController * hongbao  = [[HongBaoTCViewController alloc] init];
                hongbao.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                hongbao.titleLabel.text = [NSString stringWithFormat:@"%@元健康豆已放至账户",response.num];
                hongbao.contentLabel.text = @"邀请用户下单奖励";
                hongbao.lable.text = @"健康豆专享";
                hongbao.isJK = YES;
                hongbao.nav = self.navigationController;
                hongbao.totalLabel.text = [NSString stringWithFormat:@"¥%@",response.money];
                hongbao.modalPresentationStyle = UIModalPresentationCustom;
                
                self.modalPresentationStyle = UIModalPresentationCustom;
                [self presentViewController:hongbao animated:YES completion:^{
                    
                    
                }];
                
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
    }
}




@end
