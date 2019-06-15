//
//  PTViewController.m
//  jingGang
//
//  Created by whlx on 2019/3/6.
//  Copyright © 2019年 dengxf_dev. All rights reserved.
// 拼团详情页

#import "PTViewController.h"
#import "SelfDetailRequest.h"
#import "VApiManager.h"
#import "GloableEmerator.h"
#import "GlobeObject.h"
#import "OderDetailModel.h"
#import "GoodsInfoModel.h"
#import "PindanSuccessRequest.h"
#import "YSDateConutDown.h"
#import "YSImageConfig.h"
#import "OrderDetailController.h"
#import "OrderViewController.h"
#import "YSLoginManager.h"
#import "YSShareManager.h"
@interface PTViewController ()

@property (weak, nonatomic) IBOutlet UIView *TBView;
@property (nonatomic,copy)  NSArray *orderlist;

@property (weak, nonatomic) IBOutlet UILabel *goodsName;

@property (nonatomic,strong) YSDateConutDown *dateConutDown;

@property (weak, nonatomic) IBOutlet UILabel *tilmeLabel;

@property (strong,nonatomic) YSShareManager *shareManager;
@property (weak, nonatomic) IBOutlet UIImageView *touimage1;

@property (weak, nonatomic) IBOutlet UIImageView *touimage2;

@property (strong,nonatomic) NSString  * tilte1;
@property (strong,nonatomic) NSString  * desc1;
@property (strong,nonatomic) NSString  * imgUrl1;
@property (strong,nonatomic) NSString  * link1;


@property (strong,nonatomic) NSString  * pdPrice;
@end

@implementation PTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }  
    [self initUI];
    // Do any additional setup after loading the view from its nib.
}
-(void)initUI{
    [YSThemeManager setNavigationTitle:@"e生康缘拼单" andViewController:self];
    
    self.navigationController.navigationBar.barTintColor = COMMONTOPICCOLOR;
    //返回
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initJingGangBackItemWihtAction:@selector(btnClick) target:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self _requestOrderDetailData];
    [self _requestPindanSuccess];
}

//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    //离开当前页面需要取消掉倒计时
//    [self.dateConutDown cancelConutDown];
//}

- (IBAction)pushDingdanXQ:(id)sender {
    OrderDetailController *orderDetailVC = [[OrderDetailController alloc] init];
    orderDetailVC.orderID = @([self.orderID integerValue]);
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

- (IBAction)YQHaoyou:(id)sender {
    
    NSDictionary *dictUserInfo = [kUserDefaults objectForKey:kUserCustomerKey];
    
    
    NSLog(@"dictUserInfo,%@",dictUserInfo);
    
    _tilte1 = [NSString stringWithFormat:@"【仅剩一个名额】我%@元拼%@",_pdPrice,self.goodsName.text];
    _desc1 = [NSString stringWithFormat:@"%@",self.goodsName.text];
    _link1 =[NSString stringWithFormat:@"http://mobile.bhesky.cn/pd/pdShare.htm?orderId=%@",self.pdorderID];;
    //http://mobile.bhesky.cn/pd/pdShare.htm?orderId=988478201904241941090&from=groupmessage&isappinstalled=0
    YSShareConfig *config = [YSShareConfig configShareWithTitle:_tilte1 content:_desc1  UrlImage:_imgUrl1 shareUrl:_link1];
    
    if (!_shareManager) {
        YSShareManager *shareManager = [[YSShareManager alloc] init];
        [shareManager shareWithObj:config showController:self];
        _shareManager = shareManager;
    }else {
        [_shareManager shareWithObj:config showController:self];
    }
}

- (IBAction)pushDingdanList:(id)sender {
    
        OrderViewController *GoodsOrderVC = [[OrderViewController alloc]init];
        [self.navigationController pushViewController:GoodsOrderVC animated:YES];
}


-(void)_requestOrderDetailData{
    
    SelfDetailRequest *request = [[SelfDetailRequest alloc] init:GetToken];
    request.api_id = self.orderID;
    VApiManager * manager = [[VApiManager alloc] init];
    @weakify(self);
    [manager selfDetail:request success:^(AFHTTPRequestOperation *operation, SelfDetailResponse *response) {
     NSDictionary *responseDic = (NSDictionary *)response.selfOrder;
    self.orderlist = (NSArray *)responseDic[@"orderFormList"];
        NSMutableArray *orderArr = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dic in self.orderlist) {
            OderDetailModel *ordermodel = [[OderDetailModel alloc] initWithJSONDic:dic];
            [orderArr addObject:ordermodel];
            //每个模型里面又有一个商品list,给每个list里的商品变成模型
            NSMutableArray *goodInfosArr = [NSMutableArray arrayWithCapacity:ordermodel.goodsInfos.count];
            for (NSDictionary *dicGoodsInfo in ordermodel.goodsInfos) {
                GoodsInfoModel *goodsInfoModel = [[GoodsInfoModel alloc] initWithJSONDic:dicGoodsInfo];
                [goodInfosArr addObject:goodsInfoModel];
            NSLog(@"responseDic%@",goodsInfoModel.pdPrice);
                self.goodsName.text = goodsInfoModel.goodsName;
                self.imgUrl1 = goodsInfoModel.goodsMainphotoPath;
                self.pdPrice = goodsInfoModel.pdPrice;
            }
            //重新给订单模型的商品列表赋值,保证它里面装的是商品模型
            ordermodel.goodsInfos = (NSArray *)goodInfosArr;
            
       
        
        }
        
  
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 
    }];
     
}
-(void)_requestPindanSuccess{
    
    
    PindanSuccessRequest *request = [[PindanSuccessRequest alloc] init:GetToken];
    request.api_id = self.pdorderID;
    VApiManager * manager = [[VApiManager alloc] init];
    [manager PindanSuccess:request success:^(AFHTTPRequestOperation *operation, PindanSuccessResponse *response) {
        NSLog(@"%@",response.leftTime);
        NSLog(@"%@",response.addTime);
        NSLog(@"%@",response.userCustomer);
        NSDictionary * dic = (NSDictionary *)response.userCustomer;
        NSLog(@"dicdicdicdic%@",dic);
        [self setcountDownCancellabelWithSecond:[response.leftTime integerValue]];
        NSString  * url = [NSString stringWithFormat:@"%@",response.userCustomer[0][@"headImgPath"]];
        [YSImageConfig sd_view:_touimage1 setimageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"moren"]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
- (void)setcountDownCancellabelWithSecond:(NSInteger)second{
    
    self.dateConutDown = [[YSDateConutDown alloc]init];
    [self.dateConutDown beginCountdownWithTotle2:second being2:^(NSString *msg) {
        
        NSMutableAttributedString *attStrConutDown = [[NSMutableAttributedString alloc]initWithString:msg];
        self.tilmeLabel.attributedText = attStrConutDown;
        
        //        [attStrConutDown addAttribute:NSForegroundColorAttributeName value:[YSThemeManager buttonBgColor] range:NSMakeRange(0, 10)];
        
        
 
    } end2:^{
     
   
    }];
}


-(void)btnClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
